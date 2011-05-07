;;
;; http://www.takeoka.org/~take/ailabo/prolog/tmpro/tmpro-man.html
;;
(asdf:load-system :tmpro)

(in-package :tmpro-internal)


(tmpro)

(tmpro-assert-new
 '(
   ((append () *x *x))
   ((append (*a . *x) *y (*a . *z))
    (append *x *y *z)) ))


(tmpro-assert-at0
 '(
   ((append () (8) *x))))

(tmpro-assert-new
 '(
   (+ *x *x 2)))

(tmpro)




