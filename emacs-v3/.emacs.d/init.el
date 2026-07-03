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

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Use gcmh to dynamically manage GC: high threshold while typing,
;; low threshold when idle. Replaces manual gc-cons-threshold dance.
(use-package gcmh
  :demand t
  :custom
  ;; gc-cons-threshold is a *garbage budget*, not a memory cap. It bounds how
  ;; much RSS can spike above the live working set (~51 MB here) during a burst
  ;; of allocation before a collection runs. 128 MB covers every realistic
  ;; single interactive command (completion, grep, LSP, LLM streaming chunk),
  ;; so we keep ~all of gcmh's anti-stutter benefit while capping worst-case
  ;; RSS at ~180 MB instead of ~1 GB. Larger values (512 MB+) buy ~no extra
  ;; latency benefit but let RSS reach a high-water mark that glibc won't
  ;; return to the OS (relevant to Emacs 30 memory-growth reports).
  (gcmh-high-cons-threshold (* 512 1024 1024))
  (gcmh-idle-delay 15)
  :config
  (gcmh-mode 1))

(use-package exec-path-from-shell
  :config
  (dolist (var '("DEEPSEEK_API_KEY_EMACS"))
    (add-to-list 'exec-path-from-shell-variables var))

  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Themes
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ef-themes
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
  :custom
  (modus-themes-mixed-fonts t)
  (modus-themes-italic-constructs t)
  :config
  ;; Finally, load your theme of choice (or a random one with
  ;; `modus-themes-load-random', `modus-themes-load-random-dark',
  ;; `modus-themes-load-random-light').
  (modus-themes-load-theme 'ef-melissa-light))


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
  :bind (("C-z" . undo-fu-only-undo)
         ("C-S-z" . undo-fu-only-redo)))

;; Persist undo tree between sessions.  File limit prevents unbounded
;; disk growth in ~/.emacs.d/undo-fu-session/ by retaining undo data
;; for only the 200 most recently edited files.
(use-package undo-fu-session
  :custom
  (undo-fu-session-file-limit 200)
  :config
  (undo-fu-session-global-mode))

;; Visual undo/redo tree
(use-package vundo
  :bind (
         ("C-x u" . vundo)
         )
  )

(use-package saveplace
  :straight nil
  :hook (after-init . save-place-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Misc
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; UI Tweaks
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Electric pair
(electric-pair-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Emacs settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :straight nil
  :custom
  (scroll-margin 3)
  (scroll-preserve-screen-position 3)
  (scroll-conservatively most-positive-fixnum)
  (scroll-step 1)
  (indent-tabs-mode nil)
  (tab-width 4)
  (show-trailing-whitespace nil)
  (set-mark-command-repeat-pop t)
  (hscroll-margin 1)
  (hscroll-step 1)
  (vc-handled-backends '(Git))
  (auto-revert-remote-files nil)
  (enable-remote-dir-locals nil)
  :init
  (put 'scroll-left 'disabled nil)
  (put 'scroll-right 'disabled nil)
  :hook ((prog-mode . display-line-numbers-mode)
         (prog-mode . my/truncate-lines-for-code)
         (prog-mode . my/show-trailing-whitespace)
         (text-mode . visual-line-mode)
         (xref-after-return . recenter))
  :bind (("C-=" . text-scale-increase)
         ("C--" . text-scale-decrease)
         ("<C-wheel-up>" . text-scale-increase)
         ("<C-wheel-down>" . text-scale-decrease)
         ("C-M-s" . isearch-forward-regexp)
         ("C-M-r" . isearch-backward-regexp))
  :config
  (defun my/truncate-lines-for-code ()
    "Truncate long lines in programming buffers."
    (setq-local truncate-lines t))

  (defun my/show-trailing-whitespace ()
    (setq-local show-trailing-whitespace t))

  (global-visual-wrap-prefix-mode 1)

  ;; Font settings
  (set-face-attribute 'default nil :family "JetBrains Mono NL" :height 100 :weight 'normal)
  (set-face-attribute 'fixed-pitch nil :family "JetBrains Mono NL" :height 100)
  (set-face-attribute 'variable-pitch nil :family "Literata" :height 110)
  (set-face-attribute 'bold nil :weight 'bold)
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
  (set-face-attribute 'font-lock-string-face nil :slant 'italic)
  (setq-default line-spacing 1)

  (global-display-line-numbers-mode 1))

;; ediff tweak config
(use-package ediff
    :straight nil
    :custom
    (ediff-window-setup-function 'ediff-setup-windows-plain) ; Use a single frame for ediff
    (ediff-split-window-function 'split-window-horizontally) ; Split windows side by side
    (ediff-merge-split-window-function 'split-window-horizontally))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Dired
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dired
  :straight nil
  :bind (:map dired-mode-map
              ("C-w" . my/dired-open-with-ace-window))
  :config
  (defun my/dired-open-with-ace-window ()
    "Open file at point in a window selected via `ace-window'."
    (interactive)
    (require 'ace-window)
    (let ((file (dired-get-file-for-visit))
          (window (aw-select "Select target window")))
      (when file
        (with-selected-window window
          (find-file file))))))


;; Enable massive edition under search results (like from embark)
(use-package wgrep
  :defer t
  :custom
  (wgrep-auto-save-buffer t))

(use-package repeat
  :straight nil
  :hook (after-init . repeat-mode))

(use-package repeat-help
  :hook (repeat-mode . repeat-help-mode))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package symbol-overlay
  :defer t
  :hook (prog-mode . symbol-overlay-mode)
  :bind (
         ("C-;" . symbol-overlay-put)
         ("M-n" . symbol-overlay-jump-next)
         ("M-p" . symbol-overlay-jump-prev)
         ("M-N" . symbol-overlay-switch-forward)
         ("M-P" . symbol-overlay-switch-backward)
         ))

(use-package symbol-overlay-mc
  :bind (("M-a" . symbol-overlay-mc-mark-all)))

(use-package surround
  :bind-keymap ("C-c C-s" . surround-keymap))

(use-package helpful
  ;; Note that the built-in `describe-function' includes both functions
  ;; and macros. `helpful-function' is functions only, so we provide
  ;; `helpful-callable' as a drop-in replacement.
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-c C-d" . helpful-at-point)
         ;; Look up *F*unctions (excludes macros).
         ;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
         ;; already links to the manual, if a function is referenced there.
         ("C-h F" . helpful-function)))

(use-package stripspace
  ;; Enable for prog-mode-hook, text-mode-hook, conf-mode-hook
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode))

  :custom
  ;; The `stripspace-only-if-initially-clean' option:
  ;; - nil to always delete trailing whitespace.
  ;; - Non-nil to only delete whitespace when the buffer is clean initially.
  ;; (The initial cleanliness check is performed when `stripspace-local-mode'
  ;; is enabled.)
  (stripspace-only-if-initially-clean nil)

  ;; Enabling `stripspace-restore-column' preserves the cursor's column position
  ;; even after stripping spaces. This is useful in scenarios where you add
  ;; extra spaces and then save the file. Although the spaces are removed in the
  ;; saved file, the cursor remains in the same position, ensuring a consistent
  ;; editing experience without affecting cursor placement.
  (stripspace-restore-column t))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Search utilities
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Keybindings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package which-key
  :custom
  (which-key-side-window-location 'bottom)
  (which-key-sort-order #'which-key-key-order-alpha)
  (which-key-sort-uppercase-first nil)
  (which-key-add-column-padding 1)
  (which-key-max-display-columns nil)
  (which-key-min-display-lines 6)
  (which-key-side-window-slot -10)
  (which-key-side-window-max-height 0.25)
  (which-key-idle-delay 0.5)
  (which-key-max-description-length 25)
  (which-key-allow-imprecise-window-fit nil)
  (which-key-separator " → ")
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Extras
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Better UI/UX
(load (expand-file-name "extras/uiux.el" user-emacs-directory))

;;; Terminal settings
(load (expand-file-name "extras/term.el" user-emacs-directory))

;;; Emacs better movements
(load (expand-file-name "extras/movements.el" user-emacs-directory))

;;; Dev settings
(load (expand-file-name "extras/dev.el" user-emacs-directory))

;;; Languages specific settings
(load (expand-file-name "extras/ai.el" user-emacs-directory))

;;; Remote config (tramp)
(load (expand-file-name "extras/remote.el" user-emacs-directory))


;;; Misc settings
(load-file (expand-file-name "extras/misc.el" user-emacs-directory))

;;; Languages specific settings
(load (expand-file-name "langs/elisp.el" user-emacs-directory))
(load (expand-file-name "langs/golang.el" user-emacs-directory))
(load (expand-file-name "langs/terraform.el" user-emacs-directory))

;;; Org mode, notes, and study
(load (expand-file-name "extras/org-notes.el" user-emacs-directory))

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
  (modus-themes-load-theme 'ef-melissa-light))

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
 '(package-selected-packages nil)
 '(treesit-font-lock-level 4))
