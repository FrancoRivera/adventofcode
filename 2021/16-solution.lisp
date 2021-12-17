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

;; 1. Expand input from Hex to Binary
;; 2. Parse binary string and collect the version
;;      string := read (string, number)
;;
;;      parseBinary(string):
;;          version := read 3 bits
;;          type := read 3 bits
;;          If  type == 4:
;;           return version; // for part 1 only
;;           // stop here in part 1
;;           numbers = []
;;              while len > 0:
;;                 group := read 5 bits;
;;                 if group[0]: // end of parsing, ignore trailing zeroes
;;                    numbers <- read 4 bits
;;                    break; // exit loop
;;                 numbers <- read 4 bits
;;         else:
;;              // operator packet (contains subpackets)
;;              next 1 bit = length typ16-solution.lispe
;;              N := 15 // default value 15
;;              if length = 1 then N = 11
;;              read next N bits = number of subpackets
;;              extracted packets := 0
;;              for i in 0..numbers of subpackets
;;                  extracted packets <- read next 15 bits
;;              sum_ver = 0
;;              for packet in extracted_packets
;;                  sum_ver += parseBinary(packet);
;;              return sum_ver;
;;
;;
;;
;;
;;

; Implementation

; Parsing...

(defparameter +DAY+ 16)

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


