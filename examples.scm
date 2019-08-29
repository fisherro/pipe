(import (scheme base)
	(scheme write)
	(srfi 1)
	(srfi 26)
	(srfi 130)
	(fisherro seq)
	(fisherro thread-as))

(define (compose . fs)
  (if (null? fs)
    values
    (lambda args
      ((car fs)
       (apply (apply compose (cdr fs))
	      args)))))

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

(thread-as it
	   (iota 10)
	   (map (cute * <> 2) it)
	   (map number->string it)
	   (map (cute string-pad <> (apply max (map string-length it))) it)
	   (string-join it ", ")
	   (display it))
(newline)

