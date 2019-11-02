(in-package :cl-user)

;;; https://gist.github.com/732160

;; utility functions to define class methods
(defun extract-argument-symbols (args)
  (mapcar #'(lambda (x) (if (listp x) (car x) x)) args))

(defun has-class-method-p (method class arguments)
  (let ((methods (compute-applicable-methods method (cons class arguments))))
    (dolist (m methods)
      (let ((specializers (closer-mop:method-specializers m)))
        (if (typep (car specializers) 'closer-mop:eql-specializer)
            (return-from has-class-method-p t))))
    nil))

;; in clap, we provide define-class-method and define-class-method-default to
;; define classmethods like python.
;; 1.a classmethod should contain the name of class you want to specify as an
;; eql specializer at the first argument.
;;  it means the lambda-list of the method should be
;;  ((class (eql 'your-awesome-class-symbol)) arg2 arg3 ...)
;;
(defmacro define-class-method-default (name arg &optional (documentation nil))
  ;; arg => (class arg2 arg3 ...)
  `(progn
     (defgeneric ,name ,(extract-argument-symbols arg)
       ,@(when documentation (list documentation)))
     ;; a method wrapper for instances of any class.
     (defmethod ,name ((,(car arg) standard-object) ,@(cdr arg))
       ,@(when documentation (list documentation))
       (,name (class-name (class-of ,(car arg)))
              ,@(extract-argument-symbols (cdr arg))))
     ;; a method for any classes...
     (defmethod ,name ,arg
       ,@(when documentation (list documentation))
       (let ((cpl (mapcar #'class-name
                          (closer-mop:class-precedence-list
                           (find-class ,(car arg))))))
         ;; search a valid method...
         (dolist (c (cdr cpl))
           (let ((methods (compute-applicable-methods
                           (symbol-function ',name)
                           (list c ,@(extract-argument-symbols (cdr arg))))))
             (dolist (m methods)
               (let ((specializers (closer-mop:method-specializers m)))
                 ;; class method should eql specialize the 1st argument
                 (if (typep (car specializers) 'closer-mop:eql-specializer)
                     (return-from ,name
                       (funcall (closer-mop:method-function m)
                                (list ,@(extract-argument-symbols arg))
                                nil)))))))
         (error "cannot find applicable classmethod")))))

;; you can write like
;; (define-class-method foo ((self bar-class) arg2 arg3 ...) ...)
(defmacro define-class-method (name arg &rest forms)
  `(defmethod ,name ((,(caar arg) (eql ',(cadr (car arg)))) ,@(cdr arg))
     (labels ((call-next-class-method ()
                (let ((super-classes
                       (mapcar #'class-name
                               (closer-mop:class-precedence-list
                                (find-class ',(cadr (car arg)))))))
                  (dolist (class (cdr super-classes))
                    (if (has-class-method-p (symbol-function ',name)
                                            class
                                            (list
                                             ,@(extract-argument-symbols
                                                (cdr arg))))
                        (return-from call-next-class-method
                          (,name class ,@(extract-argument-symbols
                                          (cdr arg))))))
                  (error "cannot find applicable super classmethod"))))
       ,@forms)))


(defmethod gara-find ((obj foo))
  "hello foo")

;;; fooのクラスメソッド的
(define-class-method-default gara-find (arg))
(define-class-method gara-find ((arg foo))
  "gara:foo class!")
(define-class-method gara-find ((arg bar))
  "gara:bar class!")

(gara-find 'bar)

(test ((obj 'foo))
  (gara-find obj))
;⇒ "gara:foo class!"
#|------------------------------------------------------------|
Evaluation took:
  0.037 seconds of real time
  0.028002 seconds of total run time (0.028002 user, 0.000000 system)
  75.68% CPU
  87,181,533 processor cycles
  0 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#

(test ((obj 'bar))
  (gara-find obj))
(test ((obj 'bar))
  (gara-find obj))
;⇒ "gara:bar class!"
#|------------------------------------------------------------|
Evaluation took:
  0.034 seconds of real time
  0.036002 seconds of total run time (0.036002 user, 0.000000 system)
  105.88% CPU
  80,651,826 processor cycles
  0 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#

(test ((obj 'baz))
  (gara-find obj))
;⇒ "gara:bar class!"
#|------------------------------------------------------------|
Evaluation took:
  2.224 seconds of real time
  2.228140 seconds of total run time (2.228140 user, 0.000000 system)
  [ Run times consist of 0.040 seconds GC time, and 2.189 seconds non-GC time. ]
  100.18% CPU
  5,324,843,385 processor cycles
  304,009,440 bytes consed

Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
 |------------------------------------------------------------|#

(test ((obj 'zot))
  (gara-find obj))
