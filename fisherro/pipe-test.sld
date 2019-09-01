;;; Minimize the user of SRFI's in the tests?
(define-library (fisherro pipe-test)
  (import (scheme base)
	  (scheme write)
	  (chibi test)
	  (fisherro pipe))
  (export run-tests)
  (begin

    (define (number->hex n)
      (number->string n 16))

    (define (pad-string n s)
      (let ((len (string-length s)))
	(if (< len n)
	  (string-append (make-string (- n len) #\0) s)
	  s)))

    (define (run-tests)
      (test-begin "pipe")
      (test 10 (pipe it 10))
      (test '(1 2 3) (pipe it '(1 2 3)))
      (test '(0 0 0) (pipe it (make-list 3 0)))
      (test '(0 0 0) (let ((it 3))
		       (pipe it (make-list 3 0))))
      (test '(0 0 0) (let ((it 10))
		       (pipe it 3 (make-list it 0))))
      (test "U+0048 U+0065 U+006c U+006c U+006f U+0021"
	    (pipe _
		  "Hello!"
		  (string->list _)
		  (map char->integer _)
		  (map number->hex _)
		  (map (lambda (s)
			 (pad-string 4 s))
		       _)
		  (map (lambda (s) (string-append "U+" s)) _)
		  `(,(car _) ,@(map (lambda (s) (string-append " " s)) (cdr _)))
		  (apply string-append _)))
      (test "48656c6c6f2115"
	    (pipe this
		  "Hello!"
		  (string->list this)
		  (map char->integer this)
		  (pipe that
			(apply + this)
			(modulo that 256)
			`(,@this ,that))
		  (map number->hex this)
		  (map (lambda (s) (pad-string 2 s)) this)
		  (apply string-append this)))
      (test-end))))
