;;; -*- Mode: common-lisp; syntax: common-lisp; package: :zf; base: 10 -*-
;;;
;;; Zeromelo-Frankel (ZF) set theory
;;; Copyright (c) 2012 Seiji Koide
;;; 

;;; This file provides Zermelo-Fraenkel set theory

;;;(cl:provide :niizf)

(cl:defpackage :zf
  (:shadow #:set)
  (:use :common-lisp)
  (:export #:set #:equals #:set-p #:set-of)
  )

(in-package :zf)

(defmethod equals (s1 s2)
  "this method is invoked for non-set individual elements of sets."
  (if (eql s1 s2)
      (values t t)
    (values nil t)))

(defclass set ()
  ((type :initarg :type :accessor set-type)
   (elements :initarg :elements :accessor member-of)
   (rank :initarg :rank :accessor rank-of))
  )
(defmethod print-object ((object set) stream)
  (if (slot-boundp object 'type)
      (if (functionp (set-type object))
          (format stream "{x | ~S}" (set-type object))
        (format stream "{x | ~S}" (set-type object)))
    (if (slot-boundp object 'rank)
        (format stream "{~{~S~^,~}}" (member-of object))
        (call-next-method))))

(defun set-p (x)
  (typep x 'set))

(defun set-of (&rest members)
  (make-instance 'set :elements members))

(defun set-by (&key (type t))
  (make-instance 'set :type type))

(defun set (members)
  (make-instance 'set :elements members))

;;; Finalize
;;; cardinal number
(defun card (set)
  (length (member-of set)))

(defun finalize (set &optional (rank (card set)))
  "Default option is appicable only for ordinal numbers by succesor."
  (setf (rank-of set) rank)
  set)

(defun finalized-p (set)
  (or (slot-boundp set 'type)
      (slot-boundp set 'rank)))

;;; 1) Axiom of extensionality
;;;    http://en.wikipedia.org/wiki/ZFC#1._Axiom_of_extensionality
(defmethod equals ((x set) (y set))
  (when (eql x y) (return-from equals (values t t)))
  (cond ((and (slot-boundp x 'type) (slot-boundp y 'type))
         (let ((x-type (set-type x))
               (y-type (set-type y)))
           (when (eql x-type y-type) (return-from equals (values t t)))
           (cond ((and (functionp x-type) (functionp y-type))
                  (if (and (slot-boundp x 'rank) (slot-boundp y 'rank))
                      (let ((x-elements (member-of x))
                            (y-elements (member-of y)))
                        (if (and (every #'(lambda (ex) (member ex y-elements :test #'equals))
                                        x-elements)
                                 (every #'(lambda (ey) (member ey x-elements :test #'equals))
                                        y-elements))
                            (values t t)
                          (values nil t)))
                    (values nil nil)))
                 ((or (and (eq x-type t) (eql y-type (symbol-function 'universal-p)))
                      (and (eql x-type (symbol-function 'universal-p)) (eq y-type t)))
                  (values t t))
                 (t (multiple-value-bind (x1 x2) (subtypep x-type y-type)
                      (multiple-value-bind (y1 y2) (subtypep y-type x-type)
                        (if (and x1 y1) (values t t)
                          (if (and x2 y2) (values nil t)
                            (values nil nil)))))))))
        ((and (slot-boundp x 'rank) (slot-boundp y 'rank)) ; finalized
         (let ((x-elements (member-of x))
               (y-elements (member-of y)))
           (if (and (every #'(lambda (ex) (member ex y-elements :test #'equals))
                           x-elements)
                    (every #'(lambda (ey) (member ey x-elements :test #'equals))
                           y-elements))
               (values t t)
             (values nil t))))
        (t (values nil nil))))

;;; 2) Axiom of empty set
;;;    (exists (?x) (= ?x (setof)))
;;; 2.1) (forall (?x ?y)
;;;        (=> (and (= ?x (setof)) (= ?y (setof)))
;;;          (= ?x ?y)))
(defparameter +empty+ (set-of))
(setf (rank-of +empty+) 0)

(defun empty-p (set)
  (null (member-of set)))

#|
(equals (set-of) (set-of)) -> t
|#

;;; Singleton
(defun singleton-of (element)
  (set-of element))

(defun singleton-p (set)
  (length=1 (member-of set)))

#|
(equals +empty+ (singleton-of +empty+))  -> nil
|#

;;; 3) Axiom of unordered set
;;;    Axiom of paring
;;;    http://en.wikipedia.org/wiki/ZFC#4._Axiom_of_pairing
(defun unordered-set-of (e1 e2)
  (if (equals e1 e2) (singleton-of e1)
    (set-of e1 e2)))
(setf (symbol-function 'pair-of)
  #'unordered-set-of)

#|
(equals (pair-of 1 2) (pair-of 2 1)) -> t
|#

;;; 4) Axiom of union set
;;;    http://en.wikipedia.org/wiki/ZFC#5._Axiom_of_union
(defun union-of (&rest sets)
  (set (reduce #'(lambda (e1 e2) (union e1 e2 :test #'equals))
               (mapcar #'member-of sets)
               :initial-value '())))
#|
(equals +empty+ (union-of))
(equals +empty+ (union-of +empty+))
(equals (set-of 1 2) (union-of (set-of 1 2)))
(equals (set-of 1 2 3) (union-of (set-of 1 2) (set-of 2 3)))
|#

;;; 5) Axiom of intersection set
(defun intersection-of (&rest sets)
  (cond ((null sets) +empty+)
        ((length=1 sets) (car sets))
        (t (set (reduce #'(lambda (e1 e2) (intersection e1 e2 :test #'equals))
                        (mapcar #'member-of sets))))))
#|
(equals +empty+ (intersection-of))
(equals (set-of 1 2) (intersection-of (set-of 1 2)))
(equals (set-of 2) (intersection-of (set-of 1 2) (set-of 2 3)))
|#

;;; 6) Axiom of power set
;;;    http://en.wikipedia.org/wiki/ZFC#8._Axiom_of_power_set
(defun power-set (s)
  (cond ((empty-p s) (set-of s))
        ((singleton-p s) (set-of s +empty+))
        (t (set (cons s
                      (member-of
                       (apply #'union-of
                              (mapcar #'(lambda (e)
                                          (power-set (set (remove e (member-of s)))))      
                                (member-of s)))))))))

;;; Complement set
(defun complement-of (set for)
  (set (set-difference (member-of for) (member-of set) :test #'equals)))

;;; Now we restrict every elements must be sets in ZF.
;;; 8) Axiom of regulality
;;;    http://en.wikipedia.org/wiki/ZFC#2._Axiom_of_regularity_.28also_called_the_Axiom_of_foundation.29
(defmethod regular ((set set))
  (or (empty-p set)
      (not (null (some #'(lambda (x) (empty-p (intersection-of x set))) (member-of set))))))

#|
(regular (power-set (power-set (power-set +empty+))))
|#

;;; Subset
(defun subset-p (x y)
  (when (eql x y) (return-from subset-p (values t t)))
  (cond ((and (slot-boundp x 'type) (slot-boundp y 'type))
         (let ((x-type (set-type x))
               (y-type (set-type y)))
           (when (eql x-type y-type) (return-from subset-p (values t t)))
           (cond ((and (slot-boundp x 'rank) (functionp y-type))
                  (if (every #'(lambda (e) (funcall y-type e))
                             (member-of x))
                      (values t t)
                    (values nil t)))
                 ((and (functionp x-type) (functionp y-type))
                  (values nil nil))
                 ((eq y-type t)
                  (values t t))
                 (t (subtypep x-type y-type)))))
        ((and (slot-boundp x 'rank) (slot-boundp y 'type))
         (let ((y-type (set-type y)))
           (if (every #'(lambda (e) (funcall y-type e))
                      (member-of x))
               (values t t)
             (values nil t))))
        ((and (slot-boundp x 'rank) (slot-boundp y 'rank))    ; finalized
         (if (every #'(lambda (e) (member e (member-of y) :test #'equals))
                    (member-of x))
             (values t t)
           (values nil t)))
        ;; negative check
        ((and (member-of x) (slot-boundp y 'type))
         (if (notevery #'(lambda (e) (typep e (set-type y)))
                       (member-of x))
             (values nil t)
           (values nil nil)))
        ((and (member-of x) (slot-boundp y 'rank))
         (if (notevery #'(lambda (e) (member e (member-of y) :test #'equals))
                       (member-of x))
             (values nil t)
           (values nil nil)))
        (t (values nil nil))))

;;; Membership
(defun in (member set)
  (cond ((slot-boundp set 'type)
         (cond ((functionp (set-type set))
                (if (funcall (set-type set) member)
                    (values t t)
                  (values nil t)))
               (t (if (typep member (set-type set))
                      (values t t)
                    (values nil t)))))
        ((slot-boundp set 'rank)   ; finalized
         (if (member member (member-of set) :test #'equals)
             (values t t)
           (values nil t)))
        ((member-of set)
         (if (member member (member-of set) :test #'equals)
             (values t t)
           (values nil nil)))
        (t (values nil nil))))

;;;
;;; Successor
;;;

(defun suc (ord)
  (finalize (union-of ord (set-of ord))))

(defun *make-ord (n &optional (pre +empty+))
  (if (= n 0) pre
    (*make-ord (1- n) (suc pre))))

(defun make-ord (cont &optional n)
  (if (equal n 0) (funcall cont)
    (if (not (null n))
        (make-ord #'(lambda () (suc (funcall cont))) (1- n))
      (make-ord #'(lambda () (suc (funcall cont)))))))

#|
(make-ord #'(lambda () +empty+) 5)
|#

;;;
;;; Trans-finite ordinal number
;;; +omega+ should not be forced to compute. It attempts to generate infinite numbers ordinal number.
(defparameter +omega+ (delay (make-ord #'(lambda () +empty+))))

(defun set-of+ (&rest members+)
  (make-instance 'set :elements (cons +omega+ members+)))

(defun union-of+ (&rest sets+)
  (set (reduce #'(lambda (e1 e2) (union e1 e2 :test #'equals))
               (mapcar #'member-of sets+)
               :initial-value '())))

(defun suc+ (ord+)
  (union-of+ ord+ (set-of+ ord+)))

;;;
;;; Intensional representation
;;;

(defun natural-number (x)
  (and (typep x 'integer) (>= x 0)))

;(defparameter +NN+ (set-by :type '(satisfies natural-number)))
;(defparameter +NN+ (set-by :type #'(lambda (x) (and (typep x 'integer) (>= x 0)))))

(defparameter +NN+ (set-by :type '(integer 0 *)))

(defparameter +INT+ (set-by :type 'integer))
#|
(subset-p +NN+ +INT+)
|#
;;;
;;; Set or Class Hierarchy
;;;

(defparameter +TOP+ (set-by :type 't))
;; (setf (member-of +TOP+) +omega+) ???

(defparameter +BOTTOM+ (set-by :type 'nil))
(setf (member-of +BOTTOM+) nil)
(finalize +BOTTOM+) ; define rank

#|
(equals +BOTTOM+ +empty+)
(subset-p +NN+ +TOP+)
(subset-p +INT+ +TOP+)
|#

;;; Universal
(defun universal-p (x)
  (equals x x))
(defparameter +RR+ (set-by :type #'universal-p))

;;; Russell set
(defun russell-p (x)
  (multiple-value-bind (val1 val2) (in x x)
    (if val1 (values nil t)
      (if val2 (values t t)
        (values nil nil)))))
(defparameter +Russell+ (set-by :type #'russell-p))

;;; Self-containing set
(defun self-contained-p (x)
  (multiple-value-bind (val1 val2) (in x x)
    (if val1 (values t t)
      (if val2 (values nil t)
        (values nil nil)))))
(defparameter +anti-Russell+ (set-by :type #'self-contained-p))