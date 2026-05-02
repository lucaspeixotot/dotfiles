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
;;; LSP settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eldoc-box
  :ensure t
  :config
  ;; (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
  (global-set-key (kbd "C-c l h") 'eldoc-box-help-at-point)
  )

(use-package eglot
  :ensure t
  :config
  ;; Manual start and useful actions
  (global-set-key (kbd "C-c l e") #'eglot)
  (global-set-key (kbd "C-c l d") #'eglot-shutdown)
  (global-set-key (kbd "C-c l o") #'eglot-code-action-organize-imports)
  (global-set-key (kbd "C-c l f") #'eglot-format-buffer)
  (global-set-key (kbd "C-c l a") #'eglot-code-actions)
  (global-set-key (kbd "C-c l r") #'eglot-rename)
  )

(use-package dumb-jump
  :ensure t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  ;; (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
  (setq xref-show-definitions-function #'consult-xref)
  (setq dumb-jump-force-searcher 'rg)
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Version control
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :ensure t
  :config
  (setq magit-ediff-dwim-show-on-hunks t)
  (with-eval-after-load 'project
    (define-key project-prefix-map "m" #'magit-project-status)
    (add-to-list 'project-switch-commands '(magit-project-status "Magit") t))
  )

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Misc packages
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; Display the parent context (function/class/block name)
(use-package breadcrumb
  :ensure t
  :init
  (breadcrumb-mode t)
  )

;;; Embark to do everythin you want

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-." . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;; Tabspaces as perspective replacement
(use-package tabspaces
  ;; use this next line only if you also use ensure, otherwise ignore it.
  :ensure t
  :hook (after-init . tabspaces-mode) ;; use this only if you want the minor-mode loaded at startup.
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*"))
  (tabspaces-initialize-project-with-todo t)
  (tabspaces-todo-file-name "project-todo.org")
  ;; sessions
  (tabspaces-session t)
  (tabspaces-session-auto-restore nil)
  ;; additional options
  (tabspaces-fully-resolve-paths t)  ; Resolve relative project paths to absolute
  (tabspaces-exclude-buffers '("*Messages*" "*Compile-Log*"))  ; Additional buffers to exclude
  (tab-bar-new-tab-choice "*scratch*")

  (defvar tabspaces-command-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "C") 'tabspaces-clear-buffers)
      (define-key map (kbd "b") 'tabspaces-switch-to-buffer)
      (define-key map (kbd "d") 'tabspaces-close-workspace)
      (define-key map (kbd "k") 'tabspaces-kill-buffers-close-workspace)
      (define-key map (kbd "o") 'tabspaces-open-or-create-project-and-workspace)
      (define-key map (kbd "r") 'tabspaces-remove-current-buffer)
      (define-key map (kbd "R") 'tabspaces-remove-selected-buffer)
      (define-key map (kbd "s") 'tabspaces-switch-or-create-workspace)
      (define-key map (kbd "t") 'tabspaces-switch-buffer-and-tab)
      (define-key map (kbd "w") 'tabspaces-show-workspaces)
      (define-key map (kbd "T") 'tabspaces-toggle-echo-area-display)
      map)
    "Keymap for tabspace/workspace commands after `tabspaces-keymap-prefix'.")

  (setq tabspaces-session-project-session-store "~/.emacs.d/tabspaces-sessions")

  :config
  ;; Filter Buffers for Consult-Buffer
  (with-eval-after-load 'consult
    ;; hide full buffer list (still available with "b" prefix)
    (plist-put consult-source-buffer :hidden t)
    (plist-put consult-source-buffer :default nil)
    ;; set consult-workspace buffer list
    (defvar consult--source-workspace
      (list :name     "Workspace Buffers"
            :narrow   ?w
            :history  'buffer-name-history
            :category 'buffer
            :state    #'consult--buffer-state
            :default  t
            :items    (lambda () (consult--buffer-query
                                  :predicate #'tabspaces--local-buffer-p
                                  :sort 'visibility
                                  :as #'buffer-name)))

      "Set workspace buffer list for consult-buffer.")
    (add-to-list 'consult-buffer-sources 'consult--source-workspace))
  )

