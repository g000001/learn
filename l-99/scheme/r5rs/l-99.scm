;; utils
(define (flatten lst)
  (cond ((null? lst) '() )
	((not (pair? lst)) `(,lst))
	(else `(,@(flatten (car lst))
		,@(flatten (cdr lst))))))
;; end utils


;; ================================================================
;; p26
;; ================================================================
(define combination
  (lambda (n lis)
    (cond ((zero? n)
	   '())
	  ((= (length lis) n)
	   `(,lis))
	  ((= n 1)
	   (map (lambda (i) `(,i))
		lis))
	  (else
	   `(,@(map (lambda (i) `(,(car lis) ,@i))
		    (combination (- n 1) (cdr lis)))
	     ,@(combination n (cdr lis))))))) ;10:19pm Saturday,17 February 2007

#| test code
(dolist (l (combination 4 '(a b c d e f g h i j k l)))	
	(print l))
|#;; ================================================================
;; p26
;; ================================================================
(define combination
  (lambda (n lis)
    (cond ((zero? n)
	   '())
	  ((= (length lis) n)
	   `(,lis))
	  ((= n 1)
	   (map (lambda (i) `(,i))
		lis))
	  (else
	   `(,@(map (lambda (i) `(,(car lis) ,@i))
		    (combination (- n 1) (cdr lis)))
	     ,@(combination n (cdr lis))))))) ;10:19pm Saturday,17 February 2007

