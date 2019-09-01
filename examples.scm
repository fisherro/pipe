(import (scheme base)
	(scheme write)
	(srfi 1)
	(srfi 26)
	(srfi 130)
	(fisherro seq)
	(fisherro pipe))

(define (compose . fs)
  (if (null? fs)
    values
    (lambda args
      ((car fs)
       (apply (apply compose (cdr fs))
	      args)))))

(define (rcompose . fs)
  (apply compose (reverse fs)))

(display
  (string-join 
    (map
      (cute string-pad <> 2)
      (map
	number->string
	(map
	  (cute * <> 2)
	  (iota 10))))
    ", "))
(newline)

((compose display
	  (cute string-join <> ", ")
	  (cute map (cute string-pad <> 2) <>)
	  (cute map number->string <>)
	  (cute map (cute * <> 2) <>)
	  iota)
 10)
(newline)

((rcompose iota
	   (cute map (cute * <> 2) <>)
	   (cute map number->string <>)
	   (cute map (cute string-pad <> 2) <>)
	   (cute string-join <> ", ")
	   display)
 10)
(newline)

;((rcompose (cute iota 10)
;	   (cute map (cute * <> 2) <>)
;	   (cute map number->string <>)
;	   (cute map (cute string-pad <> 2) <>)
;	   (cute string-join <> ", ")
;	   display))
;(newline)

((rcompose iota
	   (cute map (cute * <> 2) <>)
	   (cute map number->string <>)
	   (lambda (it)
	     (map (cute string-pad
			<>
			(apply max (map string-length it)))
		  it))
	   (cute string-join <> ", ")
	   display)
 10)
(newline)

(let* ((it (iota 10))
       (it (map (cute * <> 2) it))
       (it (map number->string it))
       (it (map (cute string-pad <> 2) it))
       (it (string-join it ", ")))
  (display it))
(newline)

(let* ((it (iota 10))
       (it (map (cute * <> 2) it))
       (it (map number->string it))
       (it (map (cute string-pad <> (apply max (map string-length it))) it))
       (it (string-join it ", ")))
  (display it))
(newline)

(let*
  ((numbers (iota 10))
   (doubles (map (cute * <> 2) numbers))
   (strings (map number->string doubles))
   (padded  (map
	      (cute string-pad <> (apply max (map string-length strings)))
	      strings))
   (the-string (string-join padded ", ")))
  (display the-string))
(newline)

(seq (iota 10)
     (map (cute * <> 2) it)
     (map number->string it)
     (map (cute string-pad <> (apply max (map string-length it))) it)
     (string-join it ", ")
     (display it))
(newline)

(pipe it
      (iota 10)
      (map (cute * <> 2) it)
      (map number->string it)
      (map (cute string-pad <> (apply max (map string-length it))) it)
      (string-join it ", ")
      (display it))
(newline)

(pipe this
      (iota 10)
      (map (cute * <> 2) this)
      (map number->string this)
      (pipe that
	    (map string-length this)
	    (apply max that)
	    (map (cute string-pad <> that)
		 this))
      (string-join this ", "))
(newline)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; An example that only uses R7RS-small functions
(pipe _
      "hello😀"
      (string->list _)
      (map char->integer _)
      (map (lambda (s) (number->string s 16)) _)
      (map (lambda (s)
	     (let ((len (string-length s)))
	       (if (< len 4)
		 (string-append (make-string (- 4 len) #\0) s)
		 s)))
	   _)
      (map (lambda (s) (string-append "U+" s)) _)
      `(,(car _) ,@(map (lambda (s) (string-append " " s)) (cdr _)))
      (apply string-append _)
      (display _)
      (newline))

(pipe _
      "Hello!"
      (string->list _)
      (map char->integer _)
      (map number->string _)
      (write _))
(newline)
; ("72" "101" "108" "108" "111" "33")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Error tests
;(pipe) ; Syntax error
;(pipe it) ; Syntax error
;(pipe it 10) ; Not an error


