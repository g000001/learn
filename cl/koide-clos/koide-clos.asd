;;;; koide-clos.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)

(defsystem :koide-clos
  :serial t
  :depends-on (:fiveam
               :named-readtables
               :kmrcl
               :scheme)
  :components (#|(:file "Utils")|#
               (:file "utils")
               (:file "package")
               ;; (:file "readtable")
               ;; (:file "koide-clos")
               ;; (:file "koide-clos-06")
               (:file "zf")
               #|(:file "koide-clos-06")|#
               (:file "koide-clos-07")))

(defmethod perform ((o test-op) (c (eql (find-system :koide-clos))))
  (load-system :koide-clos)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :koide-clos.internal :koide-clos))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
