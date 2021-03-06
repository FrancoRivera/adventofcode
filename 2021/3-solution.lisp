; Finished: 11:41
(defun get-file (filename)
  "Get the content of the file as integers"
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

(defun first-part-solution ()
  (let (
		  (lines '0)
		  (count '0)
		  (iteration '0)
		  (columns 12)
		  )
	 (let ((most_common_bits (loop while (< iteration columns)
			 do
				(setq count 0)
				(setq lines 0)
				(dolist (line (get-file "3-input.txt"))
					(setq count (+ count (digit-char-p (char line iteration))))
					(setq lines (+ lines 1))
				)
				 (if (> count  (/ lines 2))
					(setq count 1)
					(setq count 0)
					)
				(setq iteration (+ 1 iteration))
		  	 collect count)))

	 	(let ((gamma '0) (epsilon '0) (it '0) (power '0))
			(loop for bit in most_common_bits
					do
					(setq power (- (length most_common_bits) 1 it))
					(setq gamma (+ gamma (binary-to-decimal bit power)))
					(setq epsilon (+ epsilon (binary-to-decimal (flip bit) power)))
					(setq it (+ 1 it))
			)
			(format t "~D ~D ~%" gamma epsilon)
			(format t "~D ~%" (* gamma epsilon))
		)
	 )))

(defun flip (bit)
  (if (= bit 0)
	 (return-from flip 1)
	 (return-from flip 0)
  )
  )

(defun binary-to-decimal (bit power)
  (* bit (expt 2 power))
  )

; SECOND PART

(defun second-part-solution ()
  (let (
		  (lines '0)
		  (count '0)
		  (iteration '0)
		  (inputs (get-file "3-input.txt"))
		  (oxygen '0)
		  (co2 '0)
		  (columns 12)
		  )
	 ; get oxygen
	 (loop while (< iteration columns)
			 do
				(setq count 0)
				(setq lines 0)
				(dolist (line inputs)
					(setq count (+ count (digit-char-p (char line iteration))))
					(setq lines (+ lines 1))
				)
				 (if (>= count  (/ lines 2))
					(setq count 1)
					(setq count 0)
				)
				(setq inputs (loop for line in inputs
				  		when (= count (digit-char-p (char line iteration)))
						collect line
				))
			(setq iteration (+ 1 iteration))
		)
	 (setq oxygen (car inputs))
	 ; reset variables
	 (setq inputs (get-file "3-input.txt"))
	 (setq iteration 0)

	 ; get c02
	 (loop while (and (< iteration columns) (> (length inputs) 1))
			 do
				(setq count 0)
				(setq lines 0)
				(dolist (line inputs)
					(setq count (+ count (digit-char-p (char line iteration))))
					(setq lines (+ lines 1))
				)
				 (if (>= count  (/ lines 2))
					(setq count 1)
					(setq count 0)
				)
				(setq inputs (loop for line in inputs
				  		when (not (= count (digit-char-p (char line iteration))))
						collect line
				))
			(setq iteration (+ 1 iteration))
		)
	 (setq co2 (car inputs))
	(let ((oxy 0) (co '0) (it '0) (power '0))
			(loop while (< it columns)
					do
					(setq power (- columns 1 it))
					(setq oxy (+ oxy (binary-to-decimal (digit-char-p (char oxygen it)) power)))
					(setq co (+ co (binary-to-decimal (digit-char-p (char co2 it)) power)))
					(setq it (+ 1 it))
			)
			(format t "~D ~D ~%" oxy co)
			(format t "~D ~%" (* oxy co))
		)
	 )
	 )
  ;)

; run both solutions
(first-part-solution)
(second-part-solution)

