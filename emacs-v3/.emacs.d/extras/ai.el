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

(use-package gptel
  :ensure t
  :bind (
         ("C-c a n" . gptel)
         ("C-c a r" . gptel-rewrite)
         ("C-c a m" . gptel-menu)
         ("C-c a a" . gptel-add))
  :config
  (setf (alist-get 'org-mode gptel-prompt-prefix-alist) "@user\n")
  (setf (alist-get 'org-mode gptel-response-prefix-alist) "@assistant\n")
  (setq gptel-expert-commands t)
  (gptel-make-deepseek "EmacsDeepseek"       ;Any name you want
    :stream t                           ;for streaming responses
    :key (getenv "DEEPSEEK_API_KEY_EMACS"))               ;can be a function that returns the key
  (setq gptel-default-mode 'org-mode)
  )

(use-package gptel-agent
  :config
  (gptel-agent-update))
