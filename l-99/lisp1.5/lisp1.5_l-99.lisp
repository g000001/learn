define ((
(length (lambda (lst)
          (cond ((null lst) 0)
                (t (add1 (length (cdr lst)))))))

(reverse (lambda (lst)
            (prog (l acc)
                  (setq l lst)
               L  (cond ((null l) (return acc)))
                  (setq acc (cons (car l) acc))
                  (setq l (cdr l))
                  (go L))))
))

;DEFINE ((
;(LAST2 (LAMBDA (LST)
;         (COND ((GREATERP 3 (LENGTH LST)) LST)
;               (T (LAST2 (CDR LST))))))    ))

;len((foo bar baz quux))
;LAST2((FOO BAR BAZ QUUX))


;  FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
; LAST2
;
; ((FOO BAR BAZ QUUX))
;
;
; END OF EVALQUOTE, VALUE IS ..
; (BAZ QUUX)

;P03 (*) Find the K'th element of a list.
;    The first element in the list is number 1.
;    Example:
;    * (element-at '(a b c d e) 3)
;    C

;  FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
; ELEMENT-AT
;
; ((A B C D E) 3)

; END OF EVALQUOTE, VALUE IS ..
; C

;DEFINE ((
;(ELEMENT-AT (LAMBDA (LST K) 
;             (COND ((NULL LST) ())
;                   ((GREATERP 2 K) (CAR LST))
;                   (T (ELEMENT-AT (CDR LST) (SUB1 K))))))
;    ))

;ELEMENT-AT((A B C D E) 3)


;DEFINE ((
;(SIZE (LAMBDA (LST)
;        (COND ((NULL LST) 0)
;              (T (ADD1 (SIZE (CDR LST)))))))
;
;(SIZE-ITER (LAMBDA (LST)
;             (PROG (L CNT)
;                   (SETQ CNT 0)
;                   (SETQ L LST)
;                L  (COND ((NULL L) (RETURN CNT)))
;                   (SETQ CNT (ADD1 CNT))
;                   (SETQ L (CDR L))
;                   (GO L))))    
;    ))
;
;SIZE((A B C D E F))
;SIZE-ITER((A B C D E F))

;  FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
; SIZE
;
; ((A B C D E F))
;
;
; END OF EVALQUOTE, VALUE IS ..
; 6
;
;  FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
; SIZE-ITER
;
; ((A B C D E F))
;
;
; END OF EVALQUOTE, VALUE IS ..
; 6


;P05 (*) Reverse a list.

;define((
;(rev (lambda (lst)
;       (cond ((null lst) () )
;             (t (append (rev (cdr lst)) (list (car lst)))))))
;
;(rev-iter (lambda (lst)
;            (prog (l acc)
;                  (setq l lst)
;               L  (cond ((null l) (return acc)))
;                  (setq acc (cons (car l) acc))
;                  (setq l (cdr l))
;                  (go L))))
;))

;  FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
; REV
;
; ((FOO BAR BAZ))
;
;
; END OF EVALQUOTE, VALUE IS ..
; (BAZ BAR FOO)
;
;  FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
; REV-ITER
;
; ((FOO BAR BAZ))
;
;
; END OF EVALQUOTE, VALUE IS ..
; (BAZ BAR FOO)

;rev((foo bar baz))
;rev-iter((foo bar baz))

;P06 (*) Find out whether a list is a palindrome.
;    A palindrome can be read forward or backward; e.g. (x a m a x).



; END OF EVALQUOTE, VALUE IS ..
; *TRUE*
;PALINDROMEP((X A M A X))

;DEFINE((
;(PALINDROMEP (LAMBDA (LST)
;              (EQUAL (REVERSE LST) LST)))
;))

;P07 (**) Flatten a nested list structure.
;    Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).
;
;    Example:
;    * (my-flatten '(a (b (c d) e)))
;    (A B C D E)
;
;    Hint: Use the predefined functions list and append.

;define((

;))

; FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
;FLATTEN
;
;((0 (1 ((((2 (((((3 (((4)))))))) 5))))) (6 (7 8) 9)))
;
;END OF EVALQUOTE, VALUE IS ..
;(0 1 2 3 4 5 6 7 8 9)

;define((
;(listp (lambda (lst)
;        (or (null lst) (not (atom lst)))))
;
;(flatten (lambda (lst)
;          (cond ((null lst) ())
;                ((listp (car lst)) 
;                 (append (flatten (car lst)) (flatten (cdr lst))))
;                (t (cons (car lst) (flatten (cdr lst)))))))
;))
;
;flatten((a (b (c d) e)))
;flatten((0(1((((2(((((3(((4))))))))5)))))(6 (7 8) 9)))
;
;listp(())
;listp((a b c d))



;(P08 連続して現われる要素を圧縮)Comments

;define((
;;; (compress (lambda (lst)
;;;             (prog (l res)
;;;                   (setq l lst)
;;;               L   (cond ((null l) 
;;;                          (return (reverse res))))
;;;                   (cond ((or (not (eq (car l) (car res)))
;;;                              (not l))
;;;                          (setq res (cons (car l) res))))
;;;                   (setq l (cdr l))
;;;                   (go L))))
;
;;; (dcompress (lambda (lst)
;;;             (prog (l res)
;;;                   (setq l lst)
;;;                   (setq res lst)
;;;               L   (cond ((null (cdr l)) (return lst)))
;;;                   (cond ((not (eq (car l) (car res)))
;;;                          (prog ()
;;;                             (rplacd res l)
;;;                             (setq res (cdr res)))))
;;;                   (setq l (cdr l))
;;;                   (go L))))
;
;
;(compress (lambda (lst)
;            (prog (l res tem)
;                  (setq l lst)
;                  (setq res (list (gensym)))
;                  (setq tem res)
;              L   (cond ((null l) (return (cdr res))))
;                  (cond ((not (eq (car l) (car tem)))
;                         (prog ()
;                               (rplacd tem (list (car l)))
;                               (setq tem (cdr tem)))))
;                  (setq l (cdr l))
;                  (go L))))
;
;))

;compress((a a a a b c c a a d e e e e))
;compress((a a a a b c c a a d e e e e))
;compress((a a a a b c c a a d e e e e f))
;compress((a a a a b c c a a d e e e e f f))
;compress((a b c d))
;
;  FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
; COMPRESS
;
; ((A A A A B C C A A D E E E E))
;
;
; END OF EVALQUOTE, VALUE IS ..
; (A B C A D E)


;P09 (**) Pack consecutive duplicates of list elements into sublists.
;    If a list contains repeated elements they should be placed in separate sublists.
;
;    Example:
;    * (pack '(a a a a b c c a a d e e e e))
;    ((A A A A) (B) (C C) (A A) (D) (E E E E))



DEFINE((
(MY-PACK (LAMBDA (LST)
           (PROG (RES TEM L)
                 (SETQ L (REVERSE 
                          (CONS (GENSYM) LST)))
              L  (COND ((NULL L) (RETURN RES)))
                 (COND ((null tem) (SETQ TEM (CONS (CAR L) TEM)))
                       ((EQUAL (CAR L) (CAR TEM))
                        (SETQ TEM (CONS (CAR L) TEM)))
                       (T (PROG ()
                                (SETQ RES (CONS TEM RES))
                                (SETQ TEM (CONS (CAR L) () )))))
                 (SETQ L (CDR L))
                 (GO L))))
))

;MY-PACK((A A A A B C C A A D E E E E))


;P10 (*) Run-length encoding of a list.
;    Use the result of problem P09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as lists (N E) where N is the number of duplicates of the element E.
;
;    Example:
;    * (encode '(a a a a b c c a a d e e e e))
;    ((4 A) (1 B) (2 C) (2 A) (1 D)(4 E))

DEFINE((
(MAPCAR (LAMBDA (LST FN)
          (COND ((NULL LST) () )
                (T (CONS (FN (CAR LST)) 
                         (MAPCAR (CDR LST) FN))))))

(ENCODE (LAMBDA (LST)
          (MAPCAR (MY-PACK LST)
                  (QUOTE (LAMBDA (X)
                           (LIST (LENGTH X) (CAR X)))))))
))

;

;MAPCAR(((1) (2) (3)) car)

;ENCODE ((a a a a b c c a a d e e e e))
;
;  FUNCTION   EVALQUOTE   HAS BEEN ENTERED, ARGUMENTS..
; ENCODE
;
; ((A A A A B C C A A D E E E E))
;
;
; END OF EVALQUOTE, VALUE IS ..
; ((4 A) (1 B) (2 C) (2 A) (1 D) (4 E))


