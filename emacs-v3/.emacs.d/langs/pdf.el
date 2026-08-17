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

(use-package pdf-tools
  :straight t
  :defer t
  :custom
  ;; pdf-tools' own per-document cache of rendered page bitmaps (~1-4 MB each).
  ;; Default 64 can hold 64-250 MB per buffer. 32 keeps scrolling smooth for
  ;; normal reading (±a few pages) while halving the worst-case footprint.
  (pdf-cache-image-limit 32)
  ;; Emacs' GLOBAL image cache eviction delay. Default 300s means stale page
  ;; bitmaps from a killed PDF buffer linger for 5 minutes. 60s reclaims them
  ;; 5x faster while still keeping recently-viewed images instant.
  (image-cache-eviction-delay 60)
  :config
  (pdf-tools-install)
  ;; Workaround for pdf-tools issues #215/#279: pdf-tools does NOT clear the
  ;; image cache when a PDF buffer is killed, so rendered pages stay resident.
  ;; Clear the cache on kill to release that memory immediately.
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (add-hook 'kill-buffer-hook #'clear-image-cache nil t)))
  :mode
  ("\\.[pP][dD][fF]\\'" . pdf-view-mode))
