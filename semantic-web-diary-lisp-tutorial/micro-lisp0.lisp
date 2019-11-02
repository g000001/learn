(defun micro-eval (s environment)
  (cond ((atom s)
         (cond ((equal s 't) 't)
               ((equal s 'nil) 'nil)
               ((numberp s) s)
               (t (micro-value s environment))))
        ((equal (car s) 'm-quote) (cadr s))
        ((equal (car s) 'm-setq)
         (micro-setq (cadr s) (caddr s) environment))
        ((equal (car s) 'm-cond)
         (micro-evalcond (cdr s) environment))
        ((equal (car s) 'm-lambda)
         ;; (list 'm-definition (cadr s) (caddr s))
         (list 'm-closure (cadr s) (caddr s) environment)
         )
        (t (micro-apply (car s)
                        (mapcar #'(lambda (x)
                                   (micro-eval x environment))
                          (cdr s))
                        environment))))

(defun micro-apply (function args environment)
  (cond ((atom function)
         (cond ((equal function 'm-car) (caar args))
               ((equal function 'm-cdr) (cdar args))
               ((equal function 'm-cons) (cons (car args) (cadr args)))
               ((equal function 'm-atom) (atom (car args)))
               ((equal function 'm-null) (null (car args)))
               ((equal function 'm-equal) (equal (car args) (cadr args)))
               ((equal function 'm-*) (apply #'* args))    ; ここに追加
               (t
                (micro-apply
                 (micro-eval function environment)
                 args
                 environment))))
        ((equal (car function) 'm-definition)
         (micro-eval (caddr function)
                     (micro-bind (cadr function) args environment)))
        ((equal (car function) 'm-closure)
         (micro-eval (caddr function)
                     (micro-bind (cadr function) args (cadddr function))))
        ))

(defun micro-r-e-p ()
  (prog (s (environment nil))
    loop
    (format *terminal-io* "~&==> ")
    (setq s (read))
    (cond ((atom s)
           (print (micro-eval s environment)))
          ((equal (car s) 'm-exit)              ; 追加
           (return-from micro-r-e-p (values)))  ; 追加
          ((equal (car s) 'm-quit)              ; 追加
           (return-from micro-r-e-p (values)))  ; 追加
          ((equal (car s) 'm-defun)
           (setq environment
                 (cons (list (cadr s)
                             (cons 'm-definition
                                   (cddr s)))
                       environment))
           (print (cadr s)))
          (t (print (micro-eval s environment))))
    (go loop)))

(defun micro-evalcond (clauses environment)
  (cond ((null clauses) nil)
        ((micro-eval (caar clauses) environment)
         (micro-eval (cadar clauses) environment))
        (t (micro-evalcond (cdr clauses) environment))))

(defun micro-bind (key-list value-list a-list)
  (cond ((or (null key-list) (null value-list)) a-list)
        (t (cons (list (car key-list) (car value-list))
                 (micro-bind (cdr key-list) (cdr value-list) a-list)))))

(defun micro-value (key a-list)
  (cadr (assoc key a-list)))

(defun micro-setq (variable value a-list)
  (prog (entry result)
    (setq entry (assoc variable a-list))
    (setq result (micro-eval value a-list))
    (cond (entry (rplaca (cdr entry) result))
          (t (rplacd (last a-list) (list (list variable result)))))
    (return result)))
