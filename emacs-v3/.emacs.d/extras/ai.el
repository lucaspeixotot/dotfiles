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


;;; Eca
(use-package eca
  :ensure t
  :config
  (when (boundp 'user-login-name)
    (setq eca-custom-command
          (if (string-equal (getenv "USER") "hpedev")
              '("~/.emacs.d/eca/eca" "-Djavax.net.ssl.trustStore=/usr/lib/jvm/java-21-openjdk-amd64/lib/security/cacerts" "-Djavax.net.ssl.trustStorePassword=changeit" "server")
            '("~/.emacs.d/eca/eca" "server")))))

;;; Agent shell
  (use-package agent-shell
    :ensure t
    :config
    (setq agent-shell-prefer-viewport-interaction t)
    (agent-shell-completion-mode t)
  )

