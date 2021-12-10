; Deps
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")

(defun get-file (filename)
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

(defvar opening "{<([" )
(defvar closing "}>)]")
(defvar points-list ")]}>")
(defvar points-pt2 "A([{<")
(defvar points '( 3 57 1197 25137) )
(defvar stack '())

(defun without-last(l)
    (reverse (cdr (reverse l)))
    )

(defun first-part-solution()
	(let ((sum '0) (symbol nil) (haserror nil) (sum-pt2 '0) (sums '()) )
	 (loop for line in (get-file "10-input.txt")
		do
		(setq stack '())
		(loop for i from 0 to (- (length line) 1)
			do
			(setq symbol (char line i))
			(if (numberp (position symbol opening)) ;
				 ; if opening symbol then push it into stack
				 (setq stack (append stack (list symbol)))
				; if closing symbol then pop the stack and see if its of the same type
				(progn
				 (if (=
						 (position (car (last stack)) opening)
						 (position symbol closing)
						)
					(+ 1 2)
					;(format t "." ) ; just for the memes
					(progn
					  (setq sum (+ sum (nth (position symbol points-list) points))) ; add the sum boy
					  ;(format t "found error ~D ~%" symbol)
					  (setq haserror t)
					  ; zero out stack
					)
				)
				(setq stack (without-last stack))
				 )
			); end of if
		)
		(if haserror
			(setq haserror nil)
			(progn
				(loop for symbol in (reverse stack)
					do
					(setq sum-pt2 (+ (* 5 sum-pt2) (position symbol points-pt2)))
					)
				(setq sums (append sums (list sum-pt2)))
				(setq sum-pt2 0)
			)
		)
	 )
	(format t "Solution ~D ~%" sum)
	(format t "Solution-2 ~D ~%" (nth (/ (- (length sums) 1) 2) (sort sums '<)))
	)
)

(first-part-solution)
