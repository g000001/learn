;;;; once-only-learn.lisp

(cl:in-package :once-only-learn-internal)

(def-suite once-only-learn)

(in-suite once-only-learn)

;; LetS
(defmacro once-only ((&rest vars) &body body)
  (letS* ((var (Elist vars))
          (name (maps #'gensym)))
    `(let ,(Rlist `(,name ,var))
       (let ,(Rlist `(,var (gensym)))
         `(let (,,@(Rlist ``(,,var ,,name)))
            ,,@body)))))

(defun square-expand (n)
  (once-only  (n)
    `(* ,n ,n)))

(square-expand '(incf a))
;=> (LET ((#:G3610955 (INCF A)))
;     (* #:G3610955 #:G3610955))


;; もしxectorで書けたとしたら
(defmacro once-only ((&rest vars) &body body)
  (let ((var αvars)
        (name (αgensym)))
    `(let ,α(list •name •var)
       (let ,α(list •var '(gensym))
         `(let (,,@α``(,,•var ,,•name))
            ,,@body)))))


