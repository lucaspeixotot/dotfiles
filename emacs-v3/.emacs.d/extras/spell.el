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

(use-package jinx
  :straight t
  ;; Ativar globalmente após iniciar Emacs
  :hook ((text-mode org-mode prog-mode conf-mode) . jinx-mode)
  ;; Idiomas: inglês americano + português brasileiro
  :custom
  (jinx-languages "en_US pt_BR")
  ;; Entry point: open the workflow hydra
  :config
  ;; Vertico grid for suggestion menu
  (when (bound-and-true-p vertico-multiform-mode)
    (add-to-list 'vertico-multiform-categories
                 '(jinx grid (vertico-grid-annotate . 20)
                        (vertico-count . 4))))

  (transient-define-prefix my/jinx-menu ()
    "Jinx spell-check workflow."
    [["Navigate"
      ("n" "next"          jinx-next          :transient t)
      ("p" "previous"      jinx-previous      :transient t)]
     ["Correct"
      ("c" "nearest"       jinx-correct-nearest :transient t)
      ("$" "dispatch"      jinx-correct         :transient t)
      ("a" "all in buffer" jinx-correct-all     :transient t)
      ("w" "word at point" jinx-correct-word    :transient t)]
     ["Session"
      ("l" "languages"     jinx-languages)
      ("m" "jinx-mode"     jinx-mode)
      ("M" "global"        global-jinx-mode)
      ("q" "quit"          transient-quit-one)]]))
