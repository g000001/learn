;;;; cl-cont-learn.asd

(cl:in-package :asdf)

(defsystem :cl-cont-learn
  :serial t
  :depends-on (:fiveam
               :cl-cont
               :named-readtables
               :srfi-71
               :srfi-5
               :srfi-86)
  :components ((:file "package")
               (:file "cl-cont-learn")))

(defmethod perform ((o test-op) (c (eql (find-system :cl-cont-learn))))
  (load-system :cl-cont-learn)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :cl-cont-learn-internal :cl-cont-learn))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

