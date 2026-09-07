;; -*- lexical-binding: t; -*-
;;; study.el --- Study rotation: least-recently-studied, priority groups

;; Data files: any Org file under `my/study-dir' (default ~/study/org/).
;; Model: level-1 headings = subjects, tagged :P0: or :P1: (optionally
;; :fast: for double weight), TODO state ONCYCLE.  Clock in/out per
;; subject (C-c C-x C-i / C-c C-x C-o).  Rotation order = weighted
;; least-recently-clocked.  Only ONCYCLE subjects participate.

(defvar my/study-dir (expand-file-name "~/study/org/")
  "Directory containing study tracking Org files.")

(defun my/study-last-clocked ()
  "Return the most recent clock-out time of the current subtree, or nil.
Scans CLOCK lines and takes the max end time (skips open/running clocks)."
  (save-excursion
    (org-back-to-heading)
    (let ((end (save-excursion (org-end-of-subtree t t)))
          (re (concat org-clock-string ".*\\]--\\(\\[[^]]+\\]\\)"))
          last ts)
      (while (re-search-forward re end t)
        (setq ts (org-time-string-to-time (match-string 1)))
        (when (or (null last) (time-less-p last ts))
          (setq last ts)))
      last)))

(defun my/study-subject-days ()
  "Days since last clock-out of the current subject; -1 if never studied."
  (if-let* ((t0 (my/study-last-clocked)))
      (- (org-today) (time-to-days t0))
    -1))

(defun my/study-subject-weight ()
  "Return 2 if the current subject is tagged :fast:, else 1."
  (if (member "fast" (org-get-tags nil t)) 2 1))

(defun my/study-tags-string (tags exclude)
  "Return TAGS (excluding EXCLUDE) formatted as \" :a:b:\", or \"\" if empty."
  (let ((tags (delete exclude tags)))
    (if tags
        (concat "  :" (mapconcat #'identity tags ":") ":")
      "")))

(defun my/study-file-p (buffer)
  "Return non-nil if BUFFER visits an Org file under `my/study-dir'."
  (when (buffer-live-p buffer)
    (let ((file (buffer-file-name buffer)))
      (and file
           (string-equal (downcase (file-name-extension file)) "org")
           (file-in-directory-p (file-truename file)
                                (file-truename my/study-dir))))))

(defun my/study-source-buffer ()
  "Return the study source buffer.
Uses the current buffer when it visits an Org file under
`my/study-dir'; otherwise prompts for one."
  (if (my/study-file-p (current-buffer))
      (current-buffer)
    (let ((files (directory-files my/study-dir t "\\.org\\'")))
      (unless files
        (user-error "No .org files in %s" my/study-dir))
      (let ((name (completing-read "Study file: "
                                   (mapcar #'file-name-nondirectory files)
                                   nil t)))
        (find-file-noselect (expand-file-name name my/study-dir))))))

(defun my/study-collect-group (group source)
  "Return ONCYCLE level-1 subjects in SOURCE tagged GROUP.
Sort by weighted staleness (descending); never-studied first; ties
keep file order.  Each element: (DAYS NAME MARKER WEIGHT TAGS)."
  (let ((entries nil)
        (idx 0))
    (with-current-buffer source
      (org-with-wide-buffer
       (org-map-entries
        (lambda ()
          (push (list (my/study-subject-days)
                      (org-get-heading t t t t)
                      (copy-marker (point) t)
                      (my/study-subject-weight)
                      (org-get-tags nil t))
                entries))
        (format "LEVEL=1+%s/ONCYCLE" group) 'file)))
    (setq entries (nreverse entries))
    (let ((indexed (mapcar (lambda (e) (setq idx (1+ idx)) (cons idx e))
                           entries)))
      (mapcar #'cdr
              (sort indexed
                    (lambda (a b)
                      (let* ((da (nth 1 a)) (db (nth 1 b))
                             (wa (nth 4 a)) (wb (nth 4 b))
                             (ka (if (= da -1) most-positive-fixnum (* da wa)))
                             (kb (if (= db -1) most-positive-fixnum (* db wb))))
                        (if (= ka kb) (< (car a) (car b)) (> ka kb)))))))))

(defun my/study--insert (text &optional marker face)
  "Insert TEXT with optional jump MARKER and FACE at beginning of line."
  (let ((s (concat text "\n")))
    (when marker
      (add-text-properties 0 1 (list 'org-marker marker
                                     'org-hd-marker marker) s))
    (insert (if face (propertize s 'face face) s))))

(defun my/study-block (group source)
  "Insert the Today+Queue block for GROUP (from SOURCE) into buffer."
  (let* ((items (my/study-collect-group group source))
         (num (if (string= group "P0") "0" "1"))
         (today (car items))
         (queue (cdr items)))
    (my/study--insert (format "Priority %s — Next" num) nil 'org-agenda-structure)
    (if today
        (my/study--insert (format "  [%s]  %s%s"
                                  (if (< (car today) 0) "new" (format "%dd" (car today)))
                                  (nth 1 today)
                                  (my/study-tags-string (nth 4 today) group))
                          (nth 2 today))
      (my/study--insert "  —" nil 'org-agenda-dimmed-todo-face))
    (my/study--insert (format "Priority %s — Queue" num) nil 'org-agenda-structure)
    (if queue
        (dolist (it queue)
          (my/study--insert (format "  [%s]  %s%s"
                                    (if (< (car it) 0) "new" (format "%dd" (car it)))
                                    (nth 1 it)
                                    (my/study-tags-string (nth 4 it) group))
                            (nth 2 it)))
      (my/study--insert "  —" nil 'org-agenda-dimmed-todo-face))
    (insert "\n")))

(defun my/study-rotation ()
  "Show the study rotation: one Today pick and the Queue per group."
  (interactive)
  (let* ((source (my/study-source-buffer))
         (buf (get-buffer-create "*Study Rotation*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (org-agenda-mode)
        (insert (propertize (format "STUDY ROTATION — %s"
                                    (file-name-nondirectory
                                     (buffer-file-name source)))
                            'face 'org-agenda-structure)
                "\n\n")
        (my/study-block "P0" source)
        (my/study-block "P1" source)
        (goto-char (point-min))
        (setq buffer-read-only t)))
    (display-buffer buf)
    (message "Study rotation: RET = jump to subject (then C-c C-x C-i). "
             "Refresh with C-c o s t.")))

;;; Keymap under C-c o s

(defvar my/study-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "t") #'my/study-rotation)
    (define-key map (kbd "c") #'org-clock-report)
    map)
  "Keymap for study tracking commands, bound under `C-c o s'.")

;;; Org settings and installation

(with-eval-after-load 'org
  (require 'org-clock)
  (unless (file-exists-p my/study-dir)
    (make-directory my/study-dir t))
  (add-to-list 'org-agenda-files my/study-dir)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DONE(d)")
          (sequence "ONCYCLE(o!)" "PAUSED(p!)" "COMPLETED(c!)")))
  (setq org-todo-keyword-faces
        '(("ONCYCLE" . (:foreground "lime green" :weight bold))
          ("PAUSED" . (:foreground "gray"))
          ("COMPLETED" . (:foreground "RoyalBlue"))))
  (define-key org-user-menu-map (kbd "s") my/study-map))

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "C-c o s"   "Study"
    "C-c o s t" "Rotation view"
    "C-c o s c" "Clock summary"))

(provide 'study)
