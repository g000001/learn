;;;; doukaku-295.asd

(cl:in-package :asdf)

(defsystem :doukaku-295
  :serial t
  :depends-on (:cl-ppcre)
  :components ((:file "package")
               (:file "doukaku-295")))

(defmethod perform ((o test-op) (c (eql (find-system :doukaku-295))))
  (load-system :doukaku-295)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :doukaku-295-internal :doukaku-295))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

