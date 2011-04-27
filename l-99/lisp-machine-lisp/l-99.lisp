;-*-Fonts:CPTFONT,CPTFONTB;  Mode:LISP; Package:USER; Base:10.-*-

;(defun endp (obj)
;  (if (listp obj)
;      (null obj)
;    (if (null obj)
;	t
;      (ferror nil "The value ~S is not of type LIST." obj))))

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
      `(x ,(skeleton l) ,(skeleton r)))))

(defun symmetric (tree)
  (let ((skel (skeleton tree)))
    (equal skel (mirror skel))))

;(symmetric '(A (B (D NIL NIL) (E NIL NIL)) (C NIL (F (G NIL NIL) NIL))))

;(symmetric '(z (A (B (D NIL NIL) (E NIL NIL)) (C NIL (F (G NIL NIL) NIL)))
;	  (A (C (F NIL (G NIL NIL)) NIL) (B (E NIL NIL) (D NIL NIL)))))

;(skeleton '(a (b nil nil) nil))

;(endp 'a)

;(destructuring-bind (a b)
		    '(foo bar)
;  b)

;(null (comment foo bar baz))

;(null (values))

;(listp (values))
;(atom (values))
;(comment foo bar baz)
;(atom 'comment)
;(eq 'comment (comment))

(defun isnode (node)
  (or (null node) (istree node))))

(defun istree (obj)
  (and (listp obj)
       (= 3 (length obj))
       (equal '(nil t t) (mapcar #'isnode obj))))


(defun node (node &rest cnode)
  (if (endp cnode)
      `(,node nil nil)
      `(,node  ,@cnode)))


;; P57
;(defun construct (lst)
;  (let ((retlst (node (car lst)))
;	(prev (car lst)))
;    (dolist (n (cdr lst))
;      (let ((d (if (<= n prev) 0 1)))
;	(setq retlst (add-node n retlst d))))
;    retlst))


;(defun construct (lst)
;  (do ((l (cdr lst) (cdr l))
;       (retlst (node (car lst)))
;       (prev (car lst) (car l)))
;      ((endp l) retlst)
;    (let ((n (car l)))
;      (setq retlst 
;	    (add-node n retlst (if (<= n prev) 0 1))))))

;; 4/15/79 17:45:29
;(defun construct (lst)
;  (do ((l (cdr lst) (cdr l))
;       (retlst (node (car lst)))
;       (prev (car lst) (car l)))
;      ((endp l) retlst)
;    (setq retlst 
;	  (let ((cur (car l)))
;	    (if (<= cur prev)
;		(cons-tree cur retlst)
;	      (cons-tree-right cur retlst))))))
	    
;(add-node (car l) retlst))

;( 2 1)

;(construct '(1 2 3))


;(construct '(3 2 5 7 1))

;; utils

;(defun add-left (leaf tree)
;  (let ((root (get-root tree))
;	(left (get-left tree))
;	(right (get-right tree)))
;    (if (null left)
;	`(,root ,leaf ,right)
;      `(,root ,(add-left leaf (get-left tree)) ,right))))

;(defun test ()
;(add-left '(c nil nil)
;(add-left '(c nil nil) 
;(add-left '(b nil nil) '(a nil nil)))))

;(defun add-right (leaf tree)
;  (let ((root (get-root tree))
;	(left (get-left tree))
;	(right (get-right tree)))
;    (if (null right)
;	`(,root ,left ,leaf)
;      `(,root ,left ,(add-right leaf (get-right tree))))))

;(add-left '(z ()())
;(add-right '(c () ())
;(add-right '(a () ()) '(b () ()))))

;(add-left '(c nil nil) 
;(add-left '(b nil nil) '(a nil nil))))

;; P57

;(defun node (leaf)
;  `(,leaf () ()))

;(defun 1get-left0 (tree)
;  (cadr tree))

;(defun 1get-right0 (tree)
;  (caddr tree))

;(defun 1get-root0 (tree)
;  (car tree))

;(defun 1add-leaf0 (leaf tree)			
;  (if (<= leaf (get-root tree))
;      (if (null (get-left tree))
;	  `(,(car tree) (,leaf () ()) ,(get-right tree))
;	`(,(car tree) ,(add-leaf leaf (get-left tree)) ,(get-right tree)))
;    (if (null (get-right tree))
;	`(,(car tree) ,(get-left tree) (,leaf () ()))
;	`(,(car tree) ,(get-left tree) ,(add-leaf leaf (get-right tree))))))

