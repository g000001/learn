;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :cl-cont-learn
  (:use)
  (:export))

(defpackage :cl-cont-learn-internal
  (:use :cl-cont-learn :cl :cl-cont :fiveam)
  (:shadowing-import-from :srfi-5 :let)
  (:import-from :srfi-71 :letrec))

