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

(add-to-list 'load-path
             (expand-file-name "lisp/elfeed-protocol-freshrss" user-emacs-directory))

;; ── Dependencies elfeed-protocol-freshrss ────────────────────────────
(use-package deferred
  :straight t
  :demand t)

(use-package request
  :straight t
  :demand t)

(use-package request-deferred
  :straight t
  :demand t)

;; ── elfeed core ──────────────────────────────────────────────────────
(use-package elfeed
  :straight t
  :custom
  (elfeed-use-curl t)
  :config
  (setq-default elfeed-search-filter "@1month +unread")
  (let* ((freshrss-username (getenv "FRESHRSS_USERNAME"))
         (freshrss-domain "rss.liclab.org")
         (protocol-entry (concat "freshrss+https://" freshrss-username "@" freshrss-domain)))
    (setq elfeed-feeds
          `((,protocol-entry
             :api-url ,(concat "https://" freshrss-domain "/api/greader.php")
             :password ,(getenv "FRESHRSS_PASSWORD"))))))

;; ── elfeed-protocol base ─────────────────────────────────────────────
(use-package elfeed-protocol
  :straight t
  :after elfeed
  :custom
  (elfeed-protocol-enabled-protocols '(freshrss))
  :config
  (elfeed-protocol-enable))

;; ── FreshRSS GReader backend ─────────────────────────────────────────
(use-package elfeed-protocol-freshrss
  :straight nil
  :after elfeed-protocol
  :config
  (elfeed-protocol-freshrss-register-protocol))

;; ── YouTube integration ──────────────────────────────────────────────
(use-package elfeed-tube
  :straight t
  :after elfeed
  :demand t
  :config
  ;; (setq elfeed-tube-auto-save-p nil) ; default value
  ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
  (elfeed-tube-setup)

  :bind (:map elfeed-show-mode-map
              ("F" . elfeed-tube-fetch)
              ([remap save-buffer] . elfeed-tube-save)
              :map elfeed-search-mode-map
              ("F" . elfeed-tube-fetch)
              ([remap save-buffer] . elfeed-tube-save)))

(use-package elfeed-tube-mpv
  :straight t
  :bind (:map elfeed-show-mode-map
              ("C-c C-f" . elfeed-tube-mpv-follow-mode)
              ("C-c C-w" . elfeed-tube-mpv-where)))
