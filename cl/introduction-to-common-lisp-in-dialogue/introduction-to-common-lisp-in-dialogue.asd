;;;; introduction-to-common-lisp-in-dialogue.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)

(defsystem :introduction-to-common-lisp-in-dialogue
  :serial t
  :depends-on (:fiveam)
  :components ((:file "package")
               (:file "introduction-to-common-lisp-in-dialogue")))

(defmethod perform ((o test-op) (c (eql (find-system :introduction-to-common-lisp-in-dialogue))))
  (load-system :introduction-to-common-lisp-in-dialogue)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :introduction-to-common-lisp-in-dialogue.internal :introduction-to-common-lisp-in-dialogue))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

