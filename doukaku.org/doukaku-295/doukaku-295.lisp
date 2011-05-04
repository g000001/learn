;;;; doukaku-295.lisp
;;;; http://ja.doukaku.org/295/

(cl:in-package :doukaku-295-internal)

(def-suite doukaku-295)

(in-suite doukaku-295)

;;; "doukaku-295" goes here. Hacks and glory await!

;;; ファイル名の表示順序としてWindows Vista以降のExplorerや、KDEの
;;; Dolphinでもいつの間にか、単純な辞書順ソートではなく数字混じりの文字
;;; 列を数字順に並べるソートが採用されています。ここではそのソート方法
;;; を数字混じり文字列ソートと呼びます。
;;;
;;; さて、数字混じり文字列ソートを実装してください。なお入力される文字
;;; はASCII文字を仮定して構いませんが、日本語の扱える文字コードにも対応
;;; していればより理想的です。
;;;
;;; 以下に、数字混じり文字列ソートでの挙動の例を示します。
;;;
;;; 例1:
;;;
;;; 辞書順ソート: 1.txt, 10.txt, 100.txt, 2.txt, 20.txt
;;;
;;; 数字混じり文字列ソート: 1.txt, 2.txt, 10.txt, 20.txt, 100.txt
;;;
;;; 例2:
;;;
;;; 辞書順ソート: x12, x13, x1A, x1B, xAB
;;;
;;; 数字混じり文字列ソート: x1A, x1B, x12, x13, xAB
;;;
;;; 例3:
;;;
;;; 辞書順ソート: A10B1, A10B10, A10B2, A1B1, A1B10, A1B2, A2B1, A2B10, A2B2
;;;
;;; 数字混じり文字列ソート: A1B1, A1B2, A1B10, A2B1, A2B2, A2B10, A10B1, A10B2, A10B10

(defun decompose-string (str)
  (flet ((*parse-integer (str)
           (if (digit-char-p (char str 0))
               (parse-integer str)
               str)))
    (let (ans)
      (ppcre:do-register-groups ((#'*parse-integer d))
                                ("(\\d+|\\D+)" str)
        (push d ans))
      (nreverse ans))))

(test decompose-string
  (is (equal (decompose-string "01.txt")
             '(1 ".txt")))
  (is (equal (decompose-string "100.txt")
             '(100 ".txt"))))

(defun string<-or-< (x y)
  (etypecase x
    (integer (< x y))
    (string (string< x y))))

(test string<-or-<
  (is-true (string<-or-< 1 2))
  (is-true (string<-or-< "a" "b"))
  (is-false (string<-or-< "a" "a"))
  (is-false (string<-or-< "b" "a"))
  (is-false (string<-or-< 0 0))
  (is-false (string<-or-< 1 0)))

(defun string<-or-<* (x y)
  (mapc (lambda (x y)
          (or (equal x y)
              (return-from string<-or-<*
                (string<-or-< x y))))
        (decompose-string x)
        (decompose-string y))
  nil)

(test string<-or-<*
  (is-true (string<-or-<* "A1B2" "A1B10"))
  (is-true (string<-or-<* "001.txt" "2.txt")))

;;
(test example-1
  (let ((data-1 (list "1.txt" "10.txt" "100.txt" "2.txt" "20.txt"))
        (data-2 (list "x12" "x13" "x1A" "x1B" "xAB"))
        (data-3 (list "A10B1" "A10B10" "A10B2" "A1B1" "A1B10" "A1B2" "A2B1" "A2B10" "A2B2")))
    ;; 辞書順ソート
    (is (equal (sort (copy-list data-1) #'string<)
               data-1))
    ;; 数字混じり文字列ソート
    (is (equal (sort (copy-list data-1) #'string<-or-<*)
               (list "1.txt" "2.txt" "10.txt" "20.txt" "100.txt")))

    ;; 辞書順ソート
    (is (equal (sort (copy-list data-2) #'string<)
               data-2))
    ;; 数字混じり文字列ソート
    (is (equal (sort (copy-list data-2) #'string<-or-<*)
               (list "x1A" "x1B" "x12" "x13" "xAB")))

    ;; 辞書順ソート
    (is (equal (sort (copy-list data-3) #'string<)
               data-3))
    ;; 数字混じり文字列ソート
    (is (equal (sort (copy-list data-3) #'string<-or-<*)
               (list "A1B1" "A1B2" "A1B10" "A2B1" "A2B2" "A2B10" "A10B1" "A10B2" "A10B10")))))

;; eof