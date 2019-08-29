(define-library (fisherro thread-as-test)
  (import (scheme base)
	  (scheme write)
	  (srfi 1)
	  (srfi 26)
	  (srfi 130)
	  (chibi test)
	  (fisherro thread-as))
  (export run-tests)
  (begin
    (define (run-tests)
      (test-begin "thread-as")
      (test 10 (thread-as it 10))
      (test '(1 2 3) (thread-as it '(1 2 3)))
      (test '(0 1 2) (thread-as it (iota 3)))
      (test '(0 1 2) (let ((it 3))
		       (thread-as it (iota it))))
      (test '(0 1 2) (let ((it 10))
		       (thread-as it 3
				  (iota it))))
      (test
	'" 0,  2,  4,  6,  8, 10"
	(thread-as
	  it
	  (iota 6)
	  (map (cute * <> 2) it)
	  (map number->string it)
	  (map (cute string-pad <> (apply max (map string-length it)))
	       it)
	  (string-join it ", ")))
      (test
	'" 0,  2,  4,  6,  8, 10"
	(thread-as
	  this
	  (iota 6)
	  (map (cute * <> 2) this)
	  (map number->string this)
	  (thread-as
	    that
	    (map string-length this)
	    (apply max that)
	    (map (cute string-pad <> that)
		 this))
	  (string-join this ", ")))
      (test-end))))
