(in-package :zf)

;;;; 6.  包括原理，ZF集合論，ラッセルのパラドックス

;; 集合を表現するのに，{0, 1, 2, 3} ではなく，{ x | x ∈A } とか，{ x
;; | φ(x) } と書く場合があります．というか，この方が一般的です．この書
;; き方だと，非常に大きなサイズの集合や無限個の数の要素の集合を難なく表
;; 記することができます．{0, 1, 2, 3} みたいなのはその集合の要素を書き
;; 連ねるわけですから，外延的表記であり，

;; { x | φ(x) } みたいなのは，ある集合の要素が共通して持つ性質 φ(x)
;; で表記するわけですから，内包的表記です．

;; 我々の集合論においても，この内包的表記を可能にしてみましょう．まず決
;; めなくてはいけないのは，内包的性質をどう実現したらいいのかということ
;; ですが，今簡単に結論を言ってしまえば，それはメンバーの型であり，クラ
;; スです．ですから，ここでも集合の性質をCommon Lisp の型で表現しましょ
;; う．そうすれば，自前でシステム開発する労力が大幅に低減される．
;; Common Lisp の型システムにのっかって，車輪の再発明はやめましょう，と
;; いうことです．まあ，このやりかたでうまくいくかどうか，やってみないと
;; わかりませんが．

;; できあがりの姿として，自然数の集合は，{ x | (and integer (>= x 0))
;; } みたいに書けたらうれしいな，ということです．そうすると，縦棒の次の
;; 部分は型指定子とすればいいのではないか．もちろん既存のCommon Lisp の
;; 型を使って，{ x | integer } と書けるし，将来はCLOS の型を使って { x
;; | animal } とか { x | carnivore } とか書けるじゃないか，という話です．
;; まあ，そうなると何が何だか分からなくなる可能性もありますが，逆になる
;; ほどクラスとはそういうことかとよく分かるようになる可能性もある．

;; そうすると，次に外延的表記と内包的表記をどう統一するかという議論が出
;; てきます．今 { x | (and integer (>= x 0)) } と定義されている集合のメ
;; ンバーにたまたま { 0, 1, 2, 3 } とあったとします．もちろんこれらのメ
;; ンバーはこの自然数の型定義を満足しますが，これですべて尽くされている
;; わけではないですよね．ほかにもメンバーとなるべき自然数は一杯ある．で
;; すから，これ以上はメンバーの増加や交代はない，という状態でないと，外
;; 延的表記と内包的表記を同一とすることはできません．逆に，そうしてもい
;; いという場合という意味で，ここに finalize という概念を持ち込みます．
;; finalize するのは，一番よく分かっている人，あなたか，あるいはエージェ
;; ントです．つまり，finalize はこれでメンバー確定という積極的な宣言で
;; す．finalize されない限り，メンバーはまだ増えるかもしれない．色々な
;; 仕事は，集合の性質を調べたり，などは finalize されて初めて安心して実
;; 行できます．一方，内包的表記では，これ以外のあれこれという可能性はあ
;; りません．可能性は書かれたそれで尽くされていますから，いわば最初から
;; finalize されている．

;; いままでの議論を踏まえて，以下のように集合の定義を拡張しました．

(defclass set ()
  ((type :initarg :type :accessor set-type)
   (elements :initarg :elements :accessor member-of)
   (rank :initarg :rank :accessor rank-of))
  )

