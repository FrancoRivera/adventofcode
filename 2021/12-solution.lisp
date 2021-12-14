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

;; memoization helper
;; This is called by doing something like
;; (setf (fdefinition 'collatz-steps) (memoize #'collatz-steps))
(defun memoize (fn)
  (let ((cache (make-hash-table :test #'equal)))
    #'(lambda (&rest args)
        (multiple-value-bind
              (result exists)
            (gethash args cache)
          (if exists
              result
              (setf (gethash args cache)
                    (apply fn args)))))))

; Validation for part 1
(defun is-a-valid-path(path node)
  (if (upper-case-p (char node 0)) ; if its uppercase then shortciruit
      (= 1 1) ; return true, idk how else to do this....yet
      (not (position node path :test #'string-equal))))

;; validation needed for pt 2
(defun list-to-string (lst)
  (format nil "~{~A~}" lst))

(defun count-substrings (substring string)
  (loop
    with sub-length = (length substring)
    for i from 0 to (- (length string) sub-length)
    when (string= string substring
                  :start1 i :end1 (+ i sub-length))
      count it))

(defparameter *time* 0)
(defun run-and-record-time (fn &rest args)
  (let ((start (get-internal-real-time)) (return-value nil))
    (setf return-value (apply fn args))
    (setf *time* (+ *time* (- (get-internal-real-time) start)))
    (return-from run-and-record-time return-value)
    ))

(defparameter *paths* '())
(defun make-path (path result)
  (list :path (list-to-string path) :result result))

(defun add-path (path)
  (push path *paths*))

(defun find-path (string)
  (remove-if-not #'(lambda (node) (equal (getf node :path) string))
                 *paths*))


(defparameter *cache-hits* '0)
(defun mem-check-if-saturated (path)
  (let ((cached-result (find-path (list-to-string path)))))
  (if (> (length cached-result) 0)
      (progn
        (format t "cache hit ~%")
        (incf *cache-hits*)
        (return-from mem-check-if-saturated
          (getf (first cached-result) :result))
        )
      (add-path (make-path path (check-if-saturated path)) )
      )
  (mem-check-if-saturated path)
)

(defun mem-check-if-saturated-pt2 (path)
  (if (> (getf *paths* (read-from-string (list-to-string path))) 0)
      (progn
        (format t "cache hit ~%")
        (incf *cache-hits*)
        (return-from mem-check-if-saturated-pt2
          (getf *paths* (read-from-string (list-to-string path)))
        ))
        (setf (getf *paths* (read-from-string (list-to-string path)))
              (check-if-saturated path)))
  (mem-check-if-saturated-pt2 path))


(defun check-if-saturated (path)
  (let ((count '0))
    (loop for node in path
          when (not (upper-case-p (char node 0)))
          do
            (if (>= (count-substrings node (list-to-string path)) 2)
                (progn
                  (incf count)
                  (if (> count 3) ; 3 becasue im incrementing before hand,
                      (return-from check-if-saturated (= 2 2))
                  )))))
  (return-from check-if-saturated nil))

(setf (fdefinition 'mem-check-if-saturated-pt3) (memoize #'check-if-saturated))

(defun is-a-valid-path-pt2(path node)
  (if (upper-case-p (char node 0)) ; if its uppercase then shortciruit
      (= 1 1)
      (and
        (< (count-substrings node (list-to-string path)) 2)
        (not (or (string= node "start")))
        (= 2 3)
        ;(not (run-and-record-time #'(lambda () (mem-check-if-saturated (new-path path node)))))
        ;(not (mem-check-if-saturated-pt3 (new-path path node)))
        ;(not (check-if-saturated (new-path path node)))
      )))

;; Helpers for nodes

(defun new-path (path node)
  (let ((npath (reverse path)))
    (reverse (push node npath))))

(defparameter *nodes* ())

(defun add-node (node)
  (push node *nodes*))

(defun make-node (label edges)
  (list :label label :edges edges))

(defun add-edge-to-node (string edge)
  (setf (getf (first (find-node string)) :edges)
   (append (getf (first (find-node string)) :edges) (list edge))))

(defun find-node (string)
  (remove-if-not #'(lambda (node) (equal (getf node :label) string))
                 *nodes*))

; Implementation

(defun dfs(path string validator-fn)
  (let ((node (first (find-node string))))
    (if (string= "end" (getf node :label))
        (progn
          ;(format t "COMPLETE PATH: ~D ~%" path)
            (return-from dfs 1)))
    (loop for n in (getf node :edges)
            when (funcall validator-fn path n)
            summing (dfs (new-path path n) n validator-fn))))

(defun dfs-pt1(path string)
  (dfs path string #'is-a-valid-path))

(defun dfs-pt2(path string)
  (dfs path string #'is-a-valid-path-pt2))

(defun parse-input (line)
    (let (
          (first-token (first (ppcre:split "-" line)))
          (second-token (second (ppcre:split "-" line)))
          )
      (if (= (length (find-node first-token)) 0)
          (add-node (make-node first-token NIL))
      )
      (if (= (length (find-node second-token)) 0)
          (add-node (make-node second-token NIL))
      )
      ;(format t "Line: ~D ~D ~%" first-token second-token)
      (add-edge-to-node first-token second-token)
      (add-edge-to-node second-token first-token)
      )
)

(defun parse-file ()
  (defparameter *nodes* ())
  (loop for line in (get-file "11-input-test.txt")
  do
     (parse-input line)))

(defun first-part-solution()
  (format t "PT1: ~D paths ~%" (dfs-pt1 '("start") "start")))

(defun second-part-solution()
  (format t "PT2:  ~D paths ~%" (dfs-pt2 '("start") "start")))

(format t "=============~%")
(format t "Parsing...~%")
(parse-file)
(format t "Calculating...~%")
(first-part-solution)
(time (second-part-solution))
(format t "Total time ~f" (/ *time* internal-time-units-per-second))
