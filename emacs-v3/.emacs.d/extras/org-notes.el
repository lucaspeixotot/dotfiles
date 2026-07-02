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

  :custom
  (denote-directory (expand-file-name "~/denote-notes/"))
  (denote-save-buffers nil)
  (denote-known-keywords '("literature" "permanent"))
  (denote-infer-keywords t)
  (denote-sort-keywords t)
  (denote-prompts '(title keywords))
  (denote-excluded-directories-regexp nil)
  (denote-keywords-to-not-infer-regexp nil)
  (denote-rename-confirmations '(rewrite-front-matter modify-file-name))
  (denote-date-prompt-use-org-read-date t)
  :config
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
  :custom
  (denote-journal-directory (expand-file-name "journal" denote-directory))
  (denote-journal-keyword "journal")
  (denote-journal-title-format 'day-date-month-year))

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
  :custom
  (denote-sequence-scheme 'alphanumeric))

(use-package denote-menu
  :straight t
  :bind (("C-c n z" . list-denotes)
         :map denote-menu-mode-map
         ("c" . denote-menu-clear-filters)
         ("/ r" . denote-menu-filter)
         ("/ k" . denote-menu-filter-by-keyword)
         ("/ o" . denote-menu-filter-out-keyword)
         ("e" . denote-menu-export-to-dired)))

(use-package calibredb
  :straight t
  :defer t
  :bind (:map calibredb-search-mode-map
              ("V" . my/calibredb-open-file-with-emacs))
  :config
  (setq calibredb-root-dir "~/Calibre")
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  ;; for folder driver metadata: it should be .metadata.calibre
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
    (find-file (calibredb-get-file-path candidate t))))

(use-package nov
  :straight t
  :hook
  (nov-mode . olivetti-mode)
  :mode
  ("\\.[eE][pP][uU][bB]\\'" . nov-mode)
  )

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
  :custom
  (org-directory "~/org/")
  (org-agenda-files '("~/org/inbox.org"
                      "~/org/tasks.org"))
  (org-default-notes-file "~/org/inbox.org")
  (org-refile-targets '(("~/org/tasks.org" :maxlevel . 3)
                        ("~/org/inbox.org" :maxlevel . 3)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-capture-templates
   `(("i" "Inbox task" entry
      (file+headline ,(expand-file-name "inbox.org" org-directory) "Inbox")
      "* TODO %?\n  DATE: %U\n")
     ("t" "Active task" entry
      (file+headline ,(expand-file-name "tasks.org" org-directory) "Tasks")
      "* TODO %?\n  DATE: %U\n")
     ("l" "Task linked to current location" entry
      (file+headline ,(expand-file-name "inbox.org" org-directory) "Inbox")
      "* TODO %?\n  DATE: %U\n  RELATED LOCATION: %a\n")))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((latex . t))))

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
  :custom
  (denote-silo-directories
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
  :bind
  (:map org-user-menu-map
        ("d c" . org-download-clipboard)
        ("d y" . org-download-yank))
  :custom
  (org-download-image-dir "./images")
  (org-download-annotate-function (lambda (_) ""))
  )

(use-package toc-org
  :straight t
  :hook ((org-mode . toc-org-mode)
         (markdown-mode . toc-org-mode)))

(use-package citar
  :straight t
  :custom
  (citar-notes-paths '("~/denote-notes"))
  (citar-bibliography '("~/Calibre/catalog.bib"))
  (org-cite-global-bibliography '("~/Calibre/catalog.bib"))
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  (citar-bibliography org-cite-global-bibliography)
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup)
  :bind
  (:map org-mode-map :package org ("C-c b" . #'org-cite-insert))
  )

(use-package citar-embark
  :straight t
  :after (citar embark)
  :no-require
  :config (citar-embark-mode))

(use-package citar-denote
  :straight t
  :demand t ;; Ensure minor mode loads
  :after (:any citar denote)
  :custom
  ;; Package defaults
  (citar-denote-file-type 'org)
  (citar-denote-keyword "bib")
  (citar-denote-signature nil)
  (citar-denote-subdir nil)
  (citar-denote-template nil)
  (citar-denote-title-format "title")
  (citar-denote-title-format-andstr "and")
  (citar-denote-title-format-authors 1)
  (citar-denote-use-bib-keywords nil)
  :preface
  (bind-key "C-c w n" #'citar-denote-open-note)
  :init
  (citar-denote-mode)
  ;; Bind all available commands
  :bind (("C-c w d" . citar-denote-dwim)
         ("C-c w e" . citar-denote-open-reference-entry)
         ("C-c w a" . citar-denote-add-citekey)
         ("C-c w k" . citar-denote-remove-citekey)
         ("C-c w r" . citar-denote-find-reference)
         ("C-c w l" . citar-denote-link-reference)
         ("C-c w f" . citar-denote-find-citation)
         ("C-c w x" . citar-denote-nocite)
         ("C-c w y" . citar-denote-cite-nocite)
         ("C-c w z" . citar-denote-nobib)))
