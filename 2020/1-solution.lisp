; Day 1;
; Given a list of numbers find two numbers a and b, that add up to 2020 and return the product of the numbers(a*b);


; Snippet to check if a variable is of certain type (for debugging)
  ; (cond ((symbolp int-numbers)
  ;       ;; If X is a symbol, put it on LIST.
  ;       (write "IS A SIMBol"))
  ;      ((listp int-numbers)
  ;       ;; If X is a list, add its elements to LIST.
  ;       (write "IS A LIST"))
  ;      (t
  ;       ;; We handle only symbols and lists.
  ;       (error "Invalid argument %s in add-on" numbers)))

;;Recursively print the elements of a list
(defun print-list (elements)
    (cond
        ((null elements) '()) ;; Base case: There are no elements that have yet to be printed. Don't do anything and return a null list.
        (t
            ;; Recursive case
            ;; Print the next element.
            (write-line (write-to-string (car elements)))
            ;; Recurse on the rest of the list.
            (print-list (cdr elements))
        )
    )
)

(defun get-file (filename)
"Get the content of the file as integers"
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))


(defun check-solution-list (numbers)
  (let ((int-numbers (loop for n in numbers collect (parse-integer n))))
  (if (= 2020 (apply #'+ int-numbers))
	(apply #'* int-numbers)
	0)))

; 2 variables
(dolist (x (get-file "1-input.txt"))
  (dolist (y (get-file "1-input.txt"))
    (let ((result (check-solution-list (list x y))))
      (if (> result 0)
	(format t "~D ~%" result)))))

; 3 variables
(dolist (x (get-file "1-input.txt"))
  (dolist (y (get-file "1-input.txt"))
    (dolist (z (get-file "1-input.txt"))
      (let ((result (check-solution-list (list x y z))))
	(if (> result 0)
	  (format t "~D ~%" result)
	  )
	))))



