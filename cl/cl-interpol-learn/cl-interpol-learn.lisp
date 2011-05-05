;;;; cl-interpol-learn.lisp

(cl:in-package :cl-interpol-learn-internal)

(def-suite cl-interpol-learn)

(in-suite cl-interpol-learn)


(enable-interpol-syntax)


#?"abc"
;=> "abc"

#?r"abc"
;=> "abc"

#?x"abc"
;=> "abc"

#?rx"abc"
;=> "abc"

#?'abc'
;=> "abc"

;??? slime
(progn #?|abc|)
;=> "abc"

#?#abc#
;=> "abc"

#?/abc/
;=> "abc"

;; ??? slime
(progn #?(abc))
;=> "abc"

#?[abc]
;=> "abc"

#?{abc}
;=> "abc"

#?<abc>
;=> "abc"


#?"abc"
;=> "abc"

#?"abc\""
;=> "abc\""

#?"abc\\"
;=> "abc\\"

#?[abc]
;=> "abc"

#?[a[b]c]
;=> "a[b]c"

#?[a[[b]]c]
;=> "a[[b]]c"

#?[a[[][]]b]
;=> "a[[][]]b"


;; ----------------------------------------------------------------

(progn #?"New\nline")
;=> "New
;   line"

;; char-code


(progn #?"\40\040")
;=> "  "

(map 'list #'char-code #?"\0\377\777")
;=> (0 255 255)

(progn #?"Only\0403 digits!")
;=> "Only 3 digits!"

(map 'list #'identity #?"\9")
;=> (#\9)

(char-code #\a)
;=> 97
#o141

(progn #?"\141\141")
;=> "aa"

(progn #?"\141\141")
;=> "aa"

(progn #?"\x61\x61")
;=> "aa"

(princ #?"\x{3042}\x{3042}")
;-> ああ
;=> "ああ"

(char-name (char #?"\cH" 0))
;=> "Backspace"

(princ #?"\N{bullet operator}")
;-> ∙
;=> "∙"

(progn #?"\lFOO")
;=> "fOO"

(progn #?"\lFOO \ufoo")
;=> "fOO Foo"

(progn #?"\LFOO \Ufoo")
;=> "foo FOO"

;; \Q
(progn #?"\Q---\E")
;=> "\\-\\-\\-"

(progn #?"\Qあいう\E")
;=> "\\あ\\い\\う"


;; \E end scope
(progn #?"\LFOO FOO")
;=> "foo foo"

(progn #?"\LFOO\E FOO")
;=> "foo FOO"

;; Interpolation


(let* ((a "foo")
         (b #\Space)
         (c "bar")
         (d (list a b c))
         (x 40))
    (values #?"$ @"
            #?"$(a)"
            #?"$<a>$[b]"
            #?"\U${a}\E \u${a}"
            (let ((*list-delimiter* #\*))
              #?"@{d}")
            (let ((*list-delimiter* ""))
              #?"@{d}")
            #?"The result is ${(let ((y 2)) (+ x y))}"
            #?"${#?'${a} ${c}'} ${x}"))
;=> "$ @"
;   "foo"
;   "foo "
;   "FOO Foo"
;   "foo* *bar"
;   "foo bar"
;   "The result is 42"
;   "foo bar 40"

(let ((hello "こんにちは"))
  #?"$(hello)")
;=> "こんにちは"

(let ((hello "こんにちは"))
  #?|$(hello)|)
;=> "こんにちは"

;; implicit progn
(let ((hello "こんにちは"))
  #?"${hello 2}")
;=> "2"

;; Support for CL-PPCRE/Perl regular expressions

(scan #?#\W\o\w# "wow")
;=> NIL

(scan #?/Wow/ "Wow")
;=> 0
;   3
;   #()
;   #()

(progn (scan #?/\W/ "foo "))

(progn
  #?/A(?#n embedded) comment/)
;=> "A comment"

;; //の中では${}だけ効く
(let ((a 42))
  (values #?"$(a)" #?"${a}"
          #?/$(a)/ #?/${a}/))
;=> "42"
;   "42"
;   "$(a)"
;   "42"

(do-register-groups (W) ("(\\w|\\W)" "foo bar baz")
  (princ (list w)))
;-> (f)(o)(o)( )(b)(a)(r)( )(b)(a)(z)
;=> NIL

(do-register-groups (W) (#?"(\\w|\\W)" "foo bar baz")
  (princ (list w)))
;-> (f)(o)(o)( )(b)(a)(r)( )(b)(a)(z)
;=> NIL

(do-register-groups (W) (#?"(\\w|\\W)" "foo bar baz")
  (princ (list w)))

;; |の数が偶数の場合はどうにかしのげるが意味が変わる
(do-register-groups (W) (#?/(\w|\s|\W)/ "foo bar baz")
  (princ (list w)))
;-> (f)(o)(o)( )(b)(a)(r)( )(b)(a)(z)
;=> NIL

(let ((scanner (cl-ppcre:create-scanner "^a{3, 3}$" :extended-mode t)))
    (cl-ppcre:scan scanner "aaa"))
;=> NIL

(let ((scanner (cl-ppcre:create-scanner "^a{3, 3}$" :extended-mode t)))
    (cl-ppcre:scan scanner "a{3,3}"))
;=> 0
;   6
;   #()
;   #()
