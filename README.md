# pipe

R7RS syntax for pipelining a value through multiple expressions

The package is available at [Snow Fort](http://snow-fort.org/)

## What?

    (import (fisherro pipe))
    (pipe <variable-name> <first-expression> . <rest-expressions>)

The value of `<first-expression>` is bound to`<variable-name>`. Then the value of each expression in `<rest-expressions>` is bound to `<variable-name>` in order.

It is equivalent to...

    (let* ((<variable-name> <first-expression>)
           (<variable-name> <second-expression>)
           ...)
      (last-expression))

## Rambling

Consider the following Scheme code:

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

Which outputs the string:

    " 0,  2,  4,  6,  8, 10, 12, 14, 16, 18"

When I was new to Scheme, I found this sort of deeply-nested, inside-out code hard to read.

### Tacit

We can rewrite it in something of a _tacit_ or _point-free_ form.

    ((compose display
              (cute string-join <> ", ")
              (cute map (cute string-pad <> 2) <>)
              (cute map number->string <>)
              (cute map (cute * <> 2) <>)
              iota)
     10)

This isn't as natural in Scheme as it is in an implicitly curried language, but it does undo the nesting. Although the sequence of steps is still in reverse order.

We could get it into a top-down order with a reverse compose.

    (define (reverse-compose . params)
      (apply compose (reverse params)))

    ((reverse-compose iota
                      (cute map (cute * <> 2) <>)
                      (cute map number->string <>)
                      (cute map (cute string-pad <> 2) <>)
                      (cute string-join <> ", ")
                      display)
     10)

### `let*`

With `let*`, we can both unnest the code and put it into a top-down sequence.

    (let* ((it (iota 10))
           (it (map (cute * <> 2) it))
           (it (map number->string it))
           (it (map (cute string-pad <> 2) it))
           (it (string-join it ", ")))
      (display it))


This also lets us use the value from one step multiple times in a following step. So now we can replace that hard-coded 2 for the `string-pad` call with a dynamically calculated value.

    (let* ((it (iota 10))
           (it (map (cute * <> 2) it))
           (it (map number->string it))
           (it (map (cute string-pad
                          <>
                          (apply max (map string-length it)))
                    it))
           (it (string-join it ", ")))
      (display it))

Arguably, it would be better to give the result of each step a more descriptive name than `it`...

    (let*
      ((numbers (iota 10))
       (doubles (map (cute * <> 2) numbers))
       (strings (map number->string doubles))
       (padded  (map (cute string-pad
                           <>
                           (apply max (map string-length strings)))
                     strings))
       (the-string (string-join padded ", ")))
      (display the-string))

...but we’ll just charge ahead past that point.

### Anaphoric `seq`

One of the first macros I ever wrote was an anaphoric `seq` that eliminated the boiler-plate from the `let*` with `it` version above.

    (seq (iota 10)
         (map (cute * <> 2) it)
         (map number->string it)
         (map (cute string-pad
                    <>
                    (apply max (map string-length it)))
              it))
         (string-join it ", ")
         (display it))

(The first version of `seq` I wrote actually transformed the code into the nested version instead of using `let*`. Which meant that if you used `it` more than once in a step it would duplicate expressions!)

### `pipe`

A more portable and hygienic version can be written if we let the user name their own `it`.

    (pipe it
          (iota 10)
          (map (cute * <> 2) it)
          (map number->string it)
          (map (cute string-pad
                     <>
                     (apply max (map string-length it)))
               it)
          (string-join it ", ")
          (display it))

This also allows nesting subsequences, e.g.

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

Readability is, unfortunately, subjective. After many years of Scheme programming, the original code is more readable to me than it used to be. So, I guess it is good to have options.
