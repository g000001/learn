;;;; koide-clos.lisp

(cl:in-package :koide-clos.internal)
;; (in-readtable :koide-clos)

(def-suite koide-clos)

(in-suite koide-clos)

;;; "koide-clos" goes here. Hacks and glory await!


;;; http://www.lispworks.com/documentation/HyperSpec/Body/m_defpkg.htm
(defpackage :zf
  (:use :cl)
  (:shadow #:set)
  (:export #:set))


(in-package :zf)

(defclass set ()
  ((elements :initarg :elements)))


(defparameter foo
  (make-instance 'set :elements `(0 1 2)))


foo
;=>  #<SET {1013DA5283}>

(slot-value foo 'elements)
;=>  (0 1 2)


(defparameter bar (make-instance 'set :elements `(0 1 2)))
;=>  BAR

(eq foo bar)
;=>  NIL

(eql foo bar)
;=>  NIL

(equal foo bar)
;=>  NIL

(defmethod equals ((s1 set) (s2 set))
  (and (every #'(lambda (e1) (member e1 (slot-value s2 'elements)))
              (slot-value s1 'elements))
       (every #'(lambda (e2) (member e2 (slot-value s1 'elements)))
              (slot-value s2 'elements))))
;=>  #<STANDARD-METHOD EQUALS (SET SET) {10148D1343}>

(equals foo bar)
;=>  T

;;; 集合の比較ができないので拡張
(defmethod equals ((s1 set) (s2 set))
  (and (every #'(lambda (e1) (member e1 (slot-value s2 'elements) :test #'equals))
              (slot-value s1 'elements) )
       (every #'(lambda (e2) (member e2 (slot-value s1 'elements) :test #'equals))
              (slot-value s2 'elements) )))

(defmethod equals (s1 s2)
  (eql s1 s2))

(equals foo bar)
;=>  T

;;; 集合の同一性は公理の内で最初に導入される，外延性公理と呼ばれます



;; 3.  空集合，合併集合，共通集合

;;集合を定義するのにいつもいつも make-instance ではタイプ入力の効率が悪いので，set とset-of という関数を次のように定義しましょう．



(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass set ()
    ((elements :initarg :elements :accessor set-elements)))
  (defun set (members)
    (make-instance 'set :elements members))
  (defun set-of (&rest members)
    (make-instance 'set :elements members)))

;; また，いつもいつも slot-value では見栄えが悪いので，次のようにして，elements スロットのアクセッサを定義します．



;; いかなる要素も含まない集合のことを空集合と言いますが，空集合の公理とは，空集合が存在するという公理です．それをここではこんな風に定義してみました．

(kl:defconstant* +empty+ (set-of))

(defun empty-p (set)
  (null (set-elements set)))

;; もし二つの集合 a と b が共に空集合なら，両者は（集合として）等しい．すなわち，

;; zf(17):
(equals (set-of) (set-of))
;=>  T


;;たった一つの要素を持つ集合を特別にシングルトンと呼びます．

(defun singleton-of (element)
  (set-of element))

(defmethod length=1 ((list list))
  (and (consp list)
       (null (cdr list))))

(defun singleton-p (set)
  (length=1 (set-elements set)))

;; 空集合と空集合のシングルトンは異なるものです．

;; zf(18):
(equals +empty+ (singleton-of +empty+))
;=>  NIL

;; 非順序対の存在公理とは，任意の二つの集合について，それらを要素として含みそれら以外を含まないような集合がある，というものです．

(defun unordered-set-of (e1 e2)
  (if (equals e1 e2)
      (singleton-of e1)
      (set-of e1 e2)))

;; 非順序ですから，二つの要素を入れ替えても結果は（集合として）同じです．

;; zf(19):
(equals (unordered-set-of 1 2) (unordered-set-of 2 1))
;=>  T

;; 合併集合はCommon Lisp のunion を使えばmap と reduce で簡単に定義できます．

#|(defun union-of (&rest sets)
  (set (reduce #'(lambda (s1 s2) (union s1 s2 :test #'equals))
               (mapcar #'set-elements sets))))|#

;; cl:union は2変数の関数ですが，こうすれば任意個の集合について合併集合を定義できます．

#|(defun union-of (&rest sets)
  (set (reduce #'(lambda (s1 s2) (union s1 s2 :test #'equals))
               (mapcar #'set-elements sets))))|#

(defun union-of (&rest sets)
  (set (reduce #'(lambda (s1 s2) (union s1 s2 :test #'equals))
               (mapcar #'set-elements sets)
               :initial-value nil)))

#|(defun union-of (&rest sets)
  (set (if (null sets)
           nil
           (reduce #'(lambda (s1 s2) (union s1 s2 :test #'equals))
                   (mapcar #'set-elements sets)))))|#

#|(defun union-of (&rest sets)
  (set (and sets
            (reduce #'(lambda (s1 s2) (union s1 s2 :test #'equals))
                    (mapcar #'set-elements sets)))))|#

(equals +empty+ (union-of))
;=>  T
(equals +empty+ (union-of +empty+))
;=>  T

(equals (set-of 1 2) (union-of (set-of 1 2)))
;=>  T

(equals (set-of 1 2 3) (union-of (set-of 1 2) (set-of 2 3)))
;=>  T
t

;共通集合は次のように定義できます．

(defun intersection-of (&rest sets)
  (cond ((null sets) +empty+)
        ((length=1 sets) (car sets))
        (t (set (reduce #'(lambda (e1 e2) (intersection e1 e2 :test #'equals))
                        (mapcar #'set-elements sets))))))

(equals +empty+ (intersection-of))
;=>  T

(equals (set-of 1 2) (intersection-of (set-of 1 2)))
;=>  T

(equals (set-of 2) (intersection-of (set-of 1 2) (set-of 2 3)))
;=>  T

;;;


;;; 4.  部分集合，冪集合，補集合

;; ある集合の要素すべてが，他の集合の要素であるような集合を部分集合と言います．

(defun subset-p (s1 s2)
  (every #'(lambda (e1) (member e1 (set-elements s2) :test #'equals))
         (set-elements s1)))

;; ですから，どんな集合でも自分自身の部分集合になりますし，空集合はどんな集合の部分集合にもなります．このとき，空リストについての every の定義がうまく働いていますね．

(subset-p +empty+ +empty+)
;=>  T

(subset-p +empty+ (set-of 1 2 3))
;=>  T

(subset-p (set-of 1 2 3) (set-of 1 2 3))
;=>  T

(subset-p (set-of 1 2) (set-of 1 2 3))
;=>  T

(every #'(lambda (x) x nil) '())
;=>  T

(subset-p (set-of 1 2) +empty+)
;=>  NIL

;; 今まで集合の印刷ではCLOSの既定の印刷が用いられてきて，直接その中身を見ることはできませんでした．
;; CLOSのオブジェクトは構造体と同様に，その印刷をカスタマイズすることができます．ここで本当に集合のように見えるような印刷メソッドを定義してみましょう．この format 文での反復の書き方は，「実践Common Lisp」に説明があります．

(defmethod print-object ((object set) stream)
  (format stream "{~{~S~^,~}}" (set-elements object)))

;; すると，システムは集合の印刷にこのメソッドを使うようになります．

+empty+
;=>  {}

(set-of 1)
;=>  {1}

(set-of 1 2 3)
;=>  {1,2,3}

;; さて，いよいよ冪集合です．冪集合の公理では，任意の集合についてその集合の部分集合全体からなる集合の存在を主張します．冪集合を作るには，まず，任意の集合からそのすべての部分集合を作り出さなければなりません．ここでLisp の再帰をうまく使います．

(defun power-set (s)
  (cond ((empty-p s) (set-of s))
        ((singleton-p s) (set-of s +empty+))
        (t (set (cons s
                      (set-elements
                       (apply #'union-of
                              (mapcar #'(lambda (e)
                                          (power-set (set (remove e (set-elements s)))))
                                (set-elements s)))))))))

;; 空集合の冪集合は空集合のシングルトン (訂正）です．シングルトンの冪集合は自分自身と空集合の合併です．それ以上の大きな集合については，その要素からひとつ何かの要素を取り去ったものの冪集合の合併と自分自身の合併です．

(power-set +empty+)
;=>  {{}}

(power-set (set-of 1))
;=>  {{1},{}}

(power-set (set-of 1 2))
;=>  {{1,2},{2},{1},{}}

(power-set (set-of 1 2 3))
;=>  {{1,2,3},{3},{1,3},{2,3},{1,2},{2},{1},{}}

;; ある集合 a に対するある集合 b の補集合 a - b はCommon Lisp の set-difference で簡単に定義できます．
(defun complement-of (set for)
  (set (set-difference (set-elements for) (set-elements set) :test #'equals)))

(complement-of (set-of 1 2) (set-of 1 2 3 4))
;=>  {4,3}

;; 集合演算と論理演算の比較でいうと，合併集合が論理の and に相当し，共通集合が論理の or に相当します．そして補集合が実は論理の not に相当するのですが，これからわかるように not というのは，本当は何に対する補集合なのかがなければならないのです．もしそれが与えられないとすると，それは全体に対してということになるのですが，それが得てして問題なのです．以前に not を入れると途端に難しくなるって書いたことがありますが，なんとなく分かっていただけたでしょうか．

;;;; CLOS で学ぶ集合論その５，順序数，超限順序数，カントールのパラドッ
;;; クス5.  順序数，超限順序数，カントールのパラドックス

;; 今まで，集合の要素として数を許してきたが，カントールは集合以外の一切
;; の挟雑物を除いて，何もないところから出発し，集合論の基礎を築いた．何
;; もないと言っても，集合という考え方はあって，最初に何もない集合すなわ
;; ち空集合の存在だけを認めるのである．そしてそれから出発して，それ以外
;; のもの，特にカントールが行ったのは自然数に相当する無限の順序数，さら
;; に可算個無限の順序数を超える順序数，すなわち超限順序数を明らかにして，
;; 集合の濃度について道を開いた．同時に，集合概念に含まれる矛盾について
;; も道を開いてしまい，それがラッセルのパラドックス，さらにはゲーデルの
;; 不完全性定理へのつながってくるのである．

;; 集合の冪集合についてはすでに，導入済みであるが，カントールの集合論で
;; は最初に空集合から出発して，順にその冪集合を計算する．

(defvar one (power-set +empty+))
;=>  {{}}

(defvar two (power-set one))
;=>  {{{}},{}}

(defvar three (power-set two))
;=>  {{{{}},{}},{{}},{{{}}},{}}

(defvar four (power-set three))
;=>  {{{{{}},{}},{{}},{{{}}},{}},{{{}},{}},{{{{}},{}},{}},{{}},{{{{}},{}},{{}},{}},{{{}},{{{}}},{}},{{{{}},{}},{{{}}},{}},{{{{}}},{}},{{{{}},{}},{{}},{{{}}}},{{{{}}}},{{{{}},{}},{{{}}}},{{{}},{{{}}}},{{{{}},{}},{{}}},{{{}}},{{{{}},{}}},{}}

;; 今ここでは適当に one とか two とかのシンボルに代入したが，空集合を
;; zero と見做したとき，我々はこのようにして自然数と同型の集合を実際に
;; 得ることができる．今 one とか two に変えて，仮にギリシャ文字と数字を
;; 使って，α，β，とすれば，この文字の順番で冪集合の手続きの出現順に１
;; 対１対応を取るものとすれば，次のようになって，そのとき，文字の順序と
;; 冪集合の部分集合における順序が全く同型であることがわかる．

(defvar α (power-set +empty+))
;=> {{}}
(defvar β (power-set α)) ;=> {{{}},{}}

(defvar γ (power-set β))
;=> {{{{}},{}},{{}},{{{}}},{}}
(defvar δ (power-set γ))
;=> {{{{{}},{}},{{}},{{{}}},{}},{{{}},{}},{{{{}},{}},{}},{{}},{{{{}},{}},{{}},{}},{{{}},{{{}}},{}},{{{{}},{}},{{{}}},{}},{{{{}}},{}},{{{{}},{}},{{}},{{{}}}},{{{{}}}},{{{{}},{}},{{{}}}},{{{}},{{{}}}},{{{{}},{}},{{}}},{{{}}},{{{{}},{}}},{}}
(char< #\α #\β) ;=> T (subset-p α β) ;=> T (char< #\β #\δ) ;=> T
(subset-p β δ) ;=> T

;; そればかりか，カントールの集合のようにすべての要素が空集合から出発し
;; て冪集合で作られた集合の場合には，上記のような部分集合であるのみなら
;; ず，低位の集合は高位の集合の要素でもある．

(defun in (member set) (not (null (member member (set-elements set)
  :test #'equals))))

(in α β) ;=> T

(in α γ) ;=> T

(in β γ) ;=> T

(in β δ) ;=> T

;; 今たまたま，ギリシャ文字における計算機内部でのchar< 順序と１対１に対
;; 応した集合をつくることができたが，このように我々が持っている自然数の
;; 順序概念に対応したものを，空集合と冪集合および部分集合の概念から作る
;; ことができる．

;; では，これの極限で得られるものはなんだろうか．つまりこのような手続き
;; を無限回行って，その極限において得られる順序数である．通常集合論では
;; それはオメガ ω と表記される．0を空集合，1を1回目の冪集合，2を2回目
;; の冪集合として，ω は自然数全体に相当する集合である．常に α ∈ β
;; ，α ⊂β だからもちろん α ∈ β ∈ω ，α ⊂β⊂ω である．このω
;; のさらに冪集合を得ることができるだろうか．ここからがカントールの仕事
;; を諾とするか否とするかの分かれ目になるのだが，カントールはさらにω＋
;; 1，ω＋2，．．．，ω＋ω ，．．．と考えていくのだ．自然数の大きさは
;; 可算個無限，あるいは付加番無限と呼ばれ，その大きさ（無限だから濃度と
;; いう）アレフ0 と言われる．ω を含む順序数は通常の順序数の範囲を超え
;; ているので超限順序数と呼ばれる．（続く）

;; ================================================================
