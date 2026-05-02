;; -*- lexical-binding: t -*-

(use-package smerge-mode
  :straight t
  :hook
  (prog-mode . smerge-mode)
  )

(use-package magit
    :straight t
    :config
    (setq magit-ediff-dwim-show-on-hunks t)
    (with-eval-after-load 'project
      (define-key project-prefix-map "m" #'magit-project-status)
      (add-to-list 'project-switch-commands '(magit-project-status "Magit") t))
    )

(use-package diff-hl
    :straight t
    :config
    (global-diff-hl-mode)
    )

(provide 'lpac-core-git)
