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
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; yes and no alias
(defalias 'yes-or-no-p 'y-or-n-p)

;; enable C-u for evil mode
(setq evil-want-C-u-scroll t)

;; line number
(global-linum-mode t)

;; c config
(setq-default c-basic-offset 4
            indent-tabs-mode nil)

;; office code pro
(set-frame-font "Office Code Pro-10" nil t)

;; smooth scroll
(setq scroll-step           5
        scroll-conservatively 10000)

;; highlight C functions
(font-lock-add-keywords
 'c-mode
 '(("\\<\\(\\sw+\\) ?(" 1 'font-lock-function-name-face)))

;; dont change current directory
(add-hook 'find-file-hook #'(lambda () (setq default-directory 'default_directory)))



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
    "wl"  '(windmove-right :which-key "move right")
    "wh"  '(windmove-left :which-key "move left")
    "wk"  '(windmove-up :which-key "move up")
    "wj"  '(windmove-down :which-key "move bottom")
    "wv"  '(split-window-right :which-key "split right")
    "ws"  '(split-window-below :which-key "split bottom")
    "nt"  '(neotree-toggle :which-key "open/close neotree")
    "q"  '(delete-window :which-key "delete window")
    "W"  '(save-buffer :which-key "save current buffer")
  ))

(use-package neotree
  :ensure t
  )

;;key-chord
(use-package key-chord
  :ensure t
  :init
  (setq key-chord-two-keys-delay 0.3)
  (key-chord-mode 1)
  (key-chord-define evil-normal-state-map "fd" 'evil-force-normal-state)
  (key-chord-define evil-visual-state-map "fd" 'evil-change-to-previous-state)
  (key-chord-define evil-insert-state-map "fd" 'evil-normal-state)
  (key-chord-define evil-replace-state-map "fd" 'evil-normal-state)
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

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CUSTOM SET VARIABLES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (rainbow-delimiters color-identifiers-mode doom-themes neotree helm key-chord evil-escape-mode general evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
