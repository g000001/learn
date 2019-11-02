(defpackage :pl0
  (:use :cl)
  (:shadow :gcd))


(in-package :pl0)

(defmacro while (pred body)
  `(loop :while ,pred :do ,body))

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
       (WHILE (> B single-float-epsilon)
        (PROGN
          (IF (ODDP (truncate B))
              (SETQ Z (+ Z (+ A))))
          (SETQ A (* 2 (* A)))
          (SETQ B (* B (float (/ 2))))))))))

 (PROGN
  (PROGN
   (SETQ X M)
   (SETQ Y N)
   (FUNCALL #'MULTIPLY)
   z
 )))
