;;; Syntax for an anaphoric pipeline
(define-library (fisherro seq)
  (import (scheme base)
	  (only (chibi)
		sc-macro-transformer
		make-syntactic-closure))
  (export seq)
  (begin
    (define-syntax seq
      (sc-macro-transformer
	(lambda (form env)
	  (let ((first-form
		  `(it ,(make-syntactic-closure env '() (cadr form))))
		(rest-forms
		  (map (lambda (subform)
			 `(it ,(make-syntactic-closure env '(it) subform)))
		       (cddr form))))
	    `(let* (,first-form ,@rest-forms)
	       it)))))))
