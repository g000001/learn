(in-package :cl-user)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :prolog))

(defpackage :p-99
  (:use :cl :prolog))

(in-package :p-99)


  (<-- (member ?item (?item . ?)))
  (<-  (member ?item (? . ?rest)) (member ?item ?rest))

(<-- (my-last () ?x))
(<- (my-last (?x) ?x))
(<- (my-last (?h . ?t) ?x)
    (my-last ?t ?x))


(?- (my-last (1 2 3 4) ?x) )

(defun my-last (list &aux ans)
  (prolog (lisp ?list list)
          (my-last ?list ?x)
          (lisp (setq ans ?x)))
  ans)

(ql:quickload :srfi-1)

(my-last (srfi-1:iota 100))
(disassemble 'my-last)

(progn
  (<-- (number-of-elements 0 ()))
  (<- (number-of-elements ?x (?h . ?t))
      (number-of-elements ?y ?t)
      #|(lisp ?xx (print (1+ ?x)))|#
      (is ?y (+ 1 ?x))))

(?- (number-of-elements ?x (8 8)))

(?- (is ?x 8)) 


(progn
  (<-- (element-at ?x (?h . ?t) 0) (= ?x ?h))
  (<- (element-at ?x (?h . ?t) ?p)
      (is ??pp (- ?p 1))
      (element-at ?x ?t ?pp)))

(?- (element-at 3 (1 2 3 4) ?p))


(progn
  (<-- (my-reverse () ()))
  (<- (my-reverse (?h . ?t) ?rev)
      (my-reverse ?t ?tt) 
      (append ?tt (?h) ?rev)))


(?- (my-reverse (1 2 3 4) ?x))

(defun my-reverse (list &aux ans)
  (prolog (lisp ?list list)
          (my-reverse ?list ?ans)
          (lisp (setq ans ?ans)))
  ans)

(my-reverse (srfi-1:iota 100))
