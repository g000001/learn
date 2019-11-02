(in-package :cl-user)

(defclass foo () ())
(defclass zot () ())
(defclass bar (foo) ())
(defclass baz (bar) ())


(defmacro test ((bind) form)
  `(let (,bind tem)
     (dotimes (i 1000000 tem)
       (setq tem ,form))))
