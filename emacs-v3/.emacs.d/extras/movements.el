;;; -*- lexical-binding: t; -*-

;;;   ________                                                                           __
;;;  /        |                                                                         /  |
;;;  $$$$$$$$/  _____  ____    ______    _______   _______         _______  __     __  _$$ |_
;;;  $$ |__    /     \/    \  /      \  /       | /       |       /       |/  \   /  |/ $$   |
;;;  $$    |   $$$$$$ $$$$  | $$$$$$  |/$$$$$$$/ /$$$$$$$/       /$$$$$$$/ $$  \ /$$/ $$$$$$/
;;;  $$$$$/    $$ | $$ | $$ | /    $$ |$$ |      $$      \       $$ |       $$  /$$/    $$ | __
;;;  $$ |_____ $$ | $$ | $$ |/$$$$$$$ |$$ \_____  $$$$$$  |      $$ \_____   $$ $$/     $$ |/  |
;;;  $$       |$$ | $$ | $$ |$$    $$ |$$       |/     $$/       $$       |   $$$/      $$  $$/
;;;  $$$$$$$$/ $$/  $$/  $$/  $$$$$$$/  $$$$$$$/ $$$$$$$/         $$$$$$$/     $/        $$$$/

;;; Avy to jump to characters quickly
(use-package avy
  :custom
  (avy-keys '(?q ?e ?r ?y ?u ?o ?p
              ?a ?s ?d ?f ?g ?h ?j
              ?k ?l ?' ?x ?c ?v ?b
              ?n ?, ?/))
  :bind (("M-RET" . avy-goto-char-timer)
         ("M-j" . avy-goto-char)
         ("M-l" . avy-goto-line)
         :map isearch-mode-map
         ("M-j" . avy-isearch))
  :config
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
  )

;;; Ace window to jump to windows quickly
(use-package ace-window
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-background nil)
  (aw-dispatch-always nil)
  (aw-ignore-on nil)
  (aw-ignore-current nil)
  :config
  (defvar aw-dispatch-alist
    '((?x aw-delete-window "Delete Window")
      (?m aw-swap-window "Swap Windows")
      (?M aw-move-window "Move Window")
      (?c aw-copy-window "Copy Window")
      (?j aw-switch-buffer-in-window "Select Buffer")
      (?n aw-flip-window)
      (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
      (?s aw-split-window-fair "Split Fair Window")
      (?v aw-split-window-vert "Split Vert Window")
      (?b aw-split-window-horz "Split Horz Window")
      (?o delete-other-windows "Delete Other Windows")
      (?? aw-show-dispatch-help))
    "List of actions for `aw-dispatch-default'.")
  ;; (ace-window-display-mode)
  :bind
  ([remap other-window] . ace-window)
  :config
  (defvar cvt/ace-window-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "o") #'ace-window)
      map)
    "Repeat map for `ace-window`.")

  (put 'ace-window 'repeat-map 'cvt/ace-window-repeat-map))

;;; God mode for better file navigation (save pinky)
(use-package god-mode
  :bind (("M-1" . (lambda () (interactive) (god-mode-all 1)))
         ("C-x C-1" . delete-other-windows)
         ("C-x C-2" . split-window-below)
         ("C-x C-3" . split-window-right)
         ("C-x C-0" . delete-window)
         :map god-local-mode-map
         ("i" . god-mode-all)
         ("." . repeat)
         ("[" . backward-paragraph)
         ("]" . forward-paragraph)
         :map isearch-mode-map
         ("<escape>" . god-mode-isearch-activate)
         :map god-mode-isearch-map
         ("<escape>" . god-mode-isearch-disable))
  :hook ((god-mode-enabled . my-god-mode-highlight-line)
         (god-mode-disabled . my-god-mode-highlight-line))
  :custom-face
  (god-mode-lighter ((t (:inherit error))))
  :config
  (require 'god-mode-isearch)
  (defun my-god-mode-highlight-line ()
    "Enable hl-line-mode when god-mode is active."
    (if god-local-mode
        (hl-line-mode 1)
      (hl-line-mode -1))))

;;; Better M-v/C-v
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


(use-package key-chord
  :config
  (key-chord-mode 1)
  (setq
   key-chord-two-keys-delay 0.1
   key-chord-one-key-delay 0.2
   key-chord-in-macros nil
   key-chord-one-key-min-delay 0.0
   key-chord-typing-detection nil
   key-chord-typing-speed-threshold 0.1
   key-chord-typing-reset-delay 0.5
   key-chord-use-key-tracking t
   )
  (key-chord-define-global "jf" 'hydra-moves/body)
  )

(use-package hydra
  :straight t
  :init
  (defhydra hydra-moves ()
      "emacs fast movements"
      ("l" forward-char)
      ("h" backward-char)
      ("j" next-line)
      ("k" previous-line)
      ("J" (lambda () (interactive) (next-line) (recenter)))
      ("K" (lambda () (interactive) (previous-line) (recenter)))
      ("a" beginning-of-line)
      ("e" end-of-line)
      ("w" forward-word)
      ("b" backward-word)
      ("u" better-scroll-down-half)
      ("d" better-scroll-up-half)
      ("z" recenter-top-bottom)
      ("c" kirigami-close-fold)
      ("C" kirigami-close-folds)
      ("o" kirigami-open-fold)
      ("O" kirigami-open-fold-rec)
      ("r" treesit-fold-open-recursively)
      ("RET" avy-goto-char-timer)
      ("f" avy-goto-char-in-line)
      (";" symbol-overlay-put)
      ("n" symbol-overlay-jump-next)
      ("p" symbol-overlay-jump-prev)
      ("." embark-dwim)
      ("," xref-go-back)
      ("?" xref-find-references)
      ("q" nil "quit"))
  )

(use-package avy-zap
  :straight t
  :config
  (global-set-key (kbd "M-z") 'avy-zap-to-char-dwim)
  (global-set-key (kbd "M-Z") 'avy-zap-up-to-char-dwim)
  )

(use-package expand-region
  :straight t
  :config
  (global-set-key (kbd "C-0") 'er/expand-region)
  )
