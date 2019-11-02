;;; -*- mode:lisp -*-
(defpackage doug
  (:use cl)
  (:export
   ))

(in-package :doug)

(defclass string-corpus () ((strings :initarg :strings)))

(defmethod open-document ((corpus string-corpus) id)
  (with-slots (strings) corpus
    (make-string-input-stream (nth id strings))))

(defclass virtual-corpus () ((sub-corpora :initarg :sub-corpora)))

(defmethod open-document ((corpus virtual-corpus) id)
  (with-slots (sub-corpora) corpus
    (let ((modulus (length sub-corpora)))
      (open-document (nth (mod id modulus) sub-corpora)
                     (floor id modulus)))))

(defclass tokenizer ()
  ((char-stream :initarg :char-stream)))
(defmethod next-token ((token-stream tokenizer))
  (with-slots (char-stream) token-stream
    (with-output-to-string (string-stream)
      (let ((in-token-p nil))
        (loop (let ((char (read-char char-stream nil)))
                (cond ((null char) ; EOF
                       (if in-token-p (return) (return-from next-token nil)))
                      ((alpha-char-p char)
                       (write-char char string-stream)
                       (setq in-token-p t))
                      (t (if in-token-p (return))))))))))

(defclass normalizer () ())
(defmethod next-tokekn ((token-stream normalizer))
  (let ((token (call-next-method)))
    (if token (string-downcase token) nil)))

(defclass stop-list ()
  ((stop-words :initform '("an" "and" "by" "for" "of" "the" "to" "with"))))
(defmethod next-token ((token-stream stop-list))
  (with-slots (stop-words) token-stream
    (loop (let ((token (call-next-method)))
            (cond ((null token) (return nil)) ; EOF
                  ((member token stop-words :test #'string=))
                  (t (return token)))))))

(defclass simple-analysis-pipeline (stop-list normalizer tokenizer) ())

(defclass simple-analyzer () ())

;; (defmethod make-token-stream ((analyzer simple-analyzer char-stream) char-stream)
(defmethod make-token-stream ((analyzer simple-analyzer) char-stream)
  (make-instance 'simple-analysis-pipeline :char-stream char-stream))

(defclass appending-token-stream () ((streams :initarg :streams)))

(defmethod next-token ((token-stream appending-token-stream))
  (with-slots (streams) token-stream
    (if streams
        (or (next-token (first streams))
            (progn (setf streams (rest streams))
              (next-token token-stream))))))

(defclass hash-store ()
  ((table :initform (make-hash-table :test #'equal))))

(defmethod get-mapping ((store hash-store) term)
  (with-slots (table) store
    (gethash term table)))

(defmethod (setf get-mapping) (value (store hash-store) term)
  (with-slots (table) store
    (setf (gethash term table) value)))

(defun map-tokens (function token-streams)
  (loop (let ((token (next-token token-streams)))
          (if token (funcall function token) (return)))))

(defclass binary-index () ())

(defmethod index-document ((index binary-index) id)
  (map-tokens #'(lambda (token) (pushnew id (get-mapping index token)))
              (make-token-stream index (open-document index id))))

(defmethod get-binary-postings ((index binary-index) term)
  (get-mapping index term))

(defmethod get-term-frequency ((index binary-index) term)
  (length (get-binary-postings index term)))

(defmethod get-frequency-postings ((index binary-index) term)
  (mapcar #'(lambda (id)
              (let ((freq 0))
                (map-tokens #'(lambda (token)
                                (if (string= token term) (incf freq)))
                            (make-token-stream index (open-document index id)))
                (cons id freq)))
    (get-binary-postings index term)))

(defmethod boolean-search ((app t) expr)
  (labels ((resolve (x)
                    (if (listp x)
                        (case (first x)
                          (and (intersection (resolve (second x)) (resolve (third x))))
                          (or (union (resolve (second x)) (resolve (third x)))))
                      (get-binary-postings app x))))
    (resolve expr)))

(defmethod relevance-search ((app t) query &optional (threshold 10))
  (let ((terms ())
        (scores ()))
    (map-tokens #'(lambda (token) (pushnew token terms :test #'string=)) query)
    (dolist (term terms)
      (let ((weight (/ 1.0 (get-term-frequency app term))))
        (dolist (freq-pair (get-frequency-postings app term))
          (let* ((id (car freq-pair))
                 (freq (cdr freq-pair))
                 (score-pair (assoc id scores)))
            (unless score-pair
              (setq score-pair (cons id 0.0)
                  scores (cons score-pair scores)))
            (incf (cdr score-pair) (* weight freq))))))
    (mapcar #'car (subseq (sort scores #'> :key #'cdr) 0 threshold))))


;; (make-instance #'appending-token-stream
(defmethod relevance-feedback ((app t) ids)
  (relevance-search
   app
   (make-instance 'appending-token-stream
     :streams (mapcar
                  #'(lambda (id)
                      (make-token-stream app (open-document app id)))
                ids))))

(defclass demo (string-corpus simple-analyzer hash-store binary-index) ()
          (:default-initargs
              :strings (mapcar #'file-to-string
                               (directory
                                (make-pathname :directory '(:relative "DOUG")
                                               :name :wild
                                               :type :wild
                                               :defaults (user-homedir-pathname)
                                               :case :common)))))

(defmethod initialize-instance :after ((app demo) &key &allow-other-keys)
  (dotimes (id (length (slot-value app 'strings)))
    (index-document app id)))

(defun file-to-string (pathname)
  (with-output-to-string (string-stream)
    (with-open-file (file-stream pathname)
      (loop (let ((char (read-char file-stream nil)))
              (if char (write-char char string-stream) (return)))))))

(defmethod print-titles ((app demo) ids)
  (dolist (id ids (values))
    (format t "~&~3D ~A~%" id (read-line (open-document app id)))))



(setq app (make-instance 'demo))

(print-titles
 app
 (boolean-search app '(and "information" (or "retrieval" "access"))))


(print-titles
 app
 (relevance-search app
                   (make-token-stream app
                                      (make-string-input-stream
                                       "information access"))))
(print-titles
 app
 (relevance-feedback app '(70 86 27)))
