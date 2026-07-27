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
  :demand t
  :init
  (which-key-add-key-based-replacements
    "C-c n" "Notes"
    "C-c n q" "Query Notes"
    "C-c n i" "Insert to notes")
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
  (:prefix-map my-denote-map
   :prefix "C-c n"
   :prefix-docstring "Notes"
   ("n" . denote)
   ("o" . denote-open-or-create)
   ("d" . denote-dired)
   ("r" . denote-rename-file)
   ("R" . denote-rename-file-using-front-matter))

  (:prefix-map my-query-denote-map
   :prefix "C-c n q"
   :prefix-docstring "Query notes"
   ("l" . denote-find-link)
   ("b" . denote-find-backlink)
   ("B" . denote-backlinks))

  (:prefix-map my-insert-denote-map
   :prefix "C-c n i"
   :prefix-docstring "Insert to notes"
   ("l" . denote-link)
   ("L" . denote-add-links)
   ("f" . denote-link-or-create)
   ("q" . my/quote-to-denote)
   ("c" . denote-query-contents-link)
   ("d" . denote-query-filenames-link))

  (:map dired-mode-map
  ("C-c C-n C-i" . denote-dired-link-marked-notes)
  ("C-c C-n C-r" . denote-dired-rename-files)
  ("C-c C-n C-k" . denote-dired-rename-marked-files-with-keywords)
  ("C-c C-n C-R" . denote-dired-rename-marked-files-using-front-matter))

  :custom
  (denote-directory (expand-file-name "~/denote-notes/"))
  (denote-save-buffers nil)
  (denote-known-keywords '("literature" "permanent"))
  (denote-infer-keywords t)
  (denote-sort-keywords t)
  (denote-prompts '(keywords template))
  (denote-excluded-directories-regexp nil)
  (denote-keywords-to-not-infer-regexp nil)
  (denote-rename-confirmations '(rewrite-front-matter modify-file-name))
  (denote-rename-buffer-format "%s %D (%k)")
  (denote-date-prompt-use-org-read-date t)
  :config
  ;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
  (denote-rename-buffer-mode 1)
  (defun my/quote-to-denote ()
  "Copy active region from nov-mode and append it with an Org link to a chosen Denote note."
  (interactive)
  (if (not (use-region-p))
      (message "Please select a paragraph/region in the EPUB first.")
    (let* ((quote (buffer-substring-no-properties (region-beginning) (region-end)))
           ;; Safely trigger the link generation hooks
           (_ (org-store-link nil))
           (link-url (plist-get org-store-link-plist :link))
           (link-desc (plist-get org-store-link-plist :description))
           (org-link (format "[[%s][%s]]" link-url (or link-desc "EPUB Source")))
           ;; Gather all currently open Denote buffers
           (denote-buffers (seq-filter (lambda (buf)
                                         (with-current-buffer buf
                                           (and (derived-mode-p 'org-mode)
                                                (fboundp 'denote-filename-is-note-p)
                                                (buffer-file-name)
                                                (denote-filename-is-note-p (buffer-file-name)))))
                                       (buffer-list))))
      (cond
       ((null denote-buffers)
        (message "No active Denote Org notes found open in buffers."))
       (t
        ;; Prompt user to choose from the open notes
        (let* ((buffer-names (mapcar #'buffer-name denote-buffers))
               (chosen-name (completing-read "Send quote to Denote note: " buffer-names nil t))
               (target-buffer (get-buffer chosen-name)))

          ;; Append to the bottom of the chosen note using native Org quote blocks
          (with-current-buffer target-buffer
            (save-excursion
              (goto-char (point-max))
              (insert "\n\n#+begin_quote\n"
                      quote
                      "\n\n-- Source: " org-link
                      "\n#+end_quote\n")))
          (message "Quote successfully copied to %s!" chosen-name)))))))

  (defun my-main-note-template ()
    (concat
     "* Links\n"
     "- Related to:\n"
     "  \n"
     "- Literature:\n"
     "  \n"
     "- Backlinks:\n"
     "#+BEGIN: denote-backlinks :sort-by-component identifier :reverse-sort t\n"
     "#+END:"))
  (setq denote-templates
        '((main . my-main-note-template)))
  (setq denote-link-description-format "%s %t (%k)")
  )

(use-package denote-org
  :straight t
  :init
  (which-key-add-key-based-replacements
    "C-c n i o" "Org DBlock")
  :bind
  (:prefix-map my-denote-org-dblock-map
   :prefix "C-c n i o"
   ("f" . denote-org-dblock-insert-files)
   ("l" . denote-org-dblock-insert-links)
   ("b" . denote-org-dblock-insert-backlinks))
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
  (:map my-denote-map
        ("f" . consult-denote-find)
        ("g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package denote-journal
  :straight t
  :init
  (which-key-add-key-based-replacements
    "C-c n j" "Journal")
  ;; Bind those to some key for your convenience.
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :bind
  (:prefix-map my-denote-journal-map
   :prefix "C-c n j"
   ("n" . denote-journal-new-entry)
   ("o" . denote-journal-new-or-existing-entry)
   ("l" . denote-journal-link-or-create-entry))
  :custom
  (denote-journal-directory (expand-file-name "journal" denote-directory))
  (denote-journal-keyword "journal")
  (denote-journal-title-format 'day-date-month-year)
  :config
  (defun my/calendar-open-denote-journal ()
    "Open the denote journal entry for the date under cursor in calendar."
    (interactive)
    (let* ((calendar-date (calendar-cursor-to-date t))
           (date (encode-time 0 0 0 (nth 1 calendar-date) (nth 0 calendar-date) (nth 2 calendar-date)))
           (time-string (format-time-string "%Y%m%d" date))
           (files (directory-files denote-journal-directory t time-string)))
      (if files
          (find-file (car files))
        (message "No journal entry found for this date."))))

  (with-eval-after-load 'calendar
    (define-key calendar-mode-map (kbd "J") #'my/calendar-open-denote-journal))

  (defun my/org-agenda-open-denote-journal ()
    "Open the denote journal entry for the date at point in the Org Agenda."
    (interactive)
    (let ((date-prop (get-text-property (point) 'day)))
      (if date-prop
          (let* ((date (if (integerp date-prop)
                           (calendar-gregorian-from-absolute date-prop)
                         date-prop))
                 (month (nth 0 date))
                 (day-num (nth 1 date))
                 (year (nth 2 date))
                 (encoded-time (encode-time 0 0 0 day-num month year))
                 (time-string (format-time-string "%Y%m%d" encoded-time))
                 (files (directory-files denote-journal-directory t time-string)))
            (if files
                (find-file (car files))
              (message "No journal entry found for %s." time-string)))
        (message "No date found at point."))))

  (with-eval-after-load 'org-agenda
    (define-key org-agenda-mode-map (kbd "J") #'my/org-agenda-open-denote-journal)))

(use-package denote-sequence
  :straight t
  :init
  (which-key-add-key-based-replacements
    "C-c n s" "Sequence")
  :bind
  (:prefix-map my-denote-sequence-map
   :prefix "C-c n s"
    ;; Here we make "C-c n s" a prefix for all "[n]otes with [s]equence".
    ;; This is just for demonstration purposes: use the key bindings
    ;; that work for you.  Also check the commands:
    ;;
    ;; - `denote-sequence-new-parent'
    ;; - `denote-sequence-new-sibling'
    ;; - `denote-sequence-new-child'
    ;; - `denote-sequence-new-child-of-current'
    ;; - `denote-sequence-new-sibling-of-current'
    ("s" . denote-sequence)
    ("f" . denote-sequence-find)
    ("l" . denote-sequence-link)
    ("d" . denote-sequence-dired)
    ("r" . denote-sequence-reparent)
    ("R" . denote-sequence-reparent-recursive)
    ("p" . denote-sequence-rename-as-parent)
    ("c" . denote-sequence-convert))
  :custom
  (denote-sequence-scheme 'alphanumeric)
  )

(use-package denote-menu
  :straight t
  :bind
  (:map my-denote-map
   ("z" . list-denotes))
  (:map denote-menu-mode-map
        ("c" . denote-menu-clear-filters)
        ("f r" . denote-menu-filter)
        ("f k" . denote-menu-filter-by-keyword)
        ("f o" . denote-menu-filter-out-keyword)
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

(use-package org
  :straight nil
  :init
  (define-prefix-command 'org-user-menu-map)
  :bind-keymap
  ("C-c o" . org-user-menu-map)
  :bind
  (:map org-user-menu-map
        ("a" . org-agenda)
        ("c" . org-capture)
        ("l" . org-toggle-link-display)
   )
  :custom
  (org-startup-truncated nil)
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
  (add-hook 'org-mode-hook #'visual-line-mode)
  (define-key org-mode-map (kbd "C-,") nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((latex . t)))
  (setq org-hide-emphasis-markers t)
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  )

(use-package org-bullets
  :straight t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package dictionary
  ;; :straight (:type built-in)
  :ensure nil
  :commands (dictionary-lookup-definition dictionary-search)
  :config
  (define-key help-map (kbd "C-d") 'apropos-documentation)
  (setq dictionary-use-single-buffer t)
  (defun dictionary-search-dwim (&optional arg)
    "Search for definition of word at point. If region is active,
search for contents of region instead. If called with a prefix
argument, query for word to search."
    (interactive "P")
    (if arg
        (dictionary-search nil)
      (if (use-region-p)
          (dictionary-search (buffer-substring-no-properties
                              (region-beginning)
                              (region-end)))
        (if (thing-at-point 'word)
            (dictionary-lookup-definition)
          (dictionary-search-dwim '(4))))))

  (defvar my/dictionary-log-file
    (concat user-cache-directory "dictionary-log")
    "File that tracks looked up words.")
  (advice-add 'dictionary-search :after
              (defun my/dictionary-log-update (word &optional dictionary)
                "Add the looked up WORD to `my/dictionary-log-file'."
                (when word
                  (write-region (concat word "\n") nil
                                my/dictionary-log-file
                                'append))))

  :bind (("C-M-=" . dictionary-search-dwim)
         :map help-map
         ("=" . dictionary-search-dwim)
         ("d" . dictionary-search)))

(use-package olivetti
  :straight t
  :after denote
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
  :init
  (which-key-add-key-based-replacements
    "C-c n m" "Silo")
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
  (:prefix-map my-denote-silo-map
   :prefix "C-c n m"
   ("c" . denote-silo-create-note)
   ("o" . denote-silo-open-or-create)
   ("d" . denote-silo-dired)
   ("s" . denote-silo-cd)
   ("x" . denote-silo-select-silo-then-command))
  )

(use-package denote-explore
  :straight t
  :init
  (which-key-add-key-based-replacements
    "C-c n e" "Explore"
    "C-c n e s" "Statistics"
    "C-c n e w" "Walks"
    "C-c n e j" "Janitor")
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
  (:prefix-map my-denote-explore-map
   :prefix "C-c n e"
   ("n" . denote-explore-network)
   ("r" . denote-explore-network-regenerate)
   ("d" . denote-explore-barchart-degree)
   ("b" . denote-explore-barchart-backlinks))
  (:prefix-map my-denote-explore-statistics-map
   :prefix "C-c n e s"
   ;; Statistics
   ("n" . denote-explore-count-notes)
   ("k" . denote-explore-count-keywords)
   ("e" . denote-explore-barchart-filetypes)
   ("w" . denote-explore-barchart-keywords)
   ("t" . denote-explore-barchart-timeline))
  (:prefix-map my-denote-explore-walk-map
   :prefix "C-c n e w"
   ;; Random walks
   ("n" . denote-explore-random-note)
   ("r" . denote-explore-random-regex)
   ("l" . denote-explore-random-link)
   ("k" . denote-explore-random-keyword))
  (:prefix-map my-denote-explore-janitor-map
   :prefix "C-c n e j"
   ;; Denote Janitor
   ("d" . denote-explore-duplicate-notes)
   ("D" . denote-explore-duplicate-notes-dired)
   ("l" . denote-explore-missing-links)
   ("z" . denote-explore-zero-keywords)
   ("s" . denote-explore-single-keywords)
   ("r" . denote-explore-rename-keywords)
   ("y" . denote-explore-sync-metadata)
   ("i" . denote-explore-isolated-files))
   )

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
  :init
  (which-key-add-key-based-replacements
    "C-c n h" "Highlight")
  :bind
  (:prefix-map my-org-remark-map
   :prefix "C-c n h"
   ("C-c n h m" . org-remark-mark)
   ("C-c n h l" . org-remark-mark-line))
  (;; :bind keyword also implicitly defers org-remark itself.
   ;; Keybindings before :map is set for global-map. Adjust the keybinds
   ;; as you see fit.
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
  :init
  (citar-denote-mode)
  (which-key-add-key-based-replacements
    "C-c n b" "Citar Denote commands")
  ;; Bind all available commands
  :bind (:prefix-map my-citar-denote-map
         :prefix "C-c n b"
         ("n" . citar-denote-open-note)
         ("d" . citar-denote-dwim)
         ("e" . citar-denote-open-reference-entry)
         ("a" . citar-denote-add-citekey)
         ("k" . citar-denote-remove-citekey)
         ("r" . citar-denote-find-reference)
         ("l" . citar-denote-link-reference)
         ("f" . citar-denote-find-citation)
         ("x" . citar-denote-nocite)
         ("y" . citar-denote-cite-nocite)
         ("z" . citar-denote-nobib)))



(use-package org-modern
  :straight t
  :config
  (add-hook 'org-mode-hook #'org-modern-mode)
  (add-hook 'org-agenda-finalize-hook #'org-modern-agenda)
  (setq org-modern-star '("◉" "○" "✸" "✿" "♦" "✜") ; Sleek headline bullets
        org-modern-hide-stars nil                 ; Keep sub-levels visible
        org-modern-table nil                      ; Set to t if you want styled tables
        org-modern-todo t                         ; Styled TODO/DONE labels
        org-modern-block-name t                   ; Clean block tags like #+begin_quote
        org-modern-keyword t)
  )

(use-package ox-pandoc
  :straight t
  :after org)

(use-package plantuml-mode
  :straight t
  :config
  (setq org-plantuml-jar-path (expand-file-name (or  (getenv "PLANTUML_JAR") "plantuml.jar")))
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t))))
