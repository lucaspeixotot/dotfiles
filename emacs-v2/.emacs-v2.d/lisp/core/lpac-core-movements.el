;; -*- lexical-binding: t -*-

(use-package meow
  :straight t
  :init
  (defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))
  :config
  (meow-setup)
  (meow-global-mode 1)
  )

(use-package avy
    :straight t
    :after meow
    :config
    ;; Additional mode-specific bindings
    (setq avy-keys '(?q ?e ?r ?y ?u ?o ?p
                        ?a ?s ?d ?f ?g ?h ?j
                        ?k ?l ?' ?x ?c ?v ?b
                        ?n ?, ?/))
    (defun avy-action-kill-whole-line (pt)
      (save-excursion
        (goto-char pt)
        (kill-whole-line))
      (select-window
       (cdr
        (ring-ref avy-ring 0)))
      t)

    (setf (alist-get ?k avy-dispatch-alist) 'avy-action-kill-stay
          (alist-get ?K avy-dispatch-alist) 'avy-action-kill-whole-line)

    (defun avy-action-copy-whole-line (pt)
      (save-excursion
        (goto-char pt)
        (cl-destructuring-bind (start . end)
            (bounds-of-thing-at-point 'line)
          (copy-region-as-kill start end)))
      (select-window
       (cdr
        (ring-ref avy-ring 0)))
      t)

    (defun avy-action-yank-whole-line (pt)
      (avy-action-copy-whole-line pt)
      (save-excursion (yank))
      t)

    (setf (alist-get ?y avy-dispatch-alist) 'avy-action-yank
          (alist-get ?w avy-dispatch-alist) 'avy-action-copy
          (alist-get ?W avy-dispatch-alist) 'avy-action-copy-whole-line
          (alist-get ?Y avy-dispatch-alist) 'avy-action-yank-whole-line)

    (defun avy-action-teleport-whole-line (pt)
      (avy-action-kill-whole-line pt)
      (save-excursion (yank)) t)

    (setf (alist-get ?t avy-dispatch-alist) 'avy-action-teleport
          (alist-get ?T avy-dispatch-alist) 'avy-action-teleport-whole-line)

    (defun avy-action-mark-to-char (pt)
      (activate-mark)
      (goto-char pt))

    (setf (alist-get ?  avy-dispatch-alist) 'avy-action-mark-to-char)

    (defun avy-action-helpful (pt)
      (save-excursion
        (goto-char pt)
        (helpful-at-point))
      (select-window
       (cdr (ring-ref avy-ring 0)))
      t)

    (setf (alist-get ?H avy-dispatch-alist) 'avy-action-helpful)

    (defun avy-action-embark (pt)
      (unwind-protect
          (save-excursion
            (goto-char pt)
            (embark-act))
        (select-window
         (cdr (ring-ref avy-ring 0))))
      t)

    (setf (alist-get ?. avy-dispatch-alist) 'avy-action-embark)

    (define-key isearch-mode-map (kbd "M-j") 'avy-isearch)

    (meow-define-keys
	'normal
      '("=" . avy-goto-char-timer))
    )

(use-package emacs
  :straight nil
  :config
    (defun better-scroll-up-half (&optional arg)
    "Scroll up by half a screen and recenter.
  With prefix ARG, scroll ARG lines instead."
    (interactive "P")
    (let ((n (if arg
                 (prefix-numeric-value arg)
               (/ (window-body-height) 2))))
      (scroll-up-command n)
      (recenter)))

  (defun better-scroll-down-half (&optional arg)
    "Scroll down by half a screen and recenter.
  With prefix ARG, scroll ARG lines instead."
    (interactive "P")
    (let ((n (if arg
                 (prefix-numeric-value arg)
               (/ (window-body-height) 2))))
      (scroll-down-command n)
      (recenter)))

  (global-set-key (kbd "C-v") 'better-scroll-up-half)
  (global-set-key (kbd "M-v") 'better-scroll-down-half)
  )

(provide 'lpac-core-movements)
