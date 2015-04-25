(defun rozmer (m)
	(cons (length m) (length (car m))))

(defun rozmer2 (m)
	(if (null m)
		0
		(+ 1 (rozmer2 (cdr m)))))

(defun rozmer3 (m)
	(cons (rozmer2 m) (rozmer2 (car m))))

(defun radek (m i)
	(if (= i 0)
		(car m)
		(radek (cdr m) (- i 1))))


;(defun diagonala (m)
;	(if (not (null m))
;		(append (nth (length m) (car m)) (list (diagonala (cdr m))))))
;(write (diagonala (list (list 1 2 3) (list 4 5 6) (list 7 8 9))))
;(defun lastcol (m)
;	(if (not (null (car m)))
;		(append (last (car m)) (lastcol (cdr m)))))
;(defun tr (m)
;	(write m)
;	(format t "~%")
;	(if (not (null m))
;		(cons (lastcol m) (tr (cdr m)))))
;(defun oloup (m)
;	(if (not (null m))
;		(append (car m) (oloup (tr (cdr m))))))

;(write (tr (list (list 1 2 3) (list 4 5 6) (list 7 8 9))))
;(write (oloup (list (list 1 2 3) (list 4 5 6) (list 7 8 9))))

;(defun cc-list (l)
;	(mapcar #'identity l))
;(write (cc-list (list 1 2 3)))

(defun ctverec (x)
	(* x x))

(defun mapuj (f l)
	(let ((empty nil))
		(dolist (x l)
			(write x)
			(format t "    a~%")
			(write empty)
			(format t "    b~%")
			(if (not (null x))
				(setf empty (append (list empty) (funcall f x))))))
		empty)

(defun mapuj2 (f l)
	(if (> (length l) 0)
		(append (list (funcall f (car l))) (mapuj2 f (cdr l)))))
;(write (mapuj2 #'ctverec '(1 -2 3 4)))

(defun mapsabat (f l)
	;(write (length l))
	(if (= (length l) 2)
		(funcall f (car l) (car (cdr l)))
		(funcall f (car l) (mapsabat f (cdr l)))))
(write (mapsabat #'+ '(1 2 3)))


(defun sloupec (m i)
	(if (not (null m))
		(cons (nth i (car m)) (sloupec (cdr m) i))))
(defun trans (m)
	(transX m (- (length (car m)) 1)))
(defun transX (m i)
	(if (atom m)
		m
		(if (= i 0)
			(list (sloupec m i))
			(cons (sloupec m i) (transX m (- i 1))))))
(defun oloupej (m)
	(if (not (null m))
		(append (car m) (oloupej (trans (cdr m))))))
;(write (oloupej (list (list 1 2 3) (list 4 5 6) (list 7 8 9))))
;(write (oloupej (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12))))




;(write (trans (list (list 1 2) (list 3 4)(list 5 6)) 1))
;(write (trans (list (list 1 2 3) (list 4 5 6) (list 7 8 9)) 2))
;(write (trans (list (list 4 5 6) (list 7 8 9)) 2))
;(write (trans (list (list 1 2 3) (list 4 5 6) (list 7 8 9)) 3))
;(write (sloupec (list (list 1 2) (list 3 4)) 0))
;(write (sloupec (list (list 1 2) (list 3 4)) 1))





; swap prvni a druhy item v listu
(defun swap (m)
	(cons (cadr m) (cons (car m) (cddr m))))

(defun swap2 (m)
	(cond
		(null m) NIL) ; n=0
		(null (cdr S) S) ; n=1
		(T (swap m))) ; 1 < n

;(write (rozmer (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12))))
;(write (rozmer3 (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12))))
;(write (radek (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)) 2))
;(write (sloupec (list (list 1 2 3) (list 4 5 6) (list 7 8 9)) 1))
;(write (swap (list 1 2 3)))
