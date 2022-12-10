; Started: 2021-12-17 @  0:12:34

; Dependencies
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")

(defun get-file (filename)
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

; Helpers


; Problem definition

; given a target area in the form
; target area: x=88..125, y=-157..-103
; and the initial position X=0 Y=0
; the task is to shoot a probe with an initail velocity dx and dy
; for every step the dx gets reduced
; for every step the dy gets reduced towards 0 because of gravity
;
;

(defun check-if-in-target (tx ty x y)
  (and
   (>= x (first tx))
   (>= y (first ty))
   (<= x (second tx))
   (<= y (second ty)))
  )

;(defparameter ())

(defun shoot-shot (dx dy &optional (steps 1000))
  (let ((x 0) (y 0)(max-y 0) (tx '(88 125)) (ty '(-157 -103)))
  ; (let ((x 0) (y 0)(max-y 0) (tx '(20 30)) (ty '(-10 -5)))
        (loop while (> steps 0)
              do (incf x dx)
                 (incf y dy)
                 (if (> y max-y) (setf max-y y))
                 ;(format t "position after ~D steps: ~D,~D ~%" steps x y)
                 (decf dy)
                 (if (> dx 0) (decf dx))
                 (if (< dx 0) (incf dx))
                 ;(if (and (< y (second ty)) (< dy 0)) (return-from shoot-shot nil))
                 ;(if (< y (second ty)) (return-from shoot-shot nil))
                 (if (> x (second tx)) (return-from shoot-shot nil))
                 (if (and (< x (first tx)) (= dx 0)) (return-from shoot-shot nil))
                 (if (check-if-in-target tx ty x y)
                    (progn (format t "t")
                            (return-from shoot-shot (list x y max-y))
                        ))
                 (decf steps))))

(progn
  (let ((max-y 0))
    (loop for x from 0 to 1000
          do (loop for y from 0 to 1000
            do (let ((result (third (shoot-shot x y))))
                 (if (and result (> result max-y))
                     (setf max-y result))
            )))
    (format t "~%max in x n y ~D ~%" max-y)
  ))

(progn
  (let ((max-y 0)(results '()))
    (loop for x from 0 to 1000
          do (loop for y from -1000 to 1000
            do (let ((result (shoot-shot x y 100000)))
                 (if result (push result results))
            )))
    (format t "~% Results ~D ~%" (length results))
  ))

(format t "~D ~%" (third (shoot-shot 6 3)))
; Implementation

(clear-output)

; Parsing...

(defparameter +DAY+ 17)

(defun parse-file (file-name)
	(let ((lines-read '0))
	 (loop for line in (get-file (concat +DAY+ "-" file-name ".txt"))
		do
		(loop for char in (ppcre:split "" line)
			do (format t "~D" char))
		(incf lines-read))))

; (parse-file "test-input") ;uncomment to parse test
; (parse-file "input")      ;uncomment to parse real input


;; Part 1

(defun first-part-solution ()
       (format t "First part solution is: ~D ~%" "Answer"))

;; Part 2
(defun second-part-solution ()
       (format t "First part solution is: ~D ~%" "Answer"))


;; Run solutions
(first-part-solution)
(second-part-solution)