#| test code
(dolist (l (combination 4 '(a b c d e f g h i j k l)))	
	(print l))
|#


(define range
  (lambda (s e)
    (let range1 ((c s)
		 (rl '()))
      (if (> c e)
	  rl
	  (range1 (+ c 1)
		  `(,@rl ,c))))))

(define is-prime
  (lambda (n)
    (call/cc
     (lambda (return)
       (cond ((< n 2) #f)
	     ((= n 2) #t)
	     ((= n 3) #t)
	     ((zero? (modulo n 2)) #f)
	     (else (let loop ((i 3)
			      (fin n))
		     (if (> i fin)
			 #t
			 (loop (+ i 2)
			       (if (zero? (remainder n i))
				   (return #f)
				   (quotient n i)))))))))))

(define prime-list 
  (lambda (start end)
    (let loop ((i start)
	       (retlist '()))
      (if (= i end)
	  retlist
	  (loop (+ i 1)
		(if (is-prime i)
		    `(,@retlist ,i)
		    retlist))))))


 (define goldbach
   (lambda (n)
     (if (even? n)
	 (let ((plist (prime-list 3 
				  (if (= n 6)
				      n
				      (/ n 2))))) ;半分までで良いが6はどうする？
	   (let/cc return
		   (for-each (lambda (i)
			  (and-let* ((j (- n i))
				     ((is-prime j)))
				    (return `(,i ,j))))
			plist)))
	 #f)))

(define prime-factors
  (lambda (n)
    (let ((next-prime
	   (lambda (n)
	     (let loop ((i (+ n 1)))
	       (if (is-prime i)
		   i
		   (loop (+ i 1)))))))
      (letrec ((prime-factors1
		(lambda (n i)
		  (let ((q (quotient n i))
			(r (remainder n i)))
		    (cond ((< n 2)
			   `(,n))
			  ((zero? r)
			   (if (= q 1)
			       `(,i)
			       `(,i ,@(prime-factors1 q i))))
			  (else
			   (prime-factors1 n (next-prime i))))))))
	(prime-factors1 n 2)))))

(define next-prime
  (lambda (n)
    (let loop ((i (+ n 1)))
      (if (is-prime i)
	  i
	  (loop (+ i 1))))))

(use srfi-1)

(define (goldbach-list start end)
  (map goldbach
       (remove (lambda (item)
		 (or (< item 6) (odd? item)))
	       (range start end))))


(use util.match)

(define (pp-goldbach-list lst)
  (for-each (lambda (item)
	      (match-let (((a b) item))
			 (format #t "~D = ~D + ~D~%"  (+ a b) a b)))
	    lst)
  lst)

(define (goldbach-list/limit start end limit)
  (remove (lambda (item) (< (car item) 50))
	  (goldbach-list start end)))

(use util.match)

(define nth-truth
  (lambda (size num true false)
    (let loop ((j size)
	       (retlst '()))
      (if (zero? j)
	  retlst
	  (loop (- j 1) 
		`(,@retlst ,(if (even? (quotient num (expt 2 (- j 1))) )
				true 
				false)))))))

(define make-truth-table
  (lambda (size true false)
    (let loop ((i 0)
	       (retlst '()))
      (if (= i (expt 2 size))
	  retlst
	  (loop (+ i 1)
		`(,@retlst ,(nth-truth size i true false)))))))

(define table/3
  (lambda (a b expr)
    (let ((size 2))
      (map (lambda (pattern)
	     (match-let (((a b) pattern))
			`(,a ,b ,(expr a b))))
	   (make-truth-table size a b)))))

(define pp-table/3 
  (lambda (lst)
    (for-each (lambda (i)
		(match-let (((a b c) i))
			   (format #t "~A ~A -> ~A~%" a b c)))
	      lst)
    (values)))

(define (and/2 a b) 
  (if a b a))

(define (or/2 a b)
  (if a a b))

(define (impl/2 a b)
  (or/2 (not a) b))

(define (nand/2 a b)
  (not (if a b a)))

(define (nor/2 a b)
  (not (if a a b)))

(define (equ/2 a b)
  (or/2 (and/2 a b)
	(and/2 (not a) (not b))))

(define (xor/2 a b)
  (not (or/2 (and/2 a b)
	     (and/2 (not a) (not b)))))

(define table
  (lambda (size expr)
    (map (lambda (item)
	   `(,@item ,(apply expr item)))
	 (make-truth-table size #t #f))))

(define pp-table
  (lambda (lst)
    (let loop ((l lst))
      (if (null? l)
	  (values)
	  (let ((m (car l)))
	    (format #t "~A -> ~A~%" (drop-right m 1) (last m))
	    (loop (cdr l)))))))

;(pp-table (table 3 (lambda (a b c)
;		     (and c (xor/2 a b)))))

(define (bin->gray n)
  (logxor (ash n -1) n))

(define (nbit-gray n)
  (let loop ((i 0) (retlst '()))
    (if (= i (expt 2 n))
	retlst
	(loop (1+ i)
	      `(,@retlst ,(format #f (format #f "~~~d,'0b" n) (bin->gray i)))))))

;(time (nbit-gray 10))
;(list-ref (nbit-gray 10) 100)

;; P50
(use util.match)

;; util
(define (for-each-tree f g n tree)
  (cond ((null? tree) n)
	((not (pair? tree)) (f tree))
	(else (g (for-each-tree f g n (car tree))
		 (for-each-tree f g n (cdr tree))))))

(define (make-frequency-list lst)
  (let ((retlst '()))
    (dolist (item lst retlst)
	    (let ((found-item (assoc item retlst)))
	      (if found-item
		  (inc! (cdr found-item))
		  (set! retlst `(,@retlst (,item . 1))))))))

(define (make-huffman-tree lst)
  (if (= (length lst) 1)
      (caar lst)
      (make-huffman-tree
       (match-let (((a b . c) (sort lst (lambda (a b) (< (cdr a) (cdr b))))))
		  `(((,(car a) ,(car b)) . ,(+ (cdr a) (cdr b))) ,@c)))))

(define (huffman-tree->code tree)
  (let tree->code ((tree tree)
		   (code ""))
    (cond ((not (list? tree)) `(,tree ,code))
	  ((null? tree) '())
	  (else `(,(tree->code (car tree) (string-append code "1"))
		  (,(tree->code (cadr tree) (string-append code "0"))))))))

(define (flatten-tree tree)
  (for-each-tree list append '() tree))

(define (rebuild-list lst)
  (do ((l lst (cddr l))
       (retlst '() `(,@retlst (,(car l) ,(cadr l)))))
      ((null? l) retlst)))

(define (huffman-encode lst)
  (rebuild-list
   (flatten-tree
    (huffman-tree->code 
     (make-huffman-tree 
      (make-frequency-list lst))))))

(define (pp-huffman-code lst)
  (for-each (lambda (item)
	      (format #t "~A => ~A~%" (car item) (cadr item)))
	    lst))

(define (istree obj)
  (let ((isnode 
	 (lambda (node)
	   (or (null? node) (istree node)))))
    (and (list? obj)
	 (= 3 (length obj))
	 (equal? '(#f #t #t) (map isnode obj)))))

;(istree '(a (b (d () ()) (e () ())) (c () (f (g () ()) ()))) )
;(istree '(a () (a)))

;; P70B
(define is-multiway-tree
  (lambda (obj)
    (let/cc exit
      (and (not (list? (list-ref obj 0 '())))
	   (dolist (o (cdr obj) #t)
		   (or (and (list? o)
			    (is-multiway-tree o))
		       (exit #f)))))))

;; P70c
(define nnodes
  (lambda (tree)
    (and (is-multiway-tree tree)
	 (let ((rest-tree (cdr tree)))
	   (apply + 1
		  (if (null? rest-tree)
		      '(0)
		      (map nnodes rest-tree)))))))

;; P70
(define node-string->tree 
  (lambda (str)
    (guard (err ((<read-error> err) #f))
	   (read-from-string
	    (list->string
	     (let ((retlst '()))
	       (for-each (lambda (c)
			   (set! retlst (if (char=? #\^ c)
					    `(,@retlst #\))
					    `(,@retlst #\( ,c))))
			 (string->list str))
	       retlst))))))

;; P71 -- 4:20am Thursday,12 April 2007
(define (internal-path-length tree)
  (let ipl ((tr tree) (depth 0))
    (cond ((> 2 (length tr)) 0)
	  (else (apply +
		       (- (length tr) 1)
		       (map (lambda (l)
			      (+ depth (ipl l (+ 1 depth))))
			    (cdr tr)))))))

;(internal-path-length '(a (f (g)) (c) (b (d) (e))))

;; P73
(define (multiway-tree->lispy-token-list tree)
  (cond ((not (pair? tree)) tree)
	((= 1 (length tree)) (car tree))
	(else `(,(multiway-tree->lispy-token-list (car tree))
		,@(map multiway-tree->lispy-token-list
		       (cdr tree))))))

(define (lispy-token-list->multiway-tree tree)
  (let frob ((tree tree) 
	     (depth 0))
    (cond ((and (zero? depth) (not (pair? tree))) 
	   `(,tree))
	  ((not (pair? tree)) 
	   tree)
	  (else 
	   `(,(frob (car tree) (+ depth 1))
	     ,@(map (lambda (n) 
		      (if (pair? n) 
			  (frob n (+ depth 1))
			  `(,n)))
		    (cdr tree)))))))

;; P56
(define (mirror tree)
  (if (null? tree)
      '()
      (match-let (((root l r) tree))
	`(,root ,(mirror r) ,(mirror l)))))

(define (skeleton tree)
  (if (null? tree)
      '()
      (match-let (((root l r) tree))
	`(x ,(skeleton l) ,(skeleton r)))))

(define (symmetric tree)
  (let ((skel (skeleton tree)))
    (equal? skel (mirror skel))))

;(symmetric '(A (B (D () ()) (E () ())) (C () (F (G () ()) ()))))

;(symmetric '(z (A (B (D () ()) (E () ())) (C () (F (G () ()) ())))
;	  (A (C (F () (G () ())) ()) (B (E () ()) (D () ())))))

;; ================================================================
;; P61
;; ================================================================
;; (define (count-leaves tree)
;;   (let loop ((count 0) 
;; 	     (job tree))
;;     (if (null? job)
;; 	count
;; 	(if (pair? (car job))		;list
;; 	    (loop (+ count 1)		
;; 		  (cdr `(,@(car job) ,@(cdr job))))
;; 	    (if (null? (car job))	;atom
;; 		(loop count (cdr job))
;; 		(loop (+ count 1) (cdr job)))))))

;; (define (count-leaves/cps tree cont)
;;   (if (null? tree)
;;       (cont 0)
;;       (count-leaves/cps (cadr tree) 
;; 			(lambda (m)
;; 			  (count-leaves/cps (caddr tree) 
;; 					    (lambda (n)
;; 					      (cont (+ 1 m n))))))))
(define (leaf? tree)
  (and (not (null? tree))
       (not (null? (car tree)))
       (not (pair? (car tree)))
       (null? (cadr tree))
       (null? (caddr tree))))

(define (count-leaves tree)
  (let cpass ((tree tree)
	      (cont values))
    (if (null? tree)
	(cont 0)
	(if (leaf? tree)
	    (cont 1)
	    (cpass (cadr tree)
		   (lambda (l)
		     (cpass (caddr tree)
			    (lambda (r)
			      (cont (+ l r))))))))))

;; P61A
;; (define (leaves tree)
;;   (let cpass ((tree tree)
;; 	      (cont values))
;;     (if (null? tree)
;; 	(cont '())
;; 	(cpass (cadr tree) 
;; 	       (lambda (m)
;; 		 (cpass (caddr tree) 
;; 			(lambda (n)
;; 			  (cont `(,(car tree) ,@m ,@n)))))))))
(define (leaves tree)
  (let cpass ((tree  tree)
	      (cont values))
    (if (null? tree)
	(cont '() )
	(if (leaf? tree)
	    (cont `(,(car tree)))
	    (cpass (cadr tree)
		   (lambda (l)
		     (cpass (caddr tree)
			    (lambda (r)
			      (cont `(,@l ,@r))))))))))

;; P62
(define (internals tree)
  (let cpass ((tree tree)
	      (cont values))
    (if (null? tree)
	(cont '() )
	(if (leaf? tree)
	    (cont '() )
	    (cpass (cadr tree)
		   (lambda (l)
		     (cpass (caddr tree)
			    (lambda (r)
			      (cont `(,(car tree) ,@l ,@r))))))))))

;(internals *tree*)

;; P62
(define (atlevel level tree)
  (let frob ((level level)
	     (tree tree)
	     (cont values))
    (cond ((null? tree) (cont '() ))
	  ((= 1 level) (cont `(,(car tree))))
	  (else
	   (frob (- level 1) 
		 (cadr tree) 
		 (lambda (l)
		   (frob (- level 1)
			 (caddr tree)
			 (lambda (r)
			   (cont `(,@l ,@r))))))))))

;(atlevel 4 *tree*)

;; P64
(define (count-leaves-and-nodes tree)
  (let loop ((count 0) 
	     (job tree))
    (if (null? job)
	count
	(if (pair? (car job))		;list
	    (loop (+ count 1)		
		  (cdr `(,@(car job) ,@(cdr job))))
	    (if (null? (car job))	;atom
		(loop count (cdr job))
		(loop (+ count 1) (cdr job)))))))

(define (tree->numlist tree)
  (let ((len (count-leaves-and-nodes tree)))
    (let ((numlist (range 1 len)))
      numlist)))

;; (tree->numlist *tree*)

;; (define (layout-binary-tree tree)
;;   (let frob ((tree tree)
;; 	     (numlist (tree->numlist tree))
;; 	     (level 1))
;;     (if (null? tree)
;; 	'()
;; 	(let ((llen (count-leaves-and-nodes (cadr tree))))
;; 	  `((,(list-ref numlist llen) . ,level)
;; 	    ,(if (zero? llen)		    
;; 		 '()
;; 		 (frob (cadr tree) (take numlist (+ llen 1)) (+ level 1)))
;; 	    ,(frob (caddr tree) (list-tail numlist  (+ llen 1)) (+ level 1)))))))

(define (layout-binary-tree tree)
  (let frob ((tree tree)
	     (numlist (tree->numlist tree))
	     (level 1)
	     (cont values))
    (if (null? tree)
	(cont '() )
	(let ((llen (count-leaves-and-nodes (cadr tree))))
	  (frob (cadr tree) (take numlist (+ llen 1)) (+ level 1) 
		(lambda (left)
		  (frob (caddr tree) (list-tail numlist  (+ llen 1)) (+ level 1) 
			(lambda (right)
			  (cont `((,(list-ref numlist llen) . ,level)
				  ,(if (zero? llen) '() left)
				  ,right))))))))))

;; P65
(define (tree-depth tree)
  (if (null? tree)
      0
      (let frob ((tree tree)
		 (level 0))
	(let ((left  (list-ref tree 1 '() ))
	      (right (list-ref tree 2 '() )))
	  (if (and (null? left) (null? right))
	      level
	      (max (frob left (+ level 1))
		   (frob right (+ level 1))))))))

(define (depth-of-most-left-node tree)
  (if (null? tree)
      0
      (let frob ((tree tree)
		 (level 0))
	(let ((left (list-ref tree 1 '() )))
	  (if (null? left)
	      level
	      (frob left (+ 1 level)))))))

(define (layout-binary-tree-2 tree)
  (let ((depth (tree-depth tree)))
    (let frob ((tree tree)
	       (pos (+ 1 (- (expt 2 (tree-depth tree))
			    (expt 2 (- (tree-depth tree) 
				       (depth-of-most-left-node tree))))))
	       (depth depth)
	       (level 1)
	       (cont values))
      (let ((left (list-ref tree 1 '() ))
	    (right (list-ref tree 2 '() )))
	(cond ((null? tree) (cont '() ))
	      (else
	       (let ((offset (expt 2 (- depth 1))))
		 (frob left  (- pos offset) (- depth 1) (+ 1 level) 
		       (lambda (left)
			 (frob right (+ pos offset) (- depth 1) (+ 1 level)
			       (lambda (right)
				 (cont `((,pos . ,level) ,left ,right)))))))))))))


;; P67
;(load "./leaf?.scm")

(use srfi-13)				;string-join

(define (find-region str)
  (if (string-scan str #\( )
      (let ((count 0)
	    (len (string-length str)))
	(do ((i 0 (+ 1 i))
	     (retlst '()))
	    ((= i len) (let ((reg (reverse retlst)))
			 (values (car reg) (cadr reg))))
	  (let ((part (substring str i (+ i 1))))
	    (cond 
	     ((and (string=? "(" part) (zero? count)) (push! retlst i) (inc! count))
	     ((and (string=? ")" part) (= 1 count))   (push! retlst i) (dec! count))
	     ((string=? "(" part) (inc! count))
	     ((string=? ")" part) (dec! count))))))
      (values 0 0)))

(define (remove-parent str)
  (receive (start end)
	   (find-region str)
	   (if (zero? end)
	       str
	       (substring str (+ 1 start) end))))

(define (get-children str)
  (if (string=? "" str)
      ""
      (let ((strip (remove-parent str)))
	(cond ((not (string-scan strip #\,))
	       (values strip ""))
	      ((zero? (string-scan strip #\,))
	       (values "" (substring strip 1 (string-length strip))))
	      ('t 
	       (if (string-scan strip #\( )
		   (receive (start end)
			    (find-region strip)
			    (values 
			     (substring strip 0 (+ 1 end))
			     (substring strip (+ 2 end) (string-length strip))))
		   (string-scan strip #\, 'both)))))))

(define (string->tree str)
  (if (string=? "" str)
      '()
      (let ((node (cond ((string-scan str #\( 'before) => string->symbol)
			(else (string->symbol str)))))
	(receive (l r)
		 (get-children str)
		 (if (string-scan str #\,)
		     `(,node
		       ,(string->tree l)
		       ,(string->tree r))
		     `(,node () ()))))))

(define (tree->string tree)
  (letrec ((frob
	    (lambda (tree)
	      (if (null? tree)
		  '()
		  (if (leaf? tree)
		      `(,(symbol->string (car tree)))
		      `(,(symbol->string (car tree)) 
			"("
			,@(frob (cadr tree))
			","
			,@(frob (caddr tree))
			")"))))))
    (string-join (frob tree) "")))

(define (tree<->string tree-or-string)
  (if (string? tree-or-string)
      (string->tree tree-or-string)
      (tree->string tree-or-string)))

;; ================================================================
;; P68
;; ================================================================

(define (preorder tree)
  (letrec ((frob 
	    (lambda (tree)
	      (if (null? tree)
		  '("")
		  `(,(symbol->string (car tree)) ,@(frob (cadr tree)) ,@(frob (caddr tree)))))))
    (string-join (frob tree) "")))

(define (inorder tree)
  (letrec ((frob 
	    (lambda (tree)
	      (if (null? tree)
		  '("")
		  `(,@(frob (cadr tree)) ,(symbol->string (car tree)) ,@(frob (caddr tree)))))))
    (string-join (frob tree) "")))

(define (disassemble-tree-string pre in)
  (if (or (string-null? pre) (string-null? in))
      ""
      (let* ((len       (string-length in))
	     (root      (substring pre 0 1))
	     (left-in   (substring in  0 (string-scan in root)))
	     (left-pre  (substring pre 1 (+ 1 (string-length left-in))))
	     (right-in  (substring in  (+ 1 (string-scan in root))   len))
	     (right-pre (substring pre (+ 1 (string-length left-in)) len)))
	(values root left-in left-pre right-in right-pre))))

(define (pre+in->tree pre in)
  (if (or (string-null? pre) (string-null? in))
      '()
      (receive (root left-in left-pre right-in right-pre) (disassemble-tree-string pre in)
	       `(,(string->symbol root)
		 ,(pre+in->tree left-pre left-in)
		 ,(pre+in->tree right-pre right-in)))))

#|
(define *tree* '(a (b (d () ()) (e () ())) (c () (f (g () ()) ()))))
(pre+in->tree "abc" "bac")
(pre+in->tree "ABDECFG" "DBEACGF")
|#

;; ================================================================
;; P69
;; ================================================================
(define (tree<=>dotstring list-or-string)
  (if (string? list-or-string)
      (dotstring->tree list-or-string)
      (tree->dotstring list-or-string)))

(define (tree->dotstring tree)
  (letrec ((frob 
	    (lambda (tree)
	      (if (null? tree)
		  '(".")
		  `(,(symbol->string (car tree)) 
		    ,@(frob (cadr tree))
		    ,@(frob (caddr tree)))))))
    (string-join (frob tree) "")))

(define (dotstring->tree str)
  (if (string=? "" str)
      '()
      (let ((root (substring str 0 1)))
	(if (string=? root ".")
	    '()
	    (receive (l r) (tree-string>get-children str)
		     `(,(string->symbol root)
		       ,(dotstring->tree l)
		       ,(dotstring->tree r)))))))

(define (tree-string>get-boundary str)
  (let/cc exit
    (let ((point 1))
      (dotimes (i (- (string-length str) 1))
	       (if (not (string=? "." (substring str i (+ 1 i))))
		   (set! point (+ 1 point))
		   (set! point (- point 1)))
	       (if (zero? point)
		   (exit i))))))

(define (tree-string>get-children str)
  (let* ((len (string-length str))
	 (rootless (substring str 1 len))
	 (boundary (+ 1 (tree-string>get-boundary rootless))))
    (values 
     (substring rootless 0 boundary)
     (substring rootless boundary (- len 1)))))


;; ================================================================
;; P80
;; ================================================================

;; utility
(define (flatten lst)
  (cond ((null? lst) '() )
	((not (pair? lst)) `(,lst))
	(else `(,@(flatten (car lst))
		,@(flatten (cdr lst))))))

(define (sort-by-symbol-name lst pos-fn)
  (sort lst
	(lambda (a b)
	  (string<? (symbol->string (pos-fn a)) (symbol->string (pos-fn b))))))

;; -----------------------------------------------------------------------------
;; Graph Term
;; 1)
(define (graph-term->edge-clause expr)
  (cadr expr))

;; 2) DIRECTED
(define graph-term->arc-clause/directed  graph-term->edge-clause)

;; 3) LABELLED
(define graph-term->arc-clause/labelled graph-term->edge-clause)

;; 1)
(define (edge-clause->graph-term expr)
  `(,(sort-by-symbol-name
      (delete-duplicates
       (fold append '() expr))
      identity)
    ,expr))

;; 3) LABELLED
(define (arc-clause->graph-term/labelled expr)
  `(,(sort-by-symbol-name
      (delete-duplicates
       (fold (lambda (item retlst) `(,@(drop-right item 1) ,@retlst))
	     '() expr))
      identity)
    ,expr))

;; 2) DIRECTED
(define arc-clause->graph-term/directed arc-clause->graph-term/labelled)

;; -----------------------------------------------------------------------------
;; Adjacency List
;; 1)
(define (graph-term->adjacency-list expr)
  `(,@(map (lambda (item)
	     `(,item 
	       ,(remove null?
			(delete-duplicates 
			 (flatten 
			  (map (lambda (lst)
				 (remove (cut eq? item <>)
					 (if (memq item lst)
					     lst
					     '() )))
			       (cadr expr)))))))
	   (car expr))))

;; 2) DIRECTED
(define (graph-term->adjacency-list/directed expr)
  (map (lambda (item) `(,item ,(get-direction item (cadr expr))))
       (car expr)))

(define (get-direction from dist-lst)
  (fold (lambda (item retlst)
	  (if (eq? from (car item))
	      `(,@retlst ,(cadr item))
	      retlst))
	'() dist-lst))

;; 3) LABELLED
(define (graph-term->adjacency-list/labelled expr)
  (map (lambda (item)
	 `(,item ,(get-direction/labelled item (cadr expr))))
       (car expr)))
                      
(define (get-direction/labelled from dist-lst)
  (fold (lambda (item retlst)
	  (if (eq? from (car item))
	      `(,@retlst (,(cadr item) ,(caddr item)))
	      retlst))
	'() dist-lst))

;; 1)
(define (adjacency-list->graph-term expr)
  `(,(map car expr)
    ,(sort-by-symbol-name
      (delete-duplicates
       (fold (lambda (item retlst)
	       `(,@retlst 
		 ,@(map (lambda (j)
			  (sort-by-symbol-name `(,(car item) ,j) identity))
			(cadr item))))
	     '() expr))
      car)))

;; 2) DIRECTED
(define adjacency-list->graph-term/directed adjacency-list->graph-term)

;; 3) LEBELLED
(define (adjacency-list->graph-term/labelled expr)
  `(,(map car expr)
    ,(fold (lambda (item retlst)
                 `(,@retlst ,@(fold (lambda (num ret)
                                          (if (not (null? num))
                                              `(,@ret (,(car item) ,@num))
					      ret))
                                      '() (cadr item))))
             '() expr)))

;; -----------------------------------------------------------------------------
;; Human Friendly

;; 1)
(define (graph-term->human-friendly expr)
  (graph-term->human-friendly-aux expr "-"))

(define (graph-term->human-friendly-aux expr separater)
  (sort `(,@(map (lambda (item)
		   (string-append (symbol->string (car item)) 
				  separater 
				  (symbol->string (cadr item))))
		 (cadr expr))
	  ,@(map symbol->string
		 (lset-difference eq? (car expr) (flatten (cadr expr)))))
	string<?))

;; 2) DIRECTED
(define (graph-term->human-friendly/directed expr)
  (graph-term->human-friendly-aux expr ">"))

;; 3) LABELLED
(define (graph-term->human-friendly/labelled expr)
  (sort `(,@(map (lambda (item)
		   (match-let (((a b c) item))
			      (format #f "~A>~A/~A" a b c)))
		 (cadr expr))
	  ,@(map symbol->string
		 (lset-difference eq? (car expr) (flatten (cadr expr)))))
	string<?))

;; 1)
(define (human-friendly->graph-term expr)
  (human-friendly->graph-term-aux expr string-split/-))

(define (human-friendly->graph-term-aux expr split-fn)
  (let ((item-list 
	 (map (lambda (item)
		(if (consp item)
		    `(,(string->symbol (car item)) 
		      ,(string->symbol (cadr item)))
		    (string->symbol item)))
	      (split-fn expr))))
    item-list))

(define (human-friendly->graph-term-aux expr split-fn)
  (let ((item-list 
	 (map (lambda (item)
		(if (null? (cdr item))
		    (string->symbol (car item))
		    `(,(string->symbol (car item)) 
		      ,(string->symbol (cadr item)))))
	      (split-fn expr))))
    `(,(delete-duplicates (flatten item-list)) 
      ,(remove (lambda (i) (not (pair? i))) item-list))))

(define (string-split/- strlst)
  (map (lambda (item) (string-split item #\-))
       strlst))

;; 2) DIRECTED
(define (human-friendly->graph-term/directed expr)
  (human-friendly->graph-term-aux expr string-split/>))

(define (string-split/> strlst)
  (map (lambda (item) (string-split item #\>))
       strlst))

;; 3) LABELLED
(define (human-friendly->graph-term/labelled expr)
  (let ((item-list 
	 (map (lambda (item)
		(if (null? (cdr item))
		    (string->symbol (car item))
		    (match-let (((from to label) item))
			       `(,(string->symbol from)
				 ,(string->symbol to)
				 ,(string->number label)))))
	      (string-split/labelled expr))))
    `(,(delete-duplicates
	(fold (lambda (item retlst)
		(if (pair? item) 
		    `(,@retlst ,@(drop-right item 1) )
		    `(,@retlst ,item)))
	      '() item-list))
      ,(remove (lambda (item) (not (pair? item))) item-list))))

(define (string-split/labelled strlst)
  (map (lambda (str)
	 (if (string-scan str #\/)
	     (match-let (((from to-label) (string-split str #\>)))
			(match-let (((to label) (string-split to-label #\/)))
				   `(,from ,to ,label)))
	     `(,str)))
       strlst))
