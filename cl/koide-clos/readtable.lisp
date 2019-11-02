;;;; readtable.lisp

(cl:in-package :koide-clos.internal)
(in-readtable :common-lisp)

#|(defreadtable :koide-clos  (:merge :standard)
  (:macro-char char fctn opt...)
  (:syntax-from readtable to-char from-char)
  (:case :upcase))|#
