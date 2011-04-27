;(provide "l99")
;(defpackage "l99")
;(in-package "l99")
;(use-package "common-lisp")
;(common-lisp::export '(
;                      combination
;                      ))


;(provide 'l99)
(defpackage l99
  (:nicknames l99 :l99)
  (:use common-lisp)
  (:export
   ADD-LEAF ADJACENCY-LIST->GRAPH-TERM ADJACENCY-LIST->GRAPH-TERM/DIRECTED
   ADJACENCY-LIST->GRAPH-TERM/LABELLED AND/2 ARC-CLAUSE->GRAPH-TERM/DIRECTED
   ARC-CLAUSE->GRAPH-TERM/LABELLED ATLEVEL BIN->GRAY BOTTOM-UP CBAL-TREE
   CBAL-TREE-P COMB2 COMBINATION COMPRESS CONSTRUCT COPRIME COUNT-LEAF
   COUNT-LEAVES COUNT-LEAVES-AND-NODES DECODE DECODE-MODIFIED-PROG
   DEPTH-OF-MOST-LEFT-NODE DISASSEMBLE-TREE-STRING DOTSTRING->TREE DROP
   DUPLI EDGE-CLAUSE->GRAPH-TERM ELEMENT-AT ENCODE ENCODE-DIRECT
   ENCODE-MODIFIED/DO EQU/2 EXPAND FIND-REGION FLATTEN FLATTEN-TREE
   FOR-EACH-TREE FULL-WORDS GEN-TREE-H GET-CHILDREN GET-DIRECTION
   GET-DIRECTION/LABELLED GOLDBACH GOLDBACH-LIST GOLDBACH-LIST/LIMIT
   GRAPH-TERM->ADJACENCY-LIST GRAPH-TERM->ADJACENCY-LIST/DIRECTED
   GRAPH-TERM->ADJACENCY-LIST/LABELLED GRAPH-TERM->ARC-CLAUSE/DIRECTED
   GRAPH-TERM->ARC-CLAUSE/LABELLED GRAPH-TERM->EDGE-CLAUSE
   GRAPH-TERM->HUMAN-FRIENDLY GRAPH-TERM->HUMAN-FRIENDLY/DIRECTED
   GRAPH-TERM->HUMAN-FRIENDLY/LABELLED GROUP GROUP-RPAT GROUP3 HBAL-TREE
   HBAL-TREE-P HUFFMAN-ENCODE HUFFMAN-TREE->CODE HUMAN-FRIENDLY->GRAPH-TERM
   HUMAN-FRIENDLY->GRAPH-TERM/DIRECTED HUMAN-FRIENDLY->GRAPH-TERM/LABELLED
   IMPL/2 INORDER INSERT-AT INTERNAL-PATH-LENGTH INTERNALS IS-MULTIWAY-TREE
   IS-PRIME ISTREE LAYOUT-BINARY-TREE LAYOUT-BINARY-TREE-2 LEAFP LEAVES
   LFSORT LISPY-TOKEN-LIST->MULTIWAY-TREE LOTTO-SELECT LSORT
   MAKE-FREQUENCY-LIST MAKE-HUFFMAN-TREE MAKE-TRUTH-TABLE MIRROR
   MULTIWAY-TREE->LISPY-TOKEN-LIST MY-BUT-LAST MY-FLATTEN MY-GCD MY-LAST
   NAND/2 NBIT-GRAY NEXT-PRIME NNODES NODE-STRING->TREE NOR/2 NTH-TRUTH
   NUMBER-OF-ELEMENTS OR/2 PACK PALINDROMEP PERM PHI PP-GOLDBACH-LIST
   PP-HUFFMAN-CODE PP-TABLE PP-TABLE/3 PPT PRE+IN->TREE PREORDER
   PRIME-FACTORS PRIME-FACTORS-MULT PRIME-LIST RANGE REBUILD-LIST REMOVE-AT
   REMOVE-PARENT REPLI REVERSE-A-LIST RND-PERMU RND-SELECT ROTATE SEP2 SEP2S
   SKELETON SLICE SNULL SPLIT STRING->TREE STRING-JOIN SYM-CBAL-TREE
   SYMMETRIC TABLE TABLE TOTIENT-PHI TREE->DOTSTRING TREE->NUMLIST
   TREE->STRING TREE-DEPTH TREE-HEIGHT TREE-STRING>GET-BOUNDARY
   TREE-STRING>GET-CHILDREN TREE<=>DOTSTRING TREE<=>STRING XAPPEND XOR/2
   ))

(in-package :l99)

;(defpackage l99)

;(in-package :l99)

;(export '(
;         combination
;         group))

;(in-package :common-lisp-user)

;(defpackage :l99
;  (:nicknames :l99)
;  (:use :common-lisp))

