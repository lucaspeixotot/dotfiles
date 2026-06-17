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

;; Remember that the website version of this manual shows the latest
;; developments, which may not be available in the package you are
;; using.  Instead of copying from the web site, refer to the version
;; of the documentation that comes with your package.  Evaluate:
;;
;;     (info "(denote) Sample configuration")

(use-package denote
  :straight t
  :hook
  (;; If you use plain text files (.txt), then you want to make the
   ;; Denote links clickable (Org mode and Markdown mode render links
   ;; as buttons right away and provide commands to open them)
   (text-mode . denote-fontify-links-mode)
   ;; Apply colours to Denote names in Dired.  This applies to all
   ;; directories.  Check `denote-dired-directories' for the specific
   ;; directories you may prefer instead.  Then, instead of
   ;; `denote-dired-mode', use `denote-dired-mode-in-directories'.
   (dired-mode . denote-dired-mode))
  :bind
  ;; Denote DOES NOT define any key bindings.  This is for the user to
  ;; decide.  For example:
  ( :map global-map
    ("C-c n n" . denote)
    ("C-c n o" . denote-open-or-create)
    ("C-c n d" . denote-dired)
    ;; ("C-c n g" . denote-grep)
    ;; If you intend to use Denote with a variety of file types, it is
    ;; easier to bind the link-related commands to the `global-map', as
    ;; shown here.  Otherwise follow the same pattern for `org-mode-map',
    ;; `markdown-mode-map', and/or `text-mode-map'.
    ("C-c n i l" . denote-link)
    ("C-c n i L" . denote-add-links)
    ("C-c n i f" . denote-link-or-create)
    ("C-c n q l" . denote-find-link)
    ("C-c n q b" . denote-find-backlink)
    ("C-c n q B" . denote-backlinks)
    ("C-c n q c" . denote-query-contents-link) ; create link that triggers a grep
    ("C-c n q f" . denote-query-filenames-link) ; create link that triggers a dired
    ;; Note that `denote-rename-file' can work from any context, not just
    ;; Dired bufffers.  That is why we bind it here to the `global-map'.
    ("C-c n r" . denote-rename-file)
    ("C-c n R" . denote-rename-file-using-front-matter)

    ;; Key bindings specifically for Dired.
    :map dired-mode-map
    ("C-c C-d C-i" . denote-dired-link-marked-notes)
    ("C-c C-d C-r" . denote-dired-rename-files)
    ("C-c C-d C-k" . denote-dired-rename-marked-files-with-keywords)
    ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter))

  :config
  ;; Remember to check the docstring of each of those variables.
  (setq denote-directory (expand-file-name "~/denote-notes/"))
  (setq denote-save-buffers nil)
  (setq denote-known-keywords '("literature" "permanent"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-prompts '(title keywords))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-keywords-to-not-infer-regexp nil)
  (setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))

  ;; Pick dates, where relevant, with Org's advanced interface:
  (setq denote-date-prompt-use-org-read-date t)

  ;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
  (denote-rename-buffer-mode 1))

