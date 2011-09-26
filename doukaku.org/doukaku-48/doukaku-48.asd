;;;; doukaku-48.asd

(cl:in-package :asdf)

(defsystem :doukaku-48
  :serial t
  :depends-on (:gsll)
  :components ((:file "package")
               (:file "doukaku-48")))

(defmethod perform ((o test-op) (c (eql (find-system :doukaku-48))))
  (load-system :doukaku-48)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :doukaku-48-internal :doukaku-48))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

