(in-package :cl-user)

(defmethod |Find| ((obj standard-class))
  (let ((obj (find-if (lambda (x) (find-method #'|Find| '() `((eql ,x)) nil))
                      (c2mop:class-precedence-list obj))))
    (if obj
        (|Find| obj)
        "hello standard-class")))


(defun find-eql-method (gf class)
  (some (lambda (x)
          (and (typep (car (c2mop:method-specializers x)) 'c2mop:eql-specializer)
               x ))
        (zl:with-stack-list (cs class)
          (compute-applicable-methods gf cs))
        #|(compute-applicable-methods gf (list class))|#))

(c2mop:compute-class-precedence-list (find-class 'baz))
(defmethod |Find| ((obj standard-class))
  (let ((obj (find-if (lambda (x) (find-eql-method #'|Find| x))
                      (c2mop:class-precedence-list obj))))
    (if obj
        (|Find| obj)
        "hello standard-class")))

(defmethod |Find| ((obj standard-class))
  (let ((m (some (lambda (x) (find-eql-method #'|Find| x))
                 (c2mop:class-precedence-list obj))))
    (if m
        (funcall (c2mop:method-function m) (list obj) nil)
        "hello standard-class")))

;;; fooのクラスメソッド的
(defmethod |Find| ((obj (eql (find-class 'foo))))
  "foo class!" )

;;; barのクラスメソッド的
(defmethod |Find| ((obj (eql (find-class 'bar))))
  "bar class!" )

(|Find| (find-class 'bar))
(c2mop:finalize-inheritance (find-class 'zot))
(|Find| (find-class 'zot))

;;; fooのインスタンスメソッド
(defmethod |Find| ((obj foo))
  "hello foo")

;;; インスタンス
(|Find| (make-instance 'foo))
;=>  "hello foo"



(test ((obj (make-instance 'foo)))
  (|Find| obj))
;⇒ "hello foo"
#|------------------------------------------------------------|
Evaluation took:
  0.028 seconds of real time
  0.028002 seconds of total run time (0.028002 user, 0.000000 system)
  100.00% CPU
  67,219,299 processor cycles
  0 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#

(test ((obj (make-instance 'bar)));fooを継承
  (|Find| obj))
;⇒ "hello foo"
#|------------------------------------------------------------|
Evaluation took:
  0.027 seconds of real time
  0.028002 seconds of total run time (0.028002 user, 0.000000 system)
  103.70% CPU
  64,409,634 processor cycles
  0 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#

;;; class
(test ((obj (class-of (make-instance 'foo))))
  (|Find| obj))
;⇒ "foo class!"
#|------------------------------------------------------------|
Evaluation took:
  0.053 seconds of real time
  0.052003 seconds of total run time (0.052003 user, 0.000000 system)
  98.11% CPU
  127,405,872 processor cycles
  0 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#

(|Find| (class-of (make-instance 'bar)))

(test ((obj (class-of (make-instance 'bar))))
  (|Find| obj))
;⇒ "bar class!"
#|------------------------------------------------------------|
Evaluation took:
  0.044 seconds of real time
  0.044002 seconds of total run time (0.044002 user, 0.000000 system)
  100.00% CPU
  105,943,446 processor cycles
  0 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#

;;; いきなり遅い
(test ((obj (class-of (make-instance 'baz))))
  (|Find| obj))
;⇒ "bar class!"
#|------------------------------------------------------------|
Evaluation took:
  4.027 seconds of real time
  4.036252 seconds of total run time (4.036252 user, 0.000000 system)
  [ Run times consist of 0.092 seconds GC time, and 3.945 seconds non-GC time. ]
  100.22% CPU
  9,640,808,235 processor cycles
  1,280,015,872 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#

;;; デフォルト とっても遅い
(test ((obj (class-of (make-instance 'zot))))
  (|Find| obj))
;⇒ "hello standard-class"
#|------------------------------------------------------------|
Evaluation took:
  9.467 seconds of real time
  9.464591 seconds of total run time (9.464591 user, 0.000000 system)
  [ Run times consist of 0.248 seconds GC time, and 9.217 seconds non-GC time. ]
  99.98% CPU
  22,662,619,740 processor cycles
  3,263,971,808 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#
