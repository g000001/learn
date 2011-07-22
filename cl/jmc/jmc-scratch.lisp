(list. 3 3)

(eval. 'v '((v 3)))
;=> 3

(eval. '(quote v) '((v 3)))
;=> V


(eval. '(atom v) '((v 3)))
;=> T


(eval. '(cons v ()) '((v 3)))
;=> (3)

(eval. '(cons v (cons v (cons v))) '((v 3)))
;=> (3 3 3)







(assoc. 'v '((v 3)))




