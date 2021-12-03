; Day 2 solution

; Finished: 26-nov-2020 (started a year before lmao)

(load "~/quicklisp/setup.lisp")

(ql:quickload "cl-ppcre")

; https://lispcookbook.github.io/cl-cookbook/regexp.html
; https://regexr.com/
(defun parse-policy (policy)
  (ppcre:register-groups-bind (min max token string)
										("([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)" policy :sharedp t)
										(list min max token string)
										)
  )

;' Baggers
;https://www.youtube.com/watch?v=ocye0h5slt4

(defun get-file (filename)
  "Get the content of the file as integers"
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

; Count letter char in a given string str
(defun countletter (char str &aux counter)
  (setq counter 0)
  (let ((string str))
	 ; http://cs.hiram.edu/~walkerel/cs152/lesson6.html
	 (loop for idex from 0 to (- (length string) 1)
			 do
			 (if (string= char (string (aref string idex)))
				(setq counter (+ counter 1))
				)
			 )
	 )
  (return-from countletter counter)
  )

(defun first-part-solution ()
	(let (counter '0)
	  (setq counter 0)
		(dolist (x (get-file "2-input.txt"))
		  (let (count '0)
			 (setq count (countletter (caddr (parse-policy x))
											  (cadddr (parse-policy x))
											  ))
			 ; https://www.tutorialspoint.com/lisp/lisp_if_construct.htm
			 (if (check-policy
				; min
				; https://stackoverflow.com/questions/10989313/how-can-i-convert-a-string-to-integer-in-common-lisp
				(parse-integer (car (parse-policy x)))
				; max
				(parse-integer (cadr (parse-policy x)))
				; count of chars
				count
				)
				(setq counter (+ counter 1))
			 )
			 )
		  )
		(format t "~D ~%" counter)
		)
  )

(defun check-policy (min max count)
  (and
	 (>= count min)
	 (>= max count)
	 )
  )

; SECOND PART

(defun get-letter-in-position (position string)
  (string (aref string (- (parse-integer position) 1))
))

; https://groups.google.com/g/comp.lang.lisp/c/H3KqqtkvjQo/m/5qr8bZn0uBkJ
(defmacro xor (v1 v2)
	`(not (eq (not ,v1) (not ,v2))))
	(defun check-second-policy (first second char string)
	  (xor
		 (string= char (get-letter-in-position first string))
		 (string= char (get-letter-in-position second string))
	  )
)

(defun second-part-solution ()
(let (counter '0)
	(setq counter 0)
(dolist (x (get-file "2-input.txt"))
  (let (count '0)
	 (setq count (countletter (caddr (parse-policy x))
									  (cadddr (parse-policy x))
									  ))
	 ; https://www.tutorialspoint.com/lisp/lisp_if_construct.htm
	 (if (check-second-policy
		; first position
		(car (parse-policy x))
		; second position
		(cadr (parse-policy x))
		; char
		(caddr (parse-policy x))
  		; string to be searched
		(cadddr (parse-policy x))
		)
		(setq counter (+ counter 1))
	 )
	 )
  )
(format t "~D ~%" counter)
))

; run both solutions
(first-part-solution)
(second-part-solution)

