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
    ("C-c n i q" . my/quote-to-denote)
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
  (denote-prompts '(title keywords template))
  (denote-excluded-directories-regexp nil)
  (denote-keywords-to-not-infer-regexp nil)
  (denote-rename-confirmations '(rewrite-front-matter modify-file-name))
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

  (defun org-dblock-write:denote-outbound-links (params)
  "List denote: links found ABOVE this block, newest first."
  (let* ((here (point))                   ; point is inside the block
         (begin-pos (save-excursion
                      (re-search-backward "^#\\+BEGIN:" nil t)
                      (line-beginning-position)))
         (links '()))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\\[\\[denote:\\([^][]+?\\)\\]\\(?:\\[\\([^][]+\\)\\]\\)?"
                                begin-pos t)
        (push (cons (car (split-string (match-string 1) "::"))
                    (or (match-string 2) (match-string 1)))
              links)))
    (setq links (delete-dups (nreverse links)))
    (dolist (link links)
      (insert (format "- [[denote:%s][%s]]\n" (car link) (cdr link))))))

  (defun my-link-denote-template ()
    (concat
     "* References\n"
     "#+BEGIN: denote-outbound-links\n"
     "#+END:\n\n"
     "* Backlinks\n"
     "#+BEGIN: denote-backlinks :sort-by-component identifier :reverse-sort t\n"
     "#+END:"))
  (setq denote-templates
        '((link . my-link-denote-template)))


  )

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
