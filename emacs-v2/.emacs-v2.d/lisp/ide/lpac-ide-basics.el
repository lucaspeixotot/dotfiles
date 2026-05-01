;; -*- lexical-binding: t -*-

(use-package project
  :straight nil
  :config
  (with-eval-after-load 'project
    (setq project-switch-commands
          (cl-remove-if
           (lambda (cmd)
             (memq (car cmd) '(project-vc-dir project-eshell)))
           project-switch-commands)))
  (with-eval-after-load 'project
    (define-key project-prefix-map "D" #'project-dired)
    (add-to-list 'project-switch-commands '(project-dired "Dired") t))
    )

(use-package vterm
    :straight t
    :config
    (defun project-vterm ()
      "Switch to or create a `vterm` buffer in the current project's root."
      (interactive)
      (let* ((proj (or (project-current)          ; find current project
                       (user-error "No project found")))
             (root (project-root proj))
             ;; strip trailing slash and take only last directory component
             (proj-name (file-name-nondirectory
                         (directory-file-name root)))
             (buf-name (format "*vterm-%s*" proj-name))
             (buf (get-buffer buf-name)))
        (if (buffer-live-p buf)
            ;; if it already exists, just switch to it
            (switch-to-buffer buf)
          ;; else create it under the project root
          (let ((default-directory root))
            (vterm buf-name)))))
    (with-eval-after-load 'project
      (define-key project-prefix-map "v" #'project-vterm)
      (add-to-list 'project-switch-commands '(project-vterm "vterm") t))
    )

  (use-package multi-vterm
    :straight t
    :config
    ;; Prefix for vterm actions
    (define-prefix-command 'my-vterm-map)
    (global-set-key (kbd "C-c v") 'my-vterm-map)
    (define-key my-vterm-map (kbd "c") #'multi-vterm)       ;; create new vterm
    (define-key my-vterm-map (kbd "n") #'multi-vterm-next)  ;; next vterm
    (define-key my-vterm-map (kbd "p") #'multi-vterm-prev)  ;; previous vterm
    (define-key my-vterm-map (kbd "v") #'project-vterm)     ;; project vterm

    (which-key-add-key-based-replacements "C-c v" "Vterm")
    (which-key-add-key-based-replacements "C-c v c" "Create vterm")
    (which-key-add-key-based-replacements "C-c v n" "Next vterm")
    (which-key-add-key-based-replacements "C-c v p" "Prev vterm")
    (which-key-add-key-based-replacements "C-c v v" "Project vterm")
    )

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :straight t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'ascii)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

(provide 'lpac-ide-basics)
