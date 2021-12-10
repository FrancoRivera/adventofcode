; Began 11:48
; Finished: 11:41


; Deps
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")


(defun get-file (filename)
  "Get the content of the file as integers"
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

(defun is-zero-length  (a)
  (= (length a) 0)
)

; http://www.cs.us.es/cursos/lp-2002/trabajo/matrices.pdf
(defun suma-columnas (a)
(let* ((dim (array-dimensions a))
(f (first dim))
(c (second dim))
(res (make-array (list c))))
(loop for i from 0 to (- c 1)
do (setf (aref res i)
(loop for j from 0 to (- f 1)
summing (aref a j i))))
res))

(defun suma-filas (a)
(let* ((dim (array-dimensions a))
(f (first dim))
(c (second dim))
(res (make-array (list c))))
(loop for i from 0 to (- c 1)
do (setf (aref res i)
(loop for j from 0 to (- f 1)
summing (aref a j i))))
res))

(defun check-if-bingo (aux-array)
  )

(defun process-bingo (bingo numbers)
  (let (
		  (calc '0)
		  (iteration '0)
		  ; matrix stuff
		  (row '0) (column '0)
		  (aux-array (make-array '(5 5) :initial-element 0))
		  (numbers (ppcre:split "," numbers)))

	 (loop for digit in digits
			 do
			 )
	(format t "-~D- ~%" bingo)
	(return-from process-bingo (list calc iteration))
  ))

(defun first-part-solution ()
  (let (
		  (lines '0)
		  ; matrix stuff
		  (row '0) (column '0)
		  (iteration '0)
		  (numbers "")
		  (best-try '0)
		  (best-calc '0)
		  (bingo (make-array '(5 5) :initial-element 0))
		  )
			(dolist (line (get-file "4-input-test.txt"))
	 			; first line of the input is the numbers drawn
			  	(if (= lines 0)
				  (setq numbers line)
				  (progn
					 	(if (= (length line) 0)
						  (progn
							 	(process-bingo bingo numbers)
		  						(setq bingo (make-array '(5 5) :initial-element 0))
							)
						  (progn
								; split line into tokens
								(let ((tokens (ppcre:split #\Space line)))
								(setq tokens (remove " " tokens))
								(setq tokens (remove-if #'is-zero-length tokens))
								;(format t "-~D- ~%" tokens)
								(setq column 0)
								(loop for digit in tokens
										do
										;iterate tokens and set them in the matrix
										(setf (aref bingo row column) digit)
										(setq column (+ column 1))
								)
								; increment row number
								(setq row (+ row 1))
								(if (= row (length tokens))
								; if row == token length reset value of row to 0
								  (setq row 0)
								)
							 )
						  )
					  )
				  )
				)
				(setq lines (+ lines 1))
			)
	 ))

; SECOND PART

(defun second-part-solution ()
)
  ;)

; run both solutions
(first-part-solution)
(second-part-solution)

