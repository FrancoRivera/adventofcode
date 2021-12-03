; Day 2 solution

; Finished: 26-nov-2020 (started a year before lmao)

(load "~/quicklisp/setup.lisp")

(ql:quickload "cl-ppcre")

;' Baggers
;https://www.youtube.com/watch?v=ocye0h5slt4

(defun get-file (filename)
  "Get the content of the file as integers"
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

(defun first-part-solution ()
	(let ((counter '0) (last '99999999999999))
	  (setq counter 0)
		(dolist (x (get-file "1-input.txt"))
		  (let (count '0)
			 (if (< last (parse-integer x))
				(setq counter (+ counter 1))
			 )
			 )
			(setq last (parse-integer x))
		  )
		(format t "~D ~%" counter)
		)
  )

; SECOND PART

(defun second-part-solution ()
  ; declare the variables
	  ; counter: Integer, stores the times the count of the new triad is bigger than the previous
	  ; last: Integer, n-1
	  ; second-last Integer, n-2
	  ; last-sum: Integer, last' triads sum
	(let ((counter '0) (last '99999999999999)(second-last '99999999999999)(last-sum '9999999999999))
	  ; set the value of counter to -1
	  (setq counter -1)
	  ; iterate thru the thing within, store each line in the variable "x"
		(dolist (x (get-file "1-input.txt"))

		  ; get the current sum, store it in the variable, current-sum
		  ; 						 sum x with n-1 and n-2
		  (let ((current-sum (+ (parse-integer x) second-last last)))
			 ; compare if last-sum < current-sum
			 (if (< last-sum current-sum)
				; print out the current and last sum (for debugging)
				(progn (format t "~D ~D ~%" current-sum last-sum)
				; increment counter by 1
				(setq counter (+ counter 1)))
			 )
			;
			; setup for next iteration
			;
			; shift last to second-last
			(setq second-last last)
			; store x as last
			(setq last (parse-integer x))
			; store current sum as last-sum
			(setq last-sum current-sum)
			 )
		  )
		; print out the counter
		(format t "~D ~%" counter)
		)
  )

dolist (value iterable)

; run both solutions
(first-part-solution)
(second-part-solution)

