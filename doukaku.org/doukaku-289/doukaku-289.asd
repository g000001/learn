;;;; doukaku-289.asd

(cl:in-package :asdf)

(defsystem :doukaku-289
  :serial t
  :components ((:file "package")
               (:file "doukaku-289")))

(defmethod perform ((o test-op) (c (eql (find-system :doukaku-289))))
  (load-system :doukaku-289)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :doukaku-289-internal :doukaku-289))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

