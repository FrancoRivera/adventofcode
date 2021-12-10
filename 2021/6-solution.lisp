
; Deps
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")

(defun get-file (filename)
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

; meme table where values are stored
(defvar table (make-array '(100000 8) :initial-element -1))
(defvar cache-hits '0)

(defun get-sum-on-day (days-to-go offset)
	(return-from get-sum-on-day (aref table (- days-to-go 1) (- offset 1)))
  )

(defun fish-life (days-to-go offset)
  (let
	 ((offspring '0)
	 (sum '0)
	 (current-day '0)
	 (og-days-to-go days-to-go)
	 (life-day offset))
	 (if (= days-to-go 0)
		(return-from fish-life 1))
	 (if (> (get-sum-on-day days-to-go offset) 0)
		(progn
	 	;(format t "Found on table: ~D ~%" (get-sum-on-day days-to-go offset))
		(setq cache-hits (+ cache-hits 1))
		(return-from fish-life (get-sum-on-day days-to-go offset))
		)
	 )
	 (loop while (< current-day (+ days-to-go 1))
			  do
			  (if (= offspring '1)
			  	(progn
				  (setq sum (+ sum (fish-life (- days-to-go current-day) 8)))
				  (setq offspring '0)
				)
				)
			  (if (= life-day 0)
				  (progn
					 (setq offspring '1)
				  	 (setq life-day '7)
				  )
				 )
			  (setq current-day (+ current-day 1))
			  (setq life-day (- life-day 1))
			  )
	 ; save value for memoization ps
	 (setf (aref table (- og-days-to-go 1) (- offset 1)) (+ sum 1))
	 (return-from fish-life (+ sum 1)))
  )

(defun make-fish (days list)
  (let ((sum '0))
  (loop for offset in list
		  do
		  (setq sum (+ sum (fish-life days (parse-integer offset))))
	 )
  (return-from make-fish sum)
  )
)
(defun first-part-solution()
  (dolist (line (get-file "6-input.txt"))
	  (format t "~D ~%" (make-fish 100000 (ppcre:split "," line)))
	 )
)
; run both solutions
;(first-part-solution)
;(format t "Cache hits: ~D ~%" cache-hits)
;(format t "TABLE: ~D ~%" table)
;(second-part-solution)


(defun add-fish (array position sum)
  	;(setq position (- position 1))
	(setf (aref array 0 position) (+ (aref array 0 position) sum))
)

(defun shift-array-to-the-left (array)
	(let ((it '1))
		(setf (aref array 0 7) (+ (aref array 0 7) (aref array 0 0)))
		(add-fish array 9 (aref array 0 0))


		(loop while (< it (second (array-dimensions array)))
				do
				(setf (aref array 0 (- it 1)) (aref array 0 it))
			 	(setq it (+ it 1))
		)
		(setf (aref array 0 9) 0)
	)
  )

(defun sum-array (array)
	(let ((it '0) (sum '0))
		(loop while (< it (second (array-dimensions array)))
				do
				(setq sum (+ sum (aref array 0 it)))
			 	(setq it (+ it 1))
	)
	(return-from sum-array sum))
)

(defun iterative-approach (days)
	(let ((fish_array (make-array'(1 10)))
			(it '0)
			(borned '0)
			)
  	(dolist (line (get-file "6-input.txt"))
		(dolist (position (ppcre:split "," line))
		  ;(format t "ADding fish to pos: ~D ~%" position)
			(add-fish fish_array (parse-integer position)1))
	)
	(format t "~D ~%" fish_array)
	(loop while (< it days)
			do
			; for every fish in the array shift them off by a single place to the left
			(shift-array-to-the-left fish_array)
			;(format t "~D ~%" fish_array)
			;(format t "~D ~%" it)
			 (setq it (+ it 1))
  )
			(format t "~D ~%" (sum-array fish_array))
)
)

;(iterative-approach 100000)


(format t "~D ~%" (+ 0.1 0.2))
(format t "~D ~%" (= (+ 0.1 0.2) 0.3))
