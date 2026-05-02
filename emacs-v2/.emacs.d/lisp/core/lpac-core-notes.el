;; -*- lexical-binding: t -*-

(use-package denote
    :straight t
    :hook (dired-mode . denote-dired-mode)
    :bind
    (("C-c n n" . denote)
     ("C-c n r" . denote-rename-file)
     ("C-c n l" . denote-link)
     ("C-c n b" . denote-backlinks)
     ("C-c n d" . denote-dired)
     ("C-c n g" . denote-grep)
     ("C-c n o" . denote-open-or-create)
     )
    :config
    (setq denote-directory (expand-file-name "~/org-denote/"))

    ;; Automatically rename Denote buffers when opening them so that
    ;; instead of their long file name they have, for example, a literal
    ;; "[D]" followed by the file's title.  Read the doc string of
    ;; `denote-rename-buffer-format' for how to modify this.
    (denote-rename-buffer-mode 1))

(provide 'lpac-core-notes)
