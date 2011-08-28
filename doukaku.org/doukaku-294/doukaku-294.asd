;;;; doukaku-294.asd

(cl:in-package :asdf)

(defsystem :doukaku-294
  :serial t
  :components ((:file "package")
               (:file "doukaku-294")))

(defmethod perform ((o test-op) (c (eql (find-system :doukaku-294))))
  (load-system :doukaku-294)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :doukaku-294-internal :doukaku-294))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

