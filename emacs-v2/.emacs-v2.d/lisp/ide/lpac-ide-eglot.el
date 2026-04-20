;; -*- lexical-binding: t -*-

(use-package eldoc-box
    :straight t
    :config
    ;; (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
    (global-set-key (kbd "M--") 'eldoc-box-help-at-point)
    )

(use-package eglot
    :straight nil
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
