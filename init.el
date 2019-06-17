;; name and email
(setq user-full-name "Lucas Peixoto")
(setq user-mail-address "lucaspeixotoac@gmail.com")

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

;; Fix undo tree bug
(setq undo-tree-enable-undo-in-region nil)

;; indentation
(setq tab-width 4
      indent-tabs-mode nil)

;; backup files
;;(setq make-backup-files nil)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; yes and no alias
(defalias 'yes-or-no-p 'y-or-n-p)

;; enable C-u for evil mode
(setq evil-want-C-u-scroll t)

;; line number
(global-linum-mode t)
(global-visual-line-mode t)  

;; (add-hook 'prog-mode-hook '(lambda ()
;;     (setq truncate-lines nil
;;           word-wrap t)))

;; c config
(setq-default c-basic-offset 4
            indent-tabs-mode nil)

;; office code pro
(set-frame-font "Office Code Pro-10" nil t)
;; (set-frame-font "Hack-10" nil t)
(setq popup-use-optimized-column-computation nil)

;; smooth scroll
(setq scroll-step           5
        scroll-conservatively 10000)

;; highlight C functions
(font-lock-add-keywords
 'c-mode
 '(("\\<\\(\\sw+\\) ?(" 1 'font-lock-function-name-face)))

(font-lock-add-keywords
 'c++-mode
 '(("\\<\\(\\sw+\\) ?(" 1 'font-lock-function-name-face)))

;; highlight match paren
(show-paren-mode 1)

;; generate tags
(defun compile-tags ()
  ;; "compile etags for the current project"
  ;; (interactive)
  (when (projectile-project-root)
    (save-window-excursion
    (cd (projectile-project-root))
    ;; (compile "find . -regex '.*/.*\.\(c\|cpp\|h\|hpp\)$' -print | etags -")
    (compile "ctags -R -e .")
    ))
  )
(add-hook 'after-save-hook (lambda () (compile-tags)))
(setq tags-revert-without-query 1)

;; history
(setq savehist-file "~/.emacs.d/savehist")
(setq history-length 1000)
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
(setq undo-tree-auto-save-history t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Package configs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "http://stable.melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)



;; Vim mode
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "C-h") #'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") #'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") #'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") #'evil-window-right)
 )

;; Helm
(use-package helm
  :ensure t
  :init
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-candidate-number-list 50))

;; Which Key
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))


(defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (if (neo-global--window-exists-p)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name)))
        (message "Could not find git project root."))))

(use-package neotree
  :ensure t
  :config
    (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
    (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-quick-look)
    (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
    (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
    (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
    (evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
    (evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
    (evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
    (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle) 
    (evil-define-key 'normal neotree-mode-map (kbd "v") 'neotree-enter-vertical-split) 
    (evil-define-key 'normal neotree-mode-map (kbd "s") 'neotree-enter-horizontal-split) 
    (add-hook 'neotree-mode-hook
        (lambda ()
            (visual-line-mode -1)
            (setq truncate-lines t)))
  )

(use-package evil-escape
  :ensure t
  :init
  (evil-escape-mode t)
  :config
  (setq-default evil-escape-key-sequence "fd")
  (setq-default evil-escape-delay 0.1)
)

;; doom themes
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-dracula t)
  )

;; highlight numbers
(use-package highlight-numbers
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'highlight-numbers-mode))

;; highlight delimiters
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; projectile
(use-package projectile
  :ensure t
  :init
  :config
  (projectile-mode +1)
  )

;; cmake font lock
(use-package cmake-font-lock
  :ensure t
  :config
  (autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
  (add-hook 'cmake-mode-hook 'cmake-font-lock-activate)
  )

;; smart parens
(use-package smartparens
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'smartparens-mode)
  )

(use-package ag
  :ensure t
  :config
  (setq ag-highlight-search t) 
  )

;; all-the-icons
(use-package all-the-icons
  :ensure t)

;; fill column indicator
;; (use-package fill-column-indicator
;;   :ensure t
;;   :init
;;   (define-globalized-minor-mode
;;     global-fci-mode fci-mode (lambda () (fci-mode 1)))
;;   (global-fci-mode 1)
;;   (setq fci-rule-width 4))

;; telephone-line
;; (use-package telephone-line
;;   :ensure t
;;   :init
;;   (setq telephone-line-lhs
;;       '((evil   . (telephone-line-evil-tag-segment))
;;         (accent . (telephone-line-vc-segment
;;                    telephone-line-erc-modified-channels-segment
;;                    telephone-line-process-segment))
;;         (nil    . (telephone-line-minor-mode-segment
;;                    telephone-line-buffer-segment))))
;; (setq telephone-line-rhs
;;       '((nil    . (telephone-line-misc-info-segment))
;;         (accent . (telephone-line-major-mode-segment))
;;         (evil   . (telephone-line-airline-position-segment))))
;;     :config
;;     (telephone-line-mode 1)
;;    )

;; powerline
;; (use-package powerline
;;   :ensure t
;;   :config
;;   (powerline-default-theme))

;; powerline evil
;; (use-package powerline-evil
;;   :ensure t
;;   :config
;;   (powerline-evil-vim-theme)
;; )


;; dimmer-mode
(use-package dimmer
  :ensure t
  :init
  (setq dimmer-fraction 0.2)
  :config
  (dimmer-mode 1)
  )

;; Custom keybinding
(use-package general
  :ensure t
  :config (general-define-key
    :states '(normal visual insert emacs)
    :prefix "SPC"
    :non-normal-prefix "M-SPC"
    "SPC" '(helm-M-x :which-key "M-x")
    "ff"  '(helm-find-files :which-key "find files")
    ;; Buffers
    "bb"  '(helm-buffers-list :which-key "buffers list")
    ;; Window
    "nt"  '(neotree-project-dir :which-key "open/close neotree")
    "q"  '(delete-window :which-key "delete window")
    "w"  '(save-buffer :which-key "save current buffer")
    ;; projectile
    "p" '(projectile-command-map :which-key "open projectile menu")
    ;; comment a region
    "c" '(comment-line :which-key "comment a region")
    "orc" '((find-file "~/.emacs.d/init.el") :which-key "open rc emacs file")
  ))

(use-package auto-complete
  :ensure t
  :init
  (ac-config-default)
  :config
    (define-key ac-complete-mode-map "\C-n" 'ac-next)
    (define-key ac-complete-mode-map "\C-p" 'ac-previous)
  )

(use-package anzu
  :ensure t
  :config
  (global-anzu-mode +1))

;; diminish
(use-package diminish
  :ensure t
  :config
  (diminish 'projectile-mode)
  (diminish 'undo-tree-mode)
  (diminish 'eldoc-mode)
  (diminish 'flymake-mode)
  (diminish 'irony-mode)
  (diminish 'company-mode)
  (diminish 'counsel-company)
  (diminish 'smartparens-mode)
  (diminish 'which-key-mode)
  (diminish 'abbrev-mode)
  (diminish 'visual-line-mode)
  (diminish 'anzu-mode)
  (diminish 'magit-mode)
  )

;; magit
(use-package magit
  :ensure t)

;; evilmagit
(use-package evil-magit
  :ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CUSTOM SET VARIABLES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil-magit anzu column-marker doxygen evil-escape powerline counsel-etags dimmer telephone-line fill-column-indicator ag smartparens cmake-font-lock projectile rainbow-delimiters color-identifiers-mode doom-themes neotree helm key-chord evil-escape-mode general evil use-package)))
 '(projectile-mode t nil (projectile))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
