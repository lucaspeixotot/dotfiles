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
  ;; Atalhos
  :bind
  (("M-$" . jinx-correct)
   ("C-M-$" . jinx-languages))
  ;; Opcional: teclas de navegação entre erros
  :config
  ;; (keymap-set jinx-mode-map "M-n" #'jinx-next)
  ;; (keymap-set jinx-mode-map "M-p" #'jinx-previous)

  ;; Se você usa Vertico, configure exibição em grade para sugestões
  (when (bound-and-true-p vertico-multiform-mode)
    (add-to-list 'vertico-multiform-categories
                 '(jinx grid (vertico-grid-annotate . 20)
                        (vertico-count . 4)))))