(defmethod print-object ((object set) stream)
  (if (slot-boundp object 'type)
      (format stream "{x | ~S}" (set-type object))
    (if (slot-boundp object 'rank)
        (format stream "{~{~S~^,~}}" (member-of object))
      (call-next-method))))

(defun set-p (x)
  (typep x 'set))

(defun set-of (&rest members)
  (make-instance 'set :elements members))

(defun set-by (&key (type t))
  (make-instance 'set :type type))

#|(defun set (type)
  (make-instance 'set :type members))|#

(defun set (members)
  (make-instance 'set :elements members))

;;; Finalize
(defun finalize (set &optional (rank (card set)))
  "Default option is appicable only for ordinal numbers by succesor."
  (setf (rank-of set) rank)
  set)

(defun finalized-p (set)
  (or (slot-boundp set 'type)
      (slot-boundp set 'rank)))

;; CLOSのクラス定義では構造体定義とは異なり，自動的に型判別のための述語
;; が定義されません．ですからここで set-p を定義しました．クラス set の
;; スロットに新しく type スロットを設けました．内包的表記における記述は
;; ここに保存されます．ここに保存されたフォームはCommon Lisp の型判別子
;; として用いることができるものとします．新しく導入された type スロット
;; に対応して，print-object を拡張しました． type スロットに値があれば
;; それが優先的に印刷されます．クラス set のスロットにもう一つ rank ス
;; ロットを設けました．竹内外史さんによれば rank(x) とは，ある集合 x の
;; 順序数のことです．今まで出てきた例でいえば，集合 =1 の rank は 1，
;; 集合 =5 の rank は 5 です．successor による順序数では rank はカージ
;; ナリティ（要素の数）と等しいのですが，冪集合による順序数では異なって
;; いました．とにかくここでは，だれかが rank を設定してくれるとして，
;; rank が設定されていれば，それは finalize されているものとしました．
;; ですから，print-object でも rank のあるときだけ従来どおりの印刷をし
;; ています．そういう実装で足らないことがあるかも知れませんが，我々の順
;; 序数に関して言えば十分ですね．ここでちょっと注意．call-next-method
;; をprint-object の中で呼び出しています．メソッド定義の中で呼ばれると
;; call-next-method は上位クラスのメソッドを呼び出します．
;; call-next-method に引数を与えることもできますが，もし引数なしの形式
;; だと，このメソッドのパラメータに与えられた値がそのまま引き継がれるだ
;; けでなく，実行時に効率のよいコードを生み出します．ですから，通常引数
;; の値を変更しない場合には（ほとんどの場合はそうのはず．around の場合
;; だけ積極的に引数の値を変更したりする），引数なしの形式で
;; call-next-methodを呼び出すのが正しいコードです．

;; 関数 finalize でもしrank を与えないときは，デフォールトとして与えら
;; れた引数 set は successor によるものだとしています．それに合わせて関
;; 数 suc を次のように修正します．ただし，+empty+ にもrank を与えておき
;; ます．

(defparameter +empty+ (set-of))
(setf (rank-of +empty+) 0)

(defun suc (ord)
  (finalize (union-of ord (set-of ord))))

;; これで，順序数については従来通りとなりました．

(defparameter =5 (make-ord #'(lambda () +empty+) 5))
;=>  =5

=5
;=>  {{},{{}},{{},{{}}},{{},{{}},{{},{{}}}},{{},{{}},{{},{{}}},{{},{{}},{{},{{}}}}}}

;; さていよいよ，内包定義です．もし，set-type の値が型指定子なら，メン
;; バーの所属を判定する関数 in は次のように拡張できます．

(defun in (member set)
  (cond ((slot-boundp set 'type)
         (if (typep member (set-type set))
             (values t t)
           (values nil t)))
        ((slot-boundp set 'rank)   ; finalized
         (if (member member (member-of set) :test #'equals)
             (values t t)
           (values nil t)))
        ((member-of set)
         (if (member member (member-of set) :test #'equals)
             (values t t)
           (values nil nil)))
        (t (values nil nil))))

;; もし，set-type があるなら，それを取り出して普通に typep で調べます．
;; 真であれば <t, t> の２値を返し，偽であれば<nil, t> の２値を返します．
;; これはCommon Lisp の subtypep のやり方に沿ったものです．分からなけれ
;; ば<nil, nil> を返します．今，typep で調べることは確定的に調べられる
;; ものとして，typep で nil が返ったときには<nil, t> を返しています．
;; finalize されているときも同様に，member で調べて真なら <t, t> ，偽な
;; ら <nil, t> です．そしてset が finalize されていないときでも，そのメ
;; ンバーが確かに set のメンバーになっているなら <t, t> ですが，そうで
;; ないとき，将来そういうこともあるかも知れないという意味で，<nil,
;; nil> を返しています．type も member-of もないならもちろん返す値は
;; <nil, nil> です．

;; 同じような考えで，subset-p を次のように拡張します．

(defun subset-p (x y)
  (when (eq x y) (return-from subset-p (values t t)))
  (cond ((and (slot-boundp x 'type) (slot-boundp y 'type))
         (let ((x-type (set-type x))
               (y-type (set-type y)))
           (when (eql x-type y-type) (return-from subset-p (values t t)))
           (subtypep x-type y-type)))
        ((and (slot-boundp x 'rank) (slot-boundp y 'rank))    ; finalized
         (if (every #'(lambda (e) (member e (member-of y) :test #'equals))
                    (member-of x))
             (values t t)
           (values nil t)))
        ((and (slot-boundp x 'rank) (slot-boundp y 'type))
         (if (every #'(lambda (e) (typep e (set-type y)))
                    (member-of x))
             (values t t)
           (values nil t)))
        ((and (member-of x) (slot-boundp y 'type))
         (if (notevery #'(lambda (e) (typep e (set-type y)))
                       (member-of x))
             (values nil t)
           (values nil nil)))
        ((and (member-of x) (slot-boundp y 'rank))
         (if (notevery #'(lambda (e) (member e (member-of y) :test #'equals))
                       (member-of x))
             (values nil t)
           (values nil nil)))
        (t (values nil nil))))

;; 二つの集合の両方に type が定義してあるなら，それについて subtypep で
;; 比較します．両方がmember について finalize されているときは従来通り
;; ですが，ただし返す値は２値にしています．x が finalize されていないと
;; きは，もし偽であるなら，将来メンバーが減少することはないとして（これ
;; を単調増加という），確かに偽であるとして <values nil, t> を返してい
;; ますが，それ以外なら <nil, nil> です．y は finalize されていなければ
;; なりません．さもなければ <nil, nil> を返します．（続く）

;;; http://blog.livedoor.jp/s-koide/archives/1901127.html

;;; CLOS で学ぶ集合論その６（続き）

;; 内包的表記の集合の性質を Common Lisp の型で表記することにして，
;; typep を利用した in や，subtypep を利用した subset-p を定義しました．
;; これらは次のように一見調子よさそうに見えますが，実は型指定子に
;; satisfies を使った場合にはうまく動きません．

(defparameter +NNN+ (set-by :type '(integer 0 *)))

(defparameter +INT+ (set-by :type 'integer))

(subset-p +NNN+ +INT+)
;=>  T
;    T

(subset-p +INT+ +NNN+)
;=>  NIL
;    T
(subset-p (finalize (set-of 0 1 2)) +INT+)
;=>  T
;    T

(subset-p (finalize (set-of 0 1 2)) +NNN+)
;=>  T
;    T

(subset-p (finalize (set-of -1 0 1)) +INT+)
;=>  T
;    T

(subset-p (finalize (set-of -1 0 1)) +NNN+)
;=>  NIL
;    T

;; ここで (integer 0 *) という型指定子は，CLtL2 にある第4.6節の「簡略化
;; を行う型指定子」というものです．上記を見るとうまくいっています．とこ
;; ろが同じことを型指定子の satisfies を用いてしようとするとこうなりま
;; す．

(defun natural-number-p (x)
  (and (typep x 'integer) (>= x 0)))

(deftype natural-number () '(satisfies natural-number-p))
;=>  NATURAL-NUMBER

(typep 1 'natural-number)
;=>  T

(typep 0 'natural-number)
;=>  T

(typep -1 'natural-number)
;=>  NIL

(subtypep 'natural-number 'integer)
;=>  NIL
;    NIL

;; CLtL2 第4.3節「述語を持つ型指定子」にあるように，１変数の述語を用意
;; しておいて，それを (satisfies 述語) として型指定子にすることができま
;; す．確かにここにあるように，typep についてはうまく動くのですが，
;; subtypep になると，意味的には先の (integer 0 *) と同じであるにもかか
;; わらず，<nil, nil> が返ってきました．これは一体どうしたことでしょう．
;; 実は subtypep の説明にこんなことがかいてあります．

;; 処理系は多くの場合，実際は与えられた型の間の関係を決定できるかも知れ
;; ないのに，簡単に「諦めて」２つの nil の値を返している．・・・
;; subtypep は，引数のうちの一つか両方に satisfies，and，or，not，
;; member を含まない限り，第２の値として nil を返すことは許されない．

;; おいおい，satisfies があったら，分からないと簡単に「諦めて」もいいの
;; かよ，といいたくなりますね．not は前々から言っているように大変なんで，
;; まあしかたがないとして，and と or は何とかしてほしい．集合のベン図を
;; 考えていただければすぐ分かりますが，and は共通集合(intersection)，
;; or は和集合(union) に相当します．巨人の肩の上に乗ろうと思ったら，巨
;; 人がそれほどでもなかったということでしょうか．

;; 実はsubtypep のやることはあらかじめ決まっているCommon Lisp のデータ
;; 型については，コード内で両者を見て真偽を判定しています．まあ，効率化
;; のために色々細工はあるにせよ．ところがユーザが新しく定義するデータ型
;; については，たとえば integer （実は (integer * *) と同じこと）を
;; (integer 0 *) と比較することは，まあ何とかできるわけです．これも
;; subtypep の中でコード化されている．ところが (satisfies
;; natural-number-p) になると，これを比較するには natural-number-p のコー
;; ドを理解しなければならない，というわけで「諦めて」しまうわけです．

;; プログラムコードを理解しているわけではないですが，このへんのことを論
;; 理的にきちんとやっているのが述語論理（description logic）という分野
;; で，それはセマンティックウェブのOWL の理論的基礎にもなっています．述
;; 語論理において行う主要なタスクは二つあって，いわば typep と
;; subtypep の質問にきちんと答えることなんですよ．ですから，述語論理の
;; 成果をCommon Lisp に取り入れると，もうちょっとましになることは確かな
;; のですが，まあちょっとこのブログの範囲をこえることになるのは，確かな
;; ことですね．

;; ここでは，まあ適当に進めさせていただきます．えーっと，and と or だけ
;; については，きちんと押さえておきたいですね．でもそうすると，結局論理
;; システムを少し導入せざるを得なくなるのですけどね．


;; ================================================================

;; CLOS で学ぶ集合論その６（続きの続き）

;; 今から少しだけ論理の話をします．型判定するアルゴリズムについて説明す
;; るには，どうしても論理の用語を使うことになるからです．論理と言っても
;; 型判定の範囲では変数はでてきませんから，表面上は命題論理になります．
;; 命題論理では，and，or，not，=> などを使った論理表現ではない素論理式
;; をアトム(atom) と言います（今関数は考えないことにする）．Lisp では通
;; 常これを Cat とか Mother のようなシンボルで表現します．Erlang や
;; Prolog では論理式でアトムになれるのはシンボルだけですが，ここでは以
;; 後論理式アトムに任意のオブジェクトが来てもいいことにします．CLOS オ
;; ブジェクトでもいいことにする．アトムとその否定 (not アトム) は特別に
;; リテラルと言います．今からやりたいことは，and，or，not を含む一般の
;; 型指定子（とりあえずsatisfies はないことにしておきましょう）を命題論
;; 理式のように見て，新規にユーザが型定義をした場合，それを既存の型階層
;; の中に subtypep の意味で正しく位置づけたい，ということです．これを述
;; 語論理の方では classify するとか言います．一般の型指定子を既存体系の
;; 中に classify すると言っても，アトムのレベルになると，どちらが上位か
;; 下位か（それとも関係ないか）は，何かほかに情報がないと判定できません．
;; 幸いなことに，Common Lisp では型とCLOSのクラスが統合されており，しか
;; も既存のCommon Lisp の型に丁度対応するCLOSクラスが定義されています
;; （すべてではない）．CLtL2 の表28-1には既存の型におけるクラス優先順位
;; リストが掲げてあります．そして，型名からCLOS クラスオブジェクトを得
;; たり，表28-1にあるような情報を得るのは次のように簡単なことです．

(find-class 't)
;=>  #<BUILT-IN-CLASS T>
(find-class 'integer)
;=>  #<BUILT-IN-CLASS INTEGER>
(c2mop:class-precedence-list (find-class 'integer))
;=>  (#<BUILT-IN-CLASS INTEGER> #<BUILT-IN-CLASS RATIONAL> #<BUILT-IN-CLASS REAL>
;     #<BUILT-IN-CLASS NUMBER> #<BUILT-IN-CLASS T>)
(c2mop:class-precedence-list (find-class 'string))
;=>  (#<BUILT-IN-CLASS STRING> #<BUILT-IN-CLASS VECTOR> #<BUILT-IN-CLASS ARRAY>
;     #<BUILT-IN-CLASS SEQUENCE> #<BUILT-IN-CLASS T>)

;; これ以降，我々も何か新しくアトミックな型定義するときは，このような
;; CLOSのクラス定義をして，そのsuperclass として上位クラスを定義してや
;; ることにしましょう．たとえば，Cat の上位に Mamal を置き，Mammal の上
;; 位に Animal を置く，というようなことです．ただし，XML データスキーマ
;; については値空間をCommon Lisp に写像するために，deftype でCommon
;; Lisp にマッピングします．たとえばこんな具合です．

;; (delete-package :xsd)
(defpackage :xsd
  (:nicknames :xs)
  (:use ) ; supressing using common lisp package
  #|(:export "string" "boolean" "decimal" "float" "double" "dataTime" "time" "date"
           "gYearMonth" "gYear" "gMonthDay" "gDay" "gMonth" "hexBinary" "base64Binary"
           "anyURI" "normallizedString" "token" "language" "NMTOKEN" "Name" "NCName"
           "integer" "nonPositiveInteger" "negativeInteger" "long" "int" "short" "byte"
           "nonNegativeInteger" "unsignedLong" "unsignedInt" "unsignedShort" "unsignedByte"
           "positiveInteger" "simpleType" "anySimpleType" "true" "false"
           "duration" "duration-year" "duration-month" "duration-day" "duration-hour"
           "duration-minute" "duration-second")|#
  (:export "STRING" "BOOLEAN" "DECIMAL" "FLOAT" "DOUBLE" "DATATIME" "TIME" "DATE"
           "GYEARMONTH" "GYEAR" "GMONTHDAY" "GDAY" "GMONTH" "HEXBINARY" "BASE64BINARY"
           "ANYURI" "NORMALLIZEDSTRING" "TOKEN" "LANGUAGE" "NMTOKEN" "NAME" "NCNAME"
           "INTEGER" "NONPOSITIVEINTEGER" "NEGATIVEINTEGER" "LONG" "INT" "SHORT" "BYTE"
           "NONNEGATIVEINTEGER" "UNSIGNEDLONG" "UNSIGNEDINT" "UNSIGNEDSHORT" "UNSIGNEDBYTE"
           "POSITIVEINTEGER" "SIMPLETYPE" "ANYSIMPLETYPE" "TRUE" "FALSE"
           "DURATION" "DURATION-YEAR" "DURATION-MONTH" "DURATION-DAY" "DURATION-HOUR"
           "DURATION-MINUTE" "DURATION-SECOND")
  (:documentation "http://www.w3.org/2001/XMLSchema#") )

(deftype xsd:integer () 'integer)

(deftype xsd:string () 'string)

;; XML データスキーマの型階層についてはここにあります．このような型階層
;; があったとき，重要な情報は上位下位関係のみならず，二つの兄弟の型が互
;; いに疎（disjoint）であるかどうか，また，上位型に対して複数の下位型が
;; 網羅的かどうかです．たとえば，xsd:decimal に対して xsd:integer は下
;; 位型ですが，網羅的ではありません．また，xsd:long は
;; xsd:nonNegativeInteger や xsd:nonPositiveInteger とdisjoint ではあり
;; ません．xsd:nonNegativeInteger と xsd:nonPositiveInteger は 0 という
;; 共通要素を持ちますが，(or xsd:nonNegativeInteger
;; xsd:nonPositiveInteger)　を型とするとこれは xsd:integer と同等です．
;; ちょっと調べてみると，Allegro Common Lisp でも SBCL でも，satisfies
;; は別としてそれ以外については，きちんと計算してくれるようです．

(deftype xsd:positiveInteger () '(cl:integer 1 cl:*))
(deftype xsd:nonPositiveInteger () '(cl:integer cl:* 0))
(deftype xsd:negativeInteger () '(cl:integer cl:* -1))
(deftype xsd:nonNegativeInteger () '(cl:integer 0 cl:*))
(deftype xsd:int () '(cl:signed-byte 32))
(subtypep 'xsd:positiveInteger 'xsd:integer)
;=>  T
;    T

(subtypep 'xsd:positiveInteger 'cl:integer)
;=>  T
;    T


(subtypep 'cl:integer 'xsd:integer)
;=>  T
;    T

(subtypep 'xsd:integer 'cl:integer)
;=>  T
;    T

(subtypep 'xsd:positiveInteger 'xsd:nonNegativeInteger)
;=>  T
;    T

(subtypep 'xsd:nonNegativeInteger 'xsd:positiveInteger)
;=>  NIL
;    T

(subtypep '(or xsd:nonNegativeInteger xsd:nonPositiveInteger)
          'xsd:integer)
;=>  T
;    T

(subtypep 'xsd:integer
          '(or xsd:nonNegativeInteger xsd:nonPositiveInteger))
;=>  T
;    T
(subtypep '(or xsd:nonNegativeInteger xsd:nonPositiveInteger xsd:int)
          'xsd:integer)
;=>  T
;    T

(subtypep 'xsd:integer
          '(or xsd:nonNegativeInteger xsd:nonPositiveInteger xsd:int))
;=>  T
;    T

;; といいつつも，XMLデータスキーマの値空間からLispデータの値空間へのマッ
;; ピングは，いろいろと根回しが必要なことがあって，いましばらく後回しに
;; して，CLOSの型階層についてのみ考えましょう．（まだまだ続く）
