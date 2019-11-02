(in-package :cl-user)

;; CLOS 組込みクラス及び構造体クラスとメタクラス

;; 本当はこの記事は，これまでのCLOS で学ぶ集合論の一環なんですが，ちょっ
;; と内容がCLOS の話だけで集合論は出てきそうもないので，こういう内容に
;; ふさわしいタイトルにしました．

;; 前のブログで，CLOS はLisp の型システムに統合されているという話をして，
;; (find-class 't) とか(find-class 'integer) でCLOS の組込みクラスであ
;; る built-in クラスの話をしました．正当なCLOSクラスではないそのほかの
;; クラスとして構造体クラス(structure class) があります．Lisp の構造体
;; はユーザが定義できますが，構造体を定義するときのオプションで
;; :include を用いると，それが型の上下関係を定義したことになり，それが
;; CLOSの構造体クラスの上下関係にもなっています．

(find-class 't)
;=>  #<BUILT-IN-CLASS T>
(find-class 'integer)
;=>  #<BUILT-IN-CLASS INTEGER>
(class-of 1)
;=>  #<BUILT-IN-CLASS FIXNUM>
(defstruct foo)
;=>  FOO
(defstruct (bar (:include foo)))
;=>  BAR
(subtypep 'bar 'foo)
;=>  T
;    T
(find-class 'foo)
;=>  #<STRUCTURE-CLASS FOO>
(find-class 'bar)
;=>  #<STRUCTURE-CLASS BAR>
(subtypep (find-class 'bar) (find-class 'foo))
;=>  T
;    T

;; なぜこんなことをしているかというと，Lisp の型システムに統合すること
;; で，CLOS のメソッドを単に普通のCLOS 実現体だけでなく，すべてのLisp
;; オブジェクトに適応することが可能になるからです．

(defmethod iam ((x integer))
  (format t "I am integer ~S." x))

(defmethod iam ((x foo))
  (format t "I am a foo: ~S" x))

(iam 1)
;>>  I am integer 1.
;=>  NIL

(iam (make-foo))
;>>  I am a foo: #S(FOO)
;=>  NIL

;; ここでクラスとしての integer やクラスとしての構造体クラスも，通常の
;; defclass で定義されるクラスと同じく一種のオブジェクトです．ですから
;; これをメタオブジェクトともいいます．これは普通のオブジェクト指向言語
;; と違うところですね．最近ではC#やJavaもリフレクションとか言って，クラ
;; ス情報をプログラム中に取り込んでその情報で仕事を変えることができるよ
;; うになりましたが，CLOSほどオブジェクトとして徹底されているわけではあ
;; りません．それでは，ここからが問題です．メタオブジェクトのクラスは一
;; 体何でしょうか．実はCLOSではこれもオブジェクトとして実現されています．
;; それがcl:standard-class という名前のクラスです．クラスオブジェクト
;; （メタオブジェクト）のクラスですから，これをメタクラスと言います．

(class-of (find-class 'integer))
;=>  #<STANDARD-CLASS BUILT-IN-CLASS>

(class-of (find-class 'foo))
;=>  #<STANDARD-CLASS STRUCTURE-CLASS>

(defclass myclass () ())
;=>  #<STANDARD-CLASS MYCLASS>

;; さらにこれからが問題です．それではcl:standard-class のクラスは一体何
;; でしょうか？実はそれはcl:standard-class 自身なのです．

(find-class 'standard-class)
;=>  #<STANDARD-CLASS STANDARD-CLASS>

(class-of (find-class 'standard-class))
;=>  #<STANDARD-CLASS STANDARD-CLASS>

;; 自分が自分自身の実現体だなんて，落語の頭山のようにありえない，という
;; 話になるのですが，これを集合論的に理解しようというのが，このブログシ
;; リーズの本当の目的なのですが，その解決はあとまわしにして，話を型階層
;; に戻します．きっちりと区別してもらいたいのは，型を集合として捉えたと
;; き，クラス／インスタンス関係は集合とその要素（元とも言います）の関係
;; であり，上位クラス／下位クラス関係は，集合の包含関係である，というこ
;; とです．これをごっちゃにしてほしくないし，集合がその要素としてその集
;; 合を含むということも絶対にないことなのです．本当に多くの人がこれを曖
;; 昧に捉えていますが，地上にあるものを一つのオブジェクトと考えたとき
;; （これを個物という），個物の集合は人の頭で考える普遍物であり，これが
;; クラスです．それはあたかも地上から１階上に上がった２階（first floor）
;; の話です．で，この普遍物についてまた集合を考えれば，これは3階
;; (second floor)の話になります．１階を２階とごちゃごちゃにすることはな
;; いし，２階と３階をごちゃごちゃにすることもありません．ただし，
;; cl:standard-class だけは階の上昇がループしているし，あとで出てきます
;; が，cl:standard-object だけはすべてのオブジェクトを呑み込んでしまう
;; ブラックホールみたいなものなのです．ですからcl:standard-class と
;; cl:standard-object だけは特別に考えてください．

;; ここまでは，すべての処理系で共通の話です．さて，cl:standard-object
;; の上位クラスは普通は 組込みクラスの t です．それでは，組込みクラス
;; t の上位クラスは？

(sb-mop:class-direct-superclasses (find-class 'standard-object))
(c2mop:class-direct-superclasses (find-class 'standard-object))
;=>  (#<SB-PCL::SLOT-CLASS SB-PCL::SLOT-OBJECT>)

(c2mop:class-direct-superclasses (find-class 'sb-pcl::slot-object))
;=>  (#<BUILT-IN-CLASS T>)

;; (#<built-in-class t>)
(c2mop:class-direct-superclasses (find-class 't))
;=>  NIL

;; ありませんでした．それでは，cl:standard-class の上位クラスは何でしょ
;; うか？これは実に処理系によって様々なのですが，各自ご自分の処理系で確
;; かめてほしい．

(c2mop:class-direct-superclasses (find-class 'standard-class))
;=>  (#<STANDARD-CLASS SB-PCL::STD-CLASS>)

(c2mop:class-direct-superclasses (find-class 'standard-class))
;=>  (#<STANDARD-CLASS SB-PCL::STD-CLASS>)
;; (#<standard-class excl::std-class>)
;; (mop:class-direct-superclasses (find-class 'excl::std-class))
(c2mop:class-direct-superclasses (find-class 'sb-pcl::std-class))
;=>  (#<STANDARD-CLASS SB-PCL::SLOT-CLASS>)
;; (#<standard-class excl::clos-class>)
;; (mop:class-direct-superclasses (find-class 'excl::clos-class))
(c2mop:class-direct-superclasses (find-class 'sb-pcl::slot-class))
;=>  (#<STANDARD-CLASS SB-PCL::PCL-CLASS>)
;; (#<standard-class class>)
(c2mop:class-direct-superclasses (find-class 'sb-pcl::pcl-class))
;=>  (#<STANDARD-CLASS CLASS>)
(c2mop:class-direct-superclasses (find-class 'class))
;=>  (#<STANDARD-CLASS SB-PCL::DEPENDENT-UPDATE-MIXIN>
;     #<STANDARD-CLASS SB-PCL::DEFINITION-SOURCE-MIXIN>
;     #<STANDARD-CLASS SB-PCL::STANDARD-SPECIALIZER>)

;; (mop:class-direct-superclasses (find-class 'class))
;; (#<standard-class excl::documentation-mixin> #<standard-class excl::dependee-mixin> #<standard-class aclmop:specializer>)
;; (mop:class-direct-superclasses (find-class 'aclmop:specializer))
;; (#<standard-class aclmop:metaobject>)
;;  (mop:class-direct-superclasses (find-class 'aclmop:metaobject)) (#<standard-class standard-object>)

;; いずれにしても，どこかでcl:standard-object が出てくることになっています．

;; では，せっかくですから，ここで型の階層関係を見せてくれるプログラムを
;; 作ってみましょう．このコードはSchank らのMemory Organization
;; Package にあるプログラムをちょっと CLOS 用に修正したものです．

(defun dah (cls)
  "dah <cls>
   prints all the specalizations under <cls>. The name is short for
   'display abstraction hierarchy'"
  (pprint (tree->list cls #'specs->list nil)))

(defun tree->list (cls fn visited)
  "tree->list <cls> <function> <cls-list>
   returns a list starting with <cls>, followed by the elements of
   the list returned by calling <function> with <cls> and <cls-list>
   updated to include <cls>. If <cls> is already in <cls-list>, just
   a list with <cls> is returned."
  (cond ((member cls visited) (list (class-name cls)))
        (t
         (push cls visited)
         `(,(class-name cls) ,@(funcall fn cls visited)))))

(defun specs->list (cls visited)
  "SPECS->LIST <cls> <cls-list>
   returns a list starting with <cls>, followed by the specialization
   tree under each specializations of <cls>."
  (loop for spec in (c2mop:class-direct-subclasses cls)
      when (tree->list spec #'specs->list visited)
      collect it))

;; (dah (find-class 'standard-object)) とか (dah (find-class 't)) とかすれば，型階層をツリーで見ることができますよ．

;; (dah (find-class 'standard-object))

;; (dah (find-class 't))

;; # CLOS 組込みクラス及び構造体クラスとメタクラス
;; -- [http://blog.livedoor.jp/s-koide/archives/1903493.html CLOS 組込みクラス及び構造体クラスとメタクラス]


;; CLOS で学ぶ集合論その６（続きの続きの続き）

;; 前回の記事は本当は，この記事の前振りにあたります．混乱しそうですが，
;; バックグラウンドの理解ということで，よろしくお願いします．

;; さて，カントールは集合論の創始者で，数論の議論に道を開いたわけですが，
;; 同時にゲーデルの不完全性定理に至る，今日では超数学と呼ばれる分野にも
;; つながるパラドックスも明らかにしてしまいました．前々から展開してきた
;; ように，集合の内包的表記では，
;; { x | φ(x) } という形式で集合を表します．ここでその意味は φ(x) と
;; いう性質を持つ要素 x のすべての集合，という意味です．このような表記
;; をベースとする集合論で内部にパラドックスを含む集合論を素朴集合論と言
;; います．素朴集合論に含まれるパラドックスを限りなく単純な形で明らかに
;; したのがラッセルのパラドックスであり，それを解決（回避）するように，
;; 個物としては空集合のみのZermelo-Fraenkel （通称ZF）集合論，一般の個
;; 物を許すvon Neumann–Bernays–Godel 集合論が創出されていきます．

;; この集合論ブログの最初に，x = x という同一性の話をして，集合における
;; 外延性公理を紹介しました．x = x は真というのは，どんな場合でも成り立
;; つことですから，これを内包とするような集合の定義は，すべての個物やす
;; べての集合についてあてはまる定義です．このような集合を今から
;; universal class と呼ぶことにします．universal class を実現するために，
;; satisfies ではありませんが，１変数の述語 φ(x) を許すようにこれまで
;; の in と subset-p を拡張します．ちょっとコード量が多くなりますので，
;; 今日時点での最新のコードを ここに置きました．興味のあるかたはダウン
;; ロードしてみて，議論につきあってください．ダウンロードしなくても要点
;; はわかるはずですが．universal-p という述語を次のように定義すれば，ユ
;; ニバーサルクラス +RR+ は次のようになります．

(in-package :zf)

(defun universal-p (x)
  (equals x x))

(defparameter +RR+ (set-by :type #'universal-p))

;; すると，すべてのものはこのクラスに所属することができます．数でも，自
;; 然数の集合でも，なんでも．

(in 1 +RR+)
;=>  T
;    T
(in +NN+ +RR+)
;=>  T
;    T

(in "This is a string." +RR+)
;=>  T
;    T

(in 'aSymbol +RR+)
;=>  T
;    T

;;コードを見ていただければ分かりますが，新しく拡張された in では，集合
;;の type スロットの値が関数の場合にはその述語を与えられた要素かもしれ
;;ない引数に適応します．universal-p はどんな x がきてもそれが x = x で
;;あるかを見るだけですから，その時々の文脈で well-formed formula であれ
;;ば常に真ですね．だからこれは type スロットの値を t とするユニバーサル
;;クラスと意味的に同一です．記述論理ではこれを T と書いて top と読みま
;;す．

(defparameter +TOP+ (set-by :type 't))

;; +TOP+ はCommon Lisp の型階層における t と同様に，集合論における最上
;; 位の集合になります．反対に nil を type に持つような集合は最下位の集
;; 合になって，それを記述論理では ⊥ と書いて bottom と読みます．実は
;; bottom は空集合と同等なので，その意味で以下のようにしました．

(defparameter +BOTTOM+ (set-by :type 'nil))

(setf (member-of +BOTTOM+) nil)

(finalize +BOTTOM+) ; define rank

(equals +RR+ +TOP+)
;=>  T
;    T

(equals +empty+ +BOTTOM+)
;=>  T
;    T

;; 実はちょっとズルをして，equals のコード中にもし type が universal-p
;; の述語だったら，というコードを埋め込んでいますが，はっはっ，このくら
;; いは許してください．エージェントがLisp コードの意味を理解できるよう
;; になればいいんですけどね．

;; さて，ここからが本題です．この実装では見かけ上，+RR+ や +TOP+ はそ
;; の要素としてそれ自身に所属することができます．

(in +RR+ +RR+)
;=>  T
;    T

(in +TOP+ +TOP+)
;=>  T
;    T


;; 何故でしょうか？前にも書いたように，集合が自分自身に所属することはあ
;; りません．実装としてはたとえば (universal-p +RR+) が起動されるだけで
;; すから，<t, t> が返ります．

(in +RR+ +RR+)
;=>  T
;    T
#||
 (universal-p {x | #<Function universal-p>})
 0[6]: returned t t
t
t
||#

;; 集合にまつわるパラドックスには，カントールのパラドックス，ブラリ・フォ
;; ルティのパラドックスがありますが，これらのすべての集合みたいな集合に
;; 関するパラドックスだけでなく，自分自身を要素としない集合についてもパ
;; ラドックスが含まれます．それがRussell 集合と呼ばれる集合のパラドック
;; スでラッセルのパラドックスと呼ばれます．今，自分自身を要素としないと
;; いう述語を次のように定義して，ラッセル集合を定義します．

(defun russell-p (x)
  (multiple-value-bind (val1 val2) (in x x)
    (if val1 (values nil t)
      (if val2 (values t t)
        (values nil nil)))))

(defparameter +Russell+ (set-by :type #'russell-p))

;; すると，一見よさそうに見えるのですが，これを自分自身に適応すると矛盾
;; が露呈します．

(in +NN+ +Russell+)
;=>  T
;    T
(in +INT+ +Russell+)
;=>  T
;    T
(in +RR+ +Russell+)
;=>  NIL
;    T
;; (in +Russell+ +Russell+)

;; Error: Stack overflow (signal 1000)
;; [condition type: synchronous-operating-system-signal]

;; ここで (in +RR+ +Russell+) が一見もっともらしく動いたのは，
;; russell-p の働きの中で universal-p が動いて，これが真となり，その否
;; 定で偽となったものであり，(in +Russell+ +Russell+) のスタックオーバー
;; フローは in の呼び出しが再帰になったがためです．

#||
zf(23): (trace russell-p universal-p)
\(universal-p russell-p)
zf(24): (in +RR+ +Russell+)
 0[6]: (russell-p {x | #<Function universal-p>})
   1[6]: (universal-p {x | #<Function universal-p>})
   1[6]: returned t t
 0[6]: returned nil t
nil
t
||#

;; Lisper の常識から言わせれば，あっそんなことしちゃだめだめ，というこ
;; とになるのですが，(in +RR+ +RR+) はきちんと動くのに対して (in
;; +Russell+ +Russell+) は駄目というところをどう解釈するのかというのが
;; 集合論的な問題なのです．ちなみに，Russell 集合 { x | x ∉ x } ではな
;; く，自分自身を含む集合 { x | x ∉ x } についてもパラドックスは全く同
;; 様です．ユニバーサルクラス
;; { x | x = x } は問題ないのにですよ．

;; カントールまでの素朴集合論では，{ x | φ(x) } のような形で集合を定義
;; できると考えられていました．この φ(x) にはどんな形の式がきてもよい
;; と．これを（今では）無制限の包括原理と呼びます．ここで，α = { x |
;; φ(x) } は∀x [ (x ∈ α) ⇔ φ(x) ]　と書けることを指摘しておきます．
;; すなわち，φ(x) を満足する x は α の要素であり，その逆も真．ところ
;; が今ラッセル集合 R = { x | x ∉ x } について考えると，任意の x の一つ
;; として R をとれば，R = R ⇔ R ∉ R と矛盾が簡単に導かれます．どこがい
;; けなかったのか分かりますか？結論として，今日では α = { x | φ(x) }
;; と書けるようなものをクラスと呼び，クラスには集合もあるが集合となりえ
;; ないものもあり，それを特別に本来のクラス(proper class) と呼んでいま
;; す．ですからRussell 集合は本当はRussell クラスと呼ばなければならず，
;; 実際にそう呼んでいる教科書もあります．

;; ユニバーサルクラス { x | x = x } も，本当の意味では集合ではなく，そ
;; れはクラスである，というわけです．ちなみに，あれこれの予備知識を前提
;; としないで，集合論を教えるブルバキの数学原論では，集合を作り得る関係
;; なるものを教えて，関係 x ∈ y （x と y は異なる記号）は集合を作り得
;; るが，x ∉ x は集合を作りえない，と述べています．ですから，ユニバーサ
;; ルクラスは集合ではなく，集合みたいな顔をした（この実装での）しかけな
;; のですよ．では，ラッセルクラスも何かしかけることができるかって？い
;; やー，多分駄目でしょうね．なんか根源的にだめなもののような気がします．
;; Lisp の再帰では，このブログで説明したように，複雑なものを一つブレー
;; クダウンして，簡単なものに分解し，そのそれぞれに対して再帰させます．
;; そしてその再帰が停止する終了条件を書くことが重要です．集合においても
;; 同様な基礎の公理（正則性の公理）というものがあって，∈の階梯を下って
;; 行ったら必ず最後は空集合で停止する，というものがあります．ユニバーサ
;; ルクラスにせよ，ラッセルクラスにせよ，それだけの条件ではこの正則性の
;; 公理を満たすことはできませんね．

;; このラッセルのパラドックスをきっかけとして，Zermelo は無制限の包括原
;; 理のかわりに，分出原理というものを置きました．

;;     ∀z∃α∀x [ (x ∈ α) ⇔ (x ∈ z) ∧ φ(x) ]

;; ここでは，集合は任意の公式 φ(x) からだけでは，作ることができず，そ
;; の集合の要素は必ず何か別の集合かクラス z を必要とし，その要素として
;; なければなりません．CLOS でいけば，すべてのクラスは，
;; cl:standard-class の実現であるみたいなことですね．上の式ではどんな
;; z でもいいと言っていますけどね．

;; Zermeloはいくつかの集合の公理を明らかにしましたが，それに加えて
;; Fraenkel の公理による集合論が今日一つの標準となっている
;; Zermelo-Fraenkel の集合論です．しかし，オントロジーやオブジェクト指
;; 向の観点からは，Zermelo-Fraenkel の集合論ではすべての実現は集合しか
;; ありません．線とか四角とか円とか，Cat とかAnimal とかはないのです．
;; そこで個物として集合以外のものも認めようとする集合論があります．次は
;; そういう話ができるといいですね．
