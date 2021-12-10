; Deps
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")

(defun get-file (filename)
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))


(defun maximum (list)
  (reduce #'max list))

(defun minimum (list)
  (reduce #'min list))


(defun first-part-solution()
  (dolist (line (get-file "7-input.txt"))
	 (let ((positions (loop for position in (ppcre:split "," line)
		collect (parse-integer position)))
			 (it '0)
			 (cost '999999)
			 (aux_cost '0)
			 )
	  (setq it (minimum positions))
	 (loop while (< it (maximum positions))
			 do
			 (setq aux_cost 0)
			 (loop for crab in positions
					 do
					 (setq aux_cost (+ aux_cost (abs (- it crab))))
			)
			 (if (< aux_cost cost)
				(setq cost aux_cost)
			)
			(setq it (+ 1 it))
		)
		(format t "~D ~%" (maximum positions))
		(format t "~D ~%" (minimum positions))
		(format t "~D ~%" cost)
	 )
  )
)

(defun second-part-solution()
  (dolist (line (get-file "7-input.txt"))
	 (let ((positions (loop for position in (ppcre:split "," line)
		collect (parse-integer position)))
			 (it '0)
			 (cost '99999999999)
			 (aux_cost '0)
			 )
	  (setq it (minimum positions))
	 (loop while (< it (maximum positions))
			 do
			 (setq aux_cost 0)
			 (loop for crab in positions
					 do
					 (setq aux_cost (+ aux_cost (/ (*  (abs (- it crab))
																   (+ (abs (- it crab)) 1))
																	2)
																	))
			)
			 (if (< aux_cost cost)
				(setq cost aux_cost)
			)
			(setq it (+ 1 it))
		)
		(format t "~D ~%" (maximum positions))
		(format t "~D ~%" (minimum positions))
		(format t "~D ~%" cost)
	 )
  )
)


;(first-part-solution)
(second-part-solution)
