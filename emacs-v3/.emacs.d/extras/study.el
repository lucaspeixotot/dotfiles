;;; study.el --- Concursos study tracking: phases and history
;; -*- lexical-binding: t; -*-

;; Data file: ~/org/study.org.  Requires org-ql (installed below).

;;; Derived parent state (level 1) from sub-subjects (level 2)

(defun my/study-derived-state ()
  "Return the state derived from the level-2 children of the current entry.
Any FOUNDATION => FOUNDATION; else any REFINEMENT => REFINEMENT;
else any REVIEW => REVIEW; else all DONE => DONE; else QUEUE when there
are children.  Return nil when there are no level-2 children yet, so a
manually assigned parent state is left untouched."
  (let ((children (delq nil (org-map-entries
                             (lambda () (org-get-todo-state))
                             "LEVEL=2" 'tree))))
    (cond
     ((member "FOUNDATION" children) "FOUNDATION")
     ((member "REFINEMENT" children) "REFINEMENT")
     ((member "REVIEW" children) "REVIEW")
     ((and children (seq-every-p (lambda (s) (equal s "DONE")) children)) "DONE")
     (children "QUEUE")
     (t nil))))

(defun my/study-derive-one ()
  "Derive the state of the parent subject of the current sub-subject."
  (org-with-wide-buffer
   (org-back-to-heading)
   (when (org-up-heading-safe)
     (let ((derived (my/study-derived-state)))
       (when (and derived (not (equal (org-get-todo-state) derived)))
         (org-todo derived))))))

(defun my/study-derive-all ()
  "Re-derive the state of every level-1 subject in the current file."
  (interactive)
  (org-with-wide-buffer
   (org-map-entries
    (lambda ()
      (let ((derived (my/study-derived-state)))
        (when (and derived (not (equal (org-get-todo-state) derived)))
          (org-todo derived))))
    "LEVEL=1" 'file)))

(defun my/study-buffer-p ()
  "Return t when the current buffer is the study tracking file."
  (and (buffer-file-name)
       (equal "study.org" (file-name-nondirectory (buffer-file-name)))))

(defun my/study-on-todo-change ()
  "Hook: after a sub-subject state change, derive its parent subject."
  (when (and (derived-mode-p 'org-mode)
             (my/study-buffer-p)
             (= (org-outline-level) 2))
    (my/study-derive-one)))

(add-hook 'org-after-todo-state-change-hook #'my/study-on-todo-change)

;;; Accuracy (refinement) and review recording

(defun my/study-log-note (text)
  "Insert TEXT as a timestamped note in the current entry's LOGBOOK."
  (org-with-wide-buffer
   (org-back-to-heading)
   (save-excursion
     (goto-char (org-log-beginning t))
     (insert (format "- %s - %s\n" (format-time-string "%Y-%m-%d %H:%M") text)))))

(defun my/study-update-accuracy (value)
  "Update ACCURACY of the current entry and log the change."
  (interactive "nNew accuracy % (Tec): ")
  (let ((old (org-entry-get nil "ACCURACY")))
    (org-set-property "ACCURACY" (number-to-string value))
    (my/study-log-note (format "ACCURACY %s -> %s%%" (or old "-") value))))

(defun my/study-mark-review ()
  "Set LAST-REVIEW to today (end of a review session)."
  (interactive)
  (org-set-property "LAST-REVIEW" (format-time-string "%Y-%m-%d")))

;;; Branch pause (fiscal vs control)

(defun my/study-toggle-paused ()
  "Toggle the :paused: tag (branch on hold; hidden from views, history kept)."
  (interactive)
  (if (member "paused" (org-get-local-tags))
      (org-toggle-tag "paused" 'off)
    (org-toggle-tag "paused" 'on)))

;;; Predicate used by the org-ql "today" view

(defun my/study-review-due-p ()
  "Return t when review is due: no LAST-REVIEW, or older than 21 days."
  (let ((s (org-entry-get nil "LAST-REVIEW")))
    (or (null s)
        (time-less-p (days-to-time 21)
                     (time-since (date-to-time s))))))

;;; Command to open the "today" view

(defun my/study-today ()
  "Open the \"Study - Today\" agenda view (custom command \"e\")."
  (interactive)
  (org-agenda nil "e"))

;;; Keymap under C-c o s

(defvar my/study-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "t") #'my/study-today)
    (define-key map (kbd "a") #'my/study-update-accuracy)
    (define-key map (kbd "r") #'my/study-mark-review)
    (define-key map (kbd "p") #'my/study-toggle-paused)
    (define-key map (kbd "d") #'my/study-derive-all)
    map)
  "Keymap for study tracking commands, bound under `C-c o s'.")

;;; Org settings and installation (apply once org is loaded)

(with-eval-after-load 'org
  (require 'org-clock)
  (setq org-todo-keyword-faces
        '(("QUEUE" . (:foreground "gray" :weight bold))
          ("FOUNDATION" . (:foreground "tomato" :weight bold))
          ("REFINEMENT" . (:foreground "goldenrod" :weight bold))
          ("REVIEW" . (:foreground "lime green" :weight bold))
          ("DONE" . (:foreground "RoyalBlue" :weight bold))
          ("CANCELED" . (:foreground "gray"))))
  (setq org-log-into-drawer "LOGBOOK")
  (setq org-clock-into-drawer "LOGBOOK")
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate)
  (setq org-agenda-custom-commands
        '(("e" "Study - Today"
           ((org-ql-block '(and (level 2)
                                (todo "FOUNDATION" "REFINEMENT")
                                (not (tags "paused")))
                          ((org-ql-block-header "ACTIVE - every week")))
            (org-ql-block '(and (level 2)
                                (todo "REVIEW")
                                (not (tags "paused"))
                                (my/study-review-due-p))
                          ((org-ql-block-header "REVIEW DUE")))
            (org-ql-block '(and (level 2)
                                (todo "QUEUE")
                                (not (tags "paused")))
                          ((org-ql-block-header "QUEUE - next")))))))
  (define-key org-user-menu-map (kbd "s") my/study-map))

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "C-c o s"   "Study"
    "C-c o s t" "Today view"
    "C-c o s a" "Update accuracy"
    "C-c o s r" "Mark review"
    "C-c o s p" "Toggle paused"
    "C-c o s d" "Derive all"))

(use-package org-ql
  :straight t
  :after org)

(provide 'study)
