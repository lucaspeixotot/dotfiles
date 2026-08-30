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

(use-package casual
  :straight t
  :config
  ;; disable line wrap
  (add-hook 'csv-mode-hook
            (lambda ()
              (visual-line-mode -1)
              (toggle-truncate-lines 1)))

  ;; auto detect separator
  (add-hook 'csv-mode-hook #'csv-guess-set-separator)
  ;; turn on field alignment
  (add-hook 'csv-mode-hook #'csv-align-mode))

(use-package popper
  :straight t
  :bind (("C-'"   . popper-toggle)
         ("C-\""    . popper-cycle)
         ("C-M-'" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          dictionary-mode
          help-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))                ; For echo area hints

(use-package dired-preview
  :straight t)

(use-package keycast
  :straight t
  :demand t
  :config
  (keycast-tab-bar-mode +1)
  )

(use-package time-zones
  :straight t
  )

(use-package sql
  :straight nil
  :config
  (setq sql-connection-alist
        '(("hoku-default-db"
           (sql-product 'postgres)
           (sql-server "localhost")
           (sql-port 5433)
           (sql-user "postgres")
           (sql-database "postgres"))
          ("gemini-default-db"
           (sql-product 'postgres)
           (sql-server "localhost")
           (sql-port 5434)
           (sql-user "postgres")
           (sql-database "postgres"))
          ("polaris-default-db"
           (sql-product 'postgres)
           (sql-server "localhost")
           (sql-port 5435)
           (sql-user "postgres")
           (sql-database "postgres"))
          ("mira-default-db"
           (sql-product 'postgres)
           (sql-server "localhost")
           (sql-port 5436)
           (sql-user "postgres")
           (sql-database "postgres")))))

(use-package tmr
  :straight t
  :config
  (define-key global-map (kbd "C-c t") #'tmr-prefix-map)
  (setq tmr-sound-file "/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"
        tmr-notification-urgency 'normal
        tmr-description-list 'tmr-description-history))
