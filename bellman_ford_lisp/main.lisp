; VAROVANI
; z nasledujiciho kodu se vam dost mozna bude chtit zvracet
; jedna se o 1:1 prepis z C
; a = matice sousednosti
; p = matice predchudcu
; d = matice vzdalenosti
; n = pocet uzlu

(defvar n_max 100)
(defvar a (make-array (list n_max n_max) :initial-element 0))
(defvar p (make-array (list n_max) :initial-element -1))
(defvar d (make-array (list n_max) :initial-element 999))
(defvar n 0)

(defun create_edge (i j v)
	(decf i)
	(decf j)
	;(format t "D a[~D][~D]=~D~%" i j v)
	(setf (aref a i j) v) 
	(setf (aref a j i) v)
	a)

(defun read_edges (r)
	(if (= r 0)
		a
		(progn
			;(format t "D read_edges: r=~D~%" r)
			(create_edge (read) (read) (read))
			(read_edges (- r 1)))))

(defun relax (i j)
	;(format t "D relax! n=~D i=~D j=~D ~%" n i j)
	(if (> (aref a i j) 0)
		(if (< (+ (aref d i) (aref a i j)) (aref d j))
			(progn
				;(format t "D     Relaxing!~%")
				(setf (aref d j) (+ (aref d i) (aref a i j)))
				(setf (aref p j) i)))))

(defun cost_inner (i j acc)
	(if (>= j 0)
		(cost_inner j (aref p j) (+ acc (aref a i j)))
		acc))

(defun cost ()
	(cost_inner (- n 1) (aref p (- n 1)) 0))

(defun reverse_edges_inner (i j)
	(if (>= j 0)
		(progn
			(setf (aref a j i) (- 0 (aref a j i)))
			(reverse_edges_inner j (aref p i)))))

(defun reverse_edges ()
	(reverse_edges_inner (- n 1) (aref p (- n 1))))

(defun bellman_ford ()
	(setf p (make-array (list n_max) :initial-element -1))
	(setf d (make-array (list n_max) :initial-element 999))
	(setf (aref d 0) 0)
	(dotimes (k n) (dotimes (i n) (dotimes (j n)
		(progn
			;(format t "D bellman k=~D i=~D j=~D~%" k i j)
			(relax i j)))))
	a)

(defun back_to_jail ()
	(if (= (aref p (- n 1)) -1)
	 T
	 NIL))

(defun run (n_param)
	(setf n n_param)
	(if (= n 0)
		(quit)
		(progn
			;(format t "D n=~D~%" n)
			(read_edges (read))
			(bellman_ford)
			(if (back_to_jail)
				(format t "Back to jail~%")
				(progn
					(setf x (cost))
					;(format t "D Second run! ~D ~%" x)
					(reverse_edges)
					(bellman_ford)
					(if (back_to_jail)
						(format t "Back to jail~%")
						(format t "~D~%"
							(+ x (cost))))))))
		(run (read)))

(run (read))