;;
;;
(defparameter +hex-list+ '("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F"))

(defun number-to-binary (number)
  "Returns passed integer number into a binary string"
  (if (= number 1) (return-from number-to-binary "1"))
  (if (= number 0) (return-from number-to-binary "0"))
  (concatenate 'string
               (number-to-binary (floor number 2))
               (write-to-string (mod number 2))))


(defun pad-string (string)
  (loop while (< (length string) 4)
        do (setf string (concatenate 'string "0" string)))
  (return-from pad-string string))

; after searching theres a function that does this lmao
; (write-to-string NUMBER :base 2)

(defun expand-hex-to-binary (hex-string)
  (let ((new-string ""))
  (loop for hex-value in (ppcre:split "" hex-string)
        do (setf new-string
                 (concatenate 'string new-string
                              (pad-string (number-to-binary (parse-integer hex-value :radix 16 :junk-allowed t))))))
    (return-from expand-hex-to-binary new-string)))


(defun read-n-bits (string n-bits)
  (let ((new-string (subseq string 0 n-bits)))
    (return-from read-n-bits new-string)))

(defun maximum (list)
  (reduce #'max list))

(defun minimum (list)
  (reduce #'min list))

(defun parse-type (type literals)
  ;(format t "TYPE: ~D LITERALS: ~D ~%" type literals)
  (list (cond
    ((= type 0 ) (apply '+ literals))
    ((= type 1 ) (apply '* literals))
    ((= type 2 ) (reduce 'min literals))
    ((= type 3 ) (reduce 'max literals))
    ((= type 5 ) (if (> (first literals) (second literals)) 1 0))
    ((= type 6 ) (if (< (first literals) (second literals)) 1 0))
    ((= type 7 ) (if (= (first literals) (second literals)) 1 0)) )))

(defun parse-packet(string)
  (let  ((version 0)
         (type '0)
         (length-packet 15)
         (sum-versions 0)
         (subpackets 0)
         (done nil)
         (literal-string "")
         (literals '()))
    ;; parse version and type
    ;(format t "Str: ~D ~%" string)
    (setf version (read-n-bits string 3))
    (setf string (subseq string 3)) ;remove version
    (setf type (read-n-bits string 3))
    (setf string (subseq string 3)) ; remove type
    ;(format t "Version and type: ~D ~D ~%" version type)
    (setf sum-versions (parse-integer version :radix 2))

    (if (string= type "100") ; Its a literal packet
        (progn
          (loop while (not done)
                do (if (string= (read-n-bits string 1) "0") (setf done 't))
                   (setf string (subseq string 1))
                   ;(format t "~D-" (read-n-bits string 4))
                   (setf literal-string (concatenate 'string literal-string (read-n-bits string 4)))
                   (setf string (subseq string 4))) ; remove literal value
           ;(format t "~% Literal: ~D ~%" (parse-integer literal-string :radix 2)) ; read literal value)
          (setf literals (push (parse-integer literal-string :radix 2) literals)) ; read literal value)
          (return-from parse-packet (list sum-versions string literals))))

    (if (string= (read-n-bits string 1) "1")
        (progn (setf length-packet 11) ; packet length = 11
                (setf string (subseq string 1)) ; remove length
                (setf subpackets (parse-integer (read-n-bits string length-packet) :radix 2)) ; get number of subpackets
                ;(format t  "eleven with subpackets ~D TYPE: ~D ~%" subpackets type)
                (setf string (subseq string length-packet)) ; remove subpackets
                (loop while (and (>= (length string) length-packet) (> subpackets 0))
                    do (let ((parsed (parse-packet string)))
                         (incf sum-versions (first parsed))
                         (setf string  (second parsed))
                         ;(format t "subpackets ~D ~%" subpackets)
                         ;(format t "literals ~D ~%" (third parsed))
                         (setf literals (append literals (third parsed)))
                         (decf subpackets))
                      )
                (return-from parse-packet (list sum-versions string (parse-type (parse-integer type :radix 2) literals))))

        (progn (setf length-packet 15) ; packet length = 15
               (setf string (subseq string 1)) ; remove length
               (setf subpackets (parse-integer (read-n-bits string length-packet) :radix 2)) ;get total length in bits to be parsed
               ;(format t "fifteen with length ~D ~%" subpackets)
                (setf string (subseq string 15)) ; remove legnth in bits of new bit
                (let ((read-bits (read-n-bits string subpackets)))
                  (loop while (> (length read-bits) 0)
                        do
                           ;(format t "Parsing still ~D ~%" read-bits)
                           (let ((parsed (parse-packet read-bits)))
                             (incf sum-versions (first parsed))
                             (setf read-bits (second parsed))
                             ;(format t "lterals ~D ~%" (third parsed))
                             (setf literals (append literals (third parsed) ))
                             )))
                (setf string (subseq string subpackets))
                (return-from parse-packet (list sum-versions string (parse-type (parse-integer type :radix 2) literals))))
          )))

;; Tests
;;
(print (parse-packet (expand-hex-to-binary "D2FE28")))
(print (parse-packet (expand-hex-to-binary "EE00D40C823060")))
(print (parse-packet (expand-hex-to-binary "38006F45291200")))
(print (parse-packet (expand-hex-to-binary "8A004A801A8002F478")))
(print (parse-packet (expand-hex-to-binary "A0016C880162017C3686B18A3D4780")))

; Result part 1
(print (parse-packet (expand-hex-to-binary "220D700071F39F9C6BC92D4A6713C737B3E98783004AC0169B4B99F93CFC31AC4D8A4BB89E9D654D216B80131DC0050B20043E27C1F83240086C468A311CC0188DB0BA12B00719221D3F7AF776DC5DE635094A7D2370082795A52911791ECB7EDA9CFD634BDED14030047C01498EE203931BF7256189A593005E116802D34673999A3A805126EB2B5BEEBB823CB561E9F2165492CE00E6918C011926CA005465B0BB2D85D700B675DA72DD7E9DBE377D62B27698F0D4BAD100735276B4B93C0FF002FF359F3BCFF0DC802ACC002CE3546B92FCB7590C380210523E180233FD21D0040001098ED076108002110960D45F988EB14D9D9802F232A32E802F2FDBEBA7D3B3B7FB06320132B0037700043224C5D8F2000844558C704A6FEAA800D2CFE27B921CA872003A90C6214D62DA8AA9009CF600B8803B10E144741006A1C47F85D29DCF7C9C40132680213037284B3D488640A1008A314BC3D86D9AB6492637D331003E79300012F9BDE8560F1009B32B09EC7FC0151006A0EC6082A0008744287511CC0269810987789132AC600BD802C00087C1D88D05C001088BF1BE284D298005FB1366B353798689D8A84D5194C017D005647181A931895D588E7736C6A5008200F0B802909F97B35897CFCBD9AC4A26DD880259A0037E49861F4E4349A6005CFAD180333E95281338A930EA400824981CC8A2804523AA6F5B3691CF5425B05B3D9AF8DD400F9EDA1100789800D2CBD30E32F4C3ACF52F9FF64326009D802733197392438BF22C52D5AD2D8524034E800C8B202F604008602A6CC00940256C008A9601FF8400D100240062F50038400970034003CE600C70C00F600760C00B98C563FB37CE4BD1BFA769839802F400F8C9CA79429B96E0A93FAE4A5F32201428401A8F508A1B0002131723B43400043618C2089E40143CBA748B3CE01C893C8904F4E1B2D300527AB63DA0091253929E42A53929E420")))


; part 2 tests
(print (parse-packet (expand-hex-to-binary "D2FE28")))
(print (parse-packet (expand-hex-to-binary "C200B40A82")))
(print (parse-packet (expand-hex-to-binary "04005AC33890")))
(print (parse-packet (expand-hex-to-binary "880086C3E88112")))
(print (parse-packet (expand-hex-to-binary "CE00C43D881120")))
(print (parse-packet (expand-hex-to-binary "D8005AC2A8F0")))
(print (parse-packet (expand-hex-to-binary "F600BC2D8F")))
(print (parse-packet (expand-hex-to-binary "9C005AC2F8F0")))
(print (parse-packet (expand-hex-to-binary "9C0141080250320F1802104A08")))

; Result part 2
(print (parse-packet (expand-hex-to-binary "220D700071F39F9C6BC92D4A6713C737B3E98783004AC0169B4B99F93CFC31AC4D8A4BB89E9D654D216B80131DC0050B20043E27C1F83240086C468A311CC0188DB0BA12B00719221D3F7AF776DC5DE635094A7D2370082795A52911791ECB7EDA9CFD634BDED14030047C01498EE203931BF7256189A593005E116802D34673999A3A805126EB2B5BEEBB823CB561E9F2165492CE00E6918C011926CA005465B0BB2D85D700B675DA72DD7E9DBE377D62B27698F0D4BAD100735276B4B93C0FF002FF359F3BCFF0DC802ACC002CE3546B92FCB7590C380210523E180233FD21D0040001098ED076108002110960D45F988EB14D9D9802F232A32E802F2FDBEBA7D3B3B7FB06320132B0037700043224C5D8F2000844558C704A6FEAA800D2CFE27B921CA872003A90C6214D62DA8AA9009CF600B8803B10E144741006A1C47F85D29DCF7C9C40132680213037284B3D488640A1008A314BC3D86D9AB6492637D331003E79300012F9BDE8560F1009B32B09EC7FC0151006A0EC6082A0008744287511CC0269810987789132AC600BD802C00087C1D88D05C001088BF1BE284D298005FB1366B353798689D8A84D5194C017D005647181A931895D588E7736C6A5008200F0B802909F97B35897CFCBD9AC4A26DD880259A0037E49861F4E4349A6005CFAD180333E95281338A930EA400824981CC8A2804523AA6F5B3691CF5425B05B3D9AF8DD400F9EDA1100789800D2CBD30E32F4C3ACF52F9FF64326009D802733197392438BF22C52D5AD2D8524034E800C8B202F604008602A6CC00940256C008A9601FF8400D100240062F50038400970034003CE600C70C00F600760C00B98C563FB37CE4BD1BFA769839802F400F8C9CA79429B96E0A93FAE4A5F32201428401A8F508A1B0002131723B43400043618C2089E40143CBA748B3CE01C893C8904F4E1B2D300527AB63DA0091253929E42A53929E420")))
