;;;; doukaku-294.lisp

(cl:in-package :doukaku-294-internal)

(def-suite doukaku-294)

(in-suite doukaku-294)

(defun |nnn.nnn.nnn.nnn-to-integer| (string)
  (do ((ns (split-sequence:split-sequence #\. string)
           (cdr ns))
       (sh 24 (- sh 8))
       (ans 0
            (+ ans (ash (parse-integer (car ns)) sh))))
      ((endp ns) ans)))

(test :|nnn.nnn.nnn.nnn-to-integer|
  (is (= (|nnn.nnn.nnn.nnn-to-integer| "192.168.1.1")
         3232235777)))

#|(defun |integer-to-nnn.nnn.nnn.nnn| (integer)
  (do ((pos 24 (- pos 8))
       (ans () (cons (ldb (byte 8 pos) integer)
                      ans)))
      ((minusp pos)
       (format nil "~{~D~^.~}" (nreverse ans)))))|#

;; こっちの方が効率良さそうだけどどうなんだろう
(defun |integer-to-nnn.nnn.nnn.nnn| (integer)
  (with-output-to-string (out)
    (do ((pos 24 (- pos 8)))
        (nil)
      (princ (ldb (byte 8 pos) integer) out)
      (when (zerop pos) (return))
      (princ "." out))))

(test :|integer-to-nnn.nnn.nnn.nnn|
  (is (string= (|integer-to-nnn.nnn.nnn.nnn| 3232235777)
               "192.168.1.1")))

(test :int->address->int
  (for-all ((a (gen-integer :max #xffffffff :min 0)))
    (is (= a
           (|nnn.nnn.nnn.nnn-to-integer|
            (|integer-to-nnn.nnn.nnn.nnn| a))))))

(defun print-network-address (address mask &optional (out *standard-output*))
  (let* ((n (|nnn.nnn.nnn.nnn-to-integer| address))
         (m (|nnn.nnn.nnn.nnn-to-integer| mask))
         (a (|integer-to-nnn.nnn.nnn.nnn| (logand n m))))
    (format out "~A/~D" a (logcount m))))

(test :print-network-address
  (is (string= (with-output-to-string (out)
                 (print-network-address  "192.168.1.1" "255.255.255.0" out))
               "192.168.1.0/24")))

;; eof