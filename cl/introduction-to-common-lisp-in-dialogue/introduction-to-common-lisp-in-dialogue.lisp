;;;; introduction-to-common-lisp-in-dialogue.lisp

(cl:in-package :introduction-to-common-lisp-in-dialogue.internal)


(def-suite introduction-to-common-lisp-in-dialogue)


(in-suite introduction-to-common-lisp-in-dialogue)


(defvar .x.)
(defvar .y.)

(define-symbol-macro x .x.)
(define-symbol-macro y .y.)

;;; x = akebono
;;; y (waka taka)

(setf x 'akebono
      y '(waka taka))

;;; 1
'(cons x y) 
;=>  (CONS X Y)

;'(cons x y)


;;; 2
(cons 'x y)
;=>  (X WAKA TAKA)


;;; 3
(cons x 'y)
;=>  (AKEBONO . Y)

;(akebono y)                             ;X

;;; 4
(cons x y)
;=>  (AKEBONO WAKA TAKA)

;(akebono waka taka)

;;; 5
(list x y)
;=>  (AKEBONO (WAKA TAKA))

;(akebono (waka taka))

;;; 6
(cons y y)
;=>  ((WAKA TAKA) WAKA TAKA)

;((waka taka) waka taka)


;;; 7
(append y y)
;=>  (WAKA TAKA WAKA TAKA)

;(waka taka waka taka)

;;; 8
(cons (length y) '(length y))
;=>  (2 LENGTH Y)

;(2 length y)

;;; 9
(cons (eql x 'x) (reverse y))
;=>  (NIL TAKA WAKA)

;(nil taka waka)

;;; 10
(atom y)
;=>  NIL

;nil


;;; expt$
;;; 5^20 = (5^2)^10, 5^21 = 5 x 5^20
;;; evenp

#|(declaim (ftype (function (integer integer) integer) expt$)
         (ftype (function (integer integer integer) integer) expt$1))|#


#| 別に効率良くなってない
  (defun expt$ (m n)
  ;; (declare #.speed-speed-speed)
  (if (evenp n)
      (expt$1 (expt$1 m 2 1) (/ n 2) 1)
      (* m (expt$ m (- n 1)))))|#

;;; 正解
(defun expt$ (m n)
  ;; (declare #.speed-speed-speed)
  (if (evenp n)
      (expt$1 (* m m) (/ n 2) 1)
      (* m (expt$ m (- n 1)))))


(defun expt$1-recur (m n)
  (if (zerop n)
      1
      (* m (expt$1-recur m (- n 1)))))


(defun expt$1 (m n acc)
  ;; (declare #.speed-speed-speed)
  (if (zerop n)
      acc
      (expt$1 m (- n 1) (* m acc))))


(test expt$1-test
  (for-all ((n (gen-integer :min 0 :max 10000))
            (m (gen-integer :min 0 :max 10000)))
    (is (= (expt$ m n) (expt m n)))))


;;; 3
;;; 3.1

(defun union$ (list1 list2)
  (union$1 (append list1 list2) '() ))


(defun union$1 (list acc)
  (cond ((null list)
         acc)
        ((member (car list) (cdr list))
         (union$1 (cdr list) acc))
        (T (union$1 (cdr list) (cons (car list) acc)))))


(test union$-test
  (for-all ((u (gen-list))
            (v (gen-list)))
    (is-true (null (set-difference (union$ u v)
                                   (union u v))))))


(defun intersection$ (list1 list2)
  (intersection$1 list1 list2 '() ))


(defun intersection$1 (list1 list2 acc)
  (cond ((or (null list1) (null list2))
         acc)
        ((and (member (car list1) list2)
              (not (member (car list1) acc)))
         (intersection$1 (cdr list1) list2 (cons (car list1) acc)))
        (T (intersection$1 (cdr list1) list2 acc))))



(test intersection$-test
  (for-all ((u (gen-list))
            (v (gen-list)))
    (is-true (null (set-difference (intersection$ u v)
                                   (intersection  u v))))))



;;; eof
