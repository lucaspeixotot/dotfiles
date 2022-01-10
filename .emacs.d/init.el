(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)
(straight-use-package 'use-package)
(use-package straight
  :custom (straight-use-package-by-default t))
(straight-use-package 'use-package)
(straight-use-package 'org)
(org-babel-load-file
(expand-file-name "config.org"
                   user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hydra-default-hint nil)
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (sphinx-doc frog-jump-buffer smart-hungry-delete goto-line-preview ccls flycheck company-lsp lsp-ui lsp-mode company imenu-anywhere key-chord latex-preview-pane multiple-cursors move-text zzz-to-char dts-mode clang-format yasnippet-snippets yasnippet counsel-projectile counsel ivy undo-tree ag projectile buffer-move neotree magit expand-region ace-window smex smartparens avy cmake-font-lock org-bullets highlight-numbers pretty-mode beacon anzu rainbow-delimiters doom-themes doom-modeline hydra which-key all-the-icons use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
