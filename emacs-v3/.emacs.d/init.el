;;; -*- lexical-binding: t; -*-

;;;   ________                                                                           __
;;;  /        |                                                                         /  |
;;;  $$$$$$$$/  _____  ____    ______    _______   _______         _______  __     __  _$$ |_
;;;  $$ |__    /     \/    \  /      \  /       | /       |       /       |/  \   /  |/ $$   |
;;;  $$    |   $$$$$$ $$$$  | $$$$$$  |/$$$$$$$/ /$$$$$$$/       /$$$$$$$/ $$  \ /$$/ $$$$$$/
;;;  $$$$$/    $$ | $$ | $$ | /    $$ |$$ |      $$      \       $$ |       $$  /$$/    $$ | __
;;;  $$ |_____ $$ | $$ | $$ |/$$$$$$$ |$$ \_____  $$$$$$  |      $$ \_____   $$ $$/     $$ |/  |
;;;  $$       |$$ | $$ | $$ |$$    $$ |$$       |/     $$/       $$       |   $$$/      $$  $$/
;;;  $$$$$$$$/ $$/  $$/  $$/  $$$$$$$/  $$$$$$$/ $$$$$$$/         $$$$$$$/     $/        $$$$/


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Package setup
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.
;; See `package-archive-priorities` and `package-pinned-packages`.
;; Most users will not need or want to do this.
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Font settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set the default font globally
(set-face-attribute 'default nil :family "JetBrains Mono NL" :height 100 :weight 'normal)

;; Ensure consistency for fixed-pitch and variable-pitch faces
(set-face-attribute 'fixed-pitch nil :family "JetBrains Mono NL" :height 100)
(set-face-attribute 'variable-pitch nil :family "JetBrains Mono NL" :height 1.0)

;; Fine-tune specific faces as desired
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
(set-face-attribute 'font-lock-string-face nil :slant 'italic)
(set-face-attribute 'bold nil :weight 'bold)

;; ;; Optional: Adjust frame-specific settings like line spacing
(setq-default line-spacing 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Themes
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ef-themes
  :ensure t
  :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(ef-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/ef-themes#h:6585235a-5219-4f78-9dd5-6a64d87d1b6e>
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)

  ;; Finally, load your theme of choice (or a random one with
  ;; `modus-themes-load-random', `modus-themes-load-random-dark',
  ;; `modus-themes-load-random-light').
  (modus-themes-load-theme 'ef-duo-dark))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Undo and history
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Create backup files in dedicated location
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

;; Improve undo/redo experience
(use-package undo-fu
  :ensure t
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z")   'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo)
  )

;;; Persist undo tree
(use-package undo-fu-session
  :ensure t
  :config
  (undo-fu-session-global-mode)
  )

;; Visual undo/redo tree
(use-package vundo
  :ensure t
  :bind (
         ("C-x u" . vundo)
         )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Misc
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Line number configs
(global-display-line-numbers-mode)

;; Smooth scrolling
(setq scroll-margin 3)
(setq scroll-preserve-screen-position 3)
(setq scroll-conservatively most-positive-fixnum)
(setq scroll-step 1)
(add-hook 'xref-after-return-hook 'recenter)

;; UI Tweaks
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Zooming
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; Trailing spaces
(setq-default show-trailing-whitespace t)

;; Electric pair
(electric-pair-mode)

;; Mark ring
(setq set-mark-command-repeat-pop t)

;; ediff tweak config
(use-package ediff
    :custom
    (ediff-window-setup-function 'ediff-setup-windows-plain) ; Use a single frame for ediff
    (ediff-split-window-function 'split-window-horizontally) ; Split windows side by side
    (ediff-merge-split-window-function 'split-window-horizontally))

;; Enable massive edition under search results (like from embark)
(use-package wgrep
    :ensure t
    :config
    (setq wgrep-auto-save-buffer t)
    )

(use-package repeat
  :ensure t
  :hook (after-init . repeat-mode))

(use-package repeat-help
  :ensure t
  :hook (repeat-mode . repeat-help-mode))

(use-package multiple-cursors
  :ensure t

  :config
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  )

(use-package symbol-overlay
  :ensure t
  :defer t
  :hook (prog-mode . symbol-overlay-mode)
  :bind (
         ("C-;" . symbol-overlay-put)
         ("M-N" . symbol-overlay-jump-next)
         ("M-P" . symbol-overlay-jump-previous)))

(use-package symbol-overlay-mc
  :ensure t
  :bind (("M-a" . symbol-overlay-mc-mark-all)))

(use-package surround
  :ensure t
  :bind-keymap ("C-0" . surround-keymap))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Search utilities
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ripgrep
  :defer t)

(use-package rg
  :defer t)

(use-package ag
  :defer t)

(use-package wgrep
  :defer t)
  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "(%s/%s) ")
  (setq lazy-count-suffix-format nil)
  (setq search-whitespace-regexp ".*?")
  ;; Isearch in other windows
  (defun isearch-forward-other-window (prefix)
    "Function to isearch-forward in other-window."
    (interactive "P")
    (unless (one-window-p)
      (save-excursion
        (let ((next (if prefix -1 1)))
          (other-window next)
          (isearch-forward)
          (other-window (- next))))))

  (defun isearch-backward-other-window (prefix)
    "Function to isearch-backward in other-window."
    (interactive "P")
    (unless (one-window-p)
      (save-excursion
        (let ((next (if prefix 1 -1)))
          (other-window next)
          (isearch-backward)
          (other-window (- next))))))

  (define-key global-map (kbd "C-M-s") 'isearch-forward-other-window)
  (define-key global-map (kbd "C-M-r") 'isearch-backward-other-window)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Keybindings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package which-key
  :ensure t
  :config
  (setq which-key-side-window-location 'bottom
  	  which-key-sort-order #'which-key-key-order-alpha
  	  which-key-sort-uppercase-first nil
  	  which-key-add-column-padding 1
  	  which-key-max-display-columns nil
  	  which-key-min-display-lines 6
  	  which-key-side-window-slot -10
  	  which-key-side-window-max-height 0.25
  	  which-key-idle-delay 0.5
  	  which-key-max-description-length 25
  	  which-key-allow-imprecise-window-fit nil
  	  which-key-separator " → " )
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Extras
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Better UI/UX
(load-file (expand-file-name "extras/uiux.el" user-emacs-directory))

;;; Emacs better movements
(load-file (expand-file-name "extras/movements.el" user-emacs-directory))

;;; Dev settings
(load-file (expand-file-name "extras/dev.el" user-emacs-directory))

;;; Languages specific settings
(load-file (expand-file-name "extras/ai.el" user-emacs-directory))

;;; Languages specific settings
(load-file (expand-file-name "langs/elisp.el" user-emacs-directory))
(load-file (expand-file-name "langs/golang.el" user-emacs-directory))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Built-in customization framework
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(agent-shell breadcrumb consult-dir dashboard diff-hl dumb-jump eca
                 ef-themes eldoc-box embark-consult go-add-tags
                 god-mode macrostep marginalia orderless paredit
                 repeat-help surround symbol-overlay-mc tabspaces
                 treemacs-magit treesit-auto undo-fu undo-fu-session
                 undo-tree vertico vundo wgrep))
 '(treesit-font-lock-level 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq gc-cons-threshold (or cvt--initial-gc-threshold 800000))
