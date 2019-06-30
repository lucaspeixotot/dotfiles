(require 'org)
(org-babel-load-file
 (expand-file-name "settings.org"
                   user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (winum pretty-mode beacon which-key use-package telephone-line smartparens rainbow-delimiters projectile powerline-evil org-bullets nlinum-relative neotree linum-relative key-chord hl-fill-column highlight-numbers helm ggtags general fill-column-indicator evil-org evil-nerd-commenter evil-mc evil-magit evil-escape doom-themes doom-modeline dimmer diminish counsel-etags company-irony color-identifiers-mode cmake-font-lock buffer-move auto-complete anzu ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
