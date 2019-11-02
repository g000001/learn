(defpackage m
  (:import-from :common-lisp #:t #:nil #:quote) 
  (:use)
  (:export #:quote #:setq #:cond #:lambda #:definition #:closure
           #:car #:cdr #:cons #:atom #:null #:equal
           #:defun #:repl #:exit #:quit #:display #:if
           #:= #:+ #:- #:* #:/
           #:eval #:define
           #:list))

(defun micro-eval (s environment)
  (cond ((atom s)
         (cond ((equal s 't) 't)
               ((equal s 'nil) 'nil)
               ((numberp s) s)
               ((micro-value s environment))
               (t s)))
        ((equal (car s) 'quote) (cadr s))
        ((equal (car s) 'm:setq)
         (micro-setq (cadr s) (caddr s) environment))
        ((equal (car s) 'm:cond)
         (micro-evalcond (cdr s) environment))
        ((equal (car s) 'm:lambda)
;;;         (list 'm:definition (cadr s) (caddr s))
         (list 'm:closure (cadr s) (caddr s) environment)
         )
        (t (micro-apply (car s)
                        (mapcar #'(lambda (x)
                                   (micro-eval x environment))
                          (cdr s))
                        environment))))

(defun micro-apply (function args environment)
  (cond ((atom function)
         (cond ((equal function 'm:car) (caar args))
               ((equal function 'm:cdr) (cdar args))
               ((equal function 'm:cons) (cons (car args) (cadr args)))
               ((equal function 'm:atom) (atom (car args)))
               ((equal function 'm:null) (null (car args)))
               ((equal function 'm:equal) (equal (car args) (cadr args)))
               ((equal function 'm:*) (apply #'cl:* args))          ; 
               ((equal function 'm:/) (apply #'cl:/ args))          ; 
               ((equal function 'm:+) (apply #'cl:+ args))          ; 
               ((equal function 'm:-) (apply #'cl:- args))          ; 
               ((equal function 'm:=) (apply #'cl:= args))          ; 
               ((equal function 'm:display) (m:display (car args))) ; 
               ((equal function 'm:list) (apply #'cl:list args))    ; 
               ((micro-boundp function environment)                 ; modified
                (micro-apply
                 (micro-eval function environment)
                 args
                 environment))
               ((equal function 'm:eval)
                (micro-eval (car args) environment))
               (t (error "Undefined function: ~S" function))))      ; added
        ((equal (car function) 'm:definition)
         (micro-eval (caddr function)
                     (micro-bind (cadr function) args environment)))
        ((equal (car function) 'm:closure)
         (micro-eval (caddr function)
                     (micro-bind (cadr function) args (cadddr function))))
        ;; for Chaitin
        ((equal (car function) 'm:lambda)
         (micro-apply
          (micro-eval function environment)
          args
          environment))
        ((equal (car function) 'quote)
         (micro-apply
          (micro-eval function environment)
          args
          environment))
        ;;
        (t (error "~S is not defined yet!" (car function)))))         ; added

(defun micro-r-e-p ()
  (prog (s (environment nil))
    loop
    (format *terminal-io* "~&==> ")
    (setq s (read))
    (cond ((atom s)
           (m:display (micro-eval s environment)))
          ((equal (car s) 'm:exit)
           (return-from micro-r-e-p (values)))
          ((equal (car s) 'm:quit)
           (return-from micro-r-e-p (values)))
          ((equal (car s) 'm:defun)
           (setq environment
                 (cons (list (cadr s)
                             (cons 'm:definition
                                   (cddr s)))
                       environment))
           (m:display (cadr s)))
          (t (m:display (micro-eval s environment))))
    (go loop)))

(defun m:repl () (micro-r-e-p))

(defun m:display (x)
  (format *terminal-io* "~&~S" x)
  x)

(defun micro-evalcond (clauses environment)
  (cond ((null clauses) nil)
        ((micro-eval (caar clauses) environment)
         (micro-eval (cadar clauses) environment))
        (t (micro-evalcond (cdr clauses) environment))))

(defun micro-bind (key-list value-list a-list)
  (cond ((or (null key-list) (null value-list)) a-list)
        (t (cons (list (car key-list) (car value-list))
                 (micro-bind (cdr key-list) (cdr value-list) a-list)))))

(defun micro-boundp (key a-list)
  (not (null (cadr (assoc key a-list)))))

(defun micro-value (key a-list)
  (cadr (assoc key a-list)))

(defun micro-setq (variable value a-list)
  (prog (entry result)
    (setq entry (assoc variable a-list))
    (setq result (micro-eval value a-list))
    (cond (entry (rplaca (cdr entry) result))
          (t (rplacd (last a-list) (list (list variable result)))))
    (return result)))
