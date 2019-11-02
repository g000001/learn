(ql:quickload :esrap)

(defpackage :esrap-scratch
  (:use :cl :esrap :snow-match))


(in-package :esrap-scratch)

;;; A semantic predicate for filtering out double quotes.

(defun not-doublequote (char)
  (not (eql #\" char)))

(defun not-integer (string)
  (when (find-if-not #'digit-char-p string)
    t))


;; Identifier = [:letter:]([:letter:] | [:digit:])*
;; Integer    = [:digit:] [:digit:]*

#|
program = block "." .

block = [ "const" ident "=" number {"," ident "=" number} ";"]
        [ "var" ident {"," ident} ";"]
        { "procedure" ident ";" block ";" } statement .
statement = [ ident ":=" expression | "call" ident |
            "begin" statement {";" statement } "end" |
            "if" condition "then" statement |
            "while" condition "do" statement ].
condition = "odd" expression |
            expression ("="|"#"|"<"|"<="|">"|">=") expression .
expression = [ "+"|"-"] term { ("+"|"-") term}.
term = factor {("*"|"/") factor}.
factor = ident | number | "(" expression ")".
|#


(defrule whitespace (+ (or #\space #\tab #\newline))
  (:constant nil))

(defrule digit (or #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))
#|(defrule integer (+ (or "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"))
  (:lambda (list)
    (parse-integer (text list) :radix 10)))|#

(defrule letter (or . #.(mapcar #'string (coerce "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" 'list)))
  (:lambda (c)
    (string-upcase c)))

(parse 'letter "z")

(defrule number (and (? whitespace)
                     (+ digit)
                     (? whitespace))
  (:destructure (space list space2)
                (declare (ignore space space2))
                (parse-integer (format nil "~{~A~}" list))))

(parse 'number "888 ")

(defrule ident (and (? whitespace)
                    letter (* (or letter digit))
                    (? whitespace))
  (:destructure (space head tail space2)
                (declare (ignore space space2))
                (intern (format nil "~A~{~A~}" head tail))))

(parse 'ident " z8a8zzz888 ")

(:destructure (pm t1 t2*)
                (sl::flatten (list pm t1 t2*)))

(defrule expression (and (? whitespace)
                         (? (or #\+ #\-)) term
                         (* (and (or #\+ #\-) term)))
  (:lambda (exp)
    (match exp
      ((NIL NIL var NIL) var)
      ((NIL "+" var NIL) `(+ ,var))
      ((NIL "-" var NIL) `(- ,var))
      ((NIL NIL var (r ***)) `(+ ,var
                                   ,@(mapcar (lambda (x)
                                               (match x
                                                 (("+" var) `(+ ,var))
                                                 (("-" var) `(- ,var))
                                                 (exp exp)))
                                             r)))
      ((NIL fn var (r ***)) `(+ (,(intern fn :cl) ,var)
                                  ,@(mapcar (lambda (x)
                                              (match x
                                                (("+" var) `(+ ,var))
                                                (("-" var) `(- ,var))
                                                (exp exp)))
                                            r)))
      (exp exp))))

(parse 'expression "baa+8")

NIL

NIL
(NIL "-" (8) NIL)
NIL

(parse 'expression "8*a")

NIL

NIL

(+ 8 (("-" (8)) ("-" (8))))
NIL
NIL

(:destructure (f1 f2*)
                (sl::flatten (list f1 f2*)))

(defrule term (and factor (* (and (or #\* #\/) factor)))
  (:lambda (exp)
    (match exp
      ((x nil) x)
      ((x (r ***))
       `(* ,x ,@(mapcar (lambda (x)
                          (match x
                            (("/" var) `(/ ,var))
                            (("*" var) `(* ,var))
                            (exp exp)))
                        r)))
      (exp exp))))

(parse 'term "8")

(parse 'term "8/8/8")
(8 (("/" 8) ("/" 8) ("/" 8)))
NIL

NIL

(:lambda (x)
    (if (atom x)
        x
        (let ((body (cdr (butlast x))))
          (cons 'progn body))) )

(defrule factor (or ident number (and #\( expression #\)))
  (:lambda (exp)
    (match exp
      (("(" sub ")") `(progn ,sub))
      (exp exp)) ))

(parse 'factor "8")
(parse 'factor "a")
(parse 'factor "(-z8+8-q)")
;; (PROGN (+ (- Z8) (+ 8) (- Q)))


NIL
(parse 'factor "(+z8)")


(:lambda (x)
    (cond ((and (atom (car x)) (string= "ODD" (car x)))
           `(odd ,(cadr x)))
          (T x)))
(defrule condition (and (? whitespace)
                        (or (and "ODD" expression)
                            (and expression
                                 (or "=" "#" "<=" "<"  ">=" ">")
                                 expression)))
  (:lambda (exp)
    (match exp
      ((NIL ("ODD" r ***)) `(oddp ,@r))
      ((NIL (x "#" y)) `(/= ,x ,y) )
      ((NIL (x fn y)) `(,(intern fn) ,x ,y) )
      (exp exp))))

(parse 'condition " ODD 8 - 8")

(parse 'condition " ODD 8 +8*338")

NIL
(parse 'condition "a = (a3+8/8)")



;;  [ ident ":=" expression | "call" ident |
;;             "begin" statement {";" statement } "end" |
;;             "if" condition "then" statement |
;;             "while" condition "do" statement ]

(defrule statement (and (? whitespace)
                        (or (and ident ":=" expression
                                 (? whitespace))
                            (and "CALL" ident
                                 (? whitespace))
                            (and "BEGIN" statement
                                 (? whitespace)
                                 (* (and ";" (? whitespace) statement))
                                 (? whitespace)
                                 "END"
                                 (? whitespace))
                            (and "IF" condition "THEN" statement)
                            (and "WHILE" condition "DO" statement)))
  ;; (&optional asign call begin if while)
  (:lambda (exp)
    (match exp
      ((nil (var ":=" val nil)) `(setq ,var ,val))
      ((NIL ("CALL" fn NIL)) `(funcall (function ,fn)))
      ((NIL ("BEGIN" sub NIL NIL NIL "END" NIL)) sub)
      ((NIL ("BEGIN" sub NIL ((";" NIL sub*) ***) NIL "END" NIL))
       `(progn ,sub ,@sub*))
      ((NIL ("WHILE" pred "DO" sub))
       `(while ,pred ,sub))
      ((NIL ("IF" pred "THEN" sub))
       `(if ,pred ,sub))
      (exp exp))))

(parse 'statement
"BEGIN A:=8 END")
(PROGN (SETQ A 8))

(parse 'statement
"A := (8+8)")
(SETQ A (PROGN (+ 8 (+ 8))))

(parse 'statement
"A := 2 * a")


(parse 'statement
"CALL a")

(parse 'statement
       "
BEGIN
  a := x;
  b := y;
  z := 0;
  WHILE b > 0 DO BEGIN
    IF ODD b THEN z := z + a;
    a := 2 * a;
    b := b / 2
  END
END")

(p)
(print )
(parse 'statement
       "
  WHILE b > 0 DO BEGIN
    CALL a;
    CALL a
  END")

(parse 'statement
       "
BEGIN
  CALL a
END")



(parse 'statement
       "
BEGIN
  CALL a;
  CALL a
END")







(NIL ("BEGIN" (FUNCALL #'A) NIL ((";" NIL (FUNCALL #'A))) NIL "END" NIL))
NIL

NIL


  z := 0










(parse 'statement
       "
  WHILE b > 0 DO BEGIN
    IF ODD b THEN z := z + a;
    a := 2 * a;
    b := b / 2
  END
")

(parse 'statement
       "WHILE f # g DO BEGIN
    IF f < g THEN g := g - f;
    IF g < f THEN f := f - g
  END
")




(parse 'statement " a := 3")
(parse 'statement "CALL a3 ")
(parse 'statement
       "
BEGIN
  a3 := 3;
  CALL a3
END")

(parse 'statement "IF f < g THEN g := g - f")


(parse 'statement
       "BEGIN
  f := x;
  g := y;
  WHILE f # g DO BEGIN
    IF f < g THEN g := g - f;
    IF g < f THEN f := f - g;
  END;
  z := f
END")

;; block = [ "const" ident "=" number {"," ident "=" number} ";"]
;;        [ "var" ident {"," ident} ";"]
;;        { "procedure" ident ";" block ";" } statement .

(defrule block (and (? whitespace)
                    (? (and (? whitespace)
                            "CONST" ident "=" number
                            (* (and "," ident "=" number))
                            ";"))
                    (? (and (? whitespace)
                            "VAR" ident (* (and "," ident)) ";"))
                    (* (and (? whitespace)
                            "PROCEDURE"
                            (? whitespace)
                            ident
                            (? whitespace) ";"
                            (? whitespace)
                            block ";"))
                    (? whitespace)
                    statement)
  (:lambda (exp)
    (match exp
      ((ignore const-clause
               var-clause
               ((NIL "PROCEDURE" NIL name NIL ";" NIL block ";") ***)
               NIL
               statement)
       `(progn
          ,(match const-clause
             ((NIL "CONST" 1st-var "=" 1st-val (2nd- ***) ";")
              `(progn (defconstant ,1st-var ,1st-val)
                      ,@(match 2nd-
                          ((("," var "=" val) ***) (mapcar (lambda (r l)
                                                             `(defconstant ,r ,l))
                                                           var
                                                           val)))))
             (exp exp))
          ,(match var-clause
             ((NIL "VAR" 1st (2nd- ***) ";")
              `(progn (defvar ,1st)
                      ,@(match 2nd-
                          ((("," var) ***) (mapcar (lambda (x)
                                                     `(defvar ,x))
                                                   var)))))
             (exp exp))
          #|(defun ,name
                 ,@(match block
                     ((() () (() "VAR" 1st (2nd- ***) ";") () () b ***)
                      `((,1st ,@(mapcar #'second 2nd-)) ,@b))
                     (exp exp)))|#
          ,@(mapcar (lambda (name exp)
                      `(defun ,name
                             ,@(match exp
                                 (('PROGN
                                    ()
                                    ('PROGN ('DEFVAR var) ***)
                                    body)
                                  `(()
                                    (let (,@var)
                                      (declare (special ,@var))
                                      ,body))))))
                    name
                    block)
          ;; ,(print (list :block block))

          (progn ,statement)))
      (exp exp))))


(print (parse 'block
        "
CONST
  m =  7,
  n = 85;

VAR
  x, y, z, q, r;

PROCEDURE multiply;
VAR a, b;

BEGIN
  a := x;
  b := y;
  z := 0;
  WHILE b > 0 DO BEGIN
    IF ODD b THEN z := z + a;
    a := 2 * a;
    b := b / 2
  END
END;

PROCEDURE divide;
VAR w;
BEGIN
  r := x;
  q := 0;
  w := y;
  WHILE w <= r DO w := 2 * w;
  WHILE w > y DO BEGIN
    q := 2 * q;
    w := w / 2;
    IF w <= r THEN BEGIN
      r := r - w;
      q := q + 1
    END
  END
END;

PROCEDURE gcd;
VAR f, g;
BEGIN
  f := x;
  g := y;
  WHILE f # g DO BEGIN
    IF f < g THEN g := g - f;
    IF g < f THEN f := f - g
  END;
  z := f
END;


BEGIN
  x := m;
  y := n;
  CALL multiply;
  x := 25;
  y :=  3;
  CALL divide;
  x := 84;
  y := 36;
  CALL gcd
END"))





(parse 'block "
CONST a=3,b=3;
VAR a,b,c;
PROCEDURE foo;
CALL a3;
CALL a3
")

(parse 'block "
PROCEDURE foo;
  CALL a3;
CALL a3")

(parse 'block
"CONST a=3,b=9;
VAR a,b,c;
PROCEDURE foo;CALL a3;CALL a3")

(parse 'program
"CONST a=3,b=9;
VAR a,b,c;
PROCEDURE foo;
CALL a3;

BEGIN
  CALL a3
END.")
(print (p))


;; program = block "." .


(defrule program (and (? whitespace)
                      block
                      (? whitespace)
                      "."
                      (? whitespace))
  (:lambda (exp)
    (match exp
      ((nil block ignore ***) block))))

(print (p))
(parse 'program "
CONST
  a=3, b=9;

VAR
  a, b, c;

PROCEDURE gcd;
VAR f, g;
BEGIN
  f := x;
  g := y;
  WHILE f # g DO BEGIN
    IF f < g THEN g := g - f;
    IF g < f THEN f := f - g
  END;
  z := f
END;

CALL foo.")


(parse 'program "
CONST
  a=3, b=9;

VAR
  a, b, c;

PROCEDURE gcd;
VAR f, g;
BEGIN
  f := x;
  g := y;
  WHILE f # g DO BEGIN
    IF f < g THEN g := g - f;
    IF g < f THEN f := f - g
  END;
  z := f
END;

CALL foo.")
(PROGN
 (PROGN (DEFCONSTANT A 3) (DEFCONSTANT B 9))
 (PROGN (DEFVAR A) (DEFVAR B) (DEFVAR C))
 (DEFUN GCD (F G)
   (PROGN
    (SETQ F X)
    (SETQ G Y)
    (WHILE (/= F G)
     (PROGN
      (IF (< F G)
          (SETQ G (+ G (- F))))
      (IF (< G F)
          (SETQ F (+ F (- G))))))
    (SETQ Z F)))
 (PROGN (FUNCALL #'FOO)))
NIL

;; VAR x, squ;

(parse 'condition " A = A ")
(parse 'statement "
BEGIN
  BEGIN
    IF A = A THEN BEGIN CALL A END
  END;
  BEGIN
    CALL a3
  END
END
")

(parse 'block "
PROCEDURE foo;
  VAR a, b;
  CALL a3;
CALL a3")

(parse 'block
       "
PROCEDURE multiply;
VAR a, b;
BEGIN
  a := x;
  b := y;
  z := 0;
  WHILE b > 0 DO BEGIN
    IF ODD b THEN z := z + a;
    a := 2 * a;
    b := b / 2
  END
END;
BEGIN
  CALL multiply
END")

(print (p))

(parse 'program   "CONST
  m =  7,
  n = 85;

VAR
  x, y, z, q, r;

PROCEDURE multiply;
VAR a, b;

BEGIN
  a := x;
  b := y;
  z := 0;
  WHILE b > 0 DO BEGIN
    IF ODD b THEN z := z + a;
    a := 2 * a;
    b := b / 2
  END
END;

PROCEDURE divide;
VAR w;
BEGIN
  r := x;
  q := 0;
  w := y;
  WHILE w <= r DO w := 2 * w;
  WHILE w > y DO BEGIN
    q := 2 * q;
    w := w / 2;
    IF w <= r THEN BEGIN
      r := r - w;
      q := q + 1
    END
  END
END;

PROCEDURE gcd;
VAR f, g;
BEGIN
  f := x;
  g := y;
  WHILE f # g DO BEGIN
    IF f < g THEN g := g - f;
    IF g < f THEN f := f - g
  END;
  z := f
END;


BEGIN
  x := m;
  y := n;
  CALL multiply;
  x := 25;
  y :=  3;
  CALL divide;
  x := 84;
  y := 36;
  CALL gcd
END.")

(PROGN
 (PROGN (DEFCONSTANT M 7) (DEFCONSTANT N 85))
 (PROGN (DEFVAR X) (DEFVAR Y) (DEFVAR Z) (DEFVAR Q) (DEFVAR R))
 (DEFUN MULTIPLY ()
   (LET (A B)
     (DECLARE (SPECIAL A B))
     (PROGN
      (PROGN
       (SETQ A X)
       (SETQ B Y)
       (SETQ Z 0)
       (WHILE (> B 0)
              (PROGN
               (IF (ODDP B)
                   (SETQ Z (+ Z (+ A))))
               (SETQ A (* 2 (* A)))
               (SETQ B (* B (/ 2)))))))))
 (DEFUN DIVIDE ()
   (LET (W)
     (DECLARE (SPECIAL W))
     (PROGN
      (PROGN
       (SETQ R X)
       (SETQ Q 0)
       (SETQ W Y)
       (WHILE (<= W R) (SETQ W (* 2 (* W))))
       (WHILE (> W Y)
              (PROGN
               (SETQ Q (* 2 (* Q)))
               (SETQ W (* W (/ 2)))
               (IF (<= W R)
                   (PROGN (SETQ R (+ R (- W))) (SETQ Q (+ Q (+ 1)))))))))))
 (DEFUN GCD ()
   (LET (F G)
     (DECLARE (SPECIAL F G))
     (PROGN
      (PROGN
       (SETQ F X)
       (SETQ G Y)
       (WHILE (/= F G)
              (PROGN
               (IF (< F G)
                   (SETQ G (+ G (- F))))
               (IF (< G F)
                   (SETQ F (+ F (- G))))))
       (SETQ Z F)))))
 (PROGN
  (PROGN
   (SETQ X M)
   (SETQ Y N)
   (FUNCALL #'MULTIPLY)
   (SETQ X 25)
   (SETQ Y 3)
   (FUNCALL #'DIVIDE)
   (SETQ X 84)
   (SETQ Y 36)
   (FUNCALL #'GCD))))


NIL





(defun p ()
  (parse 'program
         (kl:read-file-to-string "/home/mc/learn/cl/esrap/pl0-sample.pl0")))


(p)
(PROGN
 (PROGN (DEFCONSTANT M 7) (DEFCONSTANT N 85))
 (PROGN (DEFVAR X) (DEFVAR Y) (DEFVAR Z) (DEFVAR Q) (DEFVAR R))
 (DEFUN MULTIPLY ()
   (LET (A B)
     (DECLARE (SPECIAL A B))
     (PROGN
      (PROGN
       (SETQ A X)
       (SETQ B Y)
       (SETQ Z 0)
       (WHILE (> B 0)
              (PROGN
               (IF (ODDP B)
                   (SETQ Z (+ Z (+ A))))
               (SETQ A (* 2 (* A)))
               (SETQ B (* B (/ 2)))))))))
 (DEFUN DIVIDE ()
   (LET (W)
     (DECLARE (SPECIAL W))
     (PROGN
      (PROGN
       (SETQ R X)
       (SETQ Q 0)
       (SETQ W Y)
       (WHILE (<= W R) (SETQ W (* 2 (* W))))
       (WHILE (> W Y)
              (PROGN
               (SETQ Q (* 2 (* Q)))
               (SETQ W (* W (/ 2)))
               (IF (<= W R)
                   (PROGN (SETQ R (+ R (- W))) (SETQ Q (+ Q (+ 1)))))))))))
 (DEFUN GCD ()
   (LET (F G)
     (DECLARE (SPECIAL F G))
     (PROGN
      (PROGN
       (SETQ F X)
       (SETQ G Y)
       (WHILE (/= F G)
              (PROGN
               (IF (< F G)
                   (SETQ G (+ G (- F))))
               (IF (< G F)
                   (SETQ F (+ F (- G))))))
       (SETQ Z F)))))
 (PROGN
  (PROGN
   (SETQ X M)
   (SETQ Y N)
   (FUNCALL #'MULTIPLY)
   (SETQ X 25)
   (SETQ Y 3)
   (FUNCALL #'DIVIDE)
   (SETQ X 84)
   (SETQ Y 36)
   (FUNCALL #'GCD))))
NIL

;;;
