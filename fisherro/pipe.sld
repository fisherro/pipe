;;> \hyperlink[https://github.com/fisherro/pipe]{github repo}
;;>
;;> This library provides a single macro called \scheme{pipe}.
;;>
;;> \scheme{(pipe <variable> <expressions> ...)}
;;>
;;> \scheme{<variable>} is bound to the result of the first expression.
;;> Then it gets bound, in order, to the result of each additional expression.
;;> The result of the last expression is returned.
;;>
;;> For example:
;;>
;;> \schemeblock{
;;> (pipe _
;;>       "Hello!"
;;>       (string->list _)
;;>       (map char->integer _)
;;>       (map number->string _)
;;>       (write _))
;;> }
;;>
;;> ...is equivalent to...
;;>
;;> \schemeblock{
;;> (let* ((_ "Hello!")
;;>        (_ (string->list _))
;;>        (_ (map char->integer _))
;;>        (_ (map number->string _)))
;;>   (write _))
;;> }
(define-library (fisherro pipe)
  (import (scheme base))
  (export pipe)
  (begin
    (define-syntax pipe
      (syntax-rules ()
	((pipe)
	 (syntax-error
	   "pipe requires a variable name and at least on expression"))
	((pipe it)
	 (syntax-error
	   "pipe requires a variable name and at least on expression"))
	; There's an argument that this case should be an error
	((pipe it expression)
	 expression)
	((pipe it first-expression last-expression)
	 (let ((it first-expression))
	   last-expression))
	((pipe it first-expression . rest-expressions)
	 (let ((it first-expression))
	   (pipe it . rest-expressions)))))))
