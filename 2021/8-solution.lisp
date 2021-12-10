; Deps
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")

(defun get-file (filename)
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

(defun parse-string (x)
  (cond
	 ((= (length x) 2) '1)
	 ((= (length x) 3) '1)
	 ((= (length x) 4) '1)
	 ((= (length x) 7) '1)
	 (t '0)
  )
)

(defun first-part-solution()
	(format t "Solution: ~D ~%"
		(apply '+
				 (loop for line in (get-file "8-input.txt")
				collect (apply '+
				  (loop for token in (ppcre:split #\Space
						(cadr (ppcre:split "\\| " line)))
						collect (parse-string token)
					)
				  )
				 )
				)
	))

(first-part-solution)
