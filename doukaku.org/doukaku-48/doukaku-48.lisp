;;;; doukaku-48.lisp

#||
data = {
    1: [2, 3, 4, 5, 7],
    2: [1],
    3: [1, 2],
    4: [2, 3, 5],
    5: [1, 3, 4, 6],
    6: [1, 5],
    7: [5],
}

?????

print pagerank
# [0.303514376997, 0.166134185304, 0.140575079872,
#  0.105431309904, 0.178913738019, 0.0447284345048,
#  0.0607028753994]

||#

(cl:in-package :doukaku-48-internal)

(def-suite doukaku-48)

(in-suite doukaku-48)

(defun max-index (vec)
  (loop :with tem := (aref vec 0)
        :for e :across vec
        :for pos :from 0
        :when (< tem e)
          :maximize pos :and :do (setq tem e)))

(defun grid-to-vec (grid)
  (let ((ans (make-array (grid:total-size grid))))
    (grid:map-grid :source grid
                   :destination ans )))

;;; pagerank
(defun pagerank (data)
  (let* ((size (length data))
         (mat (grid:make-foreign-array 'double-float
                                       :dimensions (list size size)
                                       :initial-element 0d0)))
    (dolist (elt data)
      (destructuring-bind (k . v) elt
        (let ((vlen (length v)))
          (dolist (j v)
            (setf (grid:gref mat (1- j) (1- k))
                  (/ 1.0d0 vlen) )))))
    (multiple-value-bind (eigvals eigvecs)
                         (gsll:eigenvalues-eigenvectors-nonsymm mat)
      (let* ((ev (map 'vector #'abs
                      (grid-to-vec (grid:column eigvecs
                                                (max-index
                                                 (map 'vector #'abs
                                                      (grid-to-vec eigvals) ) )))))
             (sum (reduce #'+ ev)) )
        (map 'vector (lambda (x) (/ x sum))
             ev )))))

;;; test
(defun nearly-equal-p (x y threshold)
  ;; from metatilities
  "Returns true if x and y are within threshold of each other."
  (let ((temp 0.0d0))
    (declare (type double-float temp)
             (dynamic-extent temp))
    (cond ((> x y)
           (setf temp (the double-float (- x y)))
           (< temp threshold))
          (t
           (setf temp (the double-float (- y x)))
           (< temp threshold)))))

(test :pagerank
  (let ((data '((1 . (2 3 4 5 7))
                (2 . (1))
                (3 . (1 2))
                (4 . (2 3 5))
                (5 . (1 3 4 6))
                (6 . (1 5))
                (7 . (5)) ))
        (ans '(0.303514376997 0.166134185304 0.140575079872
               0.105431309904 0.178913738019 0.0447284345048
               0.0607028753994)))
    (is (every (lambda (x y)
                 (nearly-equal-p x y 1.0d-5) )
               (pagerank data)
               ans ))))
