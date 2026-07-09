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


  (defun move-text-internal (arg)
    (cond
     ((and mark-active transient-mark-mode)
      (if (> (point) (mark))
          (exchange-point-and-mark))
      (let ((column (current-column))
            (text (delete-and-extract-region (point) (mark))))
        (forward-line arg)
        (move-to-column column t)
        (set-mark (point))
        (insert text)
        (exchange-point-and-mark)
        (setq deactivate-mark nil)))
     (t
      (let ((column (current-column)))
        (beginning-of-line)
        (when (or (> arg 0) (not (bobp)))
          (forward-line)
          (when (or (< arg 0) (not (eobp)))
            (transpose-lines arg))
          (forward-line -1))
        (move-to-column column t)))))

  (defun move-text-down (arg)
    "Move region (transient-mark-mode active) or current line
  arg lines down."
    (interactive "*p")
    (move-text-internal arg))

  (defun move-text-up (arg)
    "Move region (transient-mark-mode active) or current line
  arg lines up."
    (interactive "*p")
    (move-text-internal (- arg)))

  (global-set-key [M-up] 'move-text-up)
  (global-set-key [M-down] 'move-text-down)

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

  (defvar-keymap my-pager-map
    :doc "Keymap with paging commands"
    "SPC" 'scroll-up-command
    "C-l" 'recenter-top-bottom
    "C-M-v" 'scroll-other-window
    "C-M-S-v" 'scroll-other-window-down
    "d" #'better-scroll-up-half

    "u" #'better-scroll-down-half
    "M-o" (if (fboundp 'switchy-window-minor-mode)
              'switchy-window 'my/other-window)
    "S-SPC" 'scroll-down-command)
  (let ((scrolling (propertize  "SCRL" 'face '(:inherit highlight)))
        ml-buffer)
    (defalias 'my/easy-page
      (lambda ()
        (interactive)
        (when (eq (window-buffer (selected-window))
                  (current-buffer))
          (setq ml-buffer (current-buffer))
          (add-to-list 'mode-line-format scrolling)
          (set-transient-map
           my-pager-map t
           (lambda () (with-current-buffer ml-buffer
                   (setq mode-line-format
                         (delete scrolling mode-line-format)))))))))

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

;; (use-package multiple-cursors
;;   :bind (("C->" . mc/mark-next-like-this)
;;          ("C-<" . mc/mark-previous-like-this)
;;          ("C-c C-<" . mc/mark-all-like-this)))

;; (use-package symbol-overlay
;;   :defer t
;;   :hook (prog-mode . symbol-overlay-mode)
;;   :bind (
;;          ("C-;" . symbol-overlay-put)
;;          ("M-n" . symbol-overlay-jump-next)
;;          ("M-p" . symbol-overlay-jump-prev)
;;          ("M-N" . symbol-overlay-switch-forward)
;;          ("M-P" . symbol-overlay-switch-backward)
;;          ))

;; (use-package symbol-overlay-mc
;;   :bind (("M-a" . symbol-overlay-mc-mark-all)))

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
  :bind (("M-g ;" . goto-last-change)
         ("M-i" . goto-last-change)
         ("M-I" . goto-last-change-reverse)
         ("M-g M-;" . goto-last-change)))

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
 '(safe-local-variable-values
   '((my/dape-cwd . "/home/cavalcan/glcp/authn/tests/feature_test")))
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
