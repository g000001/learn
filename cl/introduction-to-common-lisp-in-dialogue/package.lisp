;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :introduction-to-common-lisp-in-dialogue
  (:use)
  (:export))

(defpackage :introduction-to-common-lisp-in-dialogue.internal
  (:use :introduction-to-common-lisp-in-dialogue :cl :named-readtables :fiveam))

