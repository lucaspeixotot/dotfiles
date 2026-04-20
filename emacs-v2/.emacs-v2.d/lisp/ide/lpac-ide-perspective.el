;; -*- lexical-binding: t -*-

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c C-p"))  ; pick your own prefix key here
  :config
  (setq switch-to-prev-buffer-skip
        (lambda (win buff bury-or-kill)
          (not (persp-is-current-buffer buff))))
  (add-to-list 'consult-buffer-sources persp-consult-source)
  :config
  (require 'consult)
  (persp-mode))

(use-package persp-project
  :straight (persp-project :type git :host github :repo "PauloPhagula/persp-project")
  :after (perspective project)
  :config
  (global-set-key (kbd "C-x p p") 'persp-project-switch-project)
  )


(provide 'lpac-ide-perspective)
