;;; Minimize the user of SRFI's in the tests?
(define-library (fisherro pipe-test)
  (import (scheme base)
	  (scheme write)
	  (srfi 1)
	  (srfi 26)
	  (srfi 130)
	  (chibi test)
	  (fisherro pipe))
  (export run-tests)
  (begin
    (define (run-tests)
      (test-begin "pipe")
      (test 10 (pipe it 10))
      (test '(1 2 3) (pipe it '(1 2 3)))
      (test '(0 1 2) (pipe it (iota 3)))
      (test '(0 1 2) (let ((it 3))
		       (pipe it (iota it))))
      (test '(0 1 2) (let ((it 10))
		       (pipe it 3
			     (iota it))))
      (test
	'" 0,  2,  4,  6,  8, 10"
	(pipe
	  it
	  (iota 6)
	  (map (cute * <> 2) it)
	  (map number->string it)
	  (map (cute string-pad <> (apply max (map string-length it)))
	       it)
	  (string-join it ", ")))
      (test
	'" 0,  2,  4,  6,  8, 10"
	(pipe
	  this
	  (iota 6)
	  (map (cute * <> 2) this)
	  (map number->string this)
	  (pipe
	    that
	    (map string-length this)
	    (apply max that)
	    (map (cute string-pad <> that)
		 this))
	  (string-join this ", ")))
      (test-end))))
