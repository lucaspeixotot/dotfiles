;; -*- lexical-binding: t -*-

(use-package ef-themes
    :straight t
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
    (modus-themes-load-theme 'ef-maris-dark)
    (setq modus-themes-mixed-fonts t)
    (setq modus-themes-italic-constructs t)  
    )

;; use-package with package.el:
(use-package dashboard
  :straight t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-projects-backend 'project-el)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-projects-switch-function 'persp-project-switch-project)
  (setq dashboard-items '((recents   . 5)
                        (bookmarks . 5)
                        (projects  . 10)
                        (agenda    . 5)
                        (registers . 5)))
  (setq dashboard-startupify-list '(dashboard-insert-banner
                                  dashboard-insert-newline
                                  dashboard-insert-banner-title
                                  dashboard-insert-newline
                                  dashboard-insert-navigator
                                  dashboard-insert-newline
                                  dashboard-insert-init-info
                                  dashboard-insert-items
                                  dashboard-insert-newline))
  )

(provide 'lpac-core-themes)
