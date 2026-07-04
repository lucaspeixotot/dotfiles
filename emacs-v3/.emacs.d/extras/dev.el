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
  ;; (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
  :bind (("C-c l h" . eldoc-box-help-at-point)))

(use-package eglot
  :straight nil
  ;; Disable events buffer to prevent unbounded memory growth from LSP traffic.
  ;; Set to '(:size 2000000 :format full) temporarily when debugging LSP issues.
  :custom
  (eglot-events-buffer-config '(:size 0 :format full))
  ;; Manual start and useful actions
  :bind (("C-c l e" . eglot)
         ("C-c l d" . eglot-shutdown)
         ("C-c l o" . eglot-code-action-organize-imports)
         ("C-c l f" . eglot-format-buffer)
         ("C-c l a" . eglot-code-actions)
         ("C-c l r" . eglot-rename)))

(use-package dumb-jump
  :custom
  (dumb-jump-force-searcher 'rg)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Version control
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :bind (:map project-prefix-map ("m" . magit-project-status))
  :custom
  (magit-ediff-dwim-show-on-hunks t)
  (magit-tramp-pipe-stty-settings 'pty)
  :config
  (add-to-list 'project-switch-commands '(magit-project-status "Magit") t))

(use-package diff-hl
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
  :init
  (breadcrumb-mode t)
  )

;;; Embark to do everythin you want

(use-package embark
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
  ;; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;; Tabspaces as perspective replacement
(use-package tabspaces
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
        ("C-<return>" . corfu-insert)
        )

  :init

  ;; Recommended: Enable Corfu globally.  Recommended since many modes provide
  ;; Capfs and Dabbrev can be used globally (M-/).  See also the customization
  ;; variable `global-corfu-modes' to exclude certain modes.
  (setq global-corfu-minibuffer nil)
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
  :straight nil
  ;; Disable events buffer to prevent unbounded memory growth from LSP traffic.
  ;; Set to '(:size 2000000 :format full) temporarily when debugging LSP issues.
  :custom
  (eglot-events-buffer-config '(:size 0 :format full))
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
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  ;; :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  :hook ((completion-at-point-functions . cape-abbrev)
         (completion-at-point-functions . cape-dabbrev)
         (completion-at-point-functions . cape-file)
         (completion-at-point-functions . cape-keyword)
         (completion-at-point-functions . cape-history)
         (completion-at-point-functions . cape-elisp-block)
         (completion-at-point-functions . cape-elisp-symbol)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Folds
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package outline-indent
  :commands outline-indent-minor-mode
  :custom
  (outline-indent-ellipsis " ▼")
  )

(use-package treesit-fold
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
  :bind (("C-c z o" . kirigami-open-fold)
         ("C-c z O" . kirigami-open-fold-rec)
         ("C-c z r" . kirigami-open-folds)
         ("C-c z c" . kirigami-close-fold)
         ("C-c z m" . kirigami-close-folds)
         ("C-c z a" . kirigami-toggle-fold))

  :config
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


(use-package indent-bars
  :ensure t
  :custom
  ;; --- Core ---
  (indent-bars-treesit-support t)
  (indent-bars-prefer-character t)

  ;; --- List handling ---
  ;; 'skip = omit deeper bars AND skip bars between nested list levels
  ;; Note: C/C++ note says braces get treated as lists — same for Go
  (indent-bars-no-descend-lists 'skip)

  ;; --- Scope focus (which nodes define a "focus zone") ---
  (indent-bars-treesit-scope
   '((python function_definition class_definition
             for_statement if_statement with_statement
             while_statement)
     (rust   trait_item impl_item macro_definition macro_invocation
             struct_item enum_item mod_item const_item let_declaration
             function_item for_expression if_expression loop_expression
             while_expression match_expression match_arm call_expression
             token_tree token_tree_pattern token_repetition)
     (go     function_declaration method_declaration
             if_statement for_statement
             expression_switch_statement type_switch_statement
             select_statement)))

  ;; --- Wrap detection (prevent extra bars inside these) ---
  (indent-bars-treesit-wrap
   '((python argument_list parameters
             list list_comprehension
             dictionary dictionary_comprehension
             parenthesized_expression subscript)
     (c      argument_list parameter_list
             init_declarator parenthesized_expression)
     (rust   arguments parameters)
     (lua    expression_list function_declaration if_statement
             elseif_statement else_statement while_statement
             for_statement repeat_statement comment)
     (toml   table array comment)
     (yaml   block_mapping_pair comment)
     (go     argument_list parameter_list literal_value
             import_spec_list var_spec_list field_declaration_list
             expression_list)))

  ;; --- Blank line separation at top level ---
  (indent-bars-treesit-ignore-blank-lines-types
   '("module"      ; python
     "source_file" ; go
     ))

  ;; --- Hooks ---
  :hook ((python-base-mode . indent-bars-mode)
         (c-ts-mode        . indent-bars-mode)
         (c++-ts-mode      . indent-bars-mode)
         (rust-ts-mode     . indent-bars-mode)
         (lua-ts-mode      . indent-bars-mode)
         (toml-ts-mode     . indent-bars-mode)
         (yaml-ts-mode     . indent-bars-mode)
         (go-ts-mode       . indent-bars-mode)
         (prog-mode        . indent-bars-mode)))


(use-package envrc
  :straight t
  :hook (after-init . envrc-global-mode))

(use-package dape
  :straight t
  :commands (dape
             dape-breakpoint-toggle
             dape-info
             dape-repl
             dape-quit)
  :custom
  (dape-buffer-window-arrangement 'right)
  (dape-inlay-hints t)
  :bind
  (("C-c d d" . dape)
   ("C-c d b" . dape-breakpoint-toggle)
   ("C-c d q" . dape-quit)
   ("C-c d i" . dape-info)
   ("C-c d r" . dape-repl))
  :config
  ;; Return pytest node id for the current buffer/function.
  ;; Turns Python-style names like `TestClass.test_method' into the pytest
  ;; form `TestClass::test_method' so pytest can locate them.
  (defun my/dape-pytest-nodeid ()
    (let* ((file (buffer-file-name))
           (defun-name (ignore-errors (python-info-current-defun)))
           (pytest-name (and defun-name
                             (replace-regexp-in-string "\\." "::" defun-name))))
      (if (and pytest-name (not (string-empty-p pytest-name)))
          (format "%s::%s" file pytest-name)
        file)))

  ;; Common ensure: verifies python + debugpy are available
  (defun my/dape-python-ensure (config)
    (dape-ensure-command config)
    (let ((python (dape-config-get config 'command)))
      (unless (zerop (process-file-shell-command
                      (format "%s -c \"import debugpy.adapter\"" python)))
        (user-error "%s: debugpy is not installed in this environment" python))))

  ;; Debug the pytest test at point
  (add-to-list
   'dape-configs
   `(pytest-at-point
     modes (python-mode python-ts-mode)
     ensure my/dape-python-ensure
     command "python"
     command-args ("-m" "debugpy.adapter"
                   "--host" "127.0.0.1"
                   "--port" :autoport)
     port :autoport
     :type "python"
     :request "launch"
     :module "pytest"
     :cwd dape-cwd
     :args [my/dape-pytest-nodeid]
     :justMyCode nil
     :console "integratedTerminal"
     :showReturnValue t
     :stopOnEntry nil))

  ;; Debug all tests in the current file
  (add-to-list
   'dape-configs
   `(pytest-file
     modes (python-mode python-ts-mode)
     ensure my/dape-python-ensure
     command "python"
     command-args ("-m" "debugpy.adapter"
                   "--host" "127.0.0.1"
                   "--port" :autoport)
     port :autoport
     :type "python"
     :request "launch"
     :module "pytest"
     :cwd dape-cwd
     :args [dape-buffer-default]
     :justMyCode nil
     :console "integratedTerminal"
     :showReturnValue t
     :stopOnEntry nil)))
