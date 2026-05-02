;; -*- lexical-binding: t -*-

(use-package eglot
  :straight t
  :config
  ;; Manual start and useful actions
  (global-set-key (kbd "C-c l e") #'eglot)
  (global-set-key (kbd "C-c l d") #'eglot-shutdown)
  (global-set-key (kbd "C-c l o") #'eglot-code-action-organize-imports)
  (global-set-key (kbd "C-c l f") #'eglot-format-buffer)
  (global-set-key (kbd "C-c l a") #'eglot-code-actions)
  (global-set-key (kbd "C-c l r") #'eglot-rename)
  )


(provide 'lpac-ide-eglot)
