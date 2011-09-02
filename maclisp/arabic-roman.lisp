;; http:// blog.practical-scheme.net/shiro/20110901-arabic-roman
;; MacLISPなら、入力と出力の基数にローマ数字を指定できるという謎機能があるので余裕!

(defun arabic-to-roman (n)
  (let ((base 'roman))
    (cond ((lessp 0 n 4000)
           (format nil "~A" n))
          ('T (error "foo!")))))

(arabic-to-roman 3999)
;=> "MMMCMXCIX"

(defun roman-to-arabic (s)
  (let ((n (let ((ibase 'roman))
             (readlist (explodec s)))))
    (cond ((lessp 0 n 4000)
           n)
          ('T (error "foo!")))))

(roman-to-arabic "MMMCMXCIX")
;=> 3999