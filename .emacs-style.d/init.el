(require 'org)
(org-babel-load-file
 (expand-file-name "config.org"
                   user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hydra-default-hint nil)
 '(package-selected-packages
   (quote
    (dts-mode clang-format yasnippet-snippets yasnippet counsel ivy ag projectile buffer-move neotree magit emacs-surround sudo-edit switch-window smex smartparens avy cmake-font-lock pretty-mode beacon anzu hydra rainbow-delimiters doom-modeline org-bullets which-key use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