;(eval-when (:compile-toplevel :load-toplevel :execute)
;  (export '(my-last)))

;(in-package 'l99 :use 'common-lisp-user)

;(export '(my-last))

;(load "./amb-utils.lisp")


;; ================================================================
;; P01
;; ================================================================
(defun my-last (list)
  (do ((l list (cdr l)))
      ((null (cdr l)) l)))

;; ================================================================
;; P02
;; ================================================================
(defun my-but-last (list)
  (loop for l on list when (null (cddr l))
        do (return l)))

;; ================================================================
;; P03
;; ================================================================
(defun element-at (list k)
  (prog (l c)
        (setq l list
              c k)
L       (and (= c 1) (go X))
        (psetq c (1- c)
               l (cdr l))
        (go L)
X       (return (car l))))

;; ================================================================
;; P04
;; ================================================================
(DEFUN NUMBER-OF-ELEMENTS (LIST)
  (PROG (N L)
        (PSETQ N 0 
              L LIST)
L       (COND ((NULL L) (GO X)))
        (PSETQ N (1+ N)
               L (CDR L))
        (GO L)
X       (RETURN N)))

;; ================================================================
;; P05
;; ================================================================
(DEFUN REVERSE-A-LIST (LIST)
  (PROG (L RL)
        (PSETQ L LIST
               RL '())
L       (COND ((NULL L) (RETURN RL)))
        (PSETQ L (CDR L)
               RL (CONS (CAR L) RL))
        (GO L)))

;; ================================================================
;; P06
;; ================================================================
(defun palindromep (list)
  (cond ((equal list (reverse-a-list list)) t) ;P05
        (t nil)))

;; ================================================================
;; P07
;; ================================================================
(defun my-flatten (list acc)
  (cond ((null list) acc)
        ((consp (car list)) 
         (my-flatten (cdr list) (append acc (my-flatten (car list) '()))))
        (t 
         (my-flatten (cdr list) (append acc (list (car list)))))))

(defun flatten (list)
  (labels ((frob (list acc)
             (cond ((null list) acc)
                   ((consp (car list)) 
                    (frob (cdr list) (append acc (frob (car list) '()))))
                   (t 
                    (frob (cdr list) (append acc (list (car list))))))))
    (frob list '() )))


;; ================================================================
;; P08
;; ================================================================
(defun compress (list)
  (if (consp list)
    (if (and (equal (car list) (cadr list))
             (consp (cdr list)))
      (compress (cdr list))
      (append (list (car list))
              (compress (cdr list))))))

;; ================================================================
;; P09
;; ================================================================
(DEFUN PACK (LIST &OPTIONAL (FUNC #'EQ))
  (PROG (L PL PART)
        (SETQ L LIST)
        (SETQ PL '())
        (SETQ PART '())
     L  (COND ((NULL L) (RETURN PL)))
        (SETQ PART (CONS (CAR L) PART))
        (OR (AND (FUNCALL FUNC (CAR L) (CADR L))
                 (CONSP (CDR L)))
            (AND (SETQ PL (APPEND PL (LIST PART)))
                 (SETQ PART '())))
        (SETQ L (CDR L))
        (GO L)))

;; ================================================================
;; P10
;; ================================================================
(defun encode (list)
  (labels ((encode1 (l retlist 
                     &optional (c 0) (a (car l)))
             (cond ((endp l) 
                    `((,c ,a) ,@retlist))
                   ((equal (car l) a) 
                    (encode1 (cdr l) retlist
                             (1+ c) (car l)))
                   ('t
                    (encode1 (cdr l) `((,c ,a) ,@retlist)
                             1 (car l))))))
    (encode1 list '())))                ; 5:48pm Wednesday,21 March 2007

;; ================================================================
;; P11
;; ================================================================
(defun encode-modified/do (list)
  (flet ((list-but-single (item count)
           (if (= count 1)
               `(,item)
             `((,count ,item)))))
    (do ((l list (cdr l))
         (repeatp t (equal (car l) (cadr l)))
         (c 0 (1+ (if repeatp c 0)))
         (a (car list) (car l))
         (r '() (if repeatp 
                    r 
                  (append r (list-but-single a c)))))
        ((null l) (append r (list-but-single a c)))))) ;11:38pm Thursday,25 January 2007

;; ================================================================
;; P12
;; ================================================================
(defun expand (list)
  (let ((n (car list))
        (item (cadr list)))
    (if (= n 1)
        `(,item)
      (cons item (expand `(,(1- n) ,item))))))

(defun decode (list)
  (labels ((expand (code)
             (let ((n (car code))
                   (item (cadr code)))
               (if (= n 1)
                   `(,item)
                   (cons item (expand `(,(1- n) ,item)))))))
    (if (null list)
        '()
        (append (expand (car list)) (decode (cdr list)))))) ; 1:07pm Saturday,27 January 2007

(DEFUN DECODE-MODIFIED-PROG (LIST)
   (PROG (RETLIST EXP ITEM CODE N I)
         (SETQ RETLIST '())
L        (COND ((ENDP LIST) (GO X)))
         (SETQ I 0)
         (SETQ EXP '())
         (SETQ CODE (CAR LIST))
         (SETQ CODE (COND ((ATOM CODE) `(1 ,CODE)) ;NOMALIZE
                          ('T CODE)))
         (SETQ N (CAR CODE))
         (SETQ ITEM (CADR CODE))
EXP      (COND ((= I N) (GO ML)))
         (SETQ EXP `(,@EXP ,ITEM))
         (SETQ I (1+ I))
         (GO EXP)
ML       (SETQ RETLIST `(,@RETLIST ,@EXP))
         (SETQ LIST (CDR LIST))
         (GO L)
X        (RETURN RETLIST)))

;; ================================================================
;; P13
;; ================================================================
(defun encode-direct (list)
  (flet ((list-but-single (item count)
           (if (= count 1)
               item
               (list count item))))
    (labels ((encode1 (l c a)
               (cond ((null l) (cons (list-but-single a c) ()))
                     ((equal (car l) a) (encode1 (cdr l) (1+ c) (car l)))
                     ('t (cons (list-but-single a c)
                               (encode1 (cdr l) 1 (car l)))))))
      (encode1 list 0 (car list)))))

;; ================================================================
;; P14
;; ================================================================
(defun dupli (list)
  (if (endp list)
      '()
      (let ((item (car list)))
        `(,item ,item ,@(dupli (cdr list))))))

;; ================================================================
;; P15
;; ================================================================
(defun repli (list n)
(let ((retlist '()))
  (mapc #'(lambda (l)
            (setf retlist 
                  `(,@retlist ,@(expand `(,n ,l)))))
        list)
  retlist))

;; ================================================================
;; P16
;; ================================================================
(defun drop (list n)
  (prog ((l list) (c n) (retlist '()))
L      (and (endp l) (return retlist))
       (multiple-value-setq (c retlist)
         (if (= c 1)
             (values n retlist)
           (values (1- c) `(,@retlist ,(car l)))))
       (setq l (cdr l))
       (go L)))                         ; 6:25pm Saturday, 3 February 2007

;; ================================================================
;; P17
;; ================================================================
(defun split (list n)
  (do ((l list (cdr l))
       (c 0 (1+ c))
       (retlist '(() ()) 
                (let ((first  (car retlist))
                      (second (cadr retlist)))
                  (if (< c n)
                      `((,@first ,(car l)) ,second)
                      `(,first (,@second ,(car l)))))))
      ((endp l) retlist)))              ; 5:43pm Sunday, 4 February 2007

;; ================================================================
;; P18
;; ================================================================
(defun slice (list start end)
  (labels ((slice1 (l c retlist)
             (cond ((or (endp l) (> c end)) 
                    retlist)
                   ((<= start c end) 
                    (slice1 (cdr l) (1+ c) `(,@retlist ,(car l))))
                   ('t 
                    (slice1 (cdr l) (1+ c) retlist)))))
    (slice1 list 0 '())))               ; 1:32am Monday, 5 February 2007

;; ================================================================
;; P19
;; ================================================================
(defun rotate (list n)
  (labels ((split (list n)
             (do ((l list (cdr l))
                  (c 0 (1+ c))
                  (retlist '(() ()) 
                           (let ((first  (car retlist))
                                 (second (cadr retlist)))
                             (if (< c n)
                                 `((,@first ,(car l)) ,second)
                                 `(,first (,@second ,(car l)))))))
                 ((endp l) retlist))))
    (destructuring-bind (1st 2nd)
        (split list 
               (if (plusp n) 
                   n 
                   (+ (length list) n)))
      `(,@2nd ,@1st))))

;; ================================================================
;; P20
;; ================================================================
(DEFUN REMOVE-AT (LIST N)
  (PROG (L C RETLIST)
     (SETQ L LIST)
     (SETQ C 1)
     (SETQ RETLIST '())
L    (COND ((NULL L) (GO XIT)))
     (OR (= C N)
         (SETQ RETLIST (CONS (CAR L) RETLIST)))
     (SETQ C (1+ C))
     (SETQ L (CDR L))
     (GO L)
XIT  (RETURN (NREVERSE RETLIST))))

;; ================================================================
;; P21
;; ================================================================
(defun insert-at (item list n)
  (do ((l list (cdr l))
       (c 1 (1+ c))
       (retlist '() `(,@retlist ,(car l))))
      ((or (= c n) (endp l))
       (if (endp l)
           retlist
           `(,@retlist ,item ,@l)))))

;; ================================================================
;; P22
;; ================================================================
(defun range (start end)
  (loop for i from start to end
        collect i))

;; ================================================================
;; P23
;; ================================================================
(defun rnd-select (list n)
  (labels ((rnd-select1 (l c retlist)
             (if (zerop c)
               retlist
               (multiple-value-bind (rest item) 
                   (remove-at l (random (length l)))
                 (rnd-select1 rest (1- c) `(,item ,@retlist))))))
    (rnd-select1 list n '())))        ;12:26am Monday,12 February 2007

;; ================================================================
;; P24
;; ================================================================
(defun lotto-select (n rng)
  (rnd-select (range 1 rng) n))

;; ================================================================
;; P25
;; ================================================================
(defun rnd-permu (list)
  (rnd-select list (length list)))

;; ================================================================
;; P26
;; ================================================================
;; 11:32am Monday, 3 March 2008
(defun combination (n list)
  (let ((len (length list)))
    (cond ((not (<= 1 n len)) ())
          ((= len n) (list list))
          ((= n 1) (mapcar #'list list))
          ('T `(,@(mapcar #'(lambda (i) `(,(car list) ,@i))
                          (combination (1- n) (cdr list)))
                  ,@(combination n (cdr list)))))))

#|(defun combination (n list)
  (cond ((zerop n)
         '())
        ((= (length list) n)
         `(,list))
        ((= n 1)
         (mapcar #'(lambda (i) (cons i ()))
                 list))
        ('t
         `(,@(mapcar #'(lambda (i) `(,(car list) ,@i))
                     (combination (1- n) (cdr list)))
             ,@(combination n (cdr list))))))|# ; 5:20pm Saturday,17 February 2007

;; ================================================================
;; P27 ****************************************************************
;; ================================================================
(defun group3 (list)
  (let ((retlist '()))
    (dolist (l (combination 2 list) retlist)
      (let ((diff (set-difference list l)))
        (dolist (m (combination 3 diff))
          (setq retlist `(,@retlist (,l ,m ,(set-difference diff m)))))))))

;; 12:08pm Tuesday, 4 March 2008
(defun sep2 (lst num)
  (loop :for item :in (combination num lst)
        :collect `(,item ,(set-difference lst item))))

(defun sep2-list (lsts num)
  (loop :for l :in lsts
        :nconc (loop :for (item1 item2) :in (sep2 (car (last l)) num)
                     :if item2 :collect `(,@(butlast l) ,item1 ,item2)
                     :else :collect `(,@(butlast l) ,item1))))

(defun group (lst pat)
  (labels ((group1 (lst pat)
             (cond ((or (endp pat) (not (<= 0 (apply #'+ pat) (length lst)))) 
                    () )
                   ((= (length lst) (car pat)) 
                    (list lst))
                   ((= 1 (length pat))
                    (sep2 lst (car pat)))
                   ('T
                    (sep2-list (group1 lst (cdr pat)) (car pat))))))
    (group1 lst (reverse pat))))

;; 12:22am Monday,28 May 2007
#|(defun sep2 (lst num)
  (let ((front (combination num lst)))
    (map 'list #'(lambda (item) 
                   `(,item ,(set-difference lst item)))
         front)))|#

#|(defun sep2s (lsts num)
  (do ((l lsts (cdr l))
       (retlst '()))
      ((endp l) retlst)
    (setq retlst 
          `(,@retlst 
            ,@(map 'list #'(lambda (item)
                             (if (cadr item)
                                 `(,@(butlast (car l)) ,(car item) ,(cadr item)) 
                                 `(,@(butlast (car l)) ,(car item))))
                   (sep2 (car (last (car l))) num))))))|#

#|(defun group (lst pat)
  (group-rpat lst (reverse pat)))|#

#|(defun group-rpat (lst pat)
  (if (> (apply #'+ pat) (length lst))
      (error "foo!")
      (cond ((endp pat) '()     )
            ((= (length lst) (car pat)) `(,lst))
            ((= 1 (length pat)) 
             (sep2 lst (car pat)))
            ('t (sep2s (group-rpat lst (cdr pat)) (car pat))))))|#

;; ================================================================
;; P28
;; ================================================================
(defun lsort (list)
  (sort list #'(lambda (a b)
                 (< (length a) (length b)))))   ; 3:46pm Sunday, 4 March 2007

;; ================================================================
;; P29
;; ================================================================
(defun lfsort (list)
  (let ((lflist (lsort (pack (lsort list) #'(lambda (a b)
                                              (= (length a) (length b)))))))
    (do ((l lflist (cdr l))
         (retlist '() (if (< 0 (length (car l)))
                          `(,@retlist ,(caar l))
                          (do ((m (car l) (cdr m))
                               (retlist retlist `(,@retlist ,(car m))))
                              ((endp m) retlist)))))
        ((endp l) retlist))))           ; 5:10pm Sunday, 4 March 2007
;(30)
;; ================================================================
;; P31
;; ================================================================
(defun is-prime (n)
  (cond ((< n 2) nil)
        ((= n 2) t)
        ((= n 3) t)
        ((zerop (mod n 2)) nil)
        ('t (do ((i 3 (+ i 2))
                 (fin n (multiple-value-bind (quotient remainder)
                            (floor n i)
                          (if (zerop remainder) 
                              (return nil)
                              quotient))))
                ((> i fin) t)))))

(defun next-prime (n)
  (do ((i (1+ n) (1+ i)))
      ((is-prime i) i)))

;; ================================================================
;; P32
;; ================================================================
(defun my-gcd (n m)
  (if (zerop m)
      n
      (my-gcd m (mod n m))))

;; ================================================================
;; P33
;; ================================================================
(defun coprime (m n)
  (if (= 1 (abs (gcd m n)))
      t
      nil))

;; ================================================================
;; P34
;; ================================================================
(defun totient-phi (m)
  (labels ((totient-phi1 (m n)
             (if (zerop n) 
                 0
                 (+ (if (coprime m n)
                        1
                        0)
                    (totient-phi1 m (1- n))))))
    (totient-phi1 m (1- m))))

;; ================================================================
;; P35
;; ================================================================
(defun prime-factors (n)
  (flet ((next-prime (n)
           (do ((i (1+ n) (1+ i)))
               ((is-prime i) i))))
    (labels ((prime-factors1 (n i)
               (multiple-value-bind (q r)
                   (floor n i)
                 (cond ((< n 2)
                        `(,n))
                       ((zerop r)
                        (if (= q 1)
                            `(,i)
                            `(,i ,@(prime-factors1 q i))))
                       ('t 
                        (prime-factors1 n (next-prime i)))))))
      (prime-factors1 n 2))))

;; ================================================================
;; P36
;; ================================================================
(defun prime-factors-mult (n)
  (do ((l (prime-factors n) (cdr l))
       (c 1 (if (eql (car l) prevl)
                (1+ c)
                1))
       (retlist '() (if (eql (car l) prevl)
                        retlist
                        `(,@retlist (,prevl ,c))))
       (prevl (gensym) (car l)))
      ((endp l) (cdr `(,@retlist (,prevl ,c)))))) ; 6:42pm Wednesday,21 March 2007

;; ================================================================
;; P37
;; ================================================================
(defun phi (m)
  (apply #'*
         (mapcar #'(lambda (list) 
                     (destructuring-bind (p m)
                         list
                       (* (1- p) (expt p (1- m)))))
                 (prime-factors-mult m))))

;; ================================================================
;; P38 test P34 & P37
;; ================================================================
;(macrolet ((1000-times-time (func)
;            (format t "~a: ================" `,func)
;            `(time 
;              (dotimes (i 998 ,func)
;                ,func))))
;  (1000-times-time (phi 10090))
;  (1000-times-time (totient-phi 10090)))

;; ================================================================
;; P39
;; ================================================================
(defun prime-list (start end)
  (do ((i start (1+ i))
       (retlist '() (if (is-prime i) 
                        `(,@retlist ,i)
                        retlist)))
      ((= i end) retlist)))

;; ================================================================
;; P40
;; ================================================================
(DEFUN GOLDBACH (N)
  (AND (EVENP N)
       (> N 3)
       (PROG (I J)
          (SETQ I 2)
  L       (SETQ J (- N I))
          (AND (IS-PRIME J)
               (RETURN-FROM GOLDBACH `(,I ,J)))
          (SETQ I (NEXT-PRIME I))
          (GO L))))

;(defun goldbach/amb (n)
;  (choose-bind x (prime-list 2 (floor n 2))
;    (if (is-prime (- n x))
;       `(,x ,(- n x))
;       (fail))))

;; ================================================================
;; P41
;; ================================================================
(defun goldbach-list (start end)
  (mapcar #'goldbach
          (remove-if #'(lambda (item)
                         (or (< item 6)
                             (oddp item)))
                     (range start end))))

(defun goldbach-list/limit (start end limit)
    (remove-if #'(lambda (item) 
                   (< (car item) limit))
               (goldbach-list start end)))

(defun pp-goldbach-list (lst)
  (mapc #'(lambda (item)
            (destructuring-bind (a b)
                item
              (format t "~d = ~d + ~d~%" (+ a b) a b)))
        lst))

; (42 43 44 45)
;; ================================================================
;; P46
;; ================================================================
(defun perm (lst)
  (do ((l lst (cdr l))
       (retlst '() `(,@retlst ,@(mapcar #'(lambda (item)
                                            (list (car l) item))
                                        lst))))
      ((endp l) retlst)))

(defun table (a b expr)
  (mapcar #'(lambda (pattern)
              (destructuring-bind (a b)
                  pattern
                `(,a ,b ,(funcall expr a b))))
          (perm `(,a ,b))))

(defun pp-table/3 (lst)
  (dolist (l lst)
    (destructuring-bind (a b c) l
      (format t "~A ~A -> ~A~%" a b c))))

(defun and/2 (a b) 
  (if a b a))

(defun or/2 (a b)
  (if a a b))

(defun impl/2 (a b)
  (or/2 (not a) b))

(defun nand/2 (a b)
  (not (if a b a)))

(defun nor/2 (a b)
  (not (if a a b)))

(defun equ/2 (a b)
  (or/2 (and/2 a b)
        (and/2 (not a) (not b))))

(defun xor/2 (a b)
  (not (or/2 (and/2 a b)
             (and/2 (not a) (not b)))))

;; 10:38pm Saturday,31 March 2007
;; (defun binary-tree-p (lst)
;;   (if (/= 2 (length lst)) 
;;       nil
;;       (and (or (atom (car lst))
;;             (binary-tree-p (car lst)))
;;         (or (atom (cadr lst))
;;             (binary-tree-p (cadr lst))))))

;; ================================================================
;; P47
;; ================================================================

;;  6:35pm Tuesday,25 March 2008


; (table/b ((a t) (b nil))
;  A and (A or not B))

;=> T : T => T
;   T : NIL => T
;   NIL : T => NIL
;   NIL : NIL => NIL


(defmacro TABLE/B ((a b) &body expr)
  `(LET (,a ,b)
     (DOLIST (X (PERM (LIST ,(car a) ,(car b))))
       (DESTRUCTURING-BIND (A B) x
         (FORMAT T "~A : ~A => ~A~%" a b ,(to-prefix expr))))))

(defun TO-PREFIX (expr)
  (labels ((frob (expr)
             (cond ((atom expr) expr)
                   ((and (consp expr) (eq 'not (car expr))) 
                    (if (consp (cadr expr))
                        `(not ,(frob (cadr expr)))
                        expr))
                   ((atom (car expr))
                    (destructuring-bind (a pred b) expr
                      `(,pred ,a ,(frob b))))
                   ('T (destructuring-bind (a pred b) expr
                         `(,pred ,(frob a) ,(frob b)))))))
    (frob (conjunct-not-expr expr))))

(defun CONJUNCT-NOT-EXPR (expr)
  (cond ((null expr) () )
        ((eq 'not (car expr))
         `((not ,(if (atom (cadr expr))
                     (cadr expr)
                     (CONJUNCT-NOT-EXPR (cadr expr))))
           ,@(CONJUNCT-NOT-EXPR (cddr expr))))
        ((atom (car expr))
         (cons (car expr) (CONJUNCT-NOT-EXPR (cdr expr))))
        ('T (cons (CONJUNCT-NOT-EXPR (car expr))
                  (CONJUNCT-NOT-EXPR (cdr expr))))))

;(conjunct-not-expr '(not A and not (A or not B) and C))


;(table/b ((a t) (b nil))
;  not A and not (A or not B))

;(to-prefix '(A and not (A or not B)))
;(to-prefix '(not A and not (A or not B)))
;(to-prefix A and (A or not B))



;; ================================================================
;; P48
;; ================================================================

;P48 (**) Truth tables for logical expressions (3).  Generalize
;    problem P47 in such a way that the logical expression may contain
;    any number of logical variables. Define table/2 in a way that
;    table(List,Expr) prints the truth table for the expression Expr,
;    which contains the logical variables enumerated in List.
;
;    Example:
;    * table([A,B,C], A and (B or C) equ A and B or A and C).
;    true true true true
;    true true fail true
;    true fail true true
;    true fail fail true
;    fail true true true
;    fail true fail true
;    fail fail true true
;    fail fail fail true

; require CONJUNCT-NOT-EXPR


(defparameter *OPERATOR-PRECEDENCE-LIST*
  '(and/2 nand/2 or/2 nor/2 impl/2 equ/2 xor/2)
  "オペレータの優先順位リスト: 先頭になるほど優先順位が高い")

(defun CONJUNCT-INFIX-EXPR (pred expr)
  (cond ((atom expr) expr)
        ((eq pred (cadr expr))
         (destructuring-bind (a pred b &rest rest) expr
           `((,(CONJUNCT-INFIX-EXPR pred a)
               ,pred
               ,(CONJUNCT-INFIX-EXPR pred b))
             ,@(CONJUNCT-INFIX-EXPR pred rest))))
        ((atom (car expr))
         (cons (car expr) (CONJUNCT-INFIX-EXPR pred (cdr expr))))
        ;; 不要な入れ子を防ぐ
        ((= 3 (length (car expr)))
         (cons (car expr)
               (CONJUNCT-INFIX-EXPR pred (cdr expr))))
        ('T (cons (CONJUNCT-INFIX-EXPR pred (car expr))
                  (CONJUNCT-INFIX-EXPR pred (cdr expr))))))

(defun SET-OPERATOR-PREDENCE (expr precedence)
  (reduce (lambda (res x) (conjunct-infix-expr x res))
          precedence 
          :initial-value expr))

;(to-prefix/c '(A and/2 (B or/2 C) equ/2 A and/2 B or/2 A and/2 C) 
;             *operator-precedence-list*)
;=> (EQU/2 (AND/2 A (OR/2 B C)) (OR/2 (AND/2 A B) (AND/2 A C)))
;
(defun TO-PREFIX/C (expr precedence)
  (labels ((frob (expr)
             (cond ((atom expr) expr)
                   ((and (consp expr) (eq 'not (car expr))) 
                    (if (consp (cadr expr))
                        `(not ,(frob (cadr expr)))
                        expr))
                   ((atom (car expr))
                    (destructuring-bind (a pred b) expr
                      `(,pred ,a ,(frob b))))
                   ('T (destructuring-bind (a pred b) expr
                         `(,pred ,(frob a) ,(frob b)))))))
    (frob (car (set-operator-predence (conjunct-not-expr expr)
                                      precedence)))))

(defun MAKE-TRUTH-TABLE (size &optional (true t) (false nil))
  (loop :for i :below (expt 2 size)
        :collect (mapcar (lambda (x) (if (char= #\1 x) true false))
                         (coerce (format nil "~V,'0,B" size i) 'list))))

(defmacro TABLE/C ((&rest args) &body expr)
  (let ((g (gensym))
        (len (length args)))
    `(DOLIST (,g (make-truth-table ,len))
       (DESTRUCTURING-BIND ,args ,g
         (FORMAT T "~{~A~^, ~} => ~A~%" ,g 
                 ,(to-prefix/c expr *operator-precedence-list*))))))

;(table/c (a b c)
;  A and/2 (B or/2 C) equ/2 A and/2 B or/2 A and/2 C)

;=> T, T, T => T
;   T, T, NIL => T
;   T, NIL, T => T
;   T, NIL, NIL => T
;   NIL, T, T => T
;   NIL, T, NIL => T
;   NIL, NIL, T => T
;   NIL, NIL, NIL => T

;:- op(900, fy,not).
;:- op(910, yfx, and).
;:- op(910, yfx, nand).
;:- op(920, yfx, or).
;:- op(920, yfx, nor).
;:- op(930, yfx, impl).
;:- op(930, yfx, equ).
;:- op(930, yfx, xor).

(defun nth-truth (size num &optional (true t) (false nil))
  (do* ((j size (1- j))
        (retlst '() `(,@retlst ,(if (evenp (floor num (expt 2 j))) true false))))
       ((zerop j) retlst)))

(defun make-truth-table (size &optional (true t) (false nil))
  (do ((i 0 (1+ i))
       (retlst '() `(,@retlst ,(nth-truth size i true false))))
      ((= i (expt 2 size)) retlst)))

(defun table (size expr)
  (mapcar #'(lambda (item)
              `(,@item ,(apply expr item)))
          (make-truth-table size)))

(defun pp-table (lst)
  (dolist (l lst)
    (format t "~{~A ~} -> ~{~A~}~%" (butlast l) (last l))))


;; ================================================================
;; P49
;; ================================================================
(defun bin->gray (n)
  (logxor (ash n -1) n))

(defun nbit-gray (n)
  (do ((i 0 (1+ i))
       (retlst '() `(,@retlst ,(format nil (format nil "~~~d,'0b" n) (bin->gray i)))))
      ((= i (expt 2 n) retlst))))

;; 10:17am Friday,28 March 2008
(defun nbit-gray (n)
  (do ((i 0 (1+ i))
       (retlst () (cons (format nil "~V,'0B" n (bin->gray i)) 
                        retlst)))
      ((= i (expt 2 n)) (nreverse retlst))))

(defun nbit-gray (n)
  (loop :for i :from 0 :below (expt 2 n)
        :collect (format nil "~V,'0B" n (bin->gray i))))


(defun gray (n)
  (if (= n 1)
      '("0" "1")
      ))

;
;gray(1,['0','1']).
;gray(N,C) :- N > 1, N1 is N-1,
;   gray(N1,C1), reverse(C1,C2),
;   prepend('0',C1,C1P),
;   prepend('1',C2,C2P),
;   append(C1P,C2P,C).
;
;prepend(_,[],[]) :- !.
;prepend(X,[C|Cs],[CP|CPs]) :- atom_concat(X,C,CP), prepend(X,Cs,CPs).
;
;
;(defun prepend (x u v)
;  (if (and (null u) (null v))
;      ()
;      ))
;



;; ================================================================
;; P50
;; ================================================================
(defun for-each-tree (f g n tree)
  (cond ((not (listp tree)) (funcall f tree))           
        ((endp tree) n)
        ('t (funcall g (for-each-tree f g n (car tree))
                     (for-each-tree f g n (cdr tree))))))

(defun make-frequency-list (lst &aux (retlst '()))
  (dolist (item lst retlst)
    (let ((found-item (assoc item retlst)))
      (if found-item
          (incf (cdr found-item))
          (setf retlst `(,@retlst (,item . 1)))))))

(defun make-huffman-tree (lst)
  (if (= (length lst) 1)
    (caar lst)
    (make-huffman-tree
     (destructuring-bind (a b &rest c)
         (sort lst #'(lambda (a b) (< (cdr a) (cdr b))))
       `(((,(car a) ,(car b)) . ,(+ (cdr a) (cdr b))) ,@c)))))

(defun huffman-tree->code (tree &optional (code ""))
  (cond ((not (listp tree)) `(,tree ,code))
        ((endp tree) '())
        ('t `(,(huffman-tree->code (car tree) (concatenate 'string code "1"))
               (,(huffman-tree->code (cadr tree) (concatenate 'string code "0")))))))

(defun flatten-tree (tree)
  (for-each-tree #'list #'append '() tree))

(defun rebuild-list (lst)
  (do ((l lst (cddr l))
       (retlst '() `(,@retlst (,(car l) ,(cadr l)))))
      ((endp l) retlst)))

(defun huffman-encode (lst)
  (rebuild-list
   (flatten-tree
    (huffman-tree->code 
     (make-huffman-tree 
      (make-frequency-list lst))))))

(defun pp-huffman-code (lst)
  (mapc #'(lambda (item)
            (format t "~A => ~A~%" (car item) (cadr item)))
        lst))

;(pp-huffman-code
; (sort (huffman-encode *testdata*) #'(lambda (a b) (char< (car a) (car b)))))

;; 

;; (defun istree (obj)
;;   (and (listp obj)
;;        (atom (car obj))
;;        (not (null (car obj)))
;;        (= 3 (length obj))))


;(51 52 53)
;; ================================================================
;; P54A
;; ================================================================
(defun istree (obj)
  (flet ((isnode (node)
           (or (null node) (istree node))))
    (and (listp obj)
         (= 3 (length obj))
         (equal '(nil t t) (mapcar #'isnode obj)))))

;; ================================================================
;; P55 (11:33pm Tuesday,11 September 2007)
;; ================================================================

(defun cbal-tree (n)
  (if (zerop n)
      '(())
      (if (>= 1 n)
          '((x () () ))
          (reduce (lambda (res x) 
                    (let ((tree `(x ,@x)))
                      (if (cbal-tree-p tree)
                          `(,tree ,@res)
                          res)))
                  (let ((half (/ (1- n) 2))) ;balanced
                    (if (zerop (mod half 1))
                        (comb2 (cbal-tree half)
                               (cbal-tree half))
                        (let ((g (ceiling (/ (1- n) 2))) ;greater
                              (l (truncate (/ (1- n) 2)))) ;less
                        `(,@(comb2 (cbal-tree l)
                                   (cbal-tree g))
                            ,@(comb2 (cbal-tree g)
                                     (cbal-tree l))))))
                  :initial-value () ))))

(defun cbal-tree-p (tree)
  (>= 1 (abs (- (count-leaf (cadr tree))
                (count-leaf (caddr tree))))))

(defun count-leaf (tree)
  (if tree
      (+ 1 (count-leaf (cadr tree)) (count-leaf (caddr tree)))
      0))

(defun comb2 (xs ys)
  (mapcan (lambda (y)
            (mapcar (lambda (x) `(,x ,y)) xs))
          ys))

(defun ppt (tree)
  (mapc #'print tree))

;; ================================================================
;; P56
;; ================================================================
(defun mirror (tree)
  (if (endp tree)
      '()
      (destructuring-bind (root l r)
          tree
        `(,root ,(mirror r) ,(mirror l)))))

(defun skeleton (tree)
  (if (endp tree)
      '()
      (destructuring-bind (root l r)
          tree
        (declare (ignore root))
        `(x ,(skeleton l) ,(skeleton r)))))

(defun symmetric (tree)
  (let ((skel (skeleton tree)))
    (equal skel (mirror skel))))

;; ================================================================
;; P57
;; ================================================================
(defun add-leaf (leaf tree)
  (let ((root (car tree))
        (left (cadr tree))
        (right (caddr tree))
        (node `(,leaf () ())))
    (if (<= leaf root)
        (if (endp left)
            `(,root ,node ,right)
            `(,root ,(add-leaf leaf left) ,right))
        (if (endp right)
            `(,root ,left ,node)
            `(,root ,left ,(add-leaf leaf right))))))

(defun construct (lst)
  (reduce #'(lambda (lst leaf) (add-leaf leaf lst))
          (cdr lst) :initial-value `(,(car lst) () ())))

;; ================================================================
;; P58 (12:16am Wednesday,12 September 2007)
;; ================================================================

#|(defun sym-cbal-tree (n)
  (reduce (lambda (res tr) (if (symmetric tr) `(,tr ,@res) res))
          (cbal-tree n)
          :initial-value () ))|#

;;  5:31pm Sunday,11 May 2008
(defun sym-cbal-tree (n)
  (remove-if (complement #'symmetric) 
             (cbal-tree n)))

;(length (sym-cbal-tree 57))
;256

;; ================================================================
;; P59 ( 6:11pm Thursday,13 September 2007)
;; ================================================================

(defun hbal-tree (h)
  (remove-if-not #'hbal-tree-p (gen-tree-h h)))

#|(defun gen-tree-h (h)
  (cond ((zerop h) '(()))
        ((= h 1)   '((x () ())))
        ((= h 2)   '((x (x () ()) () )
                     (x () (x () ()))
                     (x (x () ()) (x () ()) )))
        ((> h 2)
         (let ((h-1 (gen-tree-h (1- h)))
               (h-2 (gen-tree-h (- h 2))))
           (map 'list (lambda (item) `(x ,@item))
                `(,@(comb2 h-1 h-1)
                  ,@(comb2 h-1 h-2)
                  ,@(comb2 h-2 h-1)))))
        ('T (error "Bad arg to gen-tree-h"))))|#

;;  4:31am Sunday,18 May 2008
(defun gen-tree-h (h)
  (declare ((integer 0 *) h))
  (let ((node '(x () () )))
    (case h
      (0 '(()))
      (1 `(,node))
      (2 `((x ,node () )
           (x () ,node)
           (x ,node ,node )))
      (otherwise
       (let ((h-1 (gen-tree-h (1- h)))
             (h-2 (gen-tree-h (- h 2))))
         (mapcar (lambda (item) `(x ,@item))
                 `(,@(comb2 h-1 h-1)
                     ,@(comb2 h-1 h-2)
                     ,@(comb2 h-2 h-1))))))))

(defun hbal-tree-p (tree)
  (>= 1 (abs (- (tree-height (cadr tree))
                (tree-height (caddr tree))))))

(defun tree-height (tree)
  (if tree
      (1+ (max (tree-height (cadr tree)) 
               (tree-height (caddr tree))))
      0))

;; ================================================================
;; P60 ( 4:39pm Sunday,16 September 2007)
;; ================================================================
#|
    x
  x   x
 x x x
x

これもあり。

minnode = minnode(1- )+ minnode (2-) + 1

|#
#|(defun min-nodes (h)
  (if (< h 3)
      h
      (+ 1 (min-nodes (1- h)) (min-nodes (- h 2)))))

 (defun min-nodes (h)
  (do ((h h (1- h))
       (res 2 (+ 1 res acc))
       (acc 1 res))
      ((< h 3) res)))

 (defun min-nodest (h a1 a2)
  (if (< h 3)
      a1
      (min-nodest (1- h) (+ 1 a1 a2) a1)))|#

(defun max-nodes (h)
  (1- (expt 2 h)))

;; n 1の時に-1になっていたのを修正
(defun max-height (n)
  (if (>= 1 n)
      n
      (do ((i 0 (1+ i)))
          ((> (min-nodes i) n) (1- i)))))

(defun min-height (n)
  (1+ (truncate (log n 2))))

(defun hbal-tree-nodes (n)
  (let ((min-height (min-height n))
        (max-height (max-height n)))
    (do ((h min-height (1+ h))
         res)
        ((> h max-height) res)
      (setq res `(,@(remove-if-not (lambda (x) (= n (count-leaf x)))
                                   (hbal-tree h))
                    ,@res)))))


;; ================================================================
;; P61
;; ================================================================
(defun leafp (tree)
  (and tree
       (car tree)
       (atom (car tree))
       (endp (cadr tree))
       (endp (caddr tree))))

(defun count-leaves (tree)
  (labels ((cpass (tree cont)
             (if (endp tree)
                 (funcall cont 0)
                 (if (leafp tree)
                     (funcall cont 1)
                     (cpass (second tree)
                            #'(lambda (l)
                                (cpass (third tree)
                                       #'(lambda (r)
                                           (funcall cont (+ l r))))))))))
    (cpass tree #'values)))

;; ================================================================
;; P61A
;; ================================================================
(defun leaves (tree)
  (labels ((cpass (tree cont)
             (if (endp tree)
                 (funcall cont '() )
                 (if (leafp tree)
                     (funcall cont `(,(car tree)))
                     (cpass (second tree)
                            #'(lambda (l)
                                (cpass (third tree)
                                       #'(lambda (r)
                                           (funcall cont `(,@l ,@r))))))))))
    (cpass tree #'values)))

;; ================================================================
;; P62
;; ================================================================
(defun internals (tree)
  (labels ((cpass (tree cont)
             (if (endp tree)
                 (funcall cont '() )
                 (if (leafp tree)
                     (funcall cont '() )
                     (cpass (second tree)
                            #'(lambda (l)
                                (cpass (third tree)
                                       #'(lambda (r)
                                           (funcall cont `(,(car tree) ,@l ,@r))))))))))
    (cpass tree #'values)))

;; ================================================================
;; P62B
;; ================================================================
;; (defun atlevel (tree level)
;;   (cond ((endp tree) '() )
;;      ((= 1 level) `(,(car tree)))
;;      ('T
;;       `(,@(atlevel (second tree) (1- level))
;;           ,@(atlevel (third tree) (1- level))))))

(defun atlevel (level tree)
  (labels ((frob (level tree cont)
             (cond ((endp tree) (funcall cont '() ))
                   ((= 1 level) (funcall cont `(,(car tree))))
                   ('T
                    (frob (1- level) 
                          (second tree) 
                          #'(lambda (l)
                              (frob (1- level)
                                    (third tree)
                                    #'(lambda (r)
                                        (funcall cont `(,@l ,@r))))))))))
    (frob level tree #'values)))


;; ================================================================
;; P63 ( 6:29am Wednesday,26 September 2007)
;; ================================================================

(defun complete-binary-tree (n &optional (base 1))
  (if (zerop n)
      ()
      (let ((cn-max-size (max-nodes (1- (cbt-height n))))
            (gcn-max-size (max-nodes (- (cbt-height n) 2)))
            (cn (1- n)))
        (cond ((= cn (* 2 cn-max-size))
               `(,base ,(complete-binary-tree cn-max-size (* 2 base))
                       ,(complete-binary-tree cn-max-size (1+ (* 2 base)))))
              ((> cn cn-max-size)
               `(,base ,(complete-binary-tree cn-max-size (* 2 base))
                       ,(complete-binary-tree (- cn cn-max-size) (1+ (* 2 base)))))
              ((<= cn cn-max-size)
               `(,base ,(complete-binary-tree (- cn gcn-max-size) (* 2 base))
                       ,(complete-binary-tree gcn-max-size (1+ (* 2 base)))))))))

(defun cbt-height (n)
  (if (zerop n) n (1+ (truncate (log n 2)))))

;; ================================================================
;; P64
;; ================================================================
(defun count-leaves-and-nodes (tree)
  (prog (total job tmp)
        (setq total 0)
        (push tree  job)
     l  (cond ((endp job) (return total)))
        (and (setq tmp (pop job))
             (setq total (1+ total))
             (push (caddr tmp) job)     ;right
             (push (cadr tmp)  job))    ;left
        (go l)))

(defun tree->numlist (tree)
  (let ((len (count-leaves-and-nodes tree)))
    (let ((numlist (range 1 len)))
      numlist)))

;; (defun layout-binary-tree (tree &optional (numlist (tree->numlist tree)) (level 1))
;;   (if (endp tree)
;;       '()
;;       (let ((llen (count-leaves-and-nodes (cadr tree))))
;;      `((,(nth llen numlist) . ,level)
;;        ,(if (zerop llen)
;;             '()
;;             (layout-binary-tree (cadr tree) (subseq numlist 0 llen) (1+ level)))
;;        ,(layout-binary-tree (caddr tree) (nthcdr (1+ llen)  numlist) (1+ level))))))

(defun layout-binary-tree (tree)
  (labels ((frob (tree numlist level)
             (if (endp tree)
                 '()
                 (let ((llen (count-leaves-and-nodes (cadr tree))))
                   `((,(nth llen numlist) . ,level) ;root
                     ,(if (zerop llen)              ;left
                          '()
                          (frob (cadr tree) (subseq numlist 0 llen) (1+ level)))
                     ,(frob (caddr tree) (nthcdr (1+ llen)  numlist) (1+ level))))))) ;right
    (frob tree (tree->numlist tree) 1)))

;; ================================================================
;; P65
;; ================================================================
(defun tree-depth (tree)
  (if tree
      (labels ((frob (tree level)
                 (let ((left (cadr tree))
                       (right (caddr tree)))
                   (if (and (null left) (null right))
                     level
                     (max (frob left (1+ level))
                          (frob right (1+ level)))))))
        (frob tree 0))
      0))

(defun depth-of-most-left-node (tree)
  (if tree
      (labels ((frob (tree level)
                 (let ((left (cadr tree)))
                   (if left
                       (frob left (1+ level))
                       level))))
        (frob tree 0))
      0))

(defun layout-binary-tree-2 (tree)
  (let ((depth (tree-depth tree)))
    (labels ((frob (tree pos depth level)
               (let ((left (cadr tree))
                     (right (caddr tree)))
                 (cond ((endp tree) '() )
                       ('T
                        (let ((offset (expt 2 (1- depth))))
                          `((,pos . ,level)
                            ,(frob left  (- pos offset) (1- depth) (1+ level))
                            ,(frob right (+ pos offset) (1- depth) (1+ level)))))))))
      (frob tree 
            (1+ (- (expt 2 (tree-depth tree))
                   (expt 2 (- (tree-depth tree) (depth-of-most-left-node tree)))))
            depth 1))))

;test
;(defparameter *tree* '(n 
;                      (k (c (a () ()) (e (d () ()) (g  () ()))) (m () ()))
;                      (u (p () (q () ())) ())))

;; ================================================================
;; P66****************************************************************
;; ================================================================

;(layout-binary-tree-2 *tree*)




;; ================================================================
;; P67
;; ================================================================
(defun find-region (str)
  (if (find #\( str)
      (let ((count 0)
            (len (length str)))
        (do ((i 0 (1+ i))
             (retlst '()))
            ((= i len) (let ((reg (nreverse retlst)))
                         (values (car reg) (cadr reg))))
          (let ((part (subseq str i (1+ i))))
            (cond 
              ((and (string= "(" part) (zerop count)) (push i retlst) (incf count))
              ((and (string= ")" part) (= 1 count))   (push i retlst) (decf count))
              ((string= "(" part) (incf count))
              ((string= ")" part) (decf count))
              ('t nil)))))
      (values 0 0)))

(defun remove-parent (str)
  (multiple-value-bind (start end)
      (find-region str)
    (if (zerop end)
        str
        (subseq str (1+ start) end))))

(defun get-children (str)
  (if (string= "" str)
      ""
      (let ((strip (remove-parent str)))
        (cond ((not (find #\, strip))
               (values strip ""))
              ((zerop (position #\, strip))
               (values "" (subseq strip 1)))
              ('t 
               (if (find #\( strip)
                   (multiple-value-bind (start end)
                       (find-region strip)
                     (declare (ignore start))
                     (values 
                      (subseq strip 0 (1+ end))
                      (subseq strip (+ 2 end))))
                   (values
                    (subseq strip 0 (position #\, strip))
                    (subseq strip (1+ (position #\, strip))))))))))

(defun string->tree (str)
  (if (string= "" str)
      '()
      (let ((node (read-from-string str)))
        (multiple-value-bind (l r)
            (get-children str)
          (if (find #\, str)
              `(,node
                ,(string->tree l)
                ,(string->tree r))
              `(,node () ()))))))

(defun tree->string (tree)
  (labels ((frob (tree)
             (if tree
                 (if (leafp tree)
                     `(,(string (car tree)))
                     `(,(string (car tree)) 
                        "("
                        ,@(frob (cadr tree))
                        ","
                        ,@(frob (caddr tree))
                        ")"))
                 '() )))
    (map 'string #'(lambda (x) (char x 0))
         (frob tree))))

(defun tree<=>string (tree-or-string)
  (if (stringp tree-or-string)
      (string->tree tree-or-string)
      (tree->string tree-or-string)))

;; ================================================================
;; P68
;; ================================================================
;(load "./string-join")

(defun preorder (tree)
  (labels ((frob (tree)
             (if tree
                 `(,(string (car tree)) ,@(frob (cadr tree)) ,@(frob (caddr tree)))
                 '(""))))
    (string-join (frob tree))))

(defun inorder (tree)
  (labels ((frob (tree)
             (if tree
                 `(,@(frob (cadr tree)) ,(string (car tree)) ,@(frob (caddr tree)))
                 '(""))))
    (string-join (frob tree))))

(defun snull (str)
  (if (and (stringp str) (string= str ""))
      ""
      nil))

(defun disassemble-tree-string (pre in)
  (if (or (snull pre) (snull in))
      ""
      (let* ((root (char pre 0))
             (left-in   (subseq in  0 (position root in)))
             (left-pre  (subseq pre 1 (1+ (length left-in))))
             (right-in  (subseq in  (1+ (position root in))))
             (right-pre (subseq pre (1+ (length left-in)))))
        (values (string root) left-in left-pre right-in right-pre))))

(defun pre+in->tree (pre in)
  (if (or (snull pre) (snull in))
      '()
      (multiple-value-bind (root left-in left-pre right-in right-pre) (disassemble-tree-string pre in)
        `(,(read-from-string root)
           ,(pre+in->tree left-pre left-in)
           ,(pre+in->tree right-pre right-in)))))

#|
(defvar *tree* '(a (b (d () ()) (e () ())) (c () (f (g () ()) ()))))
(defparameter *t* '(a (b (c (d () ()) (e () ())) (f (g () ()) ())) (h (i () ()) ())))
(pre+in->tree "ABDECFG" "DBEACGF")
(pre+in->tree "a" "a")
(pre+in->tree "abc" "bac")
(pre+in->tree "a" "a")
(disassemble-tree-string "a" "a")
|#

;; ================================================================
;; P69
;; ================================================================
(defun tree<=>dotstring (list-or-string)
  (if (stringp list-or-string)
      (dotstring->tree list-or-string)
      (tree->dotstring list-or-string)))

(defun tree->dotstring (tree)
  (labels ((frob (tree)
             (if tree
                 `(,(string (car tree)) ,@(frob (cadr tree)) ,@(frob (caddr tree)))
                 '("."))))
    (string-join (frob tree))))

(defun string-join (strs &optional (delim ""))
  (if strs
      (reduce #'(lambda (retstr s) (concatenate 'string retstr delim s))
              strs)
      ""))

(defun dotstring->tree (str)
  (if (string= "" str)
      '()
      (let ((root (subseq str 0 1)))
        (if (string= root ".")
            '()
            (multiple-value-bind (l r) (tree-string>get-children str)
              `(,(read-from-string (subseq str 0 1))
                 ,(dotstring->tree l)
                 ,(dotstring->tree r)))))))

(defun tree-string>get-boundary (str)
  (let ((point 1))
    (dotimes (i (1- (length str)))
      (if (string/= "." (subseq str i (1+ i)))
          (setq point (+ 1 point))
          (setq point (- point 1)))
      (if (zerop point)
          (return i)))))

(defun tree-string>get-children (str)
  (let ((rootless (subseq str 1)))
    (values 
     (subseq rootless 0 (1+ (tree-string>get-boundary rootless)))  
     (subseq rootless (1+ (tree-string>get-boundary rootless)))))) 

;(equal
; (mirror (dotstring->tree (tree->dotstring (mirror (dotstring->tree "ABD..E..C.FG...")))))
; *tree*)
    

;; ================================================================
;; P70B
;; ================================================================
(defun is-multiway-tree (obj)
  (and (not (listp (car obj)))
       (dolist (o (cdr obj) t)
         (or (and (listp o)
                  (is-multiway-tree o))
             (return-from is-multiway-tree nil)))))

;; ================================================================
;; P70C
;; ================================================================
(defun nnodes (tree)
  (and (is-multiway-tree tree)
       (let ((rest-tree (cdr tree)))
         (apply #'+ 1
                (if (null rest-tree)
                    '(0)
                    (mapcar #'nnodes rest-tree))))))

;; ================================================================
;; P70
;; ================================================================
(defun node-string->tree (string)
  (values 
   (handler-case 
       (read-from-string
        (coerce 
         (let ((retlst '()))
           (mapc #'(lambda (c)
                     (setq retlst (if (char= #\^ c)
                                      `(,@retlst #\))
                                      `(,@retlst #\( ,c))))
                 (coerce string 'list))
           retlst)
         'string))
     (end-of-file nil nil))))

;(node-string->tree "afg^^c^bd^e^^")
;(node-string->tree "abc^d^^^")

;; ================================================================
;; P71 -- 4:03am Thursday,12 April 2007
;; ================================================================
(defun internal-path-length (tree)
  (labels ((ipl (tree depth)
             (cond ((> 2 (length tree)) 0)
                   ('T (apply #'+ 
                              (1- (length tree)) 
                              (mapcar #'(lambda (l)
                                          (+ depth (ipl l (1+ depth))))
                                      (cdr tree)))))))
    (ipl tree 0)))
;(internal-path-length '(a (f (g)) (c) (b (d) (e))))

;; ================================================================
;; P72
;; ================================================================
(defun bottom-up (lst)
  (if lst
      (do ((l lst (cdr l))
           (retlst '() (cons (car l) retlst)))
          ((null (cdr l)) `(,(car l) ,(nreverse retlst))))))

;; ================================================================
;; P73
;; ================================================================
(defun multiway-tree->lispy-token-list (tree)
  (cond ((atom tree) tree)
        ((= 1 (length tree)) (car tree))
        ('T `(,(multiway-tree->lispy-token-list (car tree))
              ,@(mapcar #'multiway-tree->lispy-token-list
                        (cdr tree))))))

;(multiway-tree->lispy-token-list '(a (f (g)) (c) (b (d) (e))))
;'(A (F G) C (B D E))

(defun lispy-token-list->multiway-tree (tree)
  (labels ((frob (tree depth)
             (cond ((and (zerop depth) (atom tree)) `(,tree))
                   ((atom tree) tree)
                   ('T `(,(frob (car tree) (1+ depth))
                          ,@(mapcar #'(lambda (n) 
                                        (if (atom n) 
                                            `(,n) 
                                            (frob n (1+ depth))))
                                    (cdr tree)))))))
    (frob tree 0)))

; (74 75 76 77 78 79)
;; ================================================================
;; P80
;; ================================================================

; (load ./flatten)
(defun graph-term->edge-clause (expr)
  (cadr expr))

(defun edge-clause->graph-term (expr)
  `(,(sort (delete-duplicates
         (reduce #'(lambda (ret item) `(,(car item) ,(cadr item) ,@ret))
                 expr :initial-value '() ))
        #'(lambda(a b)
            (string< (string a) (string b))))
     ,expr))

(defun graph-term->adjacency-list (expr)
  `(,@(mapcar #'(lambda (item)
                  `(,item 
                    ,(delete nil
                             (delete-duplicates 
                              (flatten 
                               (mapcar #'(lambda (lst)
                                           (delete item
                                                   (if (member item lst)
                                                       lst
                                                       nil)))
                                       (cadr expr)))))))
              (car expr))))

(defun adjacency-list->graph-term (expr)
  `(,(mapcar #'car expr)
     ,(sort
       (delete-duplicates
        (reduce #'(lambda (retlst i)            
                    `(,@retlst ,@(mapcar #'(lambda (j)
                                             (sort `(,(car i) ,j)
                                                   #'(lambda(a b)
                                                       (string< (string a) (string b)))))
                                         (cadr i))))
                expr :initial-value '() ) 
        :test #'equal) 
       #'(lambda(a b) (string< (string (car a)) (string (car b)))))))

(defun graph-term->human-friendly (expr)
  (sort `(,@(mapcar #'(lambda (item)
                        (concatenate 'string (string (car item)) "-" (string (cadr item))))
                    (cadr expr))
            ,@(mapcar #'string
                      (set-difference (car expr) (flatten (cadr expr)))))
        #'string<))

(defun human-friendly->graph-term (expr)
  (flet ((string-split/- (strlst)
           (mapcar #'(lambda (item)
                       (let ((pos (position #\- (coerce item 'list))))
                         (if pos
                             `(,(subseq item 0 pos)
                                ,(subseq item (1+ pos)))
                             item)))
                   strlst)))
    (let ((item-list (mapcar #'(lambda (item)
                                 (if (listp item)
                                     `(,(read-from-string (car item)) 
                                        ,(read-from-string (cadr item)))
                                     (read-from-string item)))
                             (string-split/- expr))))
      `(,(delete-duplicates (flatten item-list)) ,(delete-if-not #'listp item-list)))))

;; -----------------------------------------------------------------------------
;; DIRECTED
;; graph-term <=> arc-clause
(defun graph-term->arc-clause/directed (expr)
  (cadr expr))

(defun arc-clause->graph-term/directed (expr)
  `(,(sort
      (delete-duplicates
       (reduce #'xappend
               expr :initial-value '() ))
      #'(lambda(a b) (string< (string a) (string b))))
    ,expr))

(defun xappend (lst1 lst2)
  (append lst2 lst1))

;; -----------------------------------------------------------------------------
;; adjacency-list <=> graph-term
(defun adjacency-list->graph-term/directed (expr)
  `(,(mapcar #'car expr)
    ,(reduce #'(lambda (retlst item)
                 (if item
                     `(,@retlst ,@(mapcar #'(lambda (i) `(,(car item) ,i)) 
                                          (cadr item)))
                   retlst))
             expr :initial-value '() )))

(defun graph-term->adjacency-list/directed (expr)
  (mapcar #'(lambda (item) `(,item ,(get-direction item (cadr expr))))
          (car expr)))

(defun get-direction (from dist-lst)
  (reduce #'(lambda (retlst item)
              (if (eql from (car item))
                  `(,@retlst ,(cadr item))
                retlst))
          dist-lst :initial-value '() ))

;; -----------------------------------------------------------------------------
;; directed-graph-term <=> human-friendly
(defun graph-term->human-friendly/directed (expr)
  (sort `(,@(mapcar #'(lambda (item) 
                        (format nil "~A>~A" (car item) (cadr item)))
                    (cadr expr))
          ,@(mapcar #'string
                    (set-difference (car expr) (flatten (cadr expr)))))
        #'string<))

(defun human-friendly->graph-term/directed (expr)
  (flet ((splitter (strlst)
           (mapcar #'(lambda (item)
                       (let ((pos (position #\> (coerce item 'list))))
                         (if pos
                             `(,(subseq item 0 pos)
                               ,(subseq item (1+ pos)))
                           item)))
                   strlst)))
    (let ((item-list (mapcar #'(lambda (item)
                                 (if (listp item)
                                     (mapcar #'read-from-string item)
                                   (read-from-string item)))
                             (splitter expr))))
      `(,(delete-duplicates (flatten item-list)) 
        ,(delete-if-not #'listp item-list)))))

;; -----------------------------------------------------------------------------
;; LABELLED
;; graph-term <=>arc-clause
(defun graph-term->arc-clause/labelled (expr)
  (cadr expr))

(defun arc-clause->graph-term/labelled (expr)
  `(,(sort 
      (delete-duplicates
       (reduce #'(lambda (ret item) `(,@(butlast item) ,@ret))
               expr :initial-value '() ))
      #'(lambda(a b) (string< (string a) (string b))))
    ,expr))

;; -----------------------------------------------------------------------------
;; adjacency-list <=> graph-term/labelled
(defun adjacency-list->graph-term/labelled (expr)
  `(,(mapcar #'car expr)
    ,(reduce #'(lambda (retlst item)
                 `(,@retlst ,@(reduce #'(lambda (ret num)
                                          (if num
                                              `(,@ret (,(car item) ,@num))
                                            ret))
                                      (cadr item) :initial-value '() )))
             expr :initial-value '() )))

(defun graph-term->adjacency-list/labelled (expr)
  (mapcar #'(lambda (item)
              `(,item ,(get-direction/labelled item (cadr expr))))
          (car expr)))
                       
(defun get-direction/labelled (from dist-lst)
  (reduce #'(lambda (retlst item)
              (if (eql from (car item))
                  `(,@retlst (,(cadr item) ,(caddr item)))
                retlst))
          dist-lst :initial-value '() ))

;; -----------------------------------------------------------------------------
;; graph-term <=> human-friendly
(defun graph-term->human-friendly/labelled (expr)
  (sort `(,@(mapcar #'(lambda (item) (format nil "~{~A>~A/~A~}" item))
                    (cadr expr))
          ,@(mapcar #'string
                    (set-difference (car expr) (flatten (cadr expr)))))
        #'string<))

(defun human-friendly->graph-term/labelled (expr)
  (labels ((splitter (strlst)
             (mapcar #'(lambda (item)
                         (let ((>pos (position #\> (coerce item 'list)))
                               (/pos (position #\/ (coerce item 'list))))
                           (if >pos 
                               `(,(subseq item 0 >pos)
                                 ,(subseq item (1+ >pos) /pos)
                                 ,(subseq item (1+ /pos)))
                             item)))
                     strlst)))
    (let ((item-list (mapcar #'(lambda (item)
                                 (if (listp item)
                                     (mapcar #'read-from-string item)
                                   (read-from-string item)))
                             (splitter expr))))
      `(,(delete-duplicates 
          (reduce #'(lambda (retlst item)
                      `(,@retlst ,@(if (listp item) (butlast item) `(,item))))
                  item-list :initial-value '() )) 
        ,(delete-if-not #'listp item-list)))))

;; ================================================================
;; P81
;; ================================================================

;; ================================================================
;; P82
;; ================================================================

;; ================================================================
;; P83
;; ================================================================

;; ================================================================
;; P84
;; ================================================================

;; ================================================================
;; P85
;; ================================================================

;; ================================================================
;; P86
;; ================================================================

;; ================================================================
;; P87
;; ================================================================

;; ================================================================
;; P88
;; ================================================================

;; ================================================================
;; P89
;; ================================================================

;; ================================================================
;; P90
;; ================================================================

;; ================================================================
;; P91
;; ================================================================

;; ================================================================
;; P92
;; ================================================================

;; ================================================================
;; P93
;; ================================================================

;; ================================================================
;; P94
;; ================================================================

;; ================================================================
;; P95
;; ================================================================
(defun full-words (n)
  (let ((nstr (format nil "~a" n))
        (retstr ""))
    (mapc #'(lambda(x)
              (setq retstr
                    (concatenate 'string
                                 retstr
                                 "-"
                                 (case x
                                   (#\0 "zero")
                                   (#\1 "one")
                                   (#\2 "two")
                                   (#\3 "three")
                                   (#\4 "four")
                                   (#\5 "five")
                                   (#\6 "six")
                                   (#\7 "seven")
                                   (#\8 "eight")
                                   (#\9 "nine")))))
          (coerce nstr 'list))
    (string-trim "-" retstr)))

;; ================================================================
;; P96
;; ================================================================

;; ================================================================
;; P97
;; ================================================================

;; ================================================================
;; P98
;; ================================================================

;; ================================================================
;; P99
;; ================================================================

