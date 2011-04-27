

(defun repli (lst times)
  (mapcan lst #'(lambda (x) (make-list times x))))

(reverse (repli '(a b c d e (f)) 2))

(defun make-list (n (elt nil))
  (and (0> n) (err:argument-type n 'make-list))
  (do ((n n (1- n))
       (res () (cons elt res)))
      ((0= n) res)))

(do (a b c) (t))

(do ((a) (b) (c)) (t))

(progn
  (plus 1))

(make-list 5 'foo)




(MATCH '(1 2 3 4)
       ((x . y) (list x y)))


(labels ((n (n)
	   n))
  (n 3))

(repli '() 3)