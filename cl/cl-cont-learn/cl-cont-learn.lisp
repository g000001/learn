;;;; cl-cont-learn.lisp

(cl:in-package :cl-cont-learn-internal)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun no-funcall (srm char)
    (declare (ignore char))
    (cons 'cl:funcall (read-delimited-list #\} srm 'T)))

  (editor-hints.named-readtables:defreadtable :no-funcall
      (:merge :standard)
    (:syntax-from :cl #\) #\})
    (:macro-char #\{ #'no-funcall)))

(editor-hints.named-readtables:in-readtable :no-funcall)
;; emacs
;; (progn (modify-syntax-entry ?\{ "(}") (modify-syntax-entry ?\} "){"))
;; (def-lisp-indentation letrec 1)
;; (def-lisp-indentation coroutine 1)

(def-suite cl-cont-learn)

(in-suite cl-cont-learn)

;; http://www.sampou.org/scheme/t-y-scheme/t-y-scheme-Z-H-15.html

(defun/cc tree->generator (tree &aux caller)
  (letrec ((generate-leaves
            (lambda ()
              (let lp ((tree tree))
                   (cond ((null tree) 'skip)
                         ((consp tree)
                          (lp (car tree))
                          (lp (cdr tree)))
                         (:else
                          (call/cc
                           (lambda (rest-of-tree)
                             (setq generate-leaves rest-of-tree)
                             {caller tree})))))
              {caller '()} )))
    (lambda ()
      (call/cc
       (lambda (k)
         (setq caller k)
         {generate-leaves})))))

(defun same-fringe?1 (tree1 tree2)
  (let ((gen1 (tree->generator tree1))
        (gen2 (tree->generator tree2)))
    (let lp ()
         (let ((leaf1 {gen1})
               (leaf2 {gen2}))
           (if (eql leaf1 leaf2)
               (or (null leaf1) (lp))
               nil)))))

(test :same-fringe?1
  ;; :size 17ぐらいでスタックがあふれる。どのあたりが原因か。
  (for-all ((x (gen-tree :size 16)))
    (is-true (same-fringe? x x))))

;;; coroutine
(defmacro coroutine (x &rest body)
  `(with-call/cc
     (letrec ((+local-control-state
               (lambda (,x) ,@body))
              (resume
               (lambda (c v)
                 (call/cc
                  (lambda (k)
                    (setq +local-control-state k)
                    {c v})))))
       (lambda (v)
         {+local-control-state v}))))


(defun make-matcher-coroutine (tree-cor-1 tree-cor-2)
  (coroutine dont-need-an-init-arg
    (let lp ()
         (let ((leaf1 {resume tree-cor-1 'get-a-leaf})
               (leaf2 {resume tree-cor-2 'get-a-leaf}))
           (if (eql leaf1 leaf2)
               (or (null leaf1) (lp))
               nil)))))

(defun make-leaf-gen-coroutine (tree matcher-cor)
  (coroutine dont-need-an-init-arg
    (let lp ((tree tree))
         (cond ((null tree) 'skip)
               ((consp tree)
                (lp (car tree))
                (lp (cdr tree)))
               (:else
                {resume matcher-cor tree})))
    {resume matcher-cor '()}))

(defun same-fringe? (tree1 tree2)
  (letrec ((tree-cor-1 (make-leaf-gen-coroutine
                        tree1
                        (lambda (v) {matcher-cor v})))
           (tree-cor-2 (make-leaf-gen-coroutine
                        tree2
                        (lambda (v) {matcher-cor v})))
           (matcher-cor (make-matcher-coroutine
                         (lambda (v) {tree-cor-1 v})
                         (lambda (v) {tree-cor-2 v}))))
    {matcher-cor 'start-ball-rolling}))

(test :same-fringe?
  ;; :size 17ぐらいでスタックがあふれる。どのあたりが原因か。
  (for-all ((x (gen-tree :size 16)))
    (is-true (same-fringe? x x))))

;; eof