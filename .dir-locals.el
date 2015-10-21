((java-mode
  .
  ((eval
    .
    (progn
      (defun my/point-in-defun-declaration-p ()
        (let ((bod (save-excursion (c-beginning-of-defun)
                                   (point))))
          (<= bod
              (point)
              (save-excursion (goto-char bod)
                              (re-search-forward "{")
                              (point)))))

      (defun my/is-string-concatenation-p ()
        "Returns true if the previous line is a string concatenation"
        (save-excursion
          (let ((start (point)))
            (forward-line -1)
            (if (re-search-forward " \\\+$" start t) t nil))))

      (defun my/inside-java-lambda-p ()
        "Returns true if point is the first statement inside of a lambda"
        (save-excursion
          (c-beginning-of-statement-1)
          (let ((start (point)))
            (forward-line -1)
            (if (search-forward " -> {" start t) t nil))))

      (defun my/arglist-cont-nonempty-indentation (arg)
        (if (my/inside-java-lambda-p)
            '+
          (if (my/is-string-concatenation-p)
              16
            (unless (my/point-in-defun-declaration-p) '++))))

      (defun my/statement-block-intro (arg)
        (if (and (c-at-statement-start-p) (my/inside-java-lambda-p)) 0 '+))

      (defun my/block-close (arg)
        (if (my/inside-java-lambda-p) '- 0))

      (c-set-offset 'inline-open           0)
      (c-set-offset 'topmost-intro-cont    '+)
      (c-set-offset 'statement-block-intro 'my/statement-block-intro)
      (c-set-offset 'block-close           'my/block-close)
      (c-set-offset 'knr-argdecl-intro     '+)
      (c-set-offset 'substatement-open     '+)
      (c-set-offset 'substatement-label    '+)
      (c-set-offset 'case-label            '+)
      (c-set-offset 'label                 '+)
      (c-set-offset 'statement-case-open   '+)
      (c-set-offset 'statement-cont        '++)
      (c-set-offset 'arglist-intro         0)
      (c-set-offset 'arglist-cont-nonempty '(my/arglist-cont-nonempty-indentation c-lineup-arglist))
      (c-set-offset 'arglist-close         '--)
      (c-set-offset 'inexpr-class          0)
      (c-set-offset 'access-label          0)
      (c-set-offset 'inher-intro           '++)
      (c-set-offset 'inher-cont            '++)
      (c-set-offset 'brace-list-intro      '+)
      (c-set-offset 'func-decl-cont        '++)
      ))
   (c-basic-offset . 4)
   (c-comment-only-line-offset . (0 . 0)))))
