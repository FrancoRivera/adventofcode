; Dep
(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")

(defun get-file (filename)
  (with-open-file (stream filename)
	 (loop for line = (read-line stream nil)
			 while line
			 collect line)))

(defparameter rows 500)
(defparameter cols 500)

(defparameter *matrix* (make-array '(500 500) :initial-element 0))

;; Implementation
;;
;;
(defparameter destination '(0 0))

(defun parse-file ()
	(let ((row '0) (col '0))
	 (loop for line in (get-file "15-input.txt")
		do
		(loop for digit in (ppcre:split "" line)
			do
			(setf (aref *matrix* row col) (parse-integer digit))
            (incf col))
		(setq col 0)
		(incf row))
    (setf destination (list col col))))

(defparameter BIG-NUMBER '9999999)
; cost of the cheapeast path from start to n
(defparameter *gscore* (make-array '(500 500) :initial-element BIG-NUMBER))
; gScore in N + h(n)
; current best guest
(defparameter *fscore* (make-array '(500 500) :initial-element BIG-NUMBER))
(defparameter *hscore* (make-array '(500 500) :initial-element BIG-NUMBER))

(defun heuristic-fn (x y)
  (+ x y))

(defun make-node (x y)
  (list :x x :y y ))

(defun find-lowest-f-score (set)
  (let ((minimum '99999999) (min-node nil))
    (loop for node in set
            do
               (if (<= (aref *fscore*
                            (getf node :y)
                            (getf node :x)
                            )
                   minimum)
                   (progn
                     (setf minimum (aref *fscore* (getf node :y) (getf node :x)))
                     (setf min-node node)))
                        ;(format t "looping")
          )
    (if (= minimum 99999999) (setf min-node (first set)))
    ;(format t "min is ~D ~D of set: ~D ~%" minimum min-node set)
    (return-from find-lowest-f-score min-node))
  )

(defun find-node-in-set (set x y)
    (loop for node in set
            do
               (if (and
                    (= (getf node :y) y)
                    (= (getf node :x) x))
                    (return-from find-node-in-set node))))


(defun a* (start-x start-y goal_x goal_y heuristic-fn)
  (let ((open-set (list (make-node start-x start-y))))
    ; cameFrom[n]
    ; start value for start = 0;
    (setf (aref *gscore* start-y start-x) 0);
    ; start value of fssocre is (0 + h[start])
    (setf (aref *fscore* start-y start-x) (funcall heuristic-fn start-x start-y));
    (loop while (> (length open-set) 0)
          do
             (let* ((current (find-lowest-f-score open-set))
                    (current_x (getf current :x))
                    (current_y (getf current :y)))
               (if ( and (= current_x goal_x)
                         (= current_Y goal_y))
                ;; destination boy
                (progn (format t "EZ bois")
                       (return-from a* "EZ")))
               (setf open-set (remove current open-set)) ; remove element from list
               (let ((neighbours '(
                                (0 -1) ; top
                                (0 1) ; bottom
                                (1 0) ; right
                                (-1 0)))) ; left
                 (loop for neighbour in neighbours
                    do
                       (let* ((possible-g-score NIL)
                             (dx (first neighbour))
                             (dy (second neighbour))
                             (nx (+ current_x dx))
                             (ny (+ current_y dy)))
                         ; ouf of bounds validations
                         (if (and (>= nx 0)
                                  (>= ny 0)
                                  (<= nx goal_x)
                                  (<= ny goal_y))
                             (progn
                                        ;(format t "Got here ~D ~D c ~D ~D ~%" nx ny current_x current_y)
                               (setf possible-g-score (+ (aref *matrix* ny nx) ; weigth of the edge
                                                              (aref *gscore* current_y current_x)))
                                    (if (<= possible-g-score (aref *gscore* ny nx))
                                        ; this is better than the previous one, save it up
                                        (progn (setf (aref *gscore* ny nx) possible-g-score)
                                               (setf (aref *fscore* ny nx) (+ possible-g-score (funcall heuristic-fn nx ny)))
                                               (setf (aref *hscore* ny nx) (+ possible-g-score))
                                               ;; if the neighbour is not in the open set then add it
                                               (if (not (find-node-in-set open-set nx ny))
                                                   (setf open-set (push (make-node nx ny) open-set))
                                                   )))))))))
    )))

(defun expand-matrix (matrix)
	(let* ((cols '100))
		(loop for i from 0 to (- cols 1)
			do
			(loop for j from 0 to (- cols 1)
                  do
                    (loop for mirror-y from 0 to 4
                          do (loop for mirror-x from 0 to 4
                                   do
                                      (let* ((calc-value (+ (aref matrix i j) (+ mirror-x mirror-y)))
                                            (new-value (mod calc-value 10)))
                                        (if (>= calc-value 10)
                                            (setf new-value (- calc-value 9)))
                                        (if (= new-value 0) (setf new-value 1))
                                        (setf (aref matrix
                                                    (+ (* cols mirror-y) i)
                                                    (+ (* cols mirror-x) j))
                                              new-value))
                  ))))))


; reconstructs path, doesnt really matter
(defun reconstruct_path (cameFrom current))

;; function reconstruct_path(cameFrom, current)
;;     total_path := {current}
;;     while current in cameFrom.Keys:
;;         current := cameFrom[current]
;;         total_path.prepend(current)
;;     return total_path

;; // A* finds a path from start to goal.
;; // h is the heuristic function. h(n) estimates the cost to reach goal from node n.
;; function A_Star(start, goal, h)
;;     // The set of discovered nodes that may need to be (re-)expanded.
;;     // Initially, only the start node is known.
;;     // This is usually implemented as a min-heap or priority queue rather than a hash-set.
;;     openSet := {start}

;;     // For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from start
;;     // to n currently known.
;;     cameFrom := an empty map

;;     fScore := map with default value of Infinity
;;     fScore[start] := h(start)

;;     while openSet is not empty
;;         // This operation can occur in O(1) time if openSet is a min-heap or a priority queue
        ;; current := the node in openSet having the lowest fScore[] value
        ;; if current = goal
        ;;     return reconstruct_path(cameFrom, current)

        ;; openSet.Remove(current)
        ;; for each neighbor of current
    ;;         // d(current,neighbor) is the weight of the edge from current to neighbor
    ;;         // tentative_gScore is the distance from start to the neighbor through current
    ;;         tentative_gScore := gScore[current] + d(current, neighbor)
    ;;         if tentative_gScore < gScore[neighbor]
    ;;             // This path to neighbor is better than any previous one. Record it!
    ;;             cameFrom[neighbor] := current
    ;;             gScore[neighbor] := tentative_gScore
    ;;             fScore[neighbor] := tentative_gScore + h(neighbor)
    ;;             if neighbor not in openSet
    ;;                 openSet.add(neighbor)

    ;; // Open set is empty but goal was never reached
    ;; return failure

(parse-file)

(defun iterate-matrix (matrix)
	(let* ((dim (array-dimensions matrix))
		(row (first dim))
		(col (second dim))
		(suma '0))
		(loop for i from 0 to (- row 1)
			do
			(loop for j from 0 to (- col 1)
				do (format t "do something man")))))

; manhattan heuristic
(defun heuristic (x y)
  (+ (- cols x) (- rows y)))

(defun first-part-solution ()
  (a* 0 0 (- cols 1) (- rows 1) #'heuristic))
; (defun parse-input ())
;(first-part-solution)
;(format t "Answer: ~D ~%" (aref *hscore* (- rows 1) (- cols 1)))

(defun second-part-solution ()
 (expand-matrix *matrix*)
  (a* 0 0 (- cols 1) (- rows 1) #'heuristic))

(second-part-solution)
(format t "Answer: ~D ~%" (aref *hscore* (- rows 1) (- cols 1)))

(defun array-slice (arr row)
    (make-array (array-dimension arr 1)
      :displaced-to arr
       :displaced-index-offset (* row (array-dimension arr 1))))

;(format t "Matrix: ~D ~%" (array-slice *matrix* 49))
;(format t "Matrix: ~D ~%" *matrix*)
