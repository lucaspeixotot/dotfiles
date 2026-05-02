;; -*- lexical-binding: t -*-

(use-package eca
  :straight t
  :config
  (when (boundp 'user-login-name)
    (setq eca-custom-command
          (if (string-equal (getenv "USER") "hpedev")
              '("~/.emacs.d/eca/eca" "-Djavax.net.ssl.trustStore=/usr/lib/jvm/java-21-openjdk-amd64/lib/security/cacerts" "-Djavax.net.ssl.trustStorePassword=changeit" "server")
            '("~/.emacs.d/eca/eca" "server")))))

(use-package agent-shell
    :straight t
    :config
    (setq agent-shell-prefer-viewport-interaction t)
    (agent-shell-completion-mode t)
  )

(provide 'lpac-ai-basics)
