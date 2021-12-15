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

; memo helpers peter norvig

(defmacro defun-memo (fn args &body body)
  "Define a memoized function."
  `(memoize (defun ,fn ,args . ,body)))

(defun memo (fn &key (key #'first) (test #'eql) name)
  "Return a memo-function of fn."
  (let ((table (make-hash-table :test test)))
    (setf (get name 'memo) table)
    #'(lambda (&rest args)
        (let ((k (funcall key args)))
          (multiple-value-bind (val found-p)
              (gethash k table)
            (if found-p val
                (setf (gethash k table) (apply fn args))))))))

(defun memoize (fn-name &key (key #'first) (test #'eql))
  "Replace fn-name's global definition with a memoized version."
  (clear-memoize fn-name)
  (setf (symbol-function fn-name)
        (memo (symbol-function fn-name)
              :name fn-name :key key :test test)))

(defun clear-memoize (fn-name)
  "Clear the hash table from a memo function."
  (let ((table (get fn-name 'memo)))
    (when table (clrhash table))))

; Validations


;; Helpers for nodes

(defun new-path (path node)
  (let ((npath (reverse path)))
    (reverse (push node npath))))

(defparameter *rules* ())

(defun add-rule (rule)
  (push rule *rules*))

(defun make-rule (pair insert)
  (list :pair pair :insert insert :count '0))

(defun find-rule (string)
  (remove-if-not #'(lambda (rule) (equal (getf rule :pair) string))
                 *rules*))

; pt2
(defun find-rule-r (string rules)
  (first (remove-if-not #'(lambda (rule) (equal (getf rule :pair) string))
                 rules)))

(defparameter *expansions* '())

(defparameter table (make-hash-table :test #'eql))

(defun add-ke (string result)
  (setf (gethash string table) result))

(defun find-ke (string)
  (gethash string table))


  ; (getf (first (remove-if-not #'(lambda (ke) (equal (getf ke :string) string)) *rules*)) :expansion))
; Implementation
(defparameter *seed* "")

(defun do-n-steps (n)
  (let ((new-string *seed*))
    (dotimes (i n)
      (new-new-expand-seed))
    (return-from do-n-steps new-string)))

(defun expand-rule (rule)
  (list
   (first (find-rule (concatenate 'string
                (subseq (getf rule :pair) 0 1) ;first letter
                (getf rule :insert))))
   (first (find-rule (concatenate 'string
                (getf rule :insert)
                (subseq (getf rule :pair) 1 2) ;second letter
    )))
   ))

(defun new-new-expand-seed ()
  (let (
        (og_rules (copy-tree *rules*))
        (temp_rules (copy-tree *rules*)))
  (loop for rule in *rules*
        when (> (getf (find-rule-r (getf rule :pair) og_rules) :count) 0)
        do
           (loop for exp_rule in (expand-rule rule)
                 do
                    (setf (getf exp_rule :count) (+
                                                    (getf (find-rule-r (getf rule :pair) og_rules) :count)
                                                    (getf (find-rule-r (getf exp_rule :pair) *rules*) :count)
                                                  ))
                 )
        )
    ; destroy original rules
    (loop for rule in *rules*
        when (> (getf (find-rule-r (getf rule :pair) og_rules) :count) 0)
          do (setf (getf rule :count) (- (getf rule :count)
                                         (getf (find-rule-r (getf rule :pair) og_rules) :count))))
    ))


(defun get-insert (letter)
  (getf (first (find-rule letter)) :insert))

(defun new-expand-seed (seed)
  (let ((new-string ""))
    ;(format t " Length: ~D: ~D ~%" seed (length seed))
    (if (<= (length seed) 1) (return-from new-expand-seed seed))
    (if (= (length seed) 2)
            (return-from new-expand-seed (concatenate 'string
                                                      (subseq seed 0 1) ; first letter
                                                      (get-insert (subseq seed 0 2))
                                                      (subseq seed 1 2))) ; second letter
        (progn
          ; early exit
        (if (find-ke seed) (return-from new-expand-seed (find-ke seed)))
          (let ((mid-point 0))
            (if (evenp (length seed))
                (setf mid-point (/ (length seed) 2))
                (setf mid-point (/ (+ (length seed) 1) 2)))
            (let ((left (new-expand-seed (subseq seed 0 mid-point)))
                  (right (new-expand-seed (subseq seed (- mid-point 1) (length seed)))))
            (setf new-string (concatenate 'string left (subseq right 1 (length right)))
              )))))
    (add-ke seed new-string)
    (return-from new-expand-seed new-string)))

(defun expand-seed (seed)
  (let ((new-string ""))
    (dotimes (i (- (length seed) 1))
        (setf new-string (concatenate 'string new-string  (subseq seed i (+ i 1))))
        (setf new-string (concatenate 'string new-string (get-insert (subseq seed i (+ i 2))))))
        (setf new-string (concatenate 'string new-string  (subseq seed (- (length seed) 1) (length seed) )))
    (return-from expand-seed new-string)))

(defun count-substrings (substring string)
  (loop
    with sub-length = (length substring)
    for i from 0 to (- (length string) sub-length)
    when (string= string substring
                  :start1 i :end1 (+ i sub-length))
      count it))

(defun count-letters-in-string (string)
  (let ((results '()))
    (dotimes (i (- (length string) 1))
      (if (= (length results) 10) (return-from count-letters-in-string results))
      (if (or (= (length results) 0) ; skip firs titeration
              (equal nil (position (subseq string i (+ i 1))
                           (subseq string 0 i) :test #'string-equal)))
        (push (count-substrings (subseq string i (+ i 1)) string) results)
       ))
    (return-from count-letters-in-string results)))

;; Parsing

(defparameter iterations '0)
(defun parse-input (line)
    (let* ((tokens  (ppcre:split " -> " line))
          (first-token (first tokens))
          (second-token (second tokens)))
      (cond ((= iterations 0)
             (setf *seed* line))
             ((> (length line) 0)
             (add-rule (make-rule first-token second-token))))
      (incf iterations)))


;; parse file
(defun parse-file ()
  (defparameter *nodes* ())
  (loop for line in (get-file "14-input.txt")
  do
     (parse-input line)))

;; Executiton
;;
(defun maximum (list)
  (reduce #'max list))

(defun minimum (list)
  (reduce #'min list))

(defun first-part-solution ()
    (let* (
        (result (count-letters-in-string (do-n-steps 10)))
        (min (minimum result))
        (max (maximum result))
        (sub (- max min)))
        (format t "PT 1: ~D ~D~%" sub result)))

(defun second-part-solution ()
    (dotimes (i (- (length *seed*) 1))
      (let ((rule (first (find-rule (subseq *seed* i (+ i 2))))))
      (incf (getf rule :count))
      ;(format t "Count: ~D ~%" (subseq *seed* i (+ i 2)))
      ))

    (let* (
        (result (do-n-steps 40))
        )
      (parse-rules)
      (loop for key being the hash-keys of letters
        using (hash-value value)
        do (format t "~S: ~S~%" key value))
      (let* ((result
                (loop for key being the hash-keys of letters
                  using (hash-value value)
                  collect value)
              )
              (min (minimum result))
              (max (maximum result))
              (sub (- (/ (+ max 1)  2) (/ min 2)))
              )
            (format t "RESULT ~D ~% MAX ~D ~% MIN ~D ~% SUB: ~D ~%" result max min sub)

        )
      ))


(defparameter letters (make-hash-table :test #'eql))

(defun add-count-to-letter (char count)
  (setf (gethash char letters) (+ (or (gethash char letters) 0 ) count)))

(defun parse-rules()
  (loop for rule in *rules*
        do
           (add-count-to-letter (char (getf rule :pair) 0) (getf rule :count)) ; get first char
           (add-count-to-letter (char (getf rule :pair) 1) (getf rule :count)) ; get second char
                                      ; )
  ))

(format t "=============~%")
(format t "Parsing...~%")
(parse-file)
(format t "Calculating...~%")
;(time (first-part-solution))
;(time (format t "ey ~D: ~%" (do-n-steps 10)))
(time (second-part-solution))
