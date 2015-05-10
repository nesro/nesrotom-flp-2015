; MI-FLP FitBreak lisp
; authors: {nesrotom,tatarsan}@fit.cvut.cz

; Warning: this is not a good example of functional approach. We use a 2D matrix
; as matrix storage. A list of lists would be much better.

; a = adjacency matrix (matice sousednosti)
; p = predecessor matrix (matice predchudcu)
; d = distance matrix (matice vzdalenosti)
; n = nodes count (pocet uzlu)

(defconstant n_max 100)
(defconstant infinity 999999)
(defvar a (make-array (list n_max n_max) :initial-element 0))
(defvar p (make-array (list n_max) :initial-element -1))
(defvar d (make-array (list n_max) :initial-element infinity))
(defvar n 0)

(defun create_edge (i j v)
	(decf i)
	(decf j)
	(setf (aref a i j) v) 
	(setf (aref a j i) v))

(defun read_edges (r)
	(when (> r 0)
		(create_edge (read) (read) (read))
		(read_edges (- r 1))))

(defun relax (i j)
	(when (and (> (aref a i j) 0) (< (+ (aref d i) (aref a i j)) (aref d j))
		(setf (aref d j) (+ (aref d i) (aref a i j)))
		(setf (aref p j) i))))

(defun cost_inner (i j acc)
	(if (>= j 0)
		(cost_inner j (aref p j) (+ acc (aref a i j)))
		acc))

(defun cost ()
	(cost_inner (- n 1) (aref p (- n 1)) 0))

(defun reverse_edges_inner (i j)
	(when (>= j 0)
		(setf (aref a j i) (- 0 (aref a j i)))
		(reverse_edges_inner j (aref p i))))

(defun reverse_edges ()
	(reverse_edges_inner (- n 1) (aref p (- n 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We cannot use iterative-cycles in your code. So, this is recursive! 8-)
(defun recRelA (k)
	(if (<= k n)
		(progn
			(recRelB 0)
			(recRelA (+ k 1)))))
(defun recRelB (j)
	(if (<= j n)
		(progn
			(recRelC 0 j)
			(recRelB (+ j 1)))))
(defun recRelC (i j)
	(if (< i n)
		(progn
			(relax j i)
			(recRelC (+ i 1) j))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun bellman_ford ()
	(setf p (make-array (list n_max) :initial-element -1))
	(setf d (make-array (list n_max) :initial-element infinity))
	(setf (aref d 0) 0)
	(recRelA 0))
; We cannot use dotimes. :C If we could, this is an elegant solution:
;	(dotimes (k n) (dotimes (i n) (dotimes (j n)
;			(relax i j))))

(defun back_to_jail ()
	(if (= (aref p (- n 1)) -1)
	(progn
		(format t "Back to jail~%")
		NIL)
	 T))

(defun run (n_param)
	(setf n n_param)
	(if (= n 0)
		(quit)
		(progn
			(read_edges (read))
			(bellman_ford)
			(if (back_to_jail)
				(progn
					(setf x (cost))
					(reverse_edges)
					(bellman_ford)
					(if (back_to_jail)
						(format t "~D~%"
							(+ x (cost))))))))
		(run (read)))

(run (read))

