;;;; cl-interpol-learn.asd

(cl:in-package :asdf)

(defsystem :cl-interpol-learn
  :serial t
  :depends-on (:cl-interpol :cl-ppcre)
  :components ((:file "package")
               (:file "cl-interpol-learn")))

(defmethod perform ((o test-op) (c (eql (find-system :cl-interpol-learn))))
  (load-system :cl-interpol-learn)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :cl-interpol-learn-internal :cl-interpol-learn))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

