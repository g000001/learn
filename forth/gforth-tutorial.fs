\
\ http://www.h7.dion.ne.jp/~samwyn/forth/gforth/Stack-Manipulation-Tutorial.html#Stack-Manipulation-Tutorial
\

\ 3.4 スタック =====================================================================

\ 宿題: 5 6 7 . と打ち込んだ後のスタックの状態は?
\ => 5 6

\ 3.5 演算 ========================================================================
\     3 4 + 5 * .
\     3 4 5 * + .

\    宿題: 上の例を通常の中置記法で表わすと?
\ => (3 + 4) * 5

\          6-7*8+9 を Forth の表記法で表わせ。
\ => 6 7 8 * - 9 +

\    宿題: -(-3)*4-5 を Forth での演算に変換せよ。
-3 negate 4 * 5 -

\ 3.6 スタックを操作してみる ========================================================
\    宿題: nip と tuck を、ほかのスタック操作用ワードで置き換えよ。

\ nip
1 2 swap drop .s drop

\ tuck
1 2 swap over .s

\              この入力から:    この結果を導け:
\    1 2 3           3 2 1
1 2 3 over 2swap drop

\    1 2 3           1 2 3 2
    1 2 3 over .s
    2drop 2drop

\    1 2 3           1 2 3 3
    1 2 3 dup .s
    2drop 2drop

\    1 2 3           1 3 3
    1 2 3 nip dup .s
    drop 2drop .s

\    1 2 3           2 1 3
    1 2 3 rot swap .s
    drop 2drop

\    1 2 3 4         4 3 2 1
    1 2 3 4 swap 2swap swap .s
    2drop 2drop

\    1 2 3           1 2 3 1 2 3
    1 2 3
    rot dup 2swap rot
    rot dup 2swap rot
    rot dup 2swap rot .s
    2drop 2drop 2drop

\    1 2 3 4         1 2 3 4 1 2

    1 2 3 4 2over


\    1 2 3           1 2 3 4

    1 2 3 over 2 * .s

\    1 2 3           1 3
    1 2 3 nip .s
    2drop


\    宿題:
\    17 を一回だけ使って、17^3 と 17^4 を Forth で表現せよ (訳注: 累乗は直上の例を参照)。
    17 dup dup * * .s
    17 dup * dup * .s

\    スタック上に 2 つの値 (a と b、b が上) を予期し、(a-b)(a+1) を計算するコードを
\    Forth で記述せよ。
    a b over swap - swap 1 + *

    3 4 over swap - swap 1 + *

\ 3.9 コロン定義 ==================================================================
\       宿題:
\ nip、tuck、negate、/mod を、それら以外の Forth ワードを用いてコロン定義し、
\ 正しく動作するかどうか検証せよ (ヒント: テストコードを先に作り、最初に本来の定義のままで
\ それを用いて検証するとよい)。‘redefined’ メッセージはただの警告に過ぎないので、
\ 気にしないように。
: mynip
    swap drop ;

1 2 mynip .s

: mytack
    swap over ;

1 2 mytack .s 2drop drop .s

: mynegate
    -1 * ;

1 2 mynegate .s 2drop .s

: my/mod
    2dup mod rot rot / ;

\ 3.11 スタックコメント ============================================================

\ 宿題: swap のスタックコメントは x1 x2 -- x2 x1 と書き表せる。
\ 同じように、-、drop、dup、over、rot、nip、tuck のスタックコメントを書き表せ。
\ ヒント: 書き表したなら、このマニュアルに記載されているものと見比べるとよい
\ (Word Index を参照)。

\ - ( x y -- x-y )
\ drop ( x y -- x )
\ dup ( x -- x x )
\ over ( x y -- x y x )
\ rot ( x y z -- y z x )
\ nip ( x y -- y )
\ tuck ( x y -- y x y )

\    宿題: チュートリアルでこれまでに出てきたすべての定義のスタックコメントを記述せよ。

: mynip ( w1 w2 -- w2 )
    swap ( w2 w1 ) drop ;

: mytuck ( w1 w2 -- w2 w1 w2 )
    swap ( w2 w1 ) over ;

: mynegate ( n -- -n )
    -1 ( n -1 ) * ;

: my/mod ( n1 n2 -- n1 mod n2 n1/n2 )
    2dup ( n1 n2 n1 n2) mod ( n1 n2 m )
    rot ( n2 m n1 ) rot ( m n1 n2 ) / ;

\ 3.15 ローカル変数 ===============================================================

\     宿題: これまで自分が書いてきた定義を、ローカルを使って書き直してみよ。

: mynip ( w1 w2 -- w2)
    { w1 w2 -- w2 }
    w2 ;

\ 1 2 mynip .s
\ drop
: mytuck ( w1 w2 -- w2 w1 w2)
    { w1 w2 -- w2 w1 w2 }
    w2 w1 w2 ;

\ 1 2 mytuck .s
\ 2drop drop

: my/mod ( n1 n2 )
    { n1 n2 -- r q }
    n1 n2 mod ( r )
    n1 n2 ( r n1 n2 ) / ;

\ 7 4 my/mod .s
\ 7 4 /mod .s

\ 3.16 条件分岐 ===================================================================

\    宿題: min を else 部なしで書け (ヒント: nip をどう定義したか思い出すとよい)。

: my-min ( x y -- n )
    2dup < if
        swap ( y x )
    endif
    drop ;

\ 3 5 my-min .s
\ 5 3 my-min .s

\ 3.17 真偽フラグと比較 ============================================================
\    宿題: min を、if を使わずに書け。

: my-min ( x y -- min )
    { x y }
    x y <= x and ( x or 0 )
    x y > y and  ( y or 0 )
    or ;

\ 3.18 ループ =====================================================================

\    宿題: 最大公約数を計算する定義を書け。

: gcd ( u1 u2 )
    begin
        tuck mod
        dup 0=
    until
    drop ;

\ 1071 1029 gcd .s <1> 21  ok
