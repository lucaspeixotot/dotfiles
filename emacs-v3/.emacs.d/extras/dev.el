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
  :custom
  (setq xref-show-definitions-function #'consult-xref)
  (setq dumb-jump-force-searcher 'rg)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Auto completion
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  ;; (corfu-auto-trigger ".")
  (corfu-quit-no-match 'separator)
  (corfu-cycle t) ;; Enable cycling for `corfu-next/previous'
  (corfu-quit-at-boundary 'separator) ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect 'prompt) ;; Preselect the prompt

  ;; (corfu-on-exact-match 'insert) ;; Configure handling of exact matches

  ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Use TAB for cycling, default is `corfu-complete'.
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("M-q" . corfu-quick-complete)
        ("C-q" . corfu-quick-insert)
        )

  :init

  ;; Recommended: Enable Corfu globally.  Recommended since many modes provide
  ;; Capfs and Dabbrev can be used globally (M-/).  See also the customization
  ;; variable `global-corfu-modes' to exclude certain modes.
  (global-corfu-mode)

  ;; Enable optional extension modes:
  (corfu-history-mode)
  (corfu-popupinfo-mode)

  :config
  ;; Free the RET key for less intrusive behavior.
  ;; Option 1: Unbind RET completely
  ;; (keymap-unset corfu-map "RET")
  ;; Option 2: Use RET only in shell modes
  (keymap-set corfu-map "RET" `( menu-item "" nil :filter
                                 ,(lambda (&optional _)
                                    (and (derived-mode-p 'eshell-mode 'comint-mode)
                                         #'corfu-send))))
  )


;; A few more useful configurations...
(use-package emacs
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

;; Add extensions
(use-package cape
  :ensure t
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  ;; :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-abbrev)
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-history)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-elisp-symbol)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Folds
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package outline-indent
  :ensure t
  :commands outline-indent-minor-mode
  :custom
  (outline-indent-ellipsis " ▼")
  )

(use-package treesit-fold
  :ensure t
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)

  :custom
  (treesit-fold-line-count-show t)
  (treesit-fold-line-count-format " ▼")

  :config
  (set-face-attribute 'treesit-fold-replacement-face nil
                      :foreground "#808080"
                      :box nil
                      :weight 'bold)
  ;; Systems and General Purpose
  (add-hook 'c-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'c++-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'java-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'rust-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'go-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'ruby-ts-mode-hook #'treesit-fold-mode)

  ;; Web and Frontend
  (add-hook 'js-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'typescript-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'tsx-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'css-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'html-ts-mode-hook #'treesit-fold-mode)

  ;; Scripting and Infrastructure
  (add-hook 'bash-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'cmake-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'dockerfile-ts-mode-hook #'treesit-fold-mode)

  ;; Data and Configuration
  (add-hook 'json-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'toml-ts-mode-hook #'treesit-fold-mode)

  ;; Third-party
  (add-hook 'kotlin-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'swift-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'elixir-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'zig-ts-mode-hook #'treesit-fold-mode)
  )

(use-package kirigami
  :ensure t
  :config
  (global-set-key (kbd "C-c z o") 'kirigami-open-fold)     ; Open fold at point
  (global-set-key (kbd "C-c z O") 'kirigami-open-fold-rec) ; Open fold recursively
  (global-set-key (kbd "C-c z r") 'kirigami-open-folds)    ; Open all folds
  (global-set-key (kbd "C-c z c") 'kirigami-close-fold)    ; Close fold at point
  (global-set-key (kbd "C-c z m") 'kirigami-close-folds)   ; Close all folds
  (global-set-key (kbd "C-c z a") 'kirigami-toggle-fold)   ; Toggle fold at point

  (add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)
  (add-hook 'lisp-interaction-mode-hook #'hs-minor-mode) ; scratch
  (add-hook 'lisp-mode-hook #'outline-minor-mode)
  (add-hook 'conf-mode-hook #'outline-minor-mode)
  (add-hook 'markdown-mode-hook #'outline-minor-mode)
  (add-hook 'diff-mode-hook #'outline-minor-mode)

  ;; Systems and General Purpose
  (add-hook 'c-mode-hook #'hs-minor-mode)
  (add-hook 'c++-mode-hook #'hs-minor-mode)
  (add-hook 'java-mode-hook #'hs-minor-mode)
  (add-hook 'rust-mode-hook #'hs-minor-mode)
  (add-hook 'go-mode-hook #'hs-minor-mode)
  (add-hook 'ruby-mode-hook #'hs-minor-mode)

  ;; Web and Frontend
  (add-hook 'js-mode-hook #'hs-minor-mode)
  (add-hook 'typescript-mode-hook #'hs-minor-mode)
  (add-hook 'css-mode-hook #'hs-minor-mode)

  ;; Scripting, Data, and Infrastructure
  (add-hook 'sh-mode-hook #'hs-minor-mode) ; for bash/shell scripts
  (add-hook 'json-mode-hook #'hs-minor-mode)
  (add-hook 'lua-mode-hook #'hs-minor-mode)
  (add-hook 'nxml-mode-hook #'hs-minor-mode)
  (add-hook 'html-mode-hook #'hs-minor-mode) ; mhtml and html

  ;; Python
  (add-hook 'python-mode-hook #'outline-indent-minor-mode)
  (add-hook 'python-ts-mode-hook #'outline-indent-minor-mode)

  ;; Yaml
  (add-hook 'yaml-mode-hook #'outline-indent-minor-mode)
  (add-hook 'yaml-ts-mode-hook #'outline-indent-minor-mode)

  ;; Haskell
  (add-hook 'haskell-mode-hook #'outline-indent-minor-mode)
  )
