;; -*- lexical-binding: t -*-

(use-package inf-ruby
  :straight t
  :config
  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
  (add-hook 'ruby-ts-mode-hook 'inf-ruby-minor-mode)

  )

(use-package rbenv
  :straight t
  :config (global-rbenv-mode))

(use-package robe
  :straight t
  :config
  (add-hook 'ruby-mode-hook 'robe-mode)
  (add-hook 'ruby-ts-mode-hook 'robe-mode)
  )

(provide 'lpac-ide-languages)
