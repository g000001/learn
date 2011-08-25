;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :doukaku-289
  (:use)
  (:export :|yyyymmdd = ddmmmmdd|))

(defpackage :doukaku-289-internal
  (:use :doukaku-289 :cl :fiveam))

