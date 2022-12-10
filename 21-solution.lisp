; Started: 2021-12-21 @ 17: 5:53

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

(defstruct player position points wins id)
; count the number of times the dice has been played
; count the score of every player
; deterministic dice, get the current value of the dice, (tumes that it has been played mod 100 + 1)
; the score goes position + score mod 10

(format t "yeah ~D" (mod 20 9))

(defparameter *players*
  (list (make-player :position 4 :points 0 :wins 0 :id 1)
        (make-player :position 8 :points 0 :wins 0 :id 2)))

(defparameter *dice* '1) ; dice starts at 1
(defparameter *dice-count* 0) ; dice starts at 1

(defun play-turn ()
            (loop for player in *players*
                do
                    (dotimes (number 3)
                      (incf (player-position player) *dice*)
                      (setf (player-position player) (mod (player-position player) 10))
                        (format t "~D," *dice*)
                      (incf *dice*)
                      (incf *dice-count*)
                      (if (= *dice* 101) (setf *dice* 1)))

                    (update-points player)
                      (format t "~%Player ~D rolls and moves to space ~D for at total score of ~D ~%" (player-id player) (player-position player) (player-points player))
                      ;; win condition
                      (if (> (player-points player) 999)
                          (progn
                            (format t "ITS OVER bois ~%")
                            (return-from play-turn nil)))

                )
  (return-from play-turn 't)
  )

(defun update-points (player)
    (incf (player-points player) (player-position player))
    (if (= (player-position player) 0) (incf (player-points player) 10)))


(defparameter *1-wins* '0)
(defparameter *2-wins* '0)

; this code deosnt work at all
(defun play-quantum-turn (dice players)
  (setf players (list
                 (copy-structure (first players))
                 (copy-structure (second players))))
  ; (format t "Dice: ~D  Players: ~D ~%" dice players)
        (loop for player in players
              do
                    (dotimes (number 3)
                      (incf (player-position player) dice)
                      (setf (player-position player) (mod (player-position player) 10))
                      ;; nobody has win yet so keep playing
                      (play-quantum-turn number players)
                      )
                (update-points player)
                (format t "Player rolls and moves to space ~D for at total score of ~D ~%" (player-position player) (player-points player))
                ;; win condition
                (if (> (player-points player) 20)
                    (progn
                      (if (= (player-id player) 1)
                          (incf *1-wins*)
                          (incf *2-wins*))
                    (return-from play-quantum-turn nil))))
    (return-from play-quantum-turn 't))

(defun play-quantum ()
  (setf *players* (list (make-player :position 4 :points 0 :wins 0 :id 1)
                        (make-player :position 8 :points 0 :wins 0 :id 2)))
     (setf *1-wins* '0) ; reset wins
     (setf *2-wins* '0) ;
  (format t "===============================")
        (play-quantum-turn 1 *players*)
        (play-quantum-turn 2 *players*)
        (play-quantum-turn 3 *players*)
    (format t "P1 wins ~A  p2 wins ~D ~%" *1-wins* *2-wins*)
  )

(play-quantum)

(defun play-game ()
  (setf *players* (list (make-player :position 6 :points 0 :wins 0 :id 1)
                        (make-player :position 8 :points 0 :wins 0 :id 2)))
     (setf *dice* '1) ; dice starts at 1
     (setf *dice-count* 0) ; dice starts at 1

    (loop while (play-turn))
    (format t "~A ~%" *players*)
    (format t "Dicecount ~A ~%" *dice-count*)
    (format t "PT1 ~A ~%" (* 754 1005))
  )
(play-game)
                                        ; Parsing...

(defparameter +DAY+ 21)

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
