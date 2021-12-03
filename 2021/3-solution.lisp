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
  (let (
		  (count_0 '0)
		  (count_1 '0)
		  (count_2 '0)
		  (count_3 '0)
		  (count_4 '0)
		  (count_5 '0)
		  (count_6 '0)
		  (count_7 '0)
		  (count_8 '0)
		  (count_9 '0)
		  (count_10 '0)
		  (count_11 '0)
		  )
	 (dolist (line (get-file "3-input.txt"))
		; Do something with the input
			(setq count_0 (+ count_0 (digit-char-p (char line 0))))
			(setq count_1 (+ count_1 (digit-char-p (char line 1))))
			(setq count_2 (+ count_2 (digit-char-p (char line 2))))
			(setq count_3 (+ count_3 (digit-char-p (char line 3))))
			(setq count_4 (+ count_4 (digit-char-p (char line 4))))
			(setq count_5 (+ count_5 (digit-char-p (char line 5))))
			(setq count_6 (+ count_6 (digit-char-p (char line 6))))
			(setq count_7 (+ count_7 (digit-char-p (char line 7))))
			(setq count_8 (+ count_8 (digit-char-p (char line 8))))
			(setq count_9 (+ count_9 (digit-char-p (char line 9))))
			(setq count_10 (+ count_10 (digit-char-p (char line 10))))
			(setq count_11 (+ count_11 (digit-char-p (char line 11))))
		)
	 (if (> count_0  500)
		(setq count_0 1) ; tnumber is 1
		(setq count_0 0)
		)
	 (if (> count_1  500)
		(setq count_1 1) ; tnumber is 1
		(setq count_1 0)
		)
	 (if (> count_2  500)
		(setq count_2 1) ; tnumber is 1
		(setq count_2 0)
		)
	 (if (> count_3  500)
		(setq count_3 1) ; tnumber is 1
		(setq count_3 0)
		)
	 (if (> count_4  500)
		(setq count_4 1) ; tnumber is 1
		(setq count_4 0)
		)
	 (if (> count_5  500)
		(setq count_5 1) ; tnumber is 1
		(setq count_5 0)
		)
	 (if (> count_6  500)
		(setq count_6 1) ; tnumber is 1
		(setq count_6 0)
		)
	 (if (> count_7  500)
		(setq count_7 1) ; tnumber is 1
		(setq count_7 0)
		)
	 (if (> count_8  500)
		(setq count_8 1) ; tnumber is 1
		(setq count_8 0)
		)
	 (if (> count_9  500)
		(setq count_9 1) ; tnumber is 1
		(setq count_9 0)
		)
	 (if (> count_10  500)
		(setq count_10 1) ; tnumber is 1
		(setq count_10 0)
		)
	 (if (> count_11  500)
		(setq count_11 1) ; tnumber is 1
		(setq count_11 0)
		)

	 	(let ((gamma '0) (epsilon '0))
	 	(setq gamma (+
		  (binary-to-decimal count_0 11)
		  (binary-to-decimal count_1 10)
		  (binary-to-decimal count_2 9)
		  (binary-to-decimal count_3 8)
		  (binary-to-decimal count_4 7)
		  (binary-to-decimal count_5 6)
		  (binary-to-decimal count_6 5)
		  (binary-to-decimal count_7 4)
		  (binary-to-decimal count_8 3)
		  (binary-to-decimal count_9 2)
		  (binary-to-decimal count_10 1)
		  (binary-to-decimal count_11 0)
		))

	 	(setq epsilon (+
		  (binary-to-decimal (flip count_0) 11)
		  (binary-to-decimal (flip count_1) 10)
		  (binary-to-decimal (flip count_2) 9)
		  (binary-to-decimal (flip count_3) 8)
		  (binary-to-decimal (flip count_4) 7)
		  (binary-to-decimal (flip count_5) 6)
		  (binary-to-decimal (flip count_6) 5)
		  (binary-to-decimal (flip count_7) 4)
		  (binary-to-decimal (flip count_8) 3)
		  (binary-to-decimal (flip count_9) 2)
		  (binary-to-decimal (flip count_10) 1)
		  (binary-to-decimal (flip count_11) 0)
		))
	 	(format t "~D ~%" (* gamma epsilon))
		)

	 	;(format t "~D ~%" (cl-parse-integer (format nil "~{~A~}" '( count_0 count_1 count_2 count_3 count_4 count_5 )) :radix 2))
	 	; (write-to-string count_0)
		(format t "~D ~D ~D ~D ~D ~%" count_0 count_1 count_2 count_3 count_4 count_5)
	 )
  )

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
		  (most_common_bit '0)
		  (iteration '0)
		  (conditions "")
		  )
	 (loop while (< iteration 5)
			 do
		(setq count 0)
		(setq lines 0)
	 	(dolist (line (get-file "3-input-test.txt"))
		; Do something with the input
			(setq count (+ count (digit-char-p (char line iteration))))
			(setq lines (+ lines 1))
		)
		 (if (> count  (/ lines 2))
			(setq count 1) ; tnumber is 1
			(setq count 0)
			)
		 (setq conditions (concatenate 'string conditions (string 1)))
		(setq iteration (+ 1 iteration))
	 )
	 )
  )

; run both solutions
(first-part-solution)
(second-part-solution)

