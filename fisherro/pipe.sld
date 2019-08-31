(define-library (fisherro pipe)
  (import (scheme base))
  (export pipe)
  (begin
    (define-syntax pipe
      (syntax-rules ()
	((pipe)
	 (error "pipe requires a variable name and at least on expression"))
	((pipe it)
	 (error "pipe requires a variable name and at least on expression"))
	; There's an argument that this case should be an error
	((pipe it expression)
	 expression)
	((pipe it first-expression last-expression)
	 (let ((it first-expression))
	   last-expression))
	((pipe it first-expression . rest-expressions)
	 (let ((it first-expression))
	   (pipe it . rest-expressions)))))))
