(in-package :paip)

;; 問題 6.1
;; コンパイルコードがないとき，あるいはあってもそれがソースコードの日付
;; より古い時にはソースコードをコンパイルし，その後 fasl ファイルをロー
;; ドする関数 compile&load-paip-file と compile&load-paip-files を定義
;; せよ．

(defun compile&load-paip-file (name)
  (let ((fasl (paip-pathname name :binary))
        (src  (paip-pathname name :source)) )
    (load (if (and (probe-file fasl)
                   (> (file-write-date fasl)
                      (file-write-date src) ))
              fasl
              (compile-file src :output-file fasl) ))))

(defun compile&load-paip-files ()
  (mapc #'compile&load-paip-file *paip-files*))
