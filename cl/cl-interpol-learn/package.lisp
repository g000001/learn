;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :cl-interpol-learn
  (:export))

(defpackage :cl-interpol-learn-internal
  (:use :cl-interpol-learn :cl :fiveam
        :cl-interpol
        :cl-ppcre))

