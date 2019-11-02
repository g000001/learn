;; cg-user(1): :cd
;; C:\Documents and Settings\Seiji\
;; cg-user(2): :cf micro-lisp1.lisp
;;; Compiling file micro-lisp1.lisp
;;; Writing fasl file micro-lisp1.fasl
;;; Fasl write complete
;; cg-user(3): :ld micro-lisp1
; Fast loading C:\Documents and Settings\Seiji\micro-lisp1.fasl
(cl:in-package :m)
;=>  #<COMMON-LISP:PACKAGE "M">

(repl)
==> t
　
t
==> nil
　
nil
==> (+ 1 2)
　
3
==> (defun factorial (n)
      (cond ((= n 0) 1)
            (t (* n (factorial (- n 1))))))
　
factorial
==> (factorial 5)
　
120
==> (defun append (l1 l2)
      (cond ((null l1) l2)
            (t (cons (car l1)
                     (append (cdr l1) l2)))))
　
append
==> (append (list 'A) (list 'B))
　
(A B)
==>
;=>  <no values>
(exit)

(cl:in-package :cg-user)

(defun f (x)
  ((quote (lambda (y) (cons y (cons y ()))))
   (cons (quote quote) (cons x ()))))
