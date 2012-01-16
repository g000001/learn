;; 8-1
(defun define fexpr (x)
  (eval (list 'defun (caar x)
	      (cdar x)
	      (cons 'progn (cdr x)))))

;; 8-2
(defmacro define (name-args &rest body)
  `(defun ,(car name-args) ,(cdr name-args)
     ,@body))

(defun define macro (x)
  `(defun ,(caadr x) ,(cdadr x)
     ,@(cddr x)))
