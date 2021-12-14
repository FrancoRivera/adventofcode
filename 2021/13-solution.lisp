
;; Deps
;;
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")

;; Helper to read file contents
(defun get-file (filename)
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

;; Implementation
;;
(defparameter matrix (make-array '(1500 1500) :initial-element 0))

(defun fold-matrix-x (matrix y)
  (let ((aux (make-array '(1500 1500) :initial-element 0)))
	(let* ((dim (array-dimensions matrix))
		(row (first dim))
		(col (second dim)))
       ; copy og values
		(loop for i from 0 to (- y 1)
			do
			(loop for j from 0 to (- col 1)
				do
                   (if (= 1 (aref matrix i j))
                    (setf (aref aux i j) 1))))
        ; copy below the fold values
		(loop for i from y to (- row 1)
			do
			(loop for j from 0 to (- col 1)
				do
                   (if (= 1 (aref matrix i j))
                       (setf (aref aux (- y (- i y)) j) 1)))))

    (return-from fold-matrix-x aux)))

(defun fold-matrix-y (matrix x)
  (let ((aux (make-array '(1500 1500) :initial-element 0)))
	(let* ((dim (array-dimensions matrix))
		(row (first dim))
		(col (second dim)))
       ; copy og values
		(loop for i from 0 to (- row 1)
			do
			(loop for j from 0 to (- x 1)
				do
                   (if (= 1 (aref matrix i j))
                    (setf (aref aux i j) 1))
                  ))
        ; copy below the fold values
		(loop for i from 0 to (- row 1)
			do
			(loop for j from x to (- col 1)
				do
                   (if (= 1 (aref matrix i j))
                       (setf (aref aux i (- x (- j x))) 1)))))
    (return-from fold-matrix-y aux)))


(defun count-ones (matrix)
	(let* ((dim (array-dimensions matrix))
		(row (first dim))
		(col (second dim))
		(suma '0))
       ; copy og values
		(loop for i from 0 to (- row 1)
			do
			(loop for j from 0 to (- col 1)
				do
                   (if (= 1 (aref matrix i j))
                    (incf suma))
                  ))
      (return-from count-ones suma)))

(defparameter folds '())

; char at 11 y lo que venga luego del =
;
;; parsing
(defun parse-input (line)
  (let ((tokens (ppcre:split "," line)))
    (if (> (length tokens) 1)
        ; set tokens in matrix
        (setf (aref matrix (parse-integer (second tokens)) (parse-integer (first tokens))) 1)
        (if (> (length line) 0) ; remove nils
            ; folds go here
            ; (format t "Folds go: ~d ~%" line)
            (push (list (char line 11) (parse-integer (second (ppcre:split "=" line)))) folds))
    )
))

(defun parse-file ()
  ; reinitialize variables
  (defparameter folds '())
  ; loop over contents of files
  (loop for line in (get-file "13-input.txt")
  do
     (parse-input line)))

(defun first-part-solution()
    (let ((fold (first (reverse folds))))
      (cond ((char= (first fold) #\x)
             (setq matrix (fold-matrix-y matrix (second fold))))
            ((char= (first fold) #\y)
             (setq matrix (fold-matrix-x matrix (second fold))))))
  (format t "PT1: ~D visible dots after folding: ~%"
            (count-ones matrix)))

(defun pretty-print (matrix)
	(let* ((dim (array-dimensions matrix))
		(row (first dim))
		(col (second dim)))
       ; copy og values
		(loop for i from 0 to (- row 1)
			do
			(loop for j from 0 to (- col 1)
				do
                   (if (= 1 (aref matrix i j))
                       (format t "#")
                       (format t " ")
                       ))
                    (format t"~%"))))

(defun second-part-solution()
    (loop for fold in (reverse folds)
          do
          ; (format t "Folding in ~D ~%" fold)
        (if (char= (first fold) #\x)
            (setq matrix (fold-matrix-y matrix (second fold)))
            )
        (if (char= (first fold) #\y)
            (setq matrix (fold-matrix-x matrix (second fold)))
            ))
  ; make smaller array to be able to see it
  (let ((aux (make-array '(10 100) :initial-element 0)))
	(let* ((dim (array-dimensions aux))
		(row (first dim))
		(col (second dim)))
       ; copy og values
		(loop for i from 0 to (- row 1)
			do
			(loop for j from 0 to (- col 1)
				do
                   (if (= 1 (aref matrix i j))
                    (setf (aref aux i j) 1)))))

    (format t "PT2: after folding: ~%")
    (pretty-print aux)))


(format t "=============~%")
(format t "Parsing...~%")
(parse-file)
(format t "Calculating...~%")
(first-part-solution)
(time (second-part-solution))
; (format t "Total time ~f" (/ *time* internal-time-units-per-second))
