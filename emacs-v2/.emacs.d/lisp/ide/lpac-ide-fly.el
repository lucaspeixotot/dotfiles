;; -*- lexical-binding: t -*-

  (use-package flycheck
    :straight t
    :init (global-flycheck-mode)
    :config
    (setq flycheck-check-syntax-automatically '(mode-enabled idle-change))
    )

  (use-package flycheck-eglot
    :straight t
    :after (flycheck eglot)
    :config
    (global-flycheck-eglot-mode 1))


(provide 'lpac-ide-fly)