(use-package denote-org
  :straight t
  :bind
  (:map global-map
        ("C-c n i o f" . denote-org-dblock-insert-files)
        ("C-c n i o l" . denote-org-dblock-insert-links)
        ("C-c n i o b" . denote-org-dblock-insert-backlinks)
        )
  :commands
  ;; I list the commands here so that you can discover them more
  ;; easily.  You might want to bind the most frequently used ones to
  ;; the `org-mode-map'.
  ( denote-org-link-to-heading
    denote-org-backlinks-for-heading

    denote-org-extract-org-subtree

    denote-org-convert-links-to-file-type
    denote-org-convert-links-to-denote-type

    denote-org-dblock-insert-files
    denote-org-dblock-insert-links
    denote-org-dblock-insert-backlinks
    denote-org-dblock-insert-missing-links
    denote-org-dblock-insert-files-as-headings))

(use-package consult-denote
  :straight t
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package denote-journal
  :straight t
  ;; Bind those to some key for your convenience.
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :bind
  (:map global-map
        ("C-c n j n" . denote-journal-new-entry)
        ("C-c n j o" . denote-journal-new-or-existing-entry)
        ("C-c n j l" . denote-journal-link-or-create-entry)
   )
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year))

(use-package denote-sequence
  :straight t
  :bind
  ( :map global-map
    ;; Here we make "C-c n s" a prefix for all "[n]otes with [s]equence".
    ;; This is just for demonstration purposes: use the key bindings
    ;; that work for you.  Also check the commands:
    ;;
    ;; - `denote-sequence-new-parent'
    ;; - `denote-sequence-new-sibling'
    ;; - `denote-sequence-new-child'
    ;; - `denote-sequence-new-child-of-current'
    ;; - `denote-sequence-new-sibling-of-current'
    ("C-c n s s" . denote-sequence)
    ("C-c n s f" . denote-sequence-find)
    ("C-c n s l" . denote-sequence-link)
    ("C-c n s d" . denote-sequence-dired)
    ("C-c n s r" . denote-sequence-reparent)
    ("C-c n s c" . denote-sequence-convert))
  :config
  ;; The default sequence scheme is `numeric'.
  (setq denote-sequence-scheme 'numeric))

(use-package denote-menu
  :straight t
  :config
  (global-set-key (kbd "C-c n z") #'list-denotes)

  (define-key denote-menu-mode-map (kbd "c") #'denote-menu-clear-filters)
  (define-key denote-menu-mode-map (kbd "/ r") #'denote-menu-filter)
  (define-key denote-menu-mode-map (kbd "/ k") #'denote-menu-filter-by-keyword)
  (define-key denote-menu-mode-map (kbd "/ o") #'denote-menu-filter-out-keyword)
  (define-key denote-menu-mode-map (kbd "e") #'denote-menu-export-to-dired)
)

(use-package calibredb
  :straight t
  :defer t
  :config
  (setq calibredb-root-dir "~/Calibre")
  ;; for folder driver metadata: it should be .metadata.calibre
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  ;; (setq calibredb-library-alist '(("~/OneDrive/Org/Doc/Calibre" (name . "Calibre")) ;; with name
  ;;                                 ("~/Documents/Books Library") ;; no name
  ;;                                 ("~/Documents/LIB1")
  ;;                                 ("/Volumes/ShareDrive/Documents/Library/")))
  (defun my/calibredb-open-file-with-emacs (&optional candidate)
    "Open file with Emacs.
Optional argument CANDIDATE is the selected item."
    (interactive "P")
    (unless candidate
      (setq candidate (car (calibredb-find-candidate-at-point))))
    (find-file (calibredb-get-file-path candidate t)))
  (define-key calibredb-search-mode-map "V" #'my/calibredb-open-file-with-emacs)
  )

(use-package nov
  :straight t
  :hook
  (nov-mode . olivetti-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package pdf-tools
  :straight t
  :defer t
  :config
  (pdf-tools-install)
  :mode
  ("\\.[pP][dD][fF]\\'" . pdf-view-mode))

(use-package org
  :straight nil
  :init
  (define-prefix-command 'org-user-menu-map)
  :bind-keymap
  ("C-c o" . org-user-menu-map)
  :bind
  (:map org-user-menu-map
        ("a" .  org-agenda)
        ("c" .  org-capture)
   )
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((latex . t)))
  :custom
  (org-directory "~/org/")
  (org-agenda-files '("~/org/inbox.org"
                      "~/org/tasks.org"))
  (org-default-notes-file "~/org/inbox.org")
  (org-refile-targets '(("~/org/tasks.org" :maxlevel . 3)
                        ("~/org/inbox.org" :maxlevel . 3)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  :config
  (setq org-capture-templates
        `(("i" "Inbox task" entry
           (file+headline ,(expand-file-name "inbox.org" org-directory) "Inbox")
           "* TODO %?\n  DATE: %U\n")
          ("t" "Active task" entry
           (file+headline ,(expand-file-name "tasks.org" org-directory) "Tasks")
           "* TODO %?\n  DATE: %U\n")
          ("l" "Task linked to current location" entry
           (file+headline ,(expand-file-name "inbox.org" org-directory) "Inbox")
           "* TODO %?\n  DATE: %U\n  RELATED LOCATION: %a\n"))))

(use-package dictionary
  :straight t
  :custom
  (dictionary-server "dict.org")
  :bind
  (("C-c w s d" . dictionary-lookup-definition)))

(use-package olivetti
  :straight t
  :config
  (defun my/enable-olivetti-for-denote ()
    "Enable olivetti-mode if the current buffer is a Denote note."
    (when (and buffer-file-name
               (denote-file-is-note-p buffer-file-name))
      (olivetti-mode 1)))
  :hook
  (find-file . my/enable-olivetti-for-denote))

