(cl:in-package :introduction-to-common-lisp-in-dialogue.internal)

(defvar *new-id* 0)


(defclass !object ()
  ((id :accessor id! :initform (new-id))))


(defun new-id () (incf *new-id*))


(defun eq! (!x !y) 
  (= (id! !x) (id! !y)))


;;(setf !x (make-instance '!object))

;=>  #<!OBJECT {101D9D09D3}>

(defclass !atom (!object) ())

(defclass !list (!object) ())

(defclass !number (!atom)
  ((number :accessor number! :initarg :number)))


;(setf !ten (make-instance '!number :number 10))

;(describe !ten)

;>>  #<!NUMBER {101E1A2683}>
;>>    [standard-object]
;>>  
;>>  Slots with :INSTANCE allocation:
;>>    ID      = 2
;>>    NUMBER  = 10
;>>  
;=>  <no values>

(defmethod cl! ((!num !number))
  (number! !num))


(defmethod !cl ((num number))
  (make-instance '!number :number num))


(defun !lisp ()
  (loop (print-prompt)
        (!print! (!eval! (!read!)))))


(defun print-prompt () 
  (format t "~&!CL> "))


(defun !read! ()
  (!cl (read)))


(defun !print! (!obj)
  (print (cl! !obj))
  !obj)


(defmethod !eval! ((!obj !object) &optional local)
  (declare (ignorable local))
  !obj)


(defclass !string (!atom)
  ((string :accessor string! :initarg :string)))


(defmethod cl! ((!str !string))
  (string! !str))

(defmethod !cl ((str string))
  (make-instance '!string :string str))


(defclass !symbol (!atom)
  ((name :accessor !symbol-name! :initarg :name)
   (value :accessor !symbol-value!)
   (function :accessor !symbol-function!)
   (plist :accessor !symbol-plist! :initarg :plist)
   (package :accessor !symbol-package! :initarg :package)))


(defclass !null (!symbol !list) ())

(or (boundp '!nil)
    (defconstant !nil (make-instance '!null :name (!cl "NIL"))))


(setf (!symbol-value! !nil) !nil)
(setf (!symbol-plist! !nil) !nil)

(defun !make-symbol! (!str)
  (make-instance '!symbol :name !str :plist !nil))


#|(describe (!make-symbol! "foo"))|#

(defun null! (!obj)
  (eq! !obj !nil))


(defclass !package (!atom)
  ((name :accessor !package-name! :initarg :name)
   (hash :accessor package-hash! :initarg :hash)))


(defvar !*package*
  (make-instance '!package
                 :name (!cl "!CL-USER")
                 :hash (make-hash-table :test #'equal)))


;;; NIL
(setf (gethash "NIL" (package-hash! !*package*))
      !nil)

(setf (!symbol-package! !nil) !*package*)


(defun !intern! (!str &optional (!pac !*package*))
  (let* ((str (string! !str))
         (hash (package-hash! !pac))
         (!sym (gethash str hash)))
    (if (not (null !sym))
        !sym
        (let ((!symbol (!make-symbol! !str)))
          (setf (!symbol-package! !symbol) !pac)
          (setf (gethash str hash) !symbol)))))


(defmethod !cl ((sym symbol))
  (!intern! (!cl (symbol-name sym))))


(defmethod cl! ((!sym !symbol))
  (intern (cl! (!symbol-name! !sym))))


(defmethod cl! ((!obj !object)) !obj)


(or (boundp '!t)
    (defconstant !t (!cl 't)))


(setf (!symbol-value! !t) !t)


(or (boundp '!pi)
    (defconstant !pi (!cl 'pi)))


(setf (!symbol-value! !pi) !pi)


(defmethod !eval! ((!sym !symbol) &optional local)
  (let ((binding (assoc !sym local :test #'eq!)))
    (if (not (null binding))
        (rest binding)
        (!symbol-value! !sym))))


(defclass !cons (!list)
  ((car :accessor !first! :initarg :car)
   (cdr :accessor !rest! :initarg :cdr)))


(defun !cons! (!x !y)
  (make-instance '!cons :car !x :cdr !y))


(defmethod cl! ((!cons !cons))
  (cons (cl! (!first! !cons))
        (cl! (!rest! !cons))))


(defmethod !cl ((cons cons))
  (!cons! (!cl (first cons))
          (!cl (rest cons))))


(defclass !function (!atom) ())


(defclass !special (!function)
  ((code :accessor code! :initarg :code)))


(defclass !funcallable (!function) ())


(defclass !primitive (!funcallable)
  ((code :accessor code! :initarg :code)))


(defclass !closure (!funcallable)
  ((body :accessor !body! :initarg :body)
   (parameters :accessor parameters!
               :initarg :parameters)
   (environment :accessor environment!
                :initarg :environment)))


(defmethod !eval! ((!cons !cons) &optional local)
  (!apply! (!first! !cons)
           (!rest! !cons)
           local))

(defun !-! (!x !y)
  (!cl (- (cl! !x) (cl! !y))))

#|(setf (!symbol-function! (!cl '-))
      (make-instance '!primitive :code #'!-!))|#

#|(cl! (!-! (!cl 8) (!cl 8)))|#

#|(!eval! '(- 8 8))|#

#|(setf (!symbol-function! (!cl '-))
      (make-instance '!special :code (coerce #'- 'function)))|#

#|(!apply! (code! (!symbol-function! (!cl '-))) 
         (!cl 8)
         (!cl 8))|#


(defmethod !apply! ((!sym !symbol) !args local)
  (!apply! (!symbol-function! !sym)
           !args 
           local))


(defmethod !apply! ((!spec !special) !args local)
  (apply (code! !spec)
         (cons local (noeval-args! !args))))


(defun noeval-args! (!args)
  (if (null! !args)
      nil
      (cons (!first! !args)
            (noeval-args! (!rest! !args)))))


(defun !quote! (local !a1)
  (declare (ignorable local))
  !a1)


(defun !if! (local !condition !then !else)
  (if (null! (!eval! !condition local))
      (!eval! !else local)
      (!eval! !then local)))


(defmethod !setf! (local (!sym !symbol) !form)
  (let ((!value (!eval! !form local))
        (binding (assoc !sym local :test 'eq!)))
    (if (not (null binding))
        (setf (rest binding) !value)
        (setf (!symbol-value! !sym) !value))))


(setf (!symbol-function! (!cl 'quote))
      (make-instance '!special :code #'!quote!))


(setf (!symbol-function! (!cl 'if))
      (make-instance '!special :code #'!if!))


(setf (!symbol-function! (!cl 'setf))
      (make-instance '!special :code #'!setf!))



(defmethod !apply! ((!fun !funcallable) !args local)
  ;; (break)
  (apply #'!funcall!
         (cons !fun (eval-args! !args local))))


(defmethod eval-args! (!args local)
  (if (null! !args)
      nil
      (cons (!eval! (!first! !args) local)
            (eval-args! (!rest! !args) local))))


(defmethod !funcall! ((!fun !primitive) &rest args)
  (apply (code! !fun) args))


(defun !eq! (!x !y)
  (if (eq! !x !y)
      !t
      !nil))

(setf (!symbol-function! (!cl 'eq))
      (make-instance '!primitive :code #'!eq!))


(defun !null! (!x)
  (!eq! !x !nil))

(setf (!symbol-function! (!cl 'null))
      (make-instance '!primitive :code #'!null!))


(defun !atom! (!x)
  (if (typep !x '!atom) !t !nil))

(setf (!symbol-function! (!cl 'atom))
      (make-instance '!primitive :code #'!atom!))


(setf (!symbol-function! (!cl '-))
      (make-instance '!primitive :code #'!-!))

(defun !*! (&rest list-of-!numbers)
  (!cl (apply #'* (mapcar #'cl! list-of-!numbers))))

(setf (!symbol-function! (!cl '*))
      (make-instance '!primitive :code #'!*!))


(defun install (sym)
  (let ((fun (print (intern (format nil "!~A!" (string sym))))))
    (if (fboundp fun)
        (setf (!symbol-function! (!cl sym))
              (make-instance '!primitive :code (coerce fun 'function)))
        (warn "~A" sym))))

(mapc #'install '(eq null atom
                  - *
                  first
                  rest
                  cons read print symbol-name symbol-value
                  symbol-function symbol-plist symbol-package funcall))


(defun !defun! (local !name !parameters !body)
  (setf (!symbol-function! !name)
        (make-instance '!closure
                       :body !body
                       :parameters (noeval-args! !parameters)
                       :environment local))
  (!symbol-function! !name)
  !name)

(setf (!symbol-function! (!cl 'defun))
      (make-instance '!special :code #'!defun!))

(setf (symbol-value '!lambda) (!cl 'lambda))

(defmethod !function! (local (!sym !symbol))
  (!symbol-function! !sym))


(defmethod !function! (local (!lexpr !cons))
  (make-instance '!closure 
                 :body (!first! (!rest! (!rest! !lexpr)))
                 :parameters (noeval-args! (!first! (!rest! !lexpr)))
                 :environment local))

(setf (!symbol-function! (!cl 'function))
      (make-instance '!special :code #'!function!))


(defmethod !funcall! ((!clo !closure) &rest args)
  (!eval! (!body! !clo)
          (pairlis (parameters! !clo)
                   args
                   (environment! !clo))))

#|(defun mapcar (fun lst)
  (if (null lst)
      nil
      (cons (funcall fun (first lst))
            (mapcar fun (rest lst)))))|#

#|(defun allcons (x y)
  (mapcar #'(lambda (y) (cons x y)) y))|#

#|(allcons 0 '((1) (2) (3)))|#

(defun !eval*! (!form) (!eval! !form nil))

(setf (!symbol-function! (!cl 'eval))
      (make-instance '!primitive :code #'!eval!))

(defun !describe! (!form)
  (!cl (describe !form)))


(setf (!symbol-function! (!cl 'describe))
      (make-instance '!primitive :code #'!describe!))


(defun !<! (!x !y)
  (!cl (< (cl! !x) (cl! !y))))

(setf (!symbol-function! (!cl '<))
      (make-instance '!primitive :code #'!<!))


(defun !=! (!x !y)
  (!cl (= (cl! !x) (cl! !y))))


(setf (!symbol-function! (!cl '=))
      (make-instance '!primitive :code #'!=!))


(defun !+! (!x !y)
  (!cl (+ (cl! !x) (cl! !y))))


(setf (!symbol-function! (!cl '+))
      (make-instance '!primitive :code #'!+!))

#|(defun fib (n) 
  (if (< n 2)
      n
      (+ (fib (- n 1))
         (fib (- n 2)))))|#

(defun fact (n)
  (if (= 0 n)
      1
      (* n (fact (- n 1)))))


(defun !list! (&rest list)
  (!cl (mapcar #'cl! list)))

(setf (!symbol-function! (!cl 'list))
      (make-instance '!primitive :code #'!list!))


;;; *EOF*
