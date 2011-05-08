;;;; once-only-learn.asd

(cl:in-package :asdf)

(defsystem :once-only-learn
  :serial t
  :depends-on (:lets)
  :components ((:file "package")
               (:file "once-only-learn")))

(defmethod perform ((o test-op) (c (eql (find-system :once-only-learn))))
  (load-system :once-only-learn)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :once-only-learn-internal :once-only-learn))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

