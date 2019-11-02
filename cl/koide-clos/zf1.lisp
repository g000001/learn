;;; -*- Mode: common-lisp; syntax: common-lisp; package: :zf; base: 10 -*-
;;;
;;; Zeromelo-Frankel (ZF) set theory
;;; Copyright (c) 2012 Seiji Koide
;;;

;;; This file provides Zermelo-Fraenkel set theory

(cl:provide :zf)

(cl:defpackage :zf
  (:shadow #:set #:read #:print #:newline #:scheme-top-level)
  (:use :common-lisp :sch)
  (:export #:set #:equals #:set-p #:set-of)
  (:import-from :sch :delay :length=1)
  )


(in-package :zf)

#|(defmethod length=1 ((list list))
  (and (consp list)
       (null (cdr list))))|#

#|(defmacro delay (form)
  #+sbcl `(sb-int:delay ,form)
  #-sbcl `(values form))|#

(defmethod equals (s1 s2)
  "this method is invoked for non-set individual elements of sets."
  (eql s1 s2))

(defclass set ()
  ((elements :initarg :elements :accessor member-of)
   (rank :initarg :rank :accessor rank))
  )
(defmethod print-object ((object set) stream)
  (format stream "{~{~S~^,~}}" (member-of object)))

(defun set-p (x)
  (typep x 'set))

(defun set (members)
  (make-instance 'set :elements members))

(defun set-of (&rest members)
  (make-instance 'set :elements members))

;;; 1) Axiom of extensionality
;;;    http://en.wikipedia.org/wiki/ZFC#1._Axiom_of_extensionality
(defmethod equals ((x set) (y set))
  (when (eq x y) (return-from equals t))
  (let ((x-elements (member-of x))
        (y-elements (member-of y)))
    (and (every #'(lambda (ex) (member ex y-elements :test #'equals))
                x-elements)
         (every #'(lambda (ey) (member ey x-elements :test #'equals))
                y-elements))))

;;; 2) Axiom of empty set
;;;    (exists (?x) (= ?x (setof)))
;;; 2.1) (forall (?x ?y)
;;;        (=> (and (= ?x (setof)) (= ?y (setof)))
;;;          (= ?x ?y)))
(defparameter +empty+ (set-of))
(setf (rank +empty+) 0)

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

(defun finalize (set rank)
  (setf (rank set) (1+ rank))
  set)

(defun finalized-p (set)
  (slot-boundp set 'rank))

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
(defun subset-p (s1 s2)
  (every #'(lambda (e1) (member e1 (member-of s2) :test #'equals))
         (member-of s1)))

;;; Membership
(defun in (member set)
  (not (null (member member (member-of set) :test #'equals))))

;;; cardinal number
(defun card (set)
  (length (member-of set)))

;;;
;;; Successor
;;;

(defun suc (ord)
  (union-of ord (set-of ord)))

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
