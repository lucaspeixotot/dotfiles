;; -*- lexical-binding: t -*-

(use-package emacs
  :straight nil
  :config
  ;; Line number configs
  (global-display-line-numbers-mode)
  
  ;; Smooth scrolling
  (setq scroll-margin 3)
  (setq scroll-preserve-screen-position 3)
  (setq scroll-conservatively most-positive-fixnum)
  (setq scroll-step 1)
  (add-hook 'xref-after-return-hook 'recenter)

  ;; UI Tweaks
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  ;; Tabs
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)

  ;; Zooming
  (global-set-key (kbd "C-=") 'text-scale-increase)
  (global-set-key (kbd "C--") 'text-scale-decrease)
  (global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
  (global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

  ;; Trailing spaces
  (setq-default show-trailing-whitespace nil)
  (add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

  ;; Electric pair
  (electric-pair-mode)

  ;; ISearch
  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "(%s/%s) ")
  (setq lazy-count-suffix-format nil)
  (setq search-whitespace-regexp ".*?")
  ;; Isearch in other windows
  (defun isearch-forward-other-window (prefix)
    "Function to isearch-forward in other-window."
    (interactive "P")
    (unless (one-window-p)
      (save-excursion
        (let ((next (if prefix -1 1)))
          (other-window next)
          (isearch-forward)
          (other-window (- next))))))

  (defun isearch-backward-other-window (prefix)
    "Function to isearch-backward in other-window."
    (interactive "P")
    (unless (one-window-p)
      (save-excursion
        (let ((next (if prefix 1 -1)))
          (other-window next)
          (isearch-backward)
          (other-window (- next))))))

  (define-key global-map (kbd "C-M-s") 'isearch-forward-other-window)
  (define-key global-map (kbd "C-M-r") 'isearch-backward-other-window)

  ;; Mark ring
  (setq set-mark-command-repeat-pop t)

  ;; Backup
  (defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
  (setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
  (setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
  (setq auto-save-list-file-prefix
      emacs-tmp-dir)
  )


(use-package ediff
    :custom
    (ediff-window-setup-function 'ediff-setup-windows-plain) ; Use a single frame for ediff
    (ediff-split-window-function 'split-window-horizontally) ; Split windows side by side
    (ediff-merge-split-window-function 'split-window-horizontally))

(use-package switch-window
  :straight t
  :config
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-threshold 2)
  (setq switch-window-minibuffer-shortcut ?z)
  :bind
   ([remap other-window] . switch-window)
  )

(use-package wgrep
    :straight t
    :config
    (setq wgrep-auto-save-buffer t)
    )

(provide 'lpac-core-basics)
