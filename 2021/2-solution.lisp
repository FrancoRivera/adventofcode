;/var/folders/3k/fmrt9tp145j0jl96m32y7gxh0000gn/T/TemporaryItems/NSIRD_screencaptureui_iQptjs/Schermata\ 2021-12-02\ alle\ 14.23.07.png  Day 2 solution

; Finished: 26-nov-2020 (started a year before lmao)

(load "~/quicklisp/setup.lisp")

(ql:quickload "cl-ppcre")

(defun get-file (filename)
  "Get the content of the file as integers"
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

(defun first-part-solution ()
  (let ((x_position '0) (y_position '0))
	 (dolist (line (get-file "2-input.txt"))
		(let ((command (car (ppcre:split #\Space line)))
				(movement (parse-integer(cadr (ppcre:split #\Space line)))))
		  (if (string= "forward" command) ; forward
			 (setq x_position (+ movement x_position))
			 )
		  (if (string= "down" command) ; down
			 (setq y_position (+ movement y_position))
			 )
		  (if (string= "up" command) ; up
			 (setq y_position (- y_position movement))
			 )
		  )
		)
	 (format t "~D ~D ~%" x_position y_position)
	 (format t "~D ~%" (* x_position y_position))
	 )
  )

; SECOND PART

(defun second-part-solution ()
  (let ((x_position '0) (y_position '0)(aim '0))
	 (dolist (line (get-file "2-input.txt"))
		(let ((command (car (ppcre:split #\Space line)))
				(movement (parse-integer(cadr (ppcre:split #\Space line)))))
		  (if (string= "forward" command) ; forward
			 (progn (setq x_position (+ movement x_position))
					  (setq y_position (+ y_position (* movement aim))
							  )
					  ))
		  (if (string= "down" command) ; down
			 (setq aim (+ aim movement))
			 )
		  (if (string= "up" command) ; up
			 (setq aim (- aim movement))
			 )
		  )
		)
	 (format t "~D ~D ~D ~%" x_position y_position aim)
	 (format t "~D ~%" (* x_position y_position))
	 )
  )

; run both solutions
(first-part-solution)
(second-part-solution)

