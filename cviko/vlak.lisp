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

(defun sloupec (m i)
	(if (null m)
		NIL
		(cons (nth i (car m)) (sloupec (cdr m) i))))

(write (rozmer (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12))))
(write (rozmer3 (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12))))
(write (radek (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)) 2))
(write (sloupec (list (list 1 2 3) (list 4 5 6) (list 7 8 9)) 1))

