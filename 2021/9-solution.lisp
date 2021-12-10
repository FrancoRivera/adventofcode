; Deps
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")

(defun get-file (filename)
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

(defvar matrix (make-array '(100 100) :initial-element -1))
(defvar result-matrix (make-array '(5 10) :initial-element -1))
(defvar kernel (make-array '(3 3) :initial-element 0))
(setf (aref kernel 0 1) 1)
(setf (aref kernel 1 0) 1)
(setf (aref kernel 1 1) 0)
(setf (aref kernel 1 2) 1)
(setf (aref kernel 2 1) 1)
; 0 1 0
; 1 1 1
; 0 1 0

; Sharpen Kernel
;(setf (aref kernel 0 1) -1)
;(setf (aref kernel 1 0) -1)
;(setf (aref kernel 1 1) 5)
;(setf (aref kernel 1 2) -1)
;(setf (aref kernel 2 1) -1)
; 0 -1 0
; -1 5 -1
; 0 -1 0


(defun convolution-matrix (matrix)
	(let* ((dim (array-dimensions matrix))
		(row (first dim))
		(col (second dim))
		(suma '0))
		(loop for i from 0 to (- row 1)
			do
			(loop for j from 0 to (- col 1)
				do
						; loop kernel
						(let* ((dim (array-dimensions kernel))
							(krow (first dim))
							(kcol (second dim))
							(sum '0)
							(minimum t)
							)
							(loop for ki from 0 to (- krow 1)
								do
								(loop for kj from 0 to (- kcol 1)
									do
									(if
									  ; check if outside the matrix ( too small)
									  (and
										 (>= (+ i (+ ki -1)) 0)
										 (>= (+ j (+ kj -1)) 0)
										 ; check if out of bounds (too large)
										 (<= (+ i (+ ki -1)) (- row 1))
										 (<= (+ j (+ kj -1)) (- col 1))
										)
									  ; retrieve the value and multiplie it by the value of the kernel
									  (if (= 1 (aref kernel ki kj))
										 (if (<= (aref matrix
																(+ i (+ ki -1))
																(+ j (+ kj -1))
																)
													(aref matrix i j)
											)
											(setq minimum NIL)
										)
										;(setq sum (+ sum (*
														;(aref kernel ki kj)
														;(aref matrix
																;(+ i (+ ki -1))
																;(+ j (+ kj -1))
																;))))
									   ;(format t " ~D ~D - "
																;(+ i (+ ki -1))
																;(+ j (+ kj -1))
										;)
									  )))
				  )
				(setf (aref result-matrix i j) sum)
				(if minimum
				  (progn
				  	(setq suma (+ suma  (aref matrix i j) 1))
					(format t "~D at ~D,~D ~%" suma i j)
					)
				  (setq minimum t)
				)
				) ; end of let
			; next loop
		))
		(format t "~D ~%" suma)
	)
)


(defun first-part-solution()
	(let ((row '0) (col '0))
	 (loop for line in (get-file "9-input-test.txt")
		do
		(loop for digit in (ppcre:split "" line)
			do
			(setf (aref matrix row col) (parse-integer digit))
			(setq col (+ col 1))
		)
		(setq col 0)
		(setq row (+ row 1))
	 )
	)
	;(format t "~% ogmatrix ~D ~%" matrix)
	(convolution-matrix matrix)
	;(format t "~% matrix ~D ~%" result-matrix)
)

(defvar visited-matrix (make-array '(100 100) :initial-element -1))
(defvar queue ())

; finds all connected points and returns the count
(defun abfs (x y)
  (let ((queue (list (list x y)
							))
		  (element 0))
	 (loop while (> (length queue) 0)
			 do
			 ; 1. Pop first element
			 (setq (car queue )
			 ; 1.b. remove from queue (implementing pop functionality)
			 (setq queue (cdr queue))
			 ; find neighbours
			 	; top (0, -1)
			 	; left (-1, 0)
			 	; right (1, 0)
			 	; bottom (0, 1)
				(loop for pair in (list '(0 -1) '(-1 0) '(1 0) '(0  1))
						do
						(if
						  ; check if outside the matrix ( too small)
						  (and
							 (>= (+ x (car pair) 0))
							 (>= (+ y (cadr pair) 0))
							 ; check if out of bounds (too large)
							 (<= (+ x (car pair)) (- 10 1)) ; rows
							 (<= (+ y (cadr pair)) (- 5 1)) ; columns
							)
						  ; true

						  ; false
						  )
				  )
			 ; check bounds
			 ; enqueue if not visited and not 9
			 )
	)
  )
  )

(defun bfs (i j )
  (let (sum '0)
  	(setq sum 0)

	(if
	  ; check if outside the matrix ( too small)
	  (and
		 (>= i 0)
		 (>= j 0)
		 ; check if out of bounds (too large)
		 (< i 100) ; columns
		 (< j 100) ; rows
		)
	   (format t ".")
	  	(return-from bfs '0)
	  )


	; for each of the cells in the matrix;
	(if (= (aref matrix i j) 9)
	  (return-from bfs '0)
	 )
	; check if its visited
	(if (= (aref visited-matrix i j) 1)
	  (return-from bfs '0)
	)
	; mark node as visited
	(setf (aref visited-matrix i j) 1)

  (setq sum (+ sum (bfs (- i 1)  j))) ; top
  (setq sum (+ sum (bfs (+ i 1)  j))) ; bottom
  (setq sum (+ sum (bfs i  (- j 1)))) ; left
  (setq sum (+ sum (bfs i  (+ j 1)))) ; right
  (return-from bfs (+ sum 1))
  )
)

(defun find-friends (matrix)
	(let* ((dim (array-dimensions matrix))
		(row (first dim))
		(col (second dim))
		(friends '())
		(suma '1))
		(loop for i from 0 to (- row 1)
			do
			(loop for j from 0 to (- col 1)
				do
				; next loop
				(setq friends (append friends (list (bfs i j))))
		))
		(format t "Solution: ~D ~%" (apply '* (subseq (sort friends '>) 0 3)))
	)
)


(defun second-part-solution()
	(let ((row '0) (col '0))
	 (loop for line in (get-file "9-input.txt")
		do
		(loop for digit in (ppcre:split "" line)
			do
			(setf (aref matrix row col) (parse-integer digit))
			(setq col (+ col 1))
		)
		(setq col 0)
		(setq row (+ row 1))
	 )
	)
	(format t "~% matrix ~D ~%" (find-friends matrix))
)

;(first-part-solution)
(second-part-solution)
