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

(use-package python-pytest
  :straight t
  :commands (python-pytest-dispatch
             python-pytest-file-dwim
             python-pytest-function-dwim
             python-pytest-last-failed
             python-pytest-repeat)
  :custom
  ;; Ask/edit the command line by default (invert C-u behavior)
  (python-pytest-confirm t)
  ;; Match the exact test at point instead of using -k patterns
  (python-pytest-strict-test-name-matching t)
  ;; Save modified buffers automatically before running
  (python-pytest-unsaved-buffers-behavior 'save-all)
  :bind
  (:map python-mode-map
        ("C-c t" . python-pytest-dispatch))
  (:map python-ts-mode-map
        ("C-c t" . python-pytest-dispatch)))
