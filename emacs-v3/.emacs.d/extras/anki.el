;;; anki.el --- Anki cards for concursos: anki-editor -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'subr-x)

(use-package anki-editor
  :straight t
  :custom
  (anki-editor-default-note-type "Basic"))

;;; Deck file (Denote) -----------------------------------------------------

(defun my/anki-find-deck-file (deck)
  "Return the Denote file containing :ANKI_DECK: for DECK, or nil."
  (cl-find-if
   (lambda (file)
     (with-temp-buffer
       (insert-file-contents file)
       (goto-char (point-min))
       (search-forward (format ":ANKI_DECK: %s" deck) nil t)))
   (denote-directory-files)))

(defun my/anki-deck-file ()
  "Open (or create) the Denote note for an Anki deck.
Prompts with the decks currently available via AnkiConnect; typing a
name not in the list creates a new deck on push."
  (interactive)
  (require 'anki-editor)
  (require 'denote)
  (let* ((deck (completing-read "Deck: " (anki-editor-deck-names)))
         (file (my/anki-find-deck-file deck)))
    (if file
        (find-file file)
      (let ((path (denote deck '("deck" "anki") 'org)))
        (find-file path)
        (goto-char (point-max))
        (insert "\n* " deck "\n:PROPERTIES:\n:ANKI_DECK: " deck "\n:END:\n")))))

;;; Normalize generated cards ---------------------------------------------

(defun my/anki-note-field-kind ()
  "Return 'cloze if current entry's first child is \"Text\", 'basic if
\"Back\", else nil."
  (save-excursion
    (org-back-to-heading)
    (when (org-goto-first-child)
      (let ((h (org-get-heading t t t t)))
        (cond ((string-equal-ignore-case h "Text") 'cloze)
              ((string-equal-ignore-case h "Back") 'basic))))))

(defun my/anki-normalize-notes ()
  "Nest generated cards under the ANKI_DECK heading and set ANKI_NOTE_TYPE.
Idempotent: does nothing when the structure is already correct."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (unless (re-search-forward ":ANKI_DECK:" nil t)
      (user-error "No ANKI_DECK heading found"))
    (goto-char (point-min))
    (while (re-search-forward "^\\* " nil t)
      (let ((beg (match-beginning 0)))
        (save-excursion
          (goto-char beg)
          (unless (org-entry-get nil "ANKI_DECK")
            (let ((kind (my/anki-note-field-kind)))
              (when kind
                (org-demote-subtree)
                (goto-char beg)
                (org-back-to-heading)
                (org-set-property "ANKI_NOTE_TYPE"
                                  (if (eq kind 'cloze) "Cloze" "Basic"))))))))))

;;; Push ------------------------------------------------------------------

(defun my/anki-push-new ()
  "Normalize notes, then push notes without an ANKI_NOTE_ID to Anki (create only)."
  (interactive)
  (require 'anki-editor)
  (my/anki-normalize-notes)
  (anki-editor-push-new-notes))

;;; Keymap -----------------------------------------------------------------

(defvar my/anki-map
  (let ((map (make-sparse-keymap)))
    ;; (define-key map (kbd "f") #'my/anki-deck-file)
    (define-key map (kbd "p") #'my/anki-push-new)
    map))

(with-eval-after-load 'org
  (define-key org-user-menu-map (kbd "k") my/anki-map))

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "C-c o k"   "Anki cards"
    ;; "C-c o k f" "Deck file"
    "C-c o k p" "Push new notes"))

(provide 'anki)
