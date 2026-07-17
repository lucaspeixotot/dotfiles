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

(use-package easy-kill
  :ensure t
  :bind (([remap kill-ring-save] . #'easy-kill)
         ([remap mark-sexp]      . #'easy-mark)
         ("M-S-w" . kill-ring-save)
         ("M-S-SPC" . #'easy-mark)
         :map easy-kill-base-map
         ("+" . nil) ("=" . nil)
         ("," . easy-kill-expand-region)
         ("." . easy-kill-contract-region))
  :config
  (setq easy-kill-alist
        '((119 word " ")
          (115 sexp "\n")
          (101 line "\n")
          (108 list "\n")
          (100 defun "\n\n")
          (41 sentence "\n")
          (104 paragraph "\n")
          (62 page "\n")
          (102 filename "\n")
          (68 defun-name " ")
          (98 buffer-file-name)))
  (defun easy-kill-expand-region ()
    "Expand kill according to expand-region."
    (interactive)
    (let* ((thing (easy-kill-get nil))
           (bounds (easy-kill--bounds)))
      (save-mark-and-excursion
        (set-mark (cdr bounds))
        (goto-char (car bounds))
        (er/expand-region 1)
        (deactivate-mark)
        (easy-kill-adjust-candidate thing (point) (mark)))))
  (defun easy-kill-contract-region ()
    "Expand kill according to expand-region."
    (interactive)
    (let* ((thing (easy-kill-get nil))
           (bounds (easy-kill--bounds)))
      (save-mark-and-excursion
        (set-mark (cdr bounds))
        (goto-char (car bounds))
        (er/contract-region 1)
        (deactivate-mark)
        (easy-kill-adjust-candidate thing (point) (mark))))))

(use-package easy-kill
  :after easy-kill
  :config
  (defun easy-kill-thing-alt (&optional thing n inhibit-handler)
    ;; ... selects backward instead of forward
    )
  (defun easy-kill-thing-backward (n) ...)
  (defun easy-kill-thing-backward-1 (thing &optional n) ...)
  (defun easy-kill-map ()
    "Build the keymap according to `easy-kill-alist'."
    (let ((map (make-sparse-keymap)))
      (set-keymap-parent map easy-kill-base-map)
      (when easy-kill-unhighlight-key
        (with-demoted-errors "easy-kill-unhighlight-key: %S"
          (define-key map easy-kill-unhighlight-key #'easy-kill-unhighlight)))
      (define-key map "[" (lambda () (interactive)
                            (cl-letf* (((symbol-function 'easy-kill-thing)
                                        #'easy-kill-thing-alt))
                              (call-interactively #'easy-kill-thing-alt))))
      (define-key map "]" #'easy-kill-thing)
      (dolist (c easy-kill-alist)
        (when (<= 97 (car c) 122)
          (define-key map (char-to-string (- (car c) 32))
                      (lambda () (interactive)
                        (cl-letf* (((symbol-function 'easy-kill-thing)
                                    #'easy-kill-thing-alt))
                          (call-interactively #'easy-kill-thing-alt)))))
        (define-key map (char-to-string (car c)) #'easy-kill-thing))
      map)))

(use-package macrursors
  :straight (macrursors :host github :repo "karthink/macrursors"
                        :branch "expand-region")
  :bind-keymap ("C-;" . macrursors-mark-map)
  :bind (("M-n" . macrursors-mark-next-instance-of)
         ("M-p" . macrursors-mark-previous-instance-of)
         ("C-M-;" . macrursors-mark-all-instances-of)
         :map macrursors-mode-map
         ("C-'" . macrursors-hideshow)
         ("C-;" . nil)
         ("C-; C-;" . macrursors-end)
         ("C-; C-j" . macrursors-end)
         :map isearch-mode-map
         ("C-;" . macrursors-mark-from-isearch)
         ("M-s n" . macrursors-mark-next-from-isearch)
         ("M-s p" . macrursors-mark-previous-from-isearch)
         :map macrursors-mark-map
         ("C-n" . macrursors-mark-next-line)
         ("C-p" . macrursors-mark-previous-line)
         ("C-SPC" . nil)
         ("." . macrursors-mark-all-instances-of)
         ("o" . macrursors-mark-all-instances-of)
         ("SPC" . macrursors-select)
         ("l" . macrursors-mark-all-lists)
         ("s" . macrursors-mark-all-symbols)
         ("w" . macrursors-mark-all-words)
         ("C-M-e" . macrursors-mark-all-sexps)
         ("d" . macrursors-mark-all-defuns)
         ("n" . macrursors-mark-all-numbers)
         (")" . macrursors-mark-all-sentences)
         ("M-e" . macrursors-mark-all-sentences)
         ("e" . macrursors-mark-all-lines)
         ("C-g" . macrursors-select-clear)
         ("," . macrursors-select-expand))
  :init
  (define-prefix-command 'macrursors-mark-map)
  (use-package avy
    :bind
    (:map macrursors-mark-map
     ("j" . my/macrursors-at-avy))
    :config
    (defun my/macrursors-at-avy ()
      (interactive)
      (let* ((avy-all-windows nil)
             (avy-timeout-seconds 0.5)
             (positions (mapcar #'caar (avy--read-candidates))))
        (when positions
          (when-let* ((buf (overlay-buffer mouse-secondary-overlay))
                      ((eq buf (current-buffer))))
            (setq positions
                  (cl-delete-if-not
                   (lambda (p) (<= (overlay-start mouse-secondary-overlay)
                              p (overlay-end mouse-secondary-overlay)))
                   positions))))
        (when positions
          (push-mark)
          (goto-char (car positions))
          (mapc #'macrursors--add-overlay-at-point (cdr positions))
          (macrursors-start)))))
  :config
  ;; Bind these after macrursors-select.el is loaded
  (with-eval-after-load 'macrursors-select
    (define-key macrursors-select-map (kbd "-") #'macrursors-select-contract)
    (define-key macrursors-select-map (kbd ".") #'macrursors-select-contract)
    (define-key macrursors-select-map (kbd ",") #'macrursors-select-expand))
  (dolist (mode '(show-paren-mode))
    (add-hook 'macrursors-pre-finish-hook mode)
    (add-hook 'macrursors-post-finish-hook mode))
  (setq macrursors-match-cursor-style t)

    (dolist (mode '( ;;global-eldoc-mode
                  ;; gcmh-mode corfu-mode font-lock-mode
                  show-paren-mode))
    (add-hook 'macrursors-pre-finish-hook mode)
    (add-hook 'macrursors-post-finish-hook mode))
  (setq ;; macrursors-apply-keys "C-; C-;"
   macrursors-match-cursor-style t)

  (defvar macrursors-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map "n" #'macrursors-mark-next-instance-of)
      (define-key map "p" #'macrursors-mark-previous-instance-of)
      map))
  (map-keymap (lambda (_ cmd)
                (put cmd 'repeat-map 'macrursors-repeat-map))
              macrursors-repeat-map)
  (dolist (cmd '(macrursors-mark-next-from-isearch
                 macrursors-mark-previous-from-isearch
                 macrursors-mark-next-line
                 macrursors-mark-previous-line))
    (put cmd 'repeat-map 'macrursors-repeat-map))
  (setf macrursors-mode-line nil)
  (defsubst my/mode-line-macro-recording ()
    "Display macro being recorded."
    (when (or defining-kbd-macro executing-kbd-macro)
      (let ((sep (propertize " " 'face 'highlight ))
            (vsep (propertize " " 'face '(:inherit variable-pitch))))
        ;; "●"
        (propertize
         (concat
          sep "REC" vsep
          (number-to-string kmacro-counter) vsep "▶" vsep
          (when macrursors-mode
            (if macrursors--overlays
                (format (concat "[%d/%d]" vsep)
                        (1+ (cl-count-if (lambda (p) (< p (point))) macrursors--overlays
                                         :key #'overlay-start))
                        (1+ (length macrursors--overlays)))
              (concat "[1/1]" vsep))))
         'face 'highlight)))))



;;; Avy to jump to characters quickly
(use-package avy
  :commands (avy-goto-word-1 avy-goto-char-2 avy-goto-char-timer)
  :bind (("M-j"     . my/avy-goto-char-timer)
         ("M-l"     . avy-goto-line)
         ("M-h"     . avy-goto-char-in-line)
         ("M-s y"   . avy-copy-line)
         ("M-s M-y" . avy-copy-region)
         ("M-s M-k" . avy-kill-whole-line)
         ("M-s j"   . avy-goto-char-2)
         ("M-s M-p" . avy-goto-line-above)
         ("M-s M-n" . avy-goto-line-below)
         ("M-s M-l" . avy-goto-end-of-line)
         ("M-s C-w" . avy-kill-region)
         ("M-s M-w" . avy-kill-ring-save-region)
         ("M-s t"   . avy-move-line)
         ("M-s M-t" . avy-move-region)
         ;; ("M-s s"   . my/avy-next-char-2)
         ;; ("M-s r"   . my/avy-previous-char-2)
         ("M-s z"   . my/avy-copy-line-no-prompt)
         :map isearch-mode-map
         ("C-'"     . my/avy-isearch)
         ("M-j"     . my/avy-isearch))
  ;; :bind (("M-RET" . avy-goto-char-timer)
  ;;        ("M-j" . avy-goto-char)
  ;;        ("M-l" . avy-goto-line)
  ;;        :map isearch-mode-map
  ;;        ("M-j" . avy-isearch))
  :config
  (setq avy-timeout-seconds 0.27)
  (setq avy-keys '( ?f ?d ?s ?a ?g ?q ?e ?r
                    ?c ?v ?p ?. ?, ;; ?2 ?3 ?9 ?8
                    ?u ?/ ?b ?n ?i ?o ?' ?l ?j))
  (setq avy-single-candidate-jump nil)
  (setq avy-dispatch-alist '((?m . avy-action-mark)
                             (?$ . avy-action-ispell)
                             (?z . avy-action-zap-to-char)
                             (?  . avy-action-embark)
                             (?= . avy-action-define)
                             (23 . avy-action-zap-to-char)
                             (67108896 . avy-action-mark-to-char)
                             (?h . avy-action-helpful)
                             (?x . avy-action-exchange)

                             (11 . avy-action-kill-line)
                             (25 . avy-action-yank-line)

                             (?w . avy-action-easy-kill)
                             (?k . avy-action-kill-stay)
                             (?y . avy-action-yank)
                             (?t . avy-action-teleport)

                             (?W . avy-action-copy-whole-line)
                             (?K . avy-action-kill-whole-line)
                             (?Y . avy-action-yank-whole-line)
                             (?T . avy-action-teleport-whole-line)
                             ;; (67108923 . avy-action-add-cursor)
                             (?\; . avy-action-add-cursor)))

  (defun avy-show-dispatch-help ()
    (let* ((len (length "avy-action-"))
           (fw (frame-width))
           (raw-strings (mapcar
                         (lambda (x)
                           (format "%2s: %-19s"
                                   (propertize
                                    ;; FIX: Use key-description to safely handle raw numbers and modifiers
                                    (key-description (vector (car x)))
                                    'face 'aw-key-face)
                                   (substring (symbol-name (cdr x)) len)))
                         avy-dispatch-alist))
           (max-len (1+ (apply #'max (mapcar #'length raw-strings))))
           (strings-len (length raw-strings))
           (per-row (floor fw max-len))
           display-strings)
      (cl-loop for string in raw-strings
               for N from 1 to strings-len do
               (push (concat string " ") display-strings)
               (when (= (mod N per-row) 0) (push "\n" display-strings)))
      (message "%s" (apply #'concat (nreverse display-strings)))))


  (setq avy-help-handler #'avy-show-dispatch-help)

  ;; Improved to include transposition by hylophile
  (defun avy-action-easy-kill (pt)
    (unless (require 'easy-kill nil t)
      (user-error "Easy Kill not found, please install."))
    (cl-letf* ((bounds (cond
                        ((use-region-p)
                         (prog1 (cons (region-beginning) (region-end))
                           (deactivate-mark)))
                        ((bounds-of-thing-at-point 'sexp))
                        (t (cons (point) (point)))))
               (transpose-map
                (define-keymap
                  "M-t" (lambda () (interactive "*")
                          (pcase-let ((`(,beg . ,end) (easy-kill--bounds)))
                            (transpose-regions (car bounds) (cdr bounds) beg end
                                               'leave-markers)))))
               ((symbol-function 'easy-kill-activate-keymap)
                (lambda ()
                  (let ((map (easy-kill-map)))
                    (set-transient-map
                     (make-composed-keymap transpose-map map)
                     (lambda ()
                       ;; Prevent any error from activating the keymap forever.
                       (condition-case err
                           (or (and (not (easy-kill-exit-p this-command))
                                    (or (eq this-command
                                            (lookup-key map (this-single-command-keys)))
                                        (let ((cmd (key-binding
                                                    (this-single-command-keys) nil t)))
                                          (command-remapping cmd nil (list map)))))
                               (ignore
                                (easy-kill-destroy-candidate)
                                (unless (or (easy-kill-get mark) (easy-kill-exit-p this-command))
                                  (easy-kill-save-candidate))))
                         (error (message "%s:%s" this-command (error-message-string err))
                                nil)))
                     (lambda ()
                       (let ((dat (ring-ref avy-ring 0)))
                         (select-frame-set-input-focus
                          (window-frame (cdr dat)))
                         (select-window (cdr dat))
                         (goto-char (car dat)))))))))
      (goto-char pt)
      (easy-kill)))

  (defun avy-action-exchange (pt)
    "Exchange sexp at PT with the one at point."
    (set-mark pt)
    (transpose-sexps 0))

  (defun avy-action-helpful (pt)
    (save-excursion
      (goto-char pt)
      (call-interactively #'display-local-help))
    (select-window
     (cdr (ring-ref avy-ring 0)))
    t)

  (defun avy-action-define (pt)
    (cl-letf (((symbol-function 'keyboard-quit)
               #'abort-recursive-edit))
      (save-excursion
        (goto-char pt)
        (dictionary-search-dwim))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  (defun avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  (defun avy-action-kill-line (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (kill-line))
      (avy-resume))
    (select-window
     (cdr (ring-ref avy-ring 0)))
    t)

  (defun avy-action-copy-whole-line (pt)
    (save-excursion
      (goto-char pt)
      (cl-destructuring-bind (start . end)
          (bounds-of-thing-at-point 'line)
        (copy-region-as-kill start end)))
    (select-window
     (cdr
      (ring-ref avy-ring 0)))
    t)

  (defun avy-action-kill-whole-line (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (kill-whole-line)
          (avy-resume)))
    (select-window
     (cdr
      (ring-ref avy-ring 0)))
    t)

  (defun avy-action-yank-whole-line (pt)
    (avy-action-copy-whole-line pt)
    (save-excursion (yank))
    t)

  (defun avy-action-teleport-whole-line (pt)
    (avy-action-kill-whole-line pt)
    (save-excursion (yank)) t)

  (defun avy-action-mark-to-char (pt)
    (activate-mark)
    (goto-char pt))

  (defun avy-action-add-cursor (pt)
    (require 'macrursors)
    (unwind-protect
        (progn
          (if (or macrursors--overlays
                  (cl-some
                   (pcase-lambda (`((,from . ,to) . _))
                     (<= from (point) to))
                   avy-last-candidates))
              (pcase-let* ((`(_ . ,ov) (get-char-property-and-overlay
                                        pt 'macrursors-type)))
                (if (not (overlayp ov)) ;Add or remove a cursor
                    (macrursors--add-overlay-at-point pt)
                  (setq macrursors--overlays (delq ov macrursors--overlays))
                  (delete-overlay ov)))
            (goto-char pt)                 ;jump to first selection
            (push t macrursors--overlays)) ;to make it non-nil
          (kmacro-keyboard-quit)
          (avy-resume))
      (setq macrursors--overlays (delq t macrursors--overlays))
      (macrursors-start)))

  (defun my/avy-goto-char-this-window (&optional arg)
    "Goto char in this window with hints."
    (interactive "P")
    (let ((avy-all-windows nil)
          (current-prefix-arg (if arg 4)))
      (call-interactively 'avy-goto-word-1)))

  (defun my/avy-isearch (&optional arg)
    "Goto isearch candidate in this window with hints."
    (interactive "P")
    (let ((avy-all-windows)
          (current-prefix-arg (if arg 4)))
      (call-interactively 'avy-isearch)))

  (defun my/avy--read-char-2 (char1 char2)
    "Read two characters from the minibuffer."
    (interactive (list (let ((c1 (read-char "char 1: " t)))
                         (if (memq c1 '(? ?\b))
                             (keyboard-quit)
                           c1))
                       (let ((c2 (read-char "char 2: " t)))
                         (cond ((eq c2 ?)
                                (keyboard-quit))
                               ((memq c2 '(8 127))
                                (keyboard-escape-quit)
                                (call-interactively 'my/avy-next-char-2))
                               (t
                                c2)))))

    (when (eq char1 ?) (setq char1 ?\n))
    (when (eq char2 ?) (setq char2 ?\n))
    (string char1 char2))

  (defun my/avy-next-char-2 (&optional str2 arg)
    "Go to the next occurrence of two characters"
    (interactive (list
                  (call-interactively 'my/avy--read-char-2)
                  current-prefix-arg))
    (let* ((ev last-command-event)
           (echo-keystrokes nil))
      (push-mark (point) t)
      (if (search-forward str2 nil t
                          (+ (if (looking-at (regexp-quote str2))
                                 1 0)
                             (or arg 1)))
          (backward-char 2)
        (pop-mark)))

    (set-transient-map
     (let ((map (make-sparse-keymap)))
       (define-key map (kbd ";") (lambda (&optional arg) (interactive)
                                   (my/avy-next-char-2 str2 arg)))
       (define-key map (kbd ",") (lambda (&optional arg) (interactive)
                                   (my/avy-previous-char-2 str2 arg)))
       map)))

  (defun my/avy-previous-char-2 (&optional str2 arg)
    "Go to the next occurrence of two characters"
    (interactive (list
                  (call-interactively 'my/avy--read-char-2)
                  current-prefix-arg))
    (let* ((ev last-command-event)
           (echo-keystrokes nil))
      (push-mark (point) t)
      (unless (search-backward str2 nil t (or arg 1))
        (pop-mark)))

    (set-transient-map
     (let ((map (make-sparse-keymap)))
       (define-key map (kbd ";") (lambda (&optional arg) (interactive)
                                   (my/avy-next-char-2 str2 arg)))
       (define-key map (kbd ",") (lambda (&optional arg) (interactive)
                                   (my/avy-previous-char-2 str2 arg)))
       map)))

  (defun my/avy-copy-line-no-prompt (arg)
    (interactive "p")
    (avy-copy-line arg)
    (beginning-of-line)
    (zap-to-char 1 32)
    (delete-forward-char 1)
    (move-end-of-line 1))

  (defun my/avy-link-hint (&optional win)
    "Find all visible buttons and links in window WIN and open one with Avy.

The current window is chosen if WIN is not specified."
    (interactive)
    (with-selected-window (or win
                              (setq win (selected-window)))
      (let* ((avy-single-candidate-jump t) match all-buttons)

        ;; SHR links
        (save-excursion
          (goto-char (window-start))
          (while (and
                  (<= (point) (window-end))
                  (setq match
                        (text-property-search-forward 'category 'shr t nil)))
            (let ((st (prop-match-beginning match)))
              (push
               `((,st . ,(1+ st)) . ,win)
               all-buttons))))

        ;; Collapsed sections
        (thread-last (overlays-in (window-start) (window-end))
                     (mapc (lambda (ov)
                             (when (or (overlay-get ov 'button)
                                       (eq (overlay-get ov 'face)
                                           'link))
                               (let ((st (overlay-start ov)))
                                 (push
                                  `((,st . ,(1+ st)) . ,win)
                                  all-buttons))))))

        (when-let
            ((_ all-buttons)
             (avy-action
              (lambda (pt)
                (goto-char pt)
                (let (b link)
                  (cond
                   ((and (setq b (button-at (1+ pt)))
                         (button-type b))
                    (button-activate b))
                   ((shr-url-at-point pt)
                    (shr-browse-url))
                   ((setq link (or (get-text-property pt 'shr-url)
                                   (thing-at-point 'url)))
                    (browse-url link)))))))
          (let ((cursor-type nil))
            (avy-process all-buttons))))))

  (custom-set-faces
   '(avy-lead-face
     ((((background dark))
       :foreground "LightCoral" :background "Black"
       :weight bold :underline t)
      (((background light))
       :foreground "DarkRed" :background unspecified :box (:line-width (1 . -1)) :height 0.95
       :weight bold)))
   '(avy-lead-face-0 ((t :background unspecified :inherit avy-lead-face)))
   '(avy-lead-face-1 ((t :background unspecified :inherit avy-lead-face)))
   '(avy-lead-face-2 ((t :background unspecified :inherit avy-lead-face))))

  (define-advice avy-goto-line-below (:around (orig-fn &rest args) no-default-action)
    "Ensure no default `avy-action' when moving, and go to end of line."
    (let ((avy-action)) (apply orig-fn args))) ;; (end-of-line)

  (define-advice avy-goto-line-above (:around (orig-fn &rest args) no-default-action)
    "Ensure no default `avy-action' when moving, and go to end of line."
    (let ((avy-action)) (apply orig-fn args))) ;; (end-of-line)

  ;; Jump to all paren types with [ and ]
  (advice-add 'avy-jump :filter-args
              (defun my/avy-jump-parens (args)
                (let ((new-regex
                       (my/avy-replace-syntax-class (car args))))
                  (cons new-regex (cdr args)))))

  (defun my/avy-replace-syntax-class (regex)
    (thread-last regex
                 (string-replace "\\[" "\\s(")
                 (string-replace "\\]" "\\s)")
                 (string-replace ";" "\\(?:;\\|:\\)")
                 (string-replace "'" "\\(?:'\\|\"\\)")))

  (defun my/avy-goto-char-timer (&optional arg)
    "Read one or many consecutive chars and jump to the first one.
The window scope is determined by `avy-all-windows' (ARG negates it).

This differs from Avy's goto-char-timer in how it processes parens."
    (interactive "P")
    (let ((avy-all-windows (if arg
                               (not avy-all-windows)
                             avy-all-windows))
          (avy-single-candidate-jump nil))
      (avy-with avy-goto-char-timer
        (setq avy--old-cands (avy--read-candidates
                              (lambda (str) (my/avy-replace-syntax-class
                                             (regexp-quote str)))))
        (avy-process avy--old-cands))))
  )

(use-package switchy-window
  :straight t
  :defer 2
  :init (switchy-window-minor-mode)
  :bind (("M-o" . switchy-window)
         :map other-window-repeat-map
         ("o" . switchy-window))
  :config
  (setq switchy-window-delay 0.75)
  (put 'switchy-window 'repeat-map 'other-window-repeat-map))

;;; Ace window to jump to windows quickly
(use-package ace-window
  :straight t
  :bind
  (("C-x o" . ace-window)
   ("H-o"   . ace-window)
   ("C-M-0" . ace-window-prefix)
   ("C-M-9" . ace-window)
   :map ctl-x-4-map
   ("o" . ace-window-prefix))
  ;; :custom-face
  ;; (aw-leading-char-face ((t (:height 2.5 :weight normal))))
  :defer 2
  :init (ace-window-display-mode 1)
  :custom-face (aw-mode-line-face ((t (:inherit (bold mode-line-emphasis)))))
  :config
  (defun my/aw-take-over-window (window)
    "Move from current window to WINDOW.

Delete current window in the process."
    (let ((buf (current-buffer)))
      (if (one-window-p)
          (delete-frame)
        (delete-window))
      (aw-switch-to-window window)
      (switch-to-buffer buf)))
  (defun ace-window-prefix ()
    "Use `ace-window' to display the buffer of the next command.
The next buffer is the buffer displayed by the next command invoked
immediately after this command (ignoring reading from the minibuffer).
Creates a new window before displaying the buffer.
When `switch-to-buffer-obey-display-actions' is non-nil,
`switch-to-buffer' commands are also supported."
    (interactive)
    (display-buffer-override-next-command
     (lambda (buffer _)
       (let (window type)
         (setq
          window (aw-select (propertize " ACE" 'face 'mode-line-highlight))
          type 'reuse)
         (cons window type)))
     nil "[ace-window]")
    (message "Use `ace-window' to display next command buffer..."))
  (setq aw-swap-invert t)
  (setq aw-dispatch-always t
        aw-scope 'global
        aw-background nil
        aw-display-mode-overlay nil
        aw-keys '(?q ?w ?e ?r ?t ?y ?u ?i ?p))
  (setq aw-dispatch-alist
        '((?k aw-delete-window "Delete Window")
          (?x aw-swap-window "Swap Windows")
          (?c aw-copy-window "Copy Window")
          (?j aw-switch-buffer-in-window "Select Buffer")
          (?b aw-switch-buffer-other-window "Switch Buffer Other Window")
          (?v aw-split-window-vert "Split Vert Window")
          (?h aw-split-window-horz "Split Horz Window")
          (?? aw-show-dispatch-help))))

(use-package windmove
  :after window
  :bind (("C-<right>" . windmove-swap-states-right)
         ("C-<down>" . windmove-swap-states-down)
         ("C-<up>" . windmove-swap-states-up)
         ("C-<left>" . windmove-swap-states-left)
         :map other-window-repeat-map
         ("l" . windmove-right)
         ("k" . windmove-up)
         ("h" . windmove-left)
         ("j" . windmove-down))
  :init
  (setq windmove-wrap-around t)
  (dolist (cmd '(windmove-left windmove-right
                  windmove-up windmove-down))
    (put cmd 'repeat-map 'other-window-repeat-map))

  (dolist (cmd '(windmove-swap-states-left windmove-swap-states-right
                windmove-swap-states-up windmove-swap-states-down))
  (put cmd 'repeat-map 'other-window-repeat-map)))

;;; Better M-v/C-v
(defun better-scroll-up-half (&optional arg)
  "Scroll up by half a screen and recenter.
  With prefix ARG, scroll ARG lines instead."
  (interactive "P")
  (let ((n (if arg
               (prefix-numeric-value arg)
             (/ (window-body-height) 2))))
    (scroll-up-command n)
    (recenter)))

(defun better-scroll-down-half (&optional arg)
  "Scroll down by half a screen and recenter.
  With prefix ARG, scroll ARG lines instead."
  (interactive "P")
  (let ((n (if arg
               (prefix-numeric-value arg)
             (/ (window-body-height) 2))))
    (scroll-down-command n)
    (recenter)))
(global-set-key (kbd "C-v") 'better-scroll-up-half)
(global-set-key (kbd "M-v") 'better-scroll-down-half)

(use-package hydra
  :straight t
  :bind
  ("M-1" . 'hydra-moves/body)
  :init
  (defhydra hydra-moves (:color pink)
      "emacs fast movements"
      ("l" forward-char)
      ("h" backward-char)
      ("j" next-line)
      ("k" previous-line)
      ("J" (lambda () (interactive) (next-line) (recenter)))
      ("K" (lambda () (interactive) (previous-line) (recenter)))
      ("a" beginning-of-line)
      ("e" end-of-line)
      ("w" forward-word)
      ("b" backward-word)
      ("u" better-scroll-down-half)
      ("d" better-scroll-up-half)
      ("z" recenter-top-bottom)
      ("c" kirigami-close-fold)
      ("C" kirigami-close-folds)
      ("o" kirigami-open-fold)
      ("O" kirigami-open-fold-rec)
      ("r" kirigami-open-folds)
      ("RET" avy-goto-char-timer)
      ("f" avy-goto-char-in-line)
      ("." embark-dwim)
      ("," xref-go-back)
      ("?" xref-find-references)
      ("q" nil "quit" :color blue))
  )

(use-package avy-zap
  :straight t
  :bind (("M-z" . avy-zap-to-char-dwim)
         ("M-Z" . avy-zap-up-to-char-dwim)))

(use-package expand-region
  :ensure t
  :commands expand-region
  :bind ("C-," . 'er/expand-region)
  :config
  (setq expand-region-show-usage-message nil
        expand-region-fast-keys-enabled nil)
  (defvar expand-region-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map "," #'er/expand-region)
      (define-key map "-" #'er/contract-region)
      (define-key map "." #'er/contract-region)
      map))
  (dotimes (i 9)
    (define-key expand-region-repeat-map
                (kbd (number-to-string i))
                (lambda () (interactive)
                  (er/expand-region i)
                  (setq this-command 'er/expand-region))))
  (put 'er/expand-region 'repeat-map 'expand-region-repeat-map)
  (put 'er/contract-region 'repeat-map 'expand-region-repeat-map))
