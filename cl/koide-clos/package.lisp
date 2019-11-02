;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :koide-clos
  (:use)
  (:export))

(defpackage :koide-clos.internal
  (:use :koide-clos :cl :named-readtables :fiveam))

#|(cl:defpackage :zf
  (:shadow #:set #:read #:print #:newline #:scheme-top-level)
  (:use :common-lisp :sch)
  (:export #:set #:equals #:set-p #:set-of)
  (:import-from :sch :delay :length=1)
  )|#

#|(cl:defpackage :zf
  (:shadow #:set #:read #:print #:newline #:scheme-top-level)
  (:use :common-lisp :gx)
  (:export #:set #:equals #:set-p #:set-of)
  (:import-from :sch :delay :length=1)
  )|#

#|(cl:defpackage :zf
  (:shadow #:set #:read #:print #:newline #:scheme-top-level)
  (:use :common-lisp :gx)
  (:export #:set #:equals #:set-p #:set-of)
  (:import-from :sch :delay :length=1)
  )|#

(cl:defpackage :zf
  (:shadow #:set)
  (:use :common-lisp)
  (:export #:set #:equals #:set-p #:set-of)
  )
