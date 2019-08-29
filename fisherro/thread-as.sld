(define-library (fisherro thread-as)
  (import (scheme base))
  (export thread-as)
  (begin
    (define-syntax thread-as
      (syntax-rules ()
	((thread-as)
	 (error "thread-as requires a variable name and at least on expression"))
	((thread-as it)
	 (error "thread-as requires a variable name and at least on expression"))
	; There's an argument that this case should be an error
	((thread-as it expression)
	 expression)
	((thread-as it first-expression last-expression)
	 (let ((it first-expression))
	   last-expression))
	((thread-as it first-expression . rest-expressions)
	 (let ((it first-expression))
	   (thread-as it . rest-expressions)))))))
