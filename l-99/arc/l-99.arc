;P03 (*) Find the K'th element of a list.
;    The first element in the list is number 1.
;    Example:
;    * (element-at '(a b c d e) 3)
;    C

(def elt-at (lst idx)
  (if (is idx 1)
      (car lst)
      (elt-at (cdr lst) (- idx 1))))

;(elt-at '(a b c d e) 3)
;=> c

;(def elt-at (lst idx)
;  (lst (- idx 1)))

; 04
;P04 (*) Find the number of elements of a list.

;(def list-len (lst)
;  (if (no lst)
;      0
;      (+ 1 (list-len (cdr lst)))))

(def list-len (lst)
  ((afn (lst cnt)
     (if (no lst)
         cnt
         (self (cdr lst) (+ cnt 1))))
   lst 0))

;(list-len '(foo bar baz))
;(len '(foo bar baz))

;(len "foo99")

(def reverse (lst)
  ((afn (org acc)
        (if (no org)
            acc
            (self (cdr org) (cons (car org) acc))))
   lst () ))

;(reverse '(foo bar baz))
;=> (baz bar foo)

;(rev '(foo bar baz))
;=> (baz bar foo)

;P06 (*) Find out whether a list is a palindrome.
;    A palindrome can be read forward or backward; e.g. (x a m a x).

(def palindrome (lst)
  (iso (rev lst) lst))

(def palindrome (lst)
  ((afn (l acc)
        (if (no l)
            (iso lst acc)
            (self (cdr l) (cons (car l) acc))))
   lst () ))

;(palindrome '(x a m a x))

(def flatten (lst)
  ((afn (lst acc)
        (if (no lst)
            (rev acc)
            (atom (car lst))
            (self (cdr lst) (cons (car lst) acc))
            (self (cdr lst) (+ (flatten (car lst)) acc))))
   lst () ))

(def flatten (lst)
  (rev ((afn (lst acc)
             (if (no lst)
                  acc
                 (atom (car lst))
                  (self (cdr lst) (cons (car lst) acc))
                 'else
                  (self (cdr lst) (+ (self (car lst) () ) acc))))
        lst () )))

(def flatten (lst)
  (rev ((afn (lst acc)
             (if (no lst)
                  acc
                  (self (cdr lst) 
                        (if (atom (car lst))
                            (cons (car lst) acc)
                            (+ (self (car lst) () ) acc)))))
        lst () )))

(def flatten (lst)
  ((afn (lst acc)
        (if (no lst)
            acc
            (self (cdr lst) 
                  (if (atom (car lst))
                      (cons (car lst) acc)
                      (+ (self (car lst) () ) acc)))))
   (rev lst) () ))

(def flatten (lst)
  ((afn (lst acc)
        (if (no lst)
            acc
            (atom lst)
            (cons lst acc)
            (self (car lst) (self (cdr lst) acc))))
   lst () ))

(def compress (lst)
  ((afn (lst acc)
     (if no.lst
         rev.acc
         (self cdr.lst
               (if (and (is car.acc car.lst) acc)
                   acc
                   (cons car.lst acc)))))
   lst () ))

(compress '(t t t t t nil nil nil nil nil t t))

(compress '(nil nil nil nil nil t t t t t nil nil))
;=>(nil t nil)

;(flatten '(1 2 (3 (4 5 (()(()(((((((6((((((7 8 9)))))))10)))))))))()) 11 (12)))
;(flatten '(a b (c (a b (a((((((((h((((((a b c)))))))8)))))))))) d (e)))

;(flat '("foo bar baz"))

;09 (**) Pack consecutive duplicates of list elements into sublists.
;    If a list contains repeated elements they should be placed in separate sublists.
;
;    Example:
;    * (pack '(a a a a b c c a a d e e e e))
;    ((A A A A) (B) (C C) (A A) (D) (E E E E))

(def pack (lst)
  (rev ((afn (lst acc tem) 
             (if (no lst)
                 (cons tem acc)
                 (if (or (is (car lst) (car tem)) (no tem))
                     (self (cdr lst)
                           acc
                           (cons (car lst) tem))
                     (self (cdr lst)
                           (cons tem acc)
                           (list:car lst)))))
        lst () () )))

(def pack (lst)
  (rev ((afn (lst acc tem) 
             (if (no lst)
                  (cons tem acc)
                 (or (is (car lst) (car tem)) (no tem))
                  (self (cdr lst)
                        acc
                        (cons (car lst) tem))
                  'else
                  (self (cdr lst)
                        (cons tem acc)
                        (list:car lst))))
        lst () () )))

;(mac cond body
;     (let newbody ((afn (lst acc)
;                       (if (no lst)
;                           (rev acc)
;                           (self (cdr lst) (+ `(if ,(car lst) (do ,@(cdr lst))) acc))))
;                  body () )
;         `(do ,@newbody)))

(def encode (lst)
  ((afn (lst acc)
        (if no.lst
            rev.acc
            (self cdr.lst
                  (cons `(,(len car.lst) ,caar.lst) acc))))
   pack.lst () ))

(def encode (lst)
  ((afn (lst acc)
        (if no.lst
            rev.acc
            (self cdr.lst
                  (cons `(,(len car.lst) ,caar.lst) acc))))
   pack.lst () ))

;(range 1 10)

;    * (encode-modified '(a a a a b c c a a d e e e e))
;    ((4 A) B (2 C) (2 A) D (4 E))

;P12 (**) Decode a run-length encoded list.
;    Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.

;P11 (*) Modified run-length encoding.
;    Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.

(pr "HELLO")
;; P11
(def encode-modified (lst)
  ((afn (lst acc)
        (if no.lst
            rev.acc
            (self cdr.lst
                  (let n (len car.lst)
                    (cons (if (is 1 n) caar.lst `(,n ,caar.lst)) 
                          acc)))))
   pack.lst () ))

;(encode-modified '(a a a a b c c a a d e e e e))
;((4 a) b (2 c) (2 a) d (4 e))

;P12 (**) Decode a run-length encoded list.
;    Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.

(def decode (lst)
  ((afn (lst acc)
        (if no.lst
            rev.acc
            (self cdr.lst
                  (if (atom car.lst)
                      (cons car.lst acc)
                      (cons (apply newlist car.lst) acc)))))
   lst () ))

(def decode (lst)
  ((afn (lst acc)
     (if no.lst
         rev.acc
         (self cdr.lst
               (cons (if (atom car.lst)
                         car.lst
                         (apply newlist car.lst))
                     acc))))
   lst () ))

(def newlist (size (o elt nil))
  ((afn (cnt acc)
     (if (<= cnt 0)
         acc
         (self (- cnt 1) (cons elt acc))))
   size () ))

;P13 (**) Run-length encoding of a list (direct solution).
;    Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem P09, but only count them. As in problem P11, simplify the result list by replacing the singleton lists (1 X) by X.
;
;    Example:
;    * (encode-direct '(a a a a b c c a a d e e e e))
;    ((4 A) B (2 C) (2 A) D (4 E))


(def encode-direct (lst)
  ((afn (lst acc)
     (if no.lst
         rev.acc
         (self cdr.lst
               (if (atom car.acc)
                   (if (is car.lst car.acc)
                       (cons `(2 ,car.acc) cdr.acc)
                       (cons car.lst acc))
                   (if (is car.lst (cadr car.acc))
                       (cons `(,(+ 1 caar.acc) ,car.lst) cdr.acc)
                       (cons car.lst acc))))))
   lst () ))

(def encode-direct (lst)
  ((afn (lst acc)
     (if no.lst
         rev.acc
         (self cdr.lst
               (if (atom car.acc)
                   (if (is car.lst car.acc)
                       (cons `(2 ,car.acc) cdr.acc)
                       (cons car.lst acc))
                   (if (is car.lst (cadr car.acc))
                       (cons `(,(+ 1 caar.acc) ,car.lst) cdr.acc)
                       (cons car.lst acc))))))
   lst () ))

(def encode-direct (lst)
  ((afn (lst acc)
     (if no.lst
         rev.acc
         (self cdr.lst
               (let a car.acc
                 (if atom.a
                     (if (is car.lst a)
                         (cons `(2 ,a) cdr.acc)
                         (cons car.lst acc))
                     (if (is car.lst cadr.a)
                         (cons `(,(+ 1 car.a) ,car.lst) cdr.acc)
                         (cons car.lst acc)))))))
   lst () ))

;(encode-direct '(a a a a b c c a a d e e e e))
;=> ((4 a) b (2 c) (2 a) d (4 e))

;    * (encode-direct '(a a a a b c c a a d e e e e))
;    ((4 A) B (2 C) (2 A) D (4 E))


;P14 (*) Duplicate the elements of a list.
;    Example:
;    * (dupli '(a b c c d))
;    (A A B B C C C C D D)

(def dupli (lst)
  ((afn (lst acc)
     (if no.lst
         rev.acc
         (self cdr.lst
               (cons car.lst
                     (cons car.lst
                           acc)))))
   lst () ))

(def dupli (lst)
  ((afn (lst acc)
     (if no.lst
         rev.acc
         (self cdr.lst
               (+ (list car.lst car.lst)
                  acc))))
   lst () ))

(def dupli (lst)
  ((afn (lst (H . T) acc)
     (if no.lst
         rev.acc
         (self T T `(,H ,H ,@acc))))
   lst lst () ))


;(dupli '(a b c c d))
;=> (a a b b c c c c d d)


;    * (dupli '(a b c c d))
;    (A A B B C C C C D D)

(def dupli (lst)
  (if no.lst
      ()
      (+ (list car.lst car.lst) (dupli cdr.lst))))

(def dupli (lst)
  (and lst `(,lst.0 ,lst.0 ,@(dupli cdr.lst))))

;P15 (**) Replicate the elements of a list a given number of times.
;    Example:
;    * (repli '(a b c) 3)
;    (A A A B B B C C C)

(def repli (lst times)
  ((afn (lst acc cnt)
     (if no.lst
         rev.acc
         (if (is 0 cnt)
             (self cdr.lst (cons car.lst acc) times)
             (self lst (cons car.lst acc) (- cnt 1)))))
   lst () times))

;(repli '(a b c) 6)
;=> (a a a a a a a b b b b b b b c c c c c c c)

;; 
(def repli (lst times)
  (mappend [newlist _ times] lst))

(def newlist (elt n)
  (let acc ()
    (repeat n (push elt acc))
    acc))

;P16 (**) Drop every N'th element from a list.
;    Example:
;    * (drop '(a b c d e f g h i k) 3)
;    (A B D E G H K)

;(drop '(a b c d e f g h i k) 3)

(def drop (lst n)
  ((afn (lst acc cnt)
     (if no.lst
         rev.acc
         (self cdr.lst
               (if (is 0 (mod cnt n))
                   acc
                   (cons car.lst acc))
               (+ 1 cnt))))
   lst () 1))

(def drop (lst n)
  ((afn (lst acc (o cnt 1))
     (if no.lst
         rev.acc
         (if (is cnt n)
             (self cdr.lst acc)
             (self cdr.lst (cons car.lst acc) (+ 1 cnt)))))
   lst () ))
;(drop '(a b c d e f g h i k) 3)
;=> (a b d e g h k)

(def drop (lst n)
  (let acc ()
    (forlen i lst
      (unless (is 0 (mod (+ i 1) n))
        (push lst.i acc)))
    rev.acc))

;P17 (*) Split a list into two parts; the length of the first part is given.
;    Do not use any predefined predicates.
;
;    Example:
;   * (split '(a b c d e f g h i k) 3)
;    ( (A B C) (D E F G H I K))

(def split (lst n)
  (if (<= n 0) 
      lst
      ((afn (lst acc cnt)
         (if (is 0 cnt)
             (cons rev.acc (list cdr.lst))
             (self cdr.lst (cons car.lst acc) (- cnt 1))))
       lst () n)))

(def split (lst n)
  (if (<= n 0) 
      lst
      ((afn (lst acc cnt)
         (let (head . tail) lst
           (if (is 0 cnt)
               (cons rev.acc list.tail)
               (self tail (cons head acc) (- cnt 1)))))
       lst () n)))

;   * (split '(a b c d e f g h i k) 3)

;((a b c) (e f g h i k))


;P18 (**) Extract a slice from a list.
;    Given two indices, I and K, the slice is the list containing the elements between the I'th and K'th element of the original list (both limits included). Start counting the elements with 1.
;
;    Example:
;    * (slice '(a b c d e f g h i k) 3 7)

;(slice '(a b c d e f g h i k) 3 7)
;         1 2 3 4 5 6 7
;    (C D E F G)


;0 < start < len.lst < end

;(cut '(1 2 3 4) 1 5)

(def slice (lst start end)
  (unless (<= 0 start end (len lst))
    (err "Out of range."))
  ((afn (lst acc cnt)
        (ccc 
         (fn (exit)
             (if no.lst
                 rev.acc
                 (self cdr.lst
                       (if (<= start cnt end)
                           (cons car.lst acc)
                           (if (< end cnt)
                               (exit rev.acc)
                               acc))
                       (+ 1 cnt))))))
   lst () 1))

(def slice (lst start end)
  (unless (<= 0 start end (len lst))
    (err "The bounding indices are bad for a sequence of length."))
  ((afn (lst acc cnt)
        (if (or no.lst (< end cnt))
            rev.acc
            (self cdr.lst
                  (if (<= start cnt end)
                      (cons car.lst acc)
                      acc)
                  (+ 1 cnt))))
   lst () 1))

;(slice '(a b c d e f g h i k) 3 7)

;=> (c d e f g)

;P19 (**) Rotate a list N places to the left.
;    Examples:
;    * 
;    (D E F G H A B C)
;
;    * (rotate '(a b c d e f g h) -2)
;    (G H A B C D E F)
;
;    Hint: Use the predefined functions length and append, as well as the result of problem P17.
;(rotate '(a b c d e f g h) 3)
;=> (d e f g h a b c)
;(rotate '(a b c d e f g h) -2)
;=> (g h a b c d e f)

(def rotate (lst pos)
  (let pos (mod pos len.lst)
     ((afn (lst acc cnt)
        (if (or no.lst (is pos cnt))
            (join lst rev.acc)
            (self cdr.lst
                  (cons car.lst acc)
                  (+ 1 cnt))))
      lst () 0)))

(def rotate (lst pos)
  (let pos (mod pos len.lst)
     (awith (lst lst acc () cnt 0)
       (if (or no.lst (is pos cnt))
           (join lst rev.acc)
           (self cdr.lst
                 (cons car.lst acc)
                 add1.cnt)))))

;P20 (*) Remove the K'th element from a list.
;    Example:
;    * (remove-at '(a b c d) 2)
;    (A C D)

(def remove-at (lst pos)
  ((afn (lst acc cnt)
    (if (or no.lst (> cnt pos))
        (join rev.acc lst)
        (self cdr.lst
              (if (is cnt pos)
                  acc
                  (cons car.lst acc))
              (+ 1 cnt))))
   lst () 1))

;(remove-at '(a b c d) 2)
;=> (a c d)

(def remove-at (lst pos)
  (awith (lst lst acc () cnt 1)
    (if (or no.lst (> cnt pos))
        (join rev.acc lst)
        (self cdr.lst
              (if (is cnt pos)
                  acc
                  (cons car.lst acc))
              add1.cnt))))

;P21 (*) Insert an element at a given position into a list.
;    Example:
;    * (insert-at 'alfa '(a b c d) 2)
;    (A ALFA B C D)

;(insert-at 'alfa '(a b c d) 3)
;=> (a alfa b c d)

(def insert-at (item lst pos)
  (unless (<= 1 pos (len lst))
    (err "The index is bad for a sequence of length."))
  ((afn (lst acc cnt)
     (if (or no.lst (is pos cnt))
         (join rev.acc (list item) lst)
         (self cdr.lst
               (cons car.lst acc)
               (+ 1 cnt))))
   lst () 1))

;P22 (*) Create a list containing all integers within a given range.
;    If first argument is smaller than second, produce a list in decreasing order.
;    Example:
;    * (range 4 9)
;    (4 5 6 7 8 9)

;=> (range 4 9)
;(4 5 6 7 8 9)

(def rangE (start end)
  (and (<= start end)
       ((afn (cnt acc)
          (if (> cnt end)
              rev.acc
              (self (+ 1 cnt) (cons cnt acc))))
        start () )))

;(rangE -4 -4)

;(range 3 3)


;P23 (**) Extract a given number of randomly selected elements from a list.
;    The selected items shall be returned in a list.
;    Example:
;    * (rnd-select '(a b c d e f g h) 3)
;    (E D A)

;(rnd-select '(a b c d e f g h) 7)
;=> (a c d)

(def rnd-select (lst num)
  (and (< 0 num)
       ((afn (lst cnt)
          (if (or no.lst (is len.lst num))
              lst
              (self (remove-at lst (+ 1 (rand len.lst)))
                    (+ 1 cnt))))
        lst num)))
;(apply [rand-choice _] '(3 3 3))
;(random-elt '(1 2 3))
;(rand 3)

;P24 (*) Lotto: Draw N different random numbers from the set 1..M.
;    The selected numbers shall be returned in a list.
;    Example:
;    * (lotto-select 6 49)
;    (23 1 17 33 21 37)
;
;    Hint: Combine the solutions of problems P22 and P23.

;(lotto-select 6 49)
;=> (20 44 31 36 1 9)

(def rnd-select (lst num)
  (and (< 0 num)
       ((afn (lst acc cnt)
          (if (or no.lst (is len.lst num))
              (list lst acc)
              (let pos (+ 1 (rand len.lst))
                (self (remove-at lst pos)
                      (cons (lst (- pos 1)) acc)
                      (+ 1 cnt)))))
        lst () num)))

(def lotto-select (n rng)
  (cadr:rnd-select (range 1 rng) (- rng n)))


;P25 (*) Generate a random permutation of the elements of a list.
;    Example:
;    * (rnd-permu '(a b c d e f))
;    (B A D C E F)
;
;    Hint: Use the solution of problem P23.


;(rnd-permu '(a b c d e f))
;=> '(e f c b d a)
(def rnd-permu (lst)
  (apply join (rnd-select lst 1)))

;(rnd-select '(a b c d e f) 1)

;(rnd-select '(a b c d e f) 1)
;=> ((e) (f c b d a))

;P26 (**) Generate the combinations of K distinct objects chosen from the N elements of a list
;    In how many ways can a committee of 3 be chosen from a group of 12 people? We all know that there are C(12,3) = 220 possibilities (C(N,K) denotes the well-known binomial coefficients). For pure mathematicians, this result may be great. But we want to really generate all the possibilities in a list.

;    Example:
;    * (combination 3 '(a b c d e f))
;    ((A B C) (A B D) (A B E) ... )

(def combination (n lst)
  (if (is 0 n)
      ()
      (is (len lst) n)
      `(,lst)
      (is 1 n)
      (map list lst)
      'else
      `(,@(map (fn (l) `(,car.lst ,@l))
               (combination (- n 1) cdr.lst))
        ,@(combination n cdr.lst))))

(def combination (n lst)
  (let llen (len lst)
    (if (~<= 1 n llen) ()
        (is n llen) `(,lst)
        (is n 1) (map list lst)
        'else `(,@(map (fn (l) `(,car.lst ,@l))
                       (combination (- n 1) cdr.lst))
                ,@(combination n cdr.lst)))))

;(combination 3 '(a b c d e f))
;=> ((a b c) (a b d) (a b e) ...)

;(len (combination 3 (range 1 12)))
;=> 220

;(len (combination 3 '(a b c d e f)))

(def group3 (lst)
  (let res ()
    (each u (combination 2 lst)
      (let diff (setdiff lst u)
        (each v (combination 3 diff)
          (= res `(,@res (,u ,v ,(setdiff diff v)))))))
    res))

;; Utils (from Maclisp LSETS.LSP)
(def setdiff (x y)
  (point exit
    (each yy y
      (when (mem yy x)
        (exit (y-x+z x y () ))))
    x))

(def y-x+z (y x z)
  (let y-x ()
    (each xx y
      (or (mem xx x) (push xx y-x)))
    (= y-x (join (rev y-x) z))))

;(pr (firstn 3 (group3 '(aldo beat carla david evi flip gary hugo ida))))

;(((aldo beat) (carla david evi) (flip gary hugo ida))
; ((aldo beat) (carla david flip) (evi gary hugo ida))
; ((aldo beat) (carla david gary) (evi flip hugo ida)) ...)

;(len (group3 '(aldo beat carla david evi flip gary hugo ida)))
;=> 1260

;;
(def setdiff (x y)
  (if (ccc (fn (exit)
             (each yy y
               (and (mem yy x)
                    (exit yy)))
             nil))
      (y-x+z x y () )
      x))

(def setdiff (x y)
  (if (point exit
        (each yy y
              (and (mem yy x)
                   (exit yy))
              nil))
      (y-x+z x y () )
      x))

;(setdiff '(1 2 3 4 5) '(a))
;(y-x+z '(1 2 3 4 5) '(a) () )

;(all [is 2 len._]
;     (sep2 '(aldo beat carla david evi flip gary hugo ida) 2))

(def group (lst pat)
  ((afn (lst pat)
     (if (or no.pat (~<= 0 (apply + pat) len.lst)) () 
         (is len.lst car.pat) list.lst
         (is 1 len.pat) (sep2 lst car.pat)
         'else (sep2-list (self lst cdr.pat) car.pat)))
   lst rev.pat))

(def sep2 (lst num)
  (map [list _ (setdiff lst _)]
       (combination num lst)))

;(def butlast (lst)
;  (firstn (- len.lst 1) lst))

(def sep2-list (lsts num)
  (let res ()
    (each l lsts
      (= res (+ (map [if cadr._
                         `(,@butlast.l ,@_)
                         `(,@butlast.l ,car._)]
                (sep2 last.l num))
                res)))
    res))

(def butlast (lst)
  (cut lst 0 (- len.lst 1)))

;(firstn 3 (group '(aldo beat carla david evi flip gary hugo ida) '(2 3 4)))
;(len (group '(aldo beat carla david evi flip gary hugo ida) '(1)))

;(group '(aldo beat carla david evi flip gary hugo ida) '(1))

;(len (group (range 1 9) '(1 1 1 1)))

;(sep2-list (sep2 (range 1 4) 1) 2)

;(each l (sep2-list (sep2 '(aldo beat carla) 1) 1)
;  (prn l))

;P28 (**) Sorting a list of lists according to length of sublists
;    a) We suppose that a list contains elements that are lists themselves. The objective is to sort the elements of this list according to their length. E.g. short lists first, longer lists later, or vice versa.

;    Example:
;    * (lsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
;    ((O) (D E) (D E) (M N) (A B C) (F G H) (I J K L))

;    b) Again, we suppose that a list contains elements that are lists themselves. But this time the objective is to sort the elements of this list according to their length frequency; i.e., in the default, where sorting is done ascendingly, lists with rare lengths are placed first, others with a more frequent length come later.

;(lsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
;=> ((o) (d e) (d e) (m n) (a b c) (f g h) (i j k l))

(def lsort (lst)
  (sort (fn (x y) (< (len x) (len y)))
        lst))


(def lsort (lst)
  (sort (fn (x y) (< (len x) (len y)))
        lst))

(def my-sort (lst)
  (afn (lst l r)
    (if (no car.lst)
        (+ l car.lst r)
        (self lst ))))

(def lsort (lst)
  (sort (fn (x y) (< (len x) (len y)))
        lst))

(lsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
;=> ((o) (d e) (d e) (m n) (a b c) (f g h) (i j k l))

(def lsort (lst)
  (if no.lst
      ()
      (let piv (len car.lst)
        (+ (lsort:rem [<= piv len._] cdr.lst)
           (list car.lst)
           (lsort:rem [> piv len._] cdr.lst)))))


#|
b) Again, we suppose that a list contains elements that are lists themselves. But this time the objective is to sort the elements of this list according to their length frequency; i.e., in the default, where sorting is done ascendingly, lists with rare lengths are placed first, others with a more frequent length come later.

Example:
* (lfsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
((i j k l) (o) (a b c) (f g h) (d e) (d e) (m n))

Note that in the above example, the first two lists in the result have length 4 and 1, both lengths appear just once. The third and forth list have length 3 which appears twice (there are two list of this length). And finally, the last three lists have length 2. This is the most frequent length.
|#


(def lfsort (lst)
  (let freq len-freq.lst
    (sort (fn (x y) (< (pos len.x freq) (pos len.y freq)))
          lst)))

(def len-freq (lst)
  (map car (lsort:pack (map len lsort.lst))))

(lsort (pack (map len (lsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o))))))

;(len-freq '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))

(lfsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
;-> ((o) (i j k l) (a b c) (f g h) (d e) (d e) (m n))

;P31 (**) Determine whether a given integer number is prime.
;    Example:
;    * (is-prime 7)
;    T

;(rem ~prime (range 1 100))
;-> (1 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)

(def prime (n)
  (case n
    1 'nil
    2 't
    ((afn (x max div)
       (if (isa (/ x div) 'int) 'nil
           (> div max) 't
           'else (self x max (+ 1 div))))
     n (sqrt n) 2)))

(prime 0)

;P32 (**) Determine the greatest common divisor of two positive integer numbers.
;    Use Euclid's algorithm.
;    Example:
;    * (gcd 36 63)
;    9

(def remainder (x y)
  ((afn (x y)
     (if (> 0 x)
         (+ x y)
         (self (- x y) y)))
   (abs x) (abs y)))

(def *gcd (x y)
  (if (is 0 y)
      x
      (let r (remainder x y)
        (if (is 0 r)
            y
            (gcd y r)))))

(def gcd (n m)
  (if (is 0 m)
      n
      (gcd m (mod n m))))

(def gcd nums
  (reduce 
    (afn (x y)
      (if (is 0 y)
          x
          (let r (remainder x y)
            (if (is 0 r)
                y
                (self y r)))))
    nums))

;(gcd 1071 1029 14)
;=> 7

;(gcd 1071 14)

;P33 (*) Determine whether two positive integer numbers are coprime.
;    Two numbers are coprime if their greatest common divisor equals 1.
;    Example:
;    * (coprime 35 64)
;    T

(def coprime (x y)
  (is 1 (gcd x y)))

(def gcd (n m)
  (if (is 0 m)
      n
      (gcd m (mod n m))))

;P34 (**) Calculate Euler's totient function phi(m).
;    Euler's so-called totient function phi(m) is defined as the number of positive integers r (1 <= r < m) that are coprime to m.
;
;    Example: m = 10: r = 1,3,7,9; thus phi(m) = 4. Note the special case: phi(1) = 1.
;
;    * (totient-phi 10)
;    4
;
;    Find out what the value of phi(m) is if m is a prime
;    number. Euler's totient function plays an important role in one
;    of the most widely used public key cryptography methods (RSA). In
;    this exercise you should use the most primitive method to
;    calculate this function (there are smarter ways that we shall
;    discuss later).

(def totient-phi (n)
  ((afn (m n)
     (if (is 0 n)
         0
         (+ (if (coprime m n) 1 0)
            (self m (- n 1)))))
   n (- n 1)))

;P35 (**) Determine the prime factors of a given positive integer.
;    Construct a flat list containing the prime factors in ascending order.
;    Example:
;    * (prime-factors 315)
;    (3 3 5 7)

;(prime-factors 600851475143)
;=> (71 839 1471 6857)

(def prime-factors (n)
  ((afn (n i)
     (with (q (trunc (/ n i)) r (mod n i))
       (if (< n 2) list.n
           (is 0 r) (if (is 1 q) 
                        list.i
                        (cons i (self q i)))
           'else (self n (next-prime i)))))
   n 2))

(def next-prime (n)
  ((afn (n)
     (if (prime n)
         n
         (self (+ 1 n))))
   (+ n 1)))

;P36 (**) Determine the prime factors of a given positive integer (2).
;    Construct a list containing the prime factors and their multiplicity.
;    Example:
;    * (prime-factors-mult 315)
;    ((3 2) (5 1) (7 1))

;    Hint: The problem is similar to problem P13.

(def prime-factors-mult (n)
  ((afn (lst acc)
     (if no.lst
         rev.acc
         (self cdr.lst
               (cons `(,caar.lst ,(len car.lst)) acc))))
   (pack:prime-factors n) () ))

(prime-factors 315)

(prime-factors-mult 315)

;P37 (**) Calculate Euler's totient function phi(m) (improved).
;    See problem P34 for the definition of Euler's totient function. If the list of the prime factors of a number m is known in the form of problem P36 then the function phi(m) can be efficiently calculated as follows: Let ((p1 m1) (p2 m2) (p3 m3) ...) be the list of prime factors (and their multiplicities) of a given number m. Then phi(m) can be calculated with the following formula:

;    phi(m) = (p1 - 1) * p1 ** (m1 - 1) + (p2 - 1) * p2 ** (m2 - 1) + (p3 - 1) * p3 ** (m3 - 1) + ...

;    Note that a ** b stands for the b'th power of a.

(def phi (m)
  (apply * (map (fn (lst)
                  (let (p m) lst
                    (* (- p 1) (expt p (- m 1)))))
                (prime-factors-mult m))))

(def phi (m)
  (apply * (map (fn ((p m)) (* (- p 1) (expt p (- m 1))))
                (prime-factors-mult m))))

;    phi(m) = (p1 - 1) * p1 ** (m1 - 1) + (p2 - 1) * p2 ** (m2 - 1) + (p3 - 1) * p3 ** (m3 - 1) + ...
(def phi (m)
  (apply * (map (fn ((p m)) (* (- p 1) (expt p (- m 1))))
                (prime-factors-mult m))))

(phi 1192)
;=> 592
(prime-factors-mult 315)

((fn ((x (y z))) (list x y z)) 
 '(1 (2 3)))
;=> (1 2 3)

;P38 (*) Compare the two methods of calculating Euler's totient
;    function.  Use the solutions of problems P34 and P37 to compare
;    the algorithms. Take the number of logical inferences as a
;    measure for efficiency. Try to calculate phi(10090) as an
;    example.

;----(P34 totient-phi)-------------------------------------------
;time: 597 msec.
;
;----(P38 phi)---------------------------------------------------
;time: 69 msec.

;(let n 10090
;  (prn)
;  (prn "----(P34 totient-phi)-------------------------------------------")
;  (time (totient-phi n))
;  (prn)
;  (prn "----(P38 phi)---------------------------------------------------")
;  (time (phi n))
;  (prn)
;  nil)

;P39 (*) A list of prime numbers.
;    Given a range of integers by its lower and upper limit, construct a list of all prime numbers in that range.

(def prime-list (start end)
  (rem ~prime (range start end)))

;(prime 3)
;(prime-list 1 100)

(def goldback (n)
  (and (even n)
       (< 3 n)
       (point exit
         ((afn (i)
            (let j (- n i)
              (and (prime j)
                   (exit (list i j))))
            (self (next-prime i)))
          2))))

(def goldback (n)
  (and even.n
       (< 3 n)
       (point RETURN
         (let plst (prime-list 2 n)
           (each x plst
             (when (mem (- n x) plst)
               (RETURN:list x (- n x))))))))

(def goldback (n)
  (and even.n
       (< 3 n)
       (point RETURN
         (each x (prime-list 2 n)
           (when (prime (- n x))
             (RETURN:list x (- n x)))))))


(def goldbach (n)
  (point RETURN
    (if (or odd.n (> 4 n))
        RETURN.nil
        ((afn (i)
           (let j (- n i)
             (when prime.j
               (RETURN:list i j)))
           (self next-prime.i))
         2))))

;(goldbach 88888888888)
;=> (29 88888888859)


;;P41 (**) A list of Goldbach compositions.
;;    Given a range of integers by its lower and upper limit, print a list of all even numbers and their Goldbach composition.
;;
;;    Example:
;;    * (goldbach-list 9 20)
;;    10 = 3 + 7
;;    12 = 5 + 7
;;    14 = 3 + 11
;;    16 = 3 + 13
;;    18 = 5 + 13
;;    20 = 3 + 17

(def goldbach-list (start end)
  (each p (range start end)
    (let (x y) (goldbach p)
      (when x (prf "#p = #x + #y\n")))))

;(goldbach-list 9 20)
;=> 10 = 3 + 7
;   12 = 5 + 7
;   14 = 3 + 11
;   16 = 3 + 13
;   18 = 5 + 13
;   20 = 3 + 17

(def goldbach-list (start end)
  (each p (range start end)
    (whenlet (x y) (goldbach p)
      (prf "#p = #x + #y\n"))))

;
;;    In most cases, if an even number is written as the sum of two prime numbers, one of them is very small. Very rarely, the primes are both bigger than say 50. Try to find out how many such cases there are in the range 2..3000.
;;
;;    Example (for a print limit of 50):
;;    * (goldbach-list 1 2000 50)
;;    992 = 73 + 919
;;    1382 = 61 + 1321
;;    1856 = 67 + 1789
;;    1928 = 61 + 1867

;P41b
;(goldbach-list/b 1 2000 50)
;(goldbach-list/b 2 3000 50)

(def goldbach-list/b (start end limit)
  (each p (range start end)
    (whenlet (x y) goldbach.p
      (when (< 50 (min x y))
        (prf "#p = #x + #y\n")))))

;(goldbach-list/c 2 3000 50)
;=> 10

(def goldbach-list/c (start end limit)
  (count (fn ((x y)) (< limit (min x y)))
         (trues goldbach (range start end))))

;P46 (**) Truth tables for logical expressions.
;    Define predicates and/2, or/2, nand/2, nor/2, xor/2, impl/2 and equ/2 (for logical equivalence) which succeed or fail according to the result of their respective operations; e.g. and(A,B) will succeed, if and only if both A and B succeed. Note that A and B can be Prolog goals (not only the constants true and fail).
;
;    A logical expression in two variables can then be written in prefix notation, as in the following example: and(or(A,B),nand(A,B)).
;
;    Now, write a predicate table/3 which prints the truth table of a given logical expression in two variables.
;
;    Example:
;    * table(A,B,and(A,or(A,B))).
;    true true true
;    true fail true
;    fail true fail
;    fail fail fail


;and/2, or/2, nand/2, nor/2, xor/2, impl/2 and equ/2
(def *nand (a b) (no:and a b))
(def *nor (a b) (no:or a b))

(set *and ~*nand)
(set *or ~*nor)
(def *equ (a b) (*or (*and a b) (*and no.a no.b)))
(set *xor  ~*equ)
(def *impl (a b) (*or no.a b))

(def perm (lst)
  ((afn (u res)
     (if no.u
         res
         (self cdr.u `(,@res ,@(map [list car.u _] lst)))))
   lst () ))

(def table-print (a b f)
  (prn "\n====")
  (each (a b) (perm (list a b))
    (prf "#a : #b => ~ \n" (f a b))))

;(table t nil *impl)
;====
;t : t => t
;t : nil => nil
;nil : t => t
;nil : nil => t
;nil

;(n-of 5 'a)

(def conjunct-not-expr (expr)
  (if no.expr ()
      ;; not X ...
      (is 'not car.expr) 
      `((no ,(if (atom cadr.expr)
                  cadr.expr
                  (conjunct-not-expr cadr.expr)))
        ,@(conjunct-not-expr cddr.expr))
      ;; X ...
      (atom car.expr)
      (cons car.expr (conjunct-not-expr cdr.expr))
      ;; (X ...) ...
      'else 
      (cons (conjunct-not-expr car.expr)
            (conjunct-not-expr cdr.expr))))

(def to-prefix (expr)
  ((afn (expr)
     (if atom.expr expr
         ;; not X ...
         (and (acons expr) (is 'no car.expr)) 
         (if (acons cadr.expr)
             `(no ,(self cadr.expr))
             expr)
         ;; X ...
         (atom car.expr) 
         (let (a pred b) expr
           `(,pred ,a ,self.b))
         ;; (X ...) ...
         'else
         (let (a pred b) expr
           `(,pred ,self.a ,self.b))))
   (conjunct-not-expr expr)))

(mac table/b ((a b) . expr)
  `(do (prn "\n====")
       (each (,a ,b) (perm (list ,a ,b))
         (prf "~ : ~  => ~ \n" ,a ,b ,(to-prefix expr)))))

;(let (A B) '(t nil)
;  (table/b (A B) A *and (A *or not B)))
;=> ====
;   t: t => t
;   t: nil => t
;   nil: t => nil
;   nil: nil => nil

;(conjuct-not-expr '(not a))
;(conjuct-not-expr '(not A and (A or not B)))


;(to-prefix '(A and not (A or not B)))
;(to-prefix '(a))
;(to-prefix '(not A and not (A or not B)))

(set *operator-precedence-list* '(*and *nand *or *nor *impl *equ *xor))

(def conjunct-infix-expr (pred expr)
  (if atom.expr expr
      ;; 
      (is pred cadr.expr)
      (let (a pred b . rest) expr
        `((,(conjunct-infix-expr pred a)
           ,pred
           ,(conjunct-infix-expr pred b))
          ,@(conjunct-infix-expr pred rest)))
      ;; 
      (atom car.expr)
      (cons car.expr (conjunct-infix-expr pred cdr.expr))
      ;; 
      (is 3 (len car.expr))
      (cons car.expr (conjunct-infix-expr pred cdr.expr))
      ;; 
      'else
      (cons (conjunct-infix-expr pred car.expr)
            (conjunct-infix-expr pred cdr.expr))))

;(conjunct-infix-expr '*and '(A *and (B *or C) *equ A *and B *or A *and C))

;(set-operator-predence '(A *and (B *or C) *equ A *and B *or A *and C)
;                      *operator-precedence-list*)

(def set-operator-predence (expr precedence)
  ((afn (lst res)
     (if no.lst
         res
         (self cdr.lst (conjunct-infix-expr car.lst res))))
   precedence expr))

(def to-prefix/c (expr precedence)
  ((afn (expr)
     (if atom.expr expr
         ;; 
         (and acons.expr (is 'no car.expr))
         (if (acons cadr.expr)
             `(no ,(self cadr.expr))
             expr)
         ;; 
         (atom car.expr)
         (let (a pred b) expr
           `(,pred ,a ,self.b))
         ;; 
         'else 
         (let (a pred b) expr
           `(,pred ,self.a ,self.b))))
   (car:set-operator-predence conjunct-not-expr.expr precedence)))

;(to-prefix/c '(A *and (B *or C) *equ not A *and B *or A *and C)
;             *operator-precedence-list*)
;=> (*equ (*and A (*or B C)) (*or (*and A B) (*and A C)))

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

(def gray (n)
  (if (is 1 n)
      '("0" "1")
      (let g (gray (- n 1))
        (+ (map [+ "0" _] g)
           (map [+ "1" _] rev.g)))))

;(defmemo graym (n)
;  (if (is 1 n)
;      '("0" "1")
;      (let g (graym (- n 1))
;       (+ (map [+ "0" _] g)
;          (map [+ "1" _] rev.g)))))
;; 
;(def freq (lst)
;  (let res ()
;    (each item lst
;      (aif (assoc item res)
;          (++ cadr.it)
;          (push (list item 1) res)))
;    rev.res))

(def freq (lst)
  (let h (table)
    (each item lst 
      (if (h item)
          (++ (h item))
          (= (h item) 1)))
    (tablist h)))

;(def freq (lst)
;  (tablist
;    (w/table h
;      (each item lst 
;       (if (h item)
;           (++ (h item))
;           (= (h item) 1))))))

;(freq '(a b c d e f g g g g g e))
;=> ((a 1) (d 1) (b 1) (e 2) (c 1) (f 1) (g 5))
;(freq '(a))
;(freq '(() () a b c d "a"))

;;; (def huffman-tree (lst)
;;;   ((afn (lst)
;;;      (if single.lst caar.lst
;;;      'else
;;;      (let (a b . rest) (sort (fn (a b) (< cadr.a cadr.b)) 
;;;                           lst)
;;;        (self `(((,car.a ,car.b)  ,(+ cadr.a cadr.b)) 
;;;                ,@rest)))))
;;;    freq.lst))

(def huffman-tree (lst)
  (if no.lst
      ()
      (list
        ((afn (lst)
           (if single.lst caar.lst
               'else
               (let ((ai an) (bi bn) . rest) (sort (fn ((_ a) (_ b)) (< a b)) 
                                                   lst)
                    (self `(((,ai ,bi) ,(+ an bn))
                            ,@rest)))))
         freq.lst))))

;;; (def huffman-tree (lst)
;;;   ((afn (lst)
;;;      (if single.lst caar.lst
;;;      'else
;;;      ((fn (((ai an) (bi bn) . rest))
;;;         (self `(((,ai ,bi) ,(+ an bn))
;;;                 ,@rest)))
;;;       (sort (fn ((_ a) (_ b)) (< a b)) 
;;;             lst))))
;;;    freq.lst))


;;; (def huffman-tree (lst)
;;;   ((afn (lst)
;;;      (if no.lst ()
;;;      single.lst caar.lst
;;;      'else
;;;      ((fn (((ai an) (bi bn) . rest))
;;;         (self `(((,ai ,bi) ,(+ an bn))
;;;                 ,@rest)))
;;;       (sort (fn ((_ a) (_ b)) (< a b)) 
;;;             lst))))
;;;    freq.lst))

;(huffman-tree '(a b c d e f g g g g g e))
;=> (g ((f (b c)) ((a d) e)))

;(huffman-tree '(a b c d e f () () () () () e))

;(huffman-tree '(() ()) )
;(huffman-tree '() )
;(huffman-tree '(a a a a)) a

;(huffman-tree '()) (nil nil)

;-> ((a d) 2), (b 1), (c 1), (f 1), (e 2), (g 5)
;-> ((b c) 2), (f 1), ((a d) 2), (e 2), (g 5)
;-> ((f (b c)) 3), ((a d) 2), (e 2), (g 5)
;-> (((a d) e) 4), ((f (b c)) 3), (g 5)
;-> (((f (b c)) ((a d) e)) 7), (g 5)
;-> ((g ((f (b c)) ((a d) e))) 12)
;=> (g ((f (b c)) ((a d) e)))

;bug
;(def huffman-code-tree (lst)
;  ((afn (tree (o code ""))
;     (if (no alist.tree) `(,tree ,code)
;        no.tree ()
;        'else
;        `(,(self car.tree (+ code "1"))
;          ,(self cadr.tree (+ code "0")))))
;   (huffman-tree lst)))

(def huffman-code-tree (lst)
  (if no.lst
      ()
      (let tree (car:huffman-tree lst)
        (if atom.tree `(,tree "1")
            ((afn (tree (o code ""))
               (if (no acons.tree) `(,tree ,code)
;                  (atom alist.tree) `(,tree ,code)
                   no.tree `(,tree ,code)
                   'else
                   `(,(self car.tree (+ code "1"))
                     ,(self cadr.tree (+ code "0")))))
             tree)))))



(def huffman-code-tree (lst)
  (if no.lst
      ()
      (let tree (car:huffman-tree lst)
        (if atom.tree `(,tree "1")
            ((afn (tree (o code ""))
               (if atom.tree
                   `(,tree ,code)
                   `(,(self car.tree (+ code "1"))
                     ,(self cadr.tree (+ code "0")))))
             tree)))))


;(huffman-tree '())
;(huffman-tree '(a))
;(huffman-tree '(()))
;(huffman-tree '(() ()))

;(huffman-tree '(a b c d e f g g g g g e ()))

;(huffman-code-tree '())
;(huffman-code-tree '(a))
;(huffman-code-tree '(()))
;(huffman-code-tree '(() ()))
;(huffman-code-tree '(() () ()))
;(huffman-code-tree '(a b))
;(huffman-code-tree '(a ()))
;(huffman-code-tree '(() () a))
;(huffman-code-tree '(a b c d e f g g g g g e))
;(huffman-code-tree '(a b c d e f g g g g () ()g e))
;=> ((g "1") (((f "011") ((c "0101") (d "0100"))) (((a "0011") (b "0010")) (e "000"))))
;(huffman-code-tree '(a))
;(huffman-code-tree '())

;(huffman-code-tree '(() ()))
;(huffman-code-tree '(() () a))
;(huffman-code-tree '(b b  a c d b))


(def flatten (lst)
  (if atom.lst lst
      (atom car.lst) (cons car.lst (flatten cdr.lst))
      'else (+ (flatten car.lst) (flatten cdr.lst))))

(flatten '())
(flatten '(a (b () ((((((((((())))))))))))))

(huffman-code-tree '(() ()))
(def huffman-table (lst)
  (pair:flatten:huffman-code-tree lst))

(def exch-key/val (lst)
  (map (fn ((a b)) (list b a))
       lst))

;(huffman-table '(a b c d e f g g g g g e))
;=> ((g "1") (f "011") (c "0101") (d "0100") (a "0011") (b "0010") (e "000"))

;(huffman-table '(a b c d e f g g g g g e nil nil nil))
;=> 

;(exch-key/val (huffman-table '(a b c d e f g g g g g e)))
;=> (("1" g) ("011" f) ("0101" c) ("0100" d) ("0011" a) ("0010" b) ("000" e))

(def enhuffman (lst tab)
  (and lst
       (let h (listtab tab)
         (apply + (map [h _] lst)))))
#|
 (let lst '(a b c d e f g g g g g e nil nil)
  (let tab (huffman-table lst)
    (enhuffman lst tab)))
;=> "001100100101010000001111111000"

;(huffman-table '(a))

 (let lst '(())
  (let tab (huffman-table lst)
    (enhuffman lst tab)))


 (let lst '(() ())
  (let tab (huffman-table lst)
    (enhuffman lst tab)))
;=> ""

|#

(def dehuffman (code tab)
  (with (h (listtab (exch-key/val tab)) res () cur "")
    (each c code
      (zap + cur (string c))
      (awhen (h cur)
        (push it res)
        (= cur "")))
    rev.res))

#|
 (withs (lst (coerce "% huffman(Fs,Hs) :- Hs is the Huffman code table for the frequency table Fs" 'cons)
        tab (huffman-table lst))
  (let code (enhuffman lst tab)
    (prn "\nencode:\n" (string lst) " => " code)
    (prn "\ndecode:\n" code " => " (string (dehuffman code tab)))
    nil))

 (withs (lst '(() () ())
        tab (huffman-table lst))
  (let code (enhuffman lst tab)
    (prn "\nencode:\n" lst " => " code)
    (prn "\ndecode:\n" code " => " (dehuffman code tab))
    nil))

 (withs (lst (coerce ";laksjdfijeif;a;a;anbknkapoiapiueieie;a;kamz/zxcmvkjdief8ja//zdkjei:KLJIjef" 'cons)
        tab (huffman-table lst))
  (let code (enhuffman lst tab)
    (prn "\nencode:\n" lst " => " code)
    (prn "\ndecode:\n" code " => " (string (dehuffman code tab)))
    nil))


|#

;(len "% huffman(Fs,Hs) :- Hs is the Huffman code table for the frequency table Fs")

;encode:
;% huffman(Fs,Hs) :- Hs is the Huffman code table for the frequency table Fs => 10001000000111010010010001001110110100110101011011000101101100010000101101010000101000101111000010000101000101101010100011000011111100001000010010010001001110110100110000100111001010001111100011001101100000111111100000101001001101000110000111111000001001101111101110010011110011010011101001000110011011000001111111000011000101
;
;decode:
;10001000000111010010010001001110110100110101011011000101101100010000101101010000101000101111000010000101000101101010100011000011111100001000010010010001001110110100110000100111001010001111100011001101100000111111100000101001001101000110000111111000001001101111101110010011110011010011101001000110011011000001111111000011000101 => % huffman(Fs,Hs) :- Hs is the Huffman code table for the frequency table Fs
;nil

;----------------------------------------------------------------
;=> 16

;P54A (*) Check whether a given term represents a binary tree
;    Write a predicate istree which returns true if and only if its argument is a list representing a binary tree.
;    Example:
;    * (istree (a (b nil nil) nil))
;    T
;    * (istree (a (b nil nil)))
;    NIL

(def atree (tree)
  (if atom.tree no.tree
      'else
      (and (is 3 len.tree) 
           (let (root left right) tree
             (and atom.root root
                  atree.left
                  atree.right)))))


(atree '())
(atree '(1 2 3)) ;=> nil
(atree '((foo) nil nil)) ;=> t
(atree '(x (x nil nil) (x nil (x nil nil)))) ;=> t
(atree '(x (x nil nil) (x nil (x nil nil x)))) ;=> nil

(def cbal-tree (n)
  (if (is 0 n) '(())
      (>= 1 n) '((x () () ))
      'else
      (red (fn (res x)
             (let tree `(x ,@x)
               (if cbal-tree-p.tree
                   `(,tree ,@res)
                   res)))
           () ;init
           (let half (/ (- n 1) 2)
             (if nofraction.half
                 ;; balance
                 (comb2 cbal-tree.half
                        cbal-tree.half)
                 ;; unbalance
                 (with (g (+ 1 trunc.half) ;greater 
                        l trunc.half)      ;less
                   `(,@(comb2 cbal-tree.l
                              cbal-tree.g)
                     ,@(comb2 cbal-tree.g
                              cbal-tree.l))))))))

(def red (f init lst)
  (reduce f (cons init lst)))

(def == (x y)
  (and (>= x y) (<= x y)))

(def nofraction (num)
  (== 0 (- num (trunc num))))

(def cbal-tree-p (tree)
  (let (ro l r) tree
    (>= 1 (abs (- count-leaf.l
                  count-leaf.r)))))

(def count-leaf (tree)
  (iflet (ro l r) tree
         (+ 1 count-leaf.l count-leaf.r))
         0)

(def comb2 (xs ys)
  (mappend (fn (y) (map (fn (x) `(,x ,y)) xs))
           ys))

;(x (x (x nil nil) (x nil nil)) (x nil (x nil nil)))
;(x (x (x nil nil) (x nil nil)) (x (x nil nil) nil))
;(x (x nil (x nil nil)) (x (x nil nil) (x nil nil)))
;(x (x (x nil nil) nil) (x (x nil nil) (x nil nil)))
;nil

;P56 (**) Symmetric binary trees
;    Let us call a binary tree symmetric if you can draw a vertical
;    line through the root node and then the right subtree is the
;    mirror image of the left subtree. Write a predicate symmetric/1
;    to check whether a given binary tree is symmetric. Hint: Write a
;    predicate mirror/2 first to check whether one tree is the mirror
;    image of another. We are only interested in the structure, not in
;    the contents of the nodes.

(def mirror (tree)
  (if no.tree
      ()
      (let (rt l r) tree
        `(,rt ,mirror.r ,mirror.l))))

(def skelton (tree)
  (if no.tree
      ()
      (let (rt l r) tree
        `(x ,(skelton l) ,(skelton r)))))

(def symmetric? (tree)
  (let skel (skelton tree)
    (iso skel (mirror skel))))


;; (def symmetric? (tree)
;;   ((afn (tree)
;;      (if no.tree
;;       t
;;       (let (rt l r) tree
;;            (and (~*xor l r)
;;                 (symmetric? l)
;;                 (symmetric? r)))))
;;    tree))


(symmetric? '(x (x nil nil) (x nil (x nil nil))))
(symmetric? '(x nil (x (x (x nil nil) (x nil nil))
                       (x nil (x nil nil)))))
;=> nil

(symmetric? '(x (x (x (x nil nil) (x nil nil))
                   (x nil (x nil nil)))
                (x (x (x nil nil) nil)
                   (x (x nil nil) (x nil nil)))))

;=> t

;(x (x nil nil) (x nil nil)) 

;(iso '(x (x (x nil nil) (x nil nil)) (x nil (x (x (x nil nil) (x nil nil)) (x nil (x nil nil)))))
;     '(x (x (x nil nil) (x nil nil)) (x nil (x (x (x nil nil) (x nil nil)) (x nil (x nil nil))))))

;(reduce (fn (res x) (some res x)) '(a b c d e f))

;(all idfn '(a b c nil))

(def add-leaf (leaf tree)
  (with ((root left right) tree
         node `(,leaf () () ))
    (if (<= leaf root)
        (if no.left
            `(,root ,node ,right)
            `(,root ,(add-leaf leaf left) ,right))
        (if no.right
            `(,root ,left ,node)
            `(,root ,left ,(add-leaf leaf right))))))

(def construct (lst)
  (reduce (fn (lst leaf) (add-leaf leaf lst))
          (let (head . tail) lst
            (cons `(,head () () ) tail))))

(construct '(3 2 5 7 1))
;=> (3 (2 (1 nil nil) nil) (5 nil (7 nil nil)))

(symmetric? (construct '(5 3 18 1 4 12 21)))
;=> t

;test-symmetric([3,2,5,7,1]).
(symmetric? (construct '(3 2 5 7 1)))
;=> nil

(construct '(1 2 3 4 5))


;P58 (**) Generate-and-test paradigm

;    Apply the generate-and-test paradigm to construct all symmetric,
;    completely balanced binary trees with a given number of
;    nodes. Example:
;    * sym-cbal-trees(5,Ts).  Ts = [t(x, t(x, nil,
;    t(x, nil, nil)), t(x, t(x, nil, nil), nil)), t(x, t(x, t(x, nil,
;    nil), nil), t(x, nil, t(x, nil, nil)))]
;
;    How many such trees are there with 57 nodes? Investigate about
;    how many solutions there are for a given number of nodes? What if
;    the number is even? Write an appropriate predicate

;(def sym-cbal-trees (n)
;  (reduce (fn (res tr) (if (symmetric? tr) `(,tr ,@res) res))
;         (cons () (cbal-tree n))))

(def sym-cbal-trees (n)
  (keep symmetric? cbal-tree.n))

(each tr sym-cbal-trees.5
  prn.tr)

;sym-cbal-trees.5
;(len:sym-cbal-trees 57)
;=> 256

;(time (len:sym-cbal-trees 57))

;P59 (**) Construct height-balanced binary trees

;    In a height-balanced binary tree, the following property holds
;    for every node: The height of its left subtree and the height of
;    its right subtree are almost equal, which means their difference
;    is not greater than one.
;
;    Write a predicate hbal-tree/2 to construct height-balanced binary
;    trees for a given height. The predicate should generate all
;    solutions via backtracking. Put the letter 'x' as information
;    into all nodes of the tree.
;
;    Example:
;    * hbal-tree(3,T).
;    T = t(x, t(x, t(x, nil, nil), t(x, nil, nil)), t(x, t(x, nil, nil), t(x, nil, nil))) ;
;    T = t(x, t(x, t(x, nil, nil), t(x, nil, nil)), t(x, t(x, nil, nil), nil)) ;
;    etc......No

;(len:hbal-tree 5)

(def hbal-tree (h)
  (keep hbal-tree-p gen-tree-h.h))

;(each x (firstn 5 (hbal-tree 3)) (prn x))

;108675
(def gen-tree-h (h)
  (case h
    0 '(())
    1 '((x () ()))
    (with (h-1 (gen-tree-h (- h 1))
           h-2 (gen-tree-h (- h 2)))
      (map (fn (tree) `(x ,@tree))
           `(,@(comb2 h-1 h-1)
             ,@(comb2 h-1 h-2)
             ,@(comb2 h-2 h-1))))))



(def hbal-tree-p (tree)
  (let (_ left right) tree
    (>= 1 (abs (- tree-height.left 
                  tree-height.right)))))


(def tree-height (tree)
  (let (_ left right) tree
    (if tree
        (+ 1 (max tree-height.left
                  tree-height.right))
        0)))

;(defun max-nodes (h)
;  (1- (expt 2 h)))

(def max-nodes (h)
  (- (expt 2 h) 1))

(defun min-nodes (h)
  (do ((h h (1- h))
       (res 2 (+ 1 res acc))
       (acc 1 res))
      ((< h 3) res)))

(def min-nodes (h)
  ((afn (h res acc)
     (if (< h 3)
         res
         (self (- h 1)
               (+ 1 res acc)
               res)))
   h 2 1))

;(defun max-height (n)
;  (if (>= 1 n)
;      n
;      (do ((i 0 (1+ i)))
;          ((> (min-nodes i) n) (1- i)))))


(def max-height (n)
  (if (>= 1 n)
      n
      ((afn (i)
         (if (> (min-nodes i) n)
             (- i 1)
             (self (+ 1 i))))
       0)))

;(defun min-height (n)
;  (1+ (truncate (log n 2))))

(def min-height (n)
  (+ 1 (trunc (expt n 1/2))))

;(min-height 30)

;(expt 3 1/2)

;; (defun hbal-tree-nodes (n)
;;   (let ((min-height (min-height n))
;;         (max-height (max-height n)))
;;     (do ((h min-height (1+ h))
;;          res)
;;         ((> h max-height) res)
;;       (setq res `(,@(remove-if-not (lambda (x) (= n (count-leaf x)))
;;                                    (hbal-tree h))
;;                     ,@res)))))


(def hbal-tree-nodes (n)
  (with (min-height (min-height n)
         max-height (max-height n))
    ((afn (h res)
       (if (> h max-height)
           res
           (do 
             (pr min-height "-" max-height "-")
             
             (self (+ 1 h)
                   `(,@(keep (fn (x) (is n (count-leaf x)))
                             (hbal-tree h))
                     ,@res)))))
     min-height () )))

(hbal-tree-nodes 4)
(keep (fn (x) (is 6 (count-leaf x))) (hbal-tree 4))

(keep (fn (x) (is 8 (count-leaf (hbal-tree 3)))))


(count-leaf (hbal-tree 3))

;(load "/u/mc/lisp/Work/L-99/l99.arc")
(prn "OK")