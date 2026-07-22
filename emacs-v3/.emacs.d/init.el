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


(defvar user-cache-directory "~/.cache/emacs/"
  "Location where files created by emacs are placed.")

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
  :demand t
  :config
  (setq undo-fu-session-file-limit 200)
  (undo-fu-session-global-mode))

;; Visual undo/redo tree
(use-package vundo
  :bind (
         ("C-x u" . vundo)
         )
  )

(use-package saveplace
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
         ("C-M-r" . isearch-backward-regexp)
         ("C-c SPC" . my/easy-page))
  :config
  (defun my/truncate-lines-for-code ()
    "Truncate long lines in programming buffers."
    (setq-local truncate-lines t))

  (defun my/show-trailing-whitespace ()
    (setq-local show-trailing-whitespace t))

  (defun open-next-line (arg)
    "Move to the next line and then opens a line.
See also `newline-and-indent'."
    (interactive "p")
    (end-of-line)
    (open-line arg)
    (forward-line 1)
    (when newline-and-indent
      (indent-according-to-mode)))
  (global-set-key (kbd "C-o") 'open-next-line)

  (defun open-previous-line (arg)
    "Open a new line before the current one.
See also `newline-and-indent'."
    (interactive "p")
    (beginning-of-line)
    (open-line arg)
    (when newline-and-indent
      (indent-according-to-mode)))
  (global-set-key (kbd "C-S-O") 'open-previous-line)

  (global-set-key (kbd "M-]") 'forward-paragraph)
  (when (or window-system (daemonp))
    (global-set-key (kbd "M-[") 'backward-paragraph))

  (defun unfill-paragraph (&optional region)
    "Takes a multi-line paragraph and makes it into a single line of text."
    (interactive (progn (barf-if-buffer-read-only) '(t)))
    (let ((fill-column (point-max))
          (emacs-lisp-docstring-fill-column t))
      (fill-paragraph nil region)))
  (define-key global-map "\M-Q" 'unfill-paragraph)

  ;; C-a toggle between indentation and BOL
  (defun back-to-indentation-or-beginning ()
    (interactive)
    (if (= (point) (progn (beginning-of-line-text) (point)))
        (beginning-of-line)))
  (global-set-key "\C-a" 'back-to-indentation-or-beginning)

  ;; Register store DWIM
  (defun store-register-dwim (arg register)
    "Store what I mean in a register.
With an active region, store or append (with \\[universal-argument]) the
contents, optionally deleting the region (with a negative
argument). With a numeric prefix, store the number. With \\[universal-argument]
store the frame configuration. Otherwise, store the point."
    (interactive
     (list current-prefix-arg
           (register-read-with-preview "Store in register: ")))
    (cond
     ((use-region-p)
      (let ((begin (region-beginning))
            (end (region-end))
            (delete-flag (or (equal arg '-)  (equal arg '(-4)))))
        (if (consp arg)
            (append-to-register register begin end delete-flag)
          (copy-to-register register begin end delete-flag t))))
     ((numberp arg) (number-to-register arg register))
     (t (point-to-register register arg))))

  ;; Register use DWIM
  (defun use-register-dwim (register &optional arg)
    "Do what I mean with a register.
For a window configuration, restore it. For a number or text, insert it.
For a location, jump to it."
    (interactive
     (list (register-read-with-preview "Use register: ")
           current-prefix-arg))
    (condition-case nil
        (jump-to-register register arg)
      (user-error (insert-register register arg))))
  (define-key global-map (kbd "M-m") 'store-register-dwim)
  (define-key global-map (kbd "M-'") 'use-register-dwim)

  (global-visual-wrap-prefix-mode 1)

  (setq-default line-spacing 1)

  )

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
  :custom
  (wgrep-auto-save-buffer t))

(use-package repeat
  :straight nil
  :hook (after-init . repeat-mode)
  :init
  (add-hook 'repeat-mode-hook
            (lambda () (setq repeat-echo-function #'repeat-echo-message))))

(use-package repeat-help
  :hook (repeat-mode . repeat-help-mode))

(use-package embrace
  :straight t
  :bind (:map prog-mode-map
         ("M-s a" . embrace-add)
         ("M-s c" . embrace-change)
         ("M-s d" . embrace-delete)
         :map text-mode-map
         ("M-s a" . embrace-add)
         ("M-s c" . embrace-change)
         ("M-s d" . embrace-delete)))

(use-package goto-chg
  :straight t
  :bind (("M-i" . goto-last-change)
         ("M-I" . goto-last-change-reverse)))

(use-package pulsar
  :straight t
  :bind (:map global-map
         ("C-x l" . pulsar-pulse-line)
         ("C-x L" . pulsar-highlight-permanently-dwim))
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 5)
  (setq pulsar-face 'pulsar-green)
  (setq pulsar-region-face 'pulsar-yellow)
  (setq pulsar-highlight-face 'pulsar-magenta)

  ;; --- Avy commands that should pulse after jumping ---
  (setq pulsar-pulse-functions
        (append '(my/avy-goto-char-this-window
                  my/avy-goto-char-timer
                  avy-goto-char-2
                  avy-goto-line-above
                  avy-goto-line-below
                  avy-goto-end-of-line
                  avy-copy-line
                  avy-copy-region
                  avy-kill-whole-line
                  avy-kill-region
                  avy-kill-ring-save-region
                  avy-move-line
                  avy-move-region
                  avy-resume)
                pulsar-pulse-functions))

  (setq pulsar-pulse-functions
        (append '(switchy-window
                  pulsar-pulse-functions)))

  ;; existing integrations
  (add-hook 'consult-after-jump-hook #'pulsar-recenter-top)
  (add-hook 'consult-after-jump-hook #'pulsar-reveal-entry)
  (add-hook 'imenu-after-jump-hook #'pulsar-recenter-top)
  (add-hook 'imenu-after-jump-hook #'pulsar-reveal-entry)
  (add-hook 'next-error-hook #'pulsar-pulse-line)
  (add-hook 'minibuffer-setup-hook #'pulsar-pulse-line))

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
(load-file (expand-file-name "extras/rss.el" user-emacs-directory))

;;; Languages specific settings
(load (expand-file-name "langs/elisp.el" user-emacs-directory))
(load (expand-file-name "langs/golang.el" user-emacs-directory))
(load (expand-file-name "langs/terraform.el" user-emacs-directory))
(load (expand-file-name "langs/python.el" user-emacs-directory))

;;; Org mode, notes, and study
(load (expand-file-name "extras/org-notes.el" user-emacs-directory))
(load (expand-file-name "extras/spell.el" user-emacs-directory))

;;; Transients
(load (expand-file-name "extras/setup-transients.el" user-emacs-directory))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Themes
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ef-themes
  :straight t
  ;; :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(ef-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/ef-themes#h:6585235a-5219-4f78-9dd5-6a64d87d1b6e>
  ;; (ef-themes-take-over-modus-themes-mode 1)
  ;; :config

  ;; Finally, load your theme of choice (or a random one with
  ;; `modus-themes-load-random', `modus-themes-load-random-dark',
  ;; `modus-themes-load-random-light').
  ;; (modus-themes-load-theme 'ef-melissa-light)
  )

(use-package modus-themes
  :straight t
  :demand t
  :init
  ;; Starting with version 5.0.0 of the `modus-themes', other packages
  ;; can be built on top to provide their own "Modus" derivatives.
  ;; For example, this is what I do with my `ef-themes' and
  ;; `standard-themes' (starting with versions 2.0.0 and 3.0.0,
  ;; respectively).
  ;;
  ;; The `modus-themes-include-derivatives-mode' makes all Modus
  ;; commands that act on a theme consider all such derivatives, if
  ;; their respective packages are available and have been loaded.
  ;;
  ;; Note that those packages can even completely take over from the
  ;; Modus themes such that, for example, `modus-themes-rotate' only
  ;; goes through the Ef themes (to this end, the Ef themes provide
  ;; the `ef-themes-take-over-modus-themes-mode' and the Standard
  ;; themes have the `standard-themes-take-over-modus-themes-mode'
  ;; equivalent).
  ;;
  ;; If you only care about the Modus themes, then (i) you do not need
  ;; to enable the `modus-themes-include-derivatives-mode' and (ii) do
  ;; not install and activate those other theme packages.
  (modus-themes-include-derivatives-mode 1)
  :bind
  (("<f5>" . modus-themes-toggle)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-mixed-fonts nil)
  (modus-themes-variable-pitch-ui nil)
  (modus-themes-completions '((t . (bold))))
  (modus-themes-prompts '(bold))
  (modus-themes-headings
   '((agenda-structure . (variable-pitch light 2.2))
     (agenda-date . (variable-pitch regular 1.3))
     (t . (regular 1.15))))
  (modus-themes-common-palette-overrides nil)
  (modus-themes-to-rotate modus-themes-items)
  (modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi-tinted))
  :config
  ;; Also apply italic to font-lock-string-face and font-lock-keyword-face
  ;; after the theme loads.  The modus-themes-italic-constructs option only
  ;; affects comments and documentation strings, not these faces.  Using
  ;; modus-themes-after-load-theme-hook ensures our customizations survive
  ;; theme toggling, whereas set-face-attribute in the use-package emacs
  ;; block gets overridden by the theme's custom-theme-set-faces on first load.
  (add-hook 'modus-themes-after-load-theme-hook
            (lambda ()
              (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
              (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
              (set-face-attribute 'font-lock-string-face nil :slant 'italic)))
  ;; Finally, load your theme of choice.
  (modus-themes-load-theme 'modus-operandi-tinted)
  )

(use-package fontaine
  :straight t
  :demand t
  :custom
  (fontaine-latest-state-file
   (locate-user-emacs-file "fontaine-latest-state.eld"))
  (fontaine-presets
   '((regular) ; inherits all properties from the t preset
     (t
      ;; I keep all properties for didactic purposes, but most can be
      ;; omitted.  See the fontaine manual for the technicalities:
      ;; <https://protesilaos.com/emacs/fontaine>.
      :default-family "JetBrains Mono NL"
      :default-weight regular
      :default-slant normal
      :default-width normal
      :default-height 100

      :fixed-pitch-family "JetBrains Mono NL"
      :fixed-pitch-weight nil
      :fixed-pitch-slant nil
      :fixed-pitch-width nil
      :fixed-pitch-height 1.0

      :fixed-pitch-serif-family nil
      :fixed-pitch-serif-weight nil
      :fixed-pitch-serif-slant nil
      :fixed-pitch-serif-width nil
      :fixed-pitch-serif-height 1.0

      :variable-pitch-family "Literata"
      :variable-pitch-weight nil
      :variable-pitch-slant nil
      :variable-pitch-width nil
      :variable-pitch-height 1.0

      :mode-line-active-family nil
      :mode-line-active-weight nil
      :mode-line-active-slant nil
      :mode-line-active-width nil
      :mode-line-active-height 1.0

      :mode-line-inactive-family nil
      :mode-line-inactive-weight nil
      :mode-line-inactive-slant nil
      :mode-line-inactive-width nil
      :mode-line-inactive-height 1.0

      :header-line-family nil
      :header-line-weight nil
      :header-line-slant nil
      :header-line-width nil
      :header-line-height 1.0

      :line-number-family nil
      :line-number-weight nil
      :line-number-slant nil
      :line-number-width nil
      :line-number-height 1.0

      :tab-bar-family nil
      :tab-bar-weight nil
      :tab-bar-slant nil
      :tab-bar-width nil
      :tab-bar-height 1.0

      :tab-line-family nil
      :tab-line-weight nil
      :tab-line-slant nil
      :tab-line-width nil
      :tab-line-height 1.0

      :bold-family nil
      :bold-slant nil
      :bold-weight bold
      :bold-width nil
      :bold-height 1.0

      :italic-family nil
      :italic-weight nil
      :italic-slant italic
      :italic-width nil
      :italic-height 1.0

      :line-spacing nil)))
  :config
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))
  (fontaine-mode 1)
  (define-key global-map (kbd "C-c f") #'fontaine-set-preset))

(use-package doric-themes
  :straight t
  :demand t
  :config
  ;; These are the default values.
  (setq doric-themes-to-toggle '(doric-light doric-dark))
  (setq doric-themes-to-rotate doric-themes-collection)

  ;; (doric-themes-select 'doric-light)

  ;; ;; To load a random theme instead, use something like one of these:
  ;;
  ;; (doric-themes-load-random)
  ;; (doric-themes-load-random 'light)
  ;; (doric-themes-load-random 'dark)

  ;; ;; For optimal results, also define your preferred font family (or use my `fontaine' package):
  ;;
  ;; (set-face-attribute 'default nil :family "Aporetic Sans Mono" :height 160)
  ;; (set-face-attribute 'variable-pitch nil :family "Aporetic Sans" :height 1.0)
  ;; (set-face-attribute 'fixed-pitch nil :family "Aporetic Sans Mono" :height 1.0)
  )

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
 '(repeat-echo-function 'repeat-echo-message)
 '(safe-local-variable-values
   '((my/dape-cwd . "/home/cavalcan/glcp/authn")
     (my/dape-cwd . "/home/cavalcan/glcp/authn/tests/feature_test")))
 '(treesit-font-lock-level 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-lead-face ((((background dark)) :foreground "LightCoral" :background "Black" :weight bold :underline t) (((background light)) :foreground "DarkRed" :background unspecified :box (:line-width (1 . -1)) :height 0.95 :weight bold)))
 '(avy-lead-face-0 ((t :background unspecified :inherit avy-lead-face)))
 '(avy-lead-face-1 ((t :background unspecified :inherit avy-lead-face)))
 '(avy-lead-face-2 ((t :background unspecified :inherit avy-lead-face))))