;1refact

0;; ================================================================
;; P57
;; ================================================================
(defun add-leaf (leaf tree)
  (let ((root (car tree))
	(left (cadr tree))
	(right (caddr tree))
	(node `(,leaf () ())))
    (if (<= leaf root)
	(if (null left)
	    `(,root ,node ,right)
	  `(,root ,(add-leaf leaf left) ,right))
      (if (null right)
	  `(,root ,left ,node)
	`(,root ,left ,(add-leaf leaf right))))))

(defun construct (lst)
  (and lst
       (do ((l (cdr lst) (cdr l))
	    (retlst `(,(car lst) () ())
		    (add-leaf (car l) retlst)))
	   ((null l) retlst))))

;1; test0      
(comment
  (print
    (construct '(8 3 10 1 6 14 4 7 13)))

  (construct '(1))
  (construct '())
)

;(setq foo '
;(add-leaf 7.
;(add-leaf 4.
;(add-leaf 13.
;(add-leaf 14.
;(add-leaf 6.
;(add-leaf 1.
;(add-leaf 10.
;(add-leaf 3.
;	'(8. () ()))))))))))

;; ================================================================
;; P61
;; ================================================================

(defun count-leaves (tree)
  (if (null tree)
      0
    (+ 1
       (count-leaves (second tree))
       (count-leaves (third tree)))))

(comment
  (count-leaves
    (construct '(3 2 8 1 7 5 9 1 0)))

)

(defvar *tree* '(A (B (D () ()) (E () ())) (C () (F (G () ()) ()))))


;;================================================================

(defun leafp (tree)
  (and tree
       (car tree)
       (atom (car tree))
       (null (cadr tree))
       (null (caddr tree))))

(defun count-leaves (tree)
  (if (null tree)
      0
    (if (leafp tree)
	1
      (+ (count-leaves (second tree))
	 (count-leaves (third tree))))))

(count-leaves *tree*)

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
;;================================================================

*tree*

(defun leaves (tree)
  (if (null tree)
      '()
    (if (leafp tree)
	`(,(car tree))
      `(,@(leaves (cadr tree))
	,@(leaves (caddr tree))))))

(comment ;;================
  (print 
  (leaves *tree*))

(defun leaves (tree)
  (leaves1 tree #'values))


(defun leaves1 (tree cont)
  (if (null tree)
      (funcall cont '())
    (leaves1 (cadr tree) 
	     (closure '(m)
		      #'(lambda (m)
			  (leaves1 (caddr tree) 
				   (closure '(n)
					    #'(lambda (n)
						(funcall cont `(,(car tree) ,@m ,@n))))))))))

(leaves1 '(a ()()) #'values)

(funcall #'cons 'a '(foo))
(lexpr-funcall #'cons 'a '(b c))

(+ 3 3)
((lambda (n) (+ 3 n))
 3)

(funcall (closure '(n)
		  (+ 3 n))
	 3)

;;================
)

(defun fact (n)
  (if (zerop n)
      1
    (* n (fact (1- n)))))

(fact 10.)

;; ================================================================
;; P62
;; ================================================================
(defun internals (tree)
  (if (null tree)
      '()
    (if leafp tree)
	'()
      `(,(car tree)
	,@(internals (cadr tree))
	,@(internals (caddr tree))))))

(internals *tree*)

;; ================================================================
;; P62B
;; ================================================================
(defun atlevel (level tree)
  (cond ((null tree) '() )
	((= 1 level) `(,(car tree)))
	('T
	 `(,@(atlevel (1- level) (second tree))
	   ,@(atlevel (1- level) (third tree))))))

(atlevel 4 *tree*)


;; ================================================================
;; P64
;; ======n==========================================================
(defun range (start end)
  (do ((i start (1+ i))
       (retlst '()))
      ((> i end) (nreverse retlst))
    (push i retlst)))

(defun count-leaves-and-nods (tree)
  (if tree
      (+ 1
	 (count-leaves-and-nodes (second tree))
	 (count-leaves-and-nodes (third tree)))
    0))

(defun tree->numlist (tree)
  (let ((len (count-leaves-and-nodes tree)))
    (let ((numlist (range 1 len)))
      numlist)))

(defun layout-binary-tree (tree &optional (numlist (tree->numlist tree)) (level 1))
  (if (null tree)
      '()
    (let ((llen (count-leaves-and-nodes (cadr tree))))
      `((,(nth llen numlist) . ,level)		;root
	,(if (zerop llen)			;left
	     '()
	   (layout-binary-tree (cadr tree)
			       (subseq numlist 0 llen)
			       (1+ level)))
	,(layout-binary-tree (caddr tree)	;right
			     (nthcdr (1+ llen)  numlist)
			     (1+ level))))))


(defun subseq (lst start end)
  (let ((len (length lst)))
    (cond ((or (minusp start) (minusp end))
	   (ferror nil "The value is out of range for ~S")
	  ((> end len) 
	   (ferror nil "The bounding indeces ~S and ~S are bad for sequence of length ~S" 
		   start end len))
	  ('T
	   (if lst
	       (do ((l (nthcdr start lst) (cdr l))
		    (c (- end start) (1- c))
		    (retlst '() ))
		   ((zerop c) (nreverse retlst))
		 (setq retlst (cons (car l) retlst))))))))
 

(print (subseq '(foo bar baz quux thud) 0 7))

(and (minusp 1) 1
     (minusp -2) -2)

(minusp 0 )
(nthcdr 1 '(foo bar baz))

(defvar *tree* '(n (k (c (a () ()) (h () (g () (e () ())))) (m () ())) (u (p () (s (q () ()) ())) ())))

(tree->numlist *tree*)
(count-leaves-and-nodes *tree*)

(equal (layout-binary-tree *tree*)
       '((8 . 1) ((6 . 2) ((2 . 3) ((1 . 4) () ()) ((3 . 4) () ((4 . 5) () ((5 . 6) () ())))) ((7 . 3) () ())) ((12 . 2) ((9 . 3) () ((11 . 4) ((10 . 5) () ()) ())) ())))

(defun range (start end)
  (do ((i start (1+ i))
       (retlst '()))
      ((> i end) (nreverse retlst))
    (push i retlst)))

(print (range 1 10))

;; P72

(defun bottom-up (lst)
  (if lst
      (do ((l lst (cdr l))
	   (retlst '() (cons (car l) retlst)))
	  ((null (cdr l)) `(,(car l) ,(nreverse retlst))))))

(bottom-up '(a b c d e f g h i))
(bottom-up '())

(defun bottom-up (lst)
  `(,@(last lst) ,@(mapcar #'list (butlast lst)) ))





(bottom-up '(a b c d e f g))

;; P65
(defun tree-depth (tree)
  (if tree
      (tree-depth-aux tree 0)
    0))

(tree-depth *tree*)

(defun tree-depth-aux (tree level)
  (let ((left (cadr tree))
	(right (caddr tree)))
    (if (and (null left) (null right))
	level
      (max (tree-depth-aux left (1+ level))
	   (tree-depth-aux right (1+ level))))))

(defun depth-of-most-left-node (tree)
  (if tree
      (depth-of-most-left-node-aux tree 0)
      0))

(defun depth-of-most-left-node-aux (tree level)
  (let ((left (cadr tree)))
    (if left
	(depth-of-most-left-node-aux left (1+ level))
      level)))

(defun layout-binary-tree-2 (tree)
  (let ((depth (tree-depth tree)))
    (layout-binary-tree-2-aux 
      tree 
      (1+ (- (expt 2 (tree-depth tree))
	     (expt 2 (- (tree-depth tree) (depth-of-most-left-node tree)))))
      depth 1)))

(defun layout-binary-tree-2-aux (tree pos depth level)
  (let ((left (cadr tree))
	(right (caddr tree)))
    (cond ((null tree) '() )
	  ('T
	   (let ((offset (expt 2 (1- depth))))
	     `((,pos . ,level)
	       ,(layout-binary-tree-2-aux left  (- pos offset) (1- depth) (1+ level))
	       ,(layout-binary-tree-2-aux right (+ pos offset) (1- depth) (1+ level))))))))



;test
(comment
  (defvar *tree* '(n 
			  (k (c (a () ()) (e (d () ()) (g  () ()))) (m () ()))
			  (u (p () (q () ())) ())))


(print *tree*)
(print
  (layout-binary-tree-2 *tree*))
)

;; ================================================================
;; P67
;; ================================================================

(defun subseq (lst start end)
  (let ((len (length lst)))
    (cond ((or (minusp start) (minusp end))
	   (ferror nil "The value is out of range for ~S")
	  ((> end len) 
	   (ferror nil "The bounding indeces ~S and ~S are bad for sequence of length ~S" 
		   start end len))
	  ('T
	   (if lst
	       (do ((l (nthcdr start lst) (cdr l))
		    (c (- end start) (1- c))
		    (retlst '() ))
		   ((zerop c) (nreverse retlst))
		 (setq retlst (cons (car l) retlst)))))))))


(defun leafp (tree)
  (and tree
       (car tree)
       (atom (car tree))
       (null (cadr tree))
       (null (caddr tree))))

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
      (values 0 0))))


(find)

;;; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


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

;; (defun get-root (str)
;;   (subseq str 0 (find-region str)))

;; (defun get-left (str)
;;   (if (string= "" str)
;;       ""
;;       (let ((strip (remove-parent str)))
;; 	(if (not (find #\, strip))
;; 	    strip
;; 	    (if (zerop (position #\, strip))
;; 		""
;; 		(if (find #\( strip)
;; 		    (multiple-value-bind (start end)
;; 			(find-region strip)
;; 		      (declare (ignore start))
;; 		      (subseq strip 0 (1+ end)))
;; 		    (subseq strip 0 (position #\, strip))))))))

;; (defun get-right (str)
;;   (if (string= "" str)
;;       ""
;;       (let ((strip (remove-parent str)))
;; 	(if (zerop (position #\, strip))
;; 	    (subseq strip 1)
;; 	    (if (find #\( strip)
;; 		(multiple-value-bind (start end)
;; 		    (find-region strip)
;; 		  (declare (ignore start))
;; 		  (subseq strip (+ 2 end)))
;; 		(subseq strip (1+ (position #\, strip))))))))

;; (defun string->tree (str)
;;   (if (string= "" str)
;;       '()
;;       (let ((node (read-from-string str)))
;; 	(if (find #\, str)
;; 	    `(,node
;; 	      ,(string->tree (get-left str))
;; 	      ,(string->tree (get-right str)))
;; 	    `(,node () ())))))

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

(defun tree<->string (tree-or-string)
  (if (stringp tree-or-string)
      (string->tree tree-or-string)
      (tree->string tree-or-string)))

;; ================================================================
;; P67
;; ================================================================
(defun find-region (str)
  (if (string-search-char #/( str)
      (let ((count 0)
	    (len (string-length str)))
	(do ((i 0 (1+ i))
	     (retlst '()))
	    ((= i len) (let ((reg (nreverse retlst)))
			 (values (car reg) (cadr reg))))
	  (let ((part (substring str i (1+ i))))
	    (cond 
	      ((and (string-equal "(" part) (zerop count)) (push i retlst) (incf count))
	      ((and (string-equal ")" part) (= 1 count))   (push i retlst) (decf count))
	      ((string-equal "(" part) (incf count))
	      ((string-equal ")" part) (decf count))
	      ('t nil)))))
    (values 0 0))))

(defun remove-parent (str)
  (multiple-value-bind (start end)
      (find-region str)
    (if (zerop end)
	str
      (substring str (1+ start) end))))

(defun get-children (str)
  (if (string-equal "" str)
      ""
    (let ((strip (remove-parent str)))
      (cond ((not (string-search-char #/, strip))
	     (values strip ""))
	    ((zerop (string-search-char #/, strip))
	     (values "" (substring strip 1)))
	    ('t 
	     (if (string-search-char #/( strip)
		 (multiple-value-bind (start end)
		     (find-region strip)
		   (values 
		     (substring strip 0 (1+ end))
		     (substring strip (+ 2 end))))
	       (values
		 (substring strip 0 (string-search-char #/, strip))
		 (substring strip (1+ (string-search-char #/, strip)))))))))))

;(get-children "a(b(,c),foo(,))")



(defun string->tree (str)
  (if (string-equal "" str)
      '()
    (let ((node (read-from-string str)))
      (multiple-value-bind (l r)
	  (get-children str)
	(if (string-search-char #/, str)
	    `(,node
	      ,(string->tree l)
	      ,(string->tree r))
	  `(,node () ()))))))

(defun tree->string-aux (tree)
  (if tree
      (if (leafp tree)
	  `(,(string (car tree)))
	`(,(string (car tree)) 
	  "("
	  ,@(tree->string-aux (cadr tree))
	  ","
	  ,@(tree->string-aux (caddr tree))
	  ")"))
    '() ))

(defun tree->string (tree)
  (let ((retstr ""))
    (mapc #'(lambda (str) 
	      (setq retstr (string-append retstr str)))
	  (tree->string-aux tree))
    retstr))

(defun tree<->string (tree-or-string)
  (if (stringp tree-or-string)
      (string->tree tree-or-string)
      (tree->string tree-or-string)))

(comment
(print 
  (tree<->string
    (tree<->string "a(b(d,e),c(,f(g,)))"))) 
) ;end comment

;; ================================================================
;; P69
;; ================================================================
(defun tree<=>dotstring (list-or-string)
  (if (stringp list-or-string)
      (dotstring->tree list-or-string)
    (tree->dotstring list-or-string)))

(defun tree->dotstring (tree)
  (string-join (tree->dotstring-aux tree)))

(defun tree->dotstring-aux (tree)
  (if tree
      `(,(string (car tree)) 
	,@(tree->dotstring-aux (cadr tree))
	,@(tree->dotstring-aux (caddr tree)))
    '(".")))

;(tree->dotstring *tree*)

(defun string-join (strs &optional (delim ""))
  (if strs
      (let ((retstr (car strs)))
	(do ((s (cdr strs) (cdr s))
	     (retstr retstr (string-append retstr delim (car s))))
	    ((null s) retstr)))
    ""))

(defun dotstring->tree (str)
  (if (string-equal "" str)
      '()
    (let ((root (substring str 0 1)))
      (if (string-equal root ".")
	  '()
	(multiple-value-bind (l r) (tree-string>get-children str)
	  `(,(read-from-string root)
	    ,(dotstring->tree l)
	    ,(dotstring->tree r)))))))

(defun tree-string>get-boundary (str)
  (let ((point 1))
    (dotimes (i (1- (string-length str)))
      (if (not (string-equal "." (substring str i (1+ i))))
	  (setq point (+ 1 point))
	(setq point (- point 1)))
      (if (zerop point)
	  (return i)))))

(defun tree-string>get-children (str)
  (let ((rootless (substring str 1)))
    (values 
      (substring rootless 0 (1+ (tree-string>get-boundary rootless)))  
      (substring rootless (1+ (tree-string>get-boundary rootless))))))

;; ================================================================
;; P68
;; ================================================================
;(load "server://u//mc//cadr//l99.lisp")
;(defvar *tree* '(a (b (d () ()) (e () ())) (c () (f (g () ()) ()))))
;(defvar *t* '(a (b (c (d () ()) (e () ())) (f (g () ()) ())) (h (i () ()) ())))

;; --
(defun preorder (tree)
  (string-join (preorder-aux tree)))

(defun preorder-aux (tree)
  (if tree
      `(,(string (car tree)) 
	,@(preorder-aux (cadr tree)) 
	,@(preorder-aux (caddr tree)))
    '("") ))

(defun inorder (tree)
  (string-join (inorder-aux tree)))

(defun inorder-aux (tree)
  (if tree
      `(,@(inorder-aux (cadr tree)) 
	,(string (car tree)) 
	,@(inorder-aux (caddr tree)))
    '("") ))

;(preorder *t*)

(defun snull (str)
  (if (and (stringp str) (string-equal str ""))
      ""
    nil))

;(read-from-string (string (getchar "foo" 1)))
;(string-search #/f "foo")

(defun disassemble-tree-string (pre in)
  (if (or (snull pre) (snull in))
      ""
    (let* ((root (aref pre 0))
	   (left-in   (substring in  0 (string-search root in)))
	   (left-pre  (substring pre 1 (1+ (string-length left-in))))
	   (right-in  (substring in  (1+ (string-search root in))))
	   (right-pre (substring pre (1+ (string-length left-in)))))
      (values (string root) left-in left-pre right-in right-pre))))

;(disassemble-tree-string "abc" "bac")

(defun pre+in->tree (pre in)
  (if (or (snull pre) (snull in))
      '()
    (multiple-value-bind (root left-in left-pre right-in right-pre) 
	(disassemble-tree-string pre in)
      `(,(read-from-string root)
	,(pre+in->tree left-pre left-in)
	,(pre+in->tree right-pre right-in)))))

#|
(print (pre+in->tree "ABDECFG" "DBEACGF"))
(pre+in->tree "a" "a")
(pre+in->tree "abc" "bac")
(pre+in->tree "a" "a")
(disassemble-tree-string "a" "a")
|#

(comment 
  'foo
)