(use-package denote-silo
  :straight t
  ;; Bind these commands to key bindings of your choice.
  :commands ( denote-silo-create-note
              denote-silo-open-or-create
              denote-silo-select-silo-then-command
              denote-silo-dired
              denote-silo-cd )
  :config
  ;; Add your silos to this list.  By default, it only includes the
  ;; value of the variable `denote-directory'.
  (setq denote-silo-directories
        (list denote-directory
              "~/denote-notes/"
              "~/org-denote/"
              "~/denote-test/"))
  :bind
  (:map global-map
        ("C-c n m c" . denote-silo-create-note)
        ("C-c n m o" . denote-silo-open-or-create)
        ("C-c n m d" . denote-silo-dired)
        ("C-c n m s" . denote-silo-cd)
        ("C-c n m x" . denote-silo-select-silo-then-command)
        )
  )

(use-package denote-explore
  :straight t
  :custom
  ;; Where to store network data and in which format
  ;; (denote-explore-network-directory "<your preferred folder>")
  (denote-explore-network-filename "denote-network")
  ;; (denote-explore-network-keywords-ignore "<keywords list>")
  ;; (denote-explore-network-regex-ignore "<regex>")
  (denote-explore-network-format 'gexf)
  (denote-explore-network-d3-colours 'SchemeObservable10)
  (denote-explore-network-d3-js "https://d3js.org/d3.v7.min.js")
  ;; (denote-explore-network-d3-template "<file path>")
  ;; (denote-explore-network-graphviz-header "<header strings>")
  (denote-explore-network-graphviz-filetype 'svg)
  :bind
  (;; Statistics
   ("C-c n e s n" . denote-explore-count-notes)
   ("C-c n e s k" . denote-explore-count-keywords)
   ("C-c n e s e" . denote-explore-barchart-filetypes)
   ("C-c n e s w" . denote-explore-barchart-keywords)
   ("C-c n e s t" . denote-explore-barchart-timeline)
   ;; Random walks
   ("C-c n e w n" . denote-explore-random-note)
   ("C-c n e w r" . denote-explore-random-regex)
   ("C-c n e w l" . denote-explore-random-link)
   ("C-c n e w k" . denote-explore-random-keyword)
   ;; Denote Janitor
   ("C-c n e j d" . denote-explore-duplicate-notes)
   ("C-c n e j D" . denote-explore-duplicate-notes-dired)
   ("C-c n e j l" . denote-explore-missing-links)
   ("C-c n e j z" . denote-explore-zero-keywords)
   ("C-c n e j s" . denote-explore-single-keywords)
   ("C-c n e j r" . denote-explore-rename-keywords)
   ("C-c n e j y" . denote-explore-sync-metadata)
   ("C-c n e j i" . denote-explore-isolated-files)
   ;; Visualise denote
   ("C-c n e n" . denote-explore-network)
   ("C-c n e r" . denote-explore-network-regenerate)
   ("C-c n e d" . denote-explore-barchart-degree)
   ("C-c n e b" . denote-explore-barchart-backlinks)))

(use-package org-remark-global-tracking
  :straight nil
  ;; It is recommended that `org-remark-global-tracking-mode' be
  ;; enabled when Emacs initializes. You can set it in
  ;; `after-init-hook'.
  :hook after-init
  :config
  ;; Selectively keep or comment out the following if you want to use
  ;; extensions for Info-mode, EWW, and NOV.el (EPUB) respectively.
  (use-package org-remark-info :straight nil :after info :config (org-remark-info-mode +1))
  (use-package org-remark-eww  :straight nil :after eww  :config (org-remark-eww-mode +1))
  (use-package org-remark-nov  :straight nil :after nov  :config (org-remark-nov-mode +1)))

(use-package org-remark
  :straight t
  :bind (;; :bind keyword also implicitly defers org-remark itself.
         ;; Keybindings before :map is set for global-map. Adjust the keybinds
         ;; as you see fit.
         ("C-c n h m" . org-remark-mark)
         ("C-c n h l" . org-remark-mark-line)
         :map org-remark-mode-map
         ("C-c n h o" . org-remark-open)
         ("C-c n h ]" . org-remark-view-next)
         ("C-c n h [" . org-remark-view-prev)
         ("C-c n h r" . org-remark-remove)
         ("C-c n h d" . org-remark-delete))
  )

(use-package org-download
  :straight t
  :after org
  :config
  ;; Define a pasta padrão onde as imagens serão salvas
  (setq-default org-download-image-dir "./images")

  ;; Opcional: Evita que o Emacs crie textos longos de anotação acima da imagem
  (setq org-download-annotate-function (lambda (_) ""))
  (define-key org-mode-map (kbd "C-c o d c") 'org-download-clipboard)
  (define-key org-mode-map (kbd "C-c o d y") 'org-download-yank)
  )
