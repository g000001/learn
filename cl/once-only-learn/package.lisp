;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :once-only-learn
  (:export))

(defpackage :once-only-learn-internal
  (:use :once-only-learn :cl :fiveam
        :lets))

