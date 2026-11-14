;;; slides.el --- Org presentation infrastructure -*- lexical-binding: t; -*-

;; This file provides presentation tooling only; it does not define a deck.

(defconst my/excali-local-directory
  (expand-file-name "extras/local/excali-mode" user-emacs-directory)
  "Optional local checkout of excali-mode.")

(when (file-directory-p my/excali-local-directory)
  (add-to-list 'load-path my/excali-local-directory))

(defun my/slides--call (command)
  "Load dslide and invoke interactive COMMAND."
  (unless (require 'dslide nil t)
    (user-error "dslide is unavailable; install it with straight and try again"))
  (call-interactively command))

(defun my/slides-start ()
  "Start, resume, or show the contents of the current dslide deck."
  (interactive)
  (my/slides--call #'dslide-deck-start))

(defun my/slides-present ()
  "Present the current dslide deck in a separate frame."
  (interactive)
  (my/slides--call #'dslide-deck-present))

(defun my/slides-develop ()
  "Open dslide's development view for the current deck."
  (interactive)
  (my/slides--call #'dslide-deck-develop))

(defun my/slides-stop ()
  "Stop the active dslide deck."
  (interactive)
  (my/slides--call #'dslide-deck-stop))

(defun my/slides-contents ()
  "Show dslide contents, or start the deck when it is not active."
  (interactive)
  (my/slides--call #'dslide-deck-start))

(defun my/slides-forward ()
  "Advance the active dslide deck."
  (interactive)
  (my/slides--call #'dslide-deck-forward))

(defun my/slides-backward ()
  "Move backward in the active dslide deck."
  (interactive)
  (my/slides--call #'dslide-deck-backward))

(define-prefix-command 'my/slides-map)
(global-set-key (kbd "C-c S") #'my/slides-map)
(define-key my/slides-map (kbd "s") #'my/slides-start)
(define-key my/slides-map (kbd "p") #'my/slides-present)
(define-key my/slides-map (kbd "d") #'my/slides-develop)
(define-key my/slides-map (kbd "q") #'my/slides-stop)
(define-key my/slides-map (kbd "c") #'my/slides-contents)
(define-key my/slides-map (kbd "n") #'my/slides-forward)
(define-key my/slides-map (kbd "f") #'my/slides-forward)
(define-key my/slides-map (kbd "b") #'my/slides-backward)

(defun my/slides--display-inline-images ()
  "Display image links in the current, indirect dslide buffer."
  (cond
   ((fboundp 'org-link-preview-region)
    (org-link-preview-region nil nil (point-min) (point-max)))
   ((fboundp 'org-display-inline-images)
    (org-display-inline-images nil nil (point-min) (point-max)))))

(defun my/slides--setup-presentation-buffer ()
  "Apply presentation-local display settings to dslide's slide buffer."
  (visual-line-mode 1)
  (if (fboundp 'dslide-hide-cursor-mode)
      (dslide-hide-cursor-mode 1)
    (setq-local cursor-type nil))
  ;; A local value prevents the presentation chrome from affecting the source.
  (setq-local mode-line-format nil)
  ;; Inline images are handled by `dslide-action-image' (a default action).
  ;; Forcing `org-display-inline-images' here would re-show images that the
  ;; action is deliberately hiding for ":slide-display reveal".
  )

(use-package dslide
  :straight (dslide :type git :host github :repo "positron-solutions/dslide")
  :defer t
  :init
  ;; These hooks run in dslide's indirect slide buffer, never the source buffer.
  (add-hook 'dslide-start-hook #'my/slides--setup-presentation-buffer)
  (add-hook 'dslide-present-hook #'my/slides--setup-presentation-buffer)
  (add-hook 'dslide-develop-hook #'my/slides--setup-presentation-buffer)
  :config
  ;; Hide #+BEGIN_NOTES ... #+END_NOTES (Org special blocks) while presenting.
  ;; They hold Reveal.js speaker notes for the HTML export and must not show
  ;; up in the live dslide presentation.
  (add-to-list 'dslide-hide-markup-types 'special-block))

(use-package ob-excali
  :straight nil
  :after org
  :if (file-directory-p my/excali-local-directory)
  :config
  ;; Preserve existing Babel languages and its confirmation policy.
  (add-to-list 'org-babel-load-languages '(excali . t)))

;; HTML export of Org decks: org-re-reveal translates the Org file into a
;; Reveal.js presentation. Only the exporter lives here; the Reveal.js
;; runtime is expected inside each talk's directory (see #+reveal_root).
(use-package org-re-reveal
  :straight (org-re-reveal :type git :host gitlab :repo "oer/org-re-reveal")
  :after org
  :commands (org-re-reveal-export-to-html
             org-re-reveal-export-to-html-and-browse))

(defun my/slides-export-html ()
  "Export the current Org deck to Reveal.js HTML next to the source file."
  (interactive)
  (unless (require 'org-re-reveal nil t)
    (user-error "org-re-reveal is unavailable; install it with straight and try again"))
  (call-interactively #'org-re-reveal-export-to-html))

(defun my/slides-export-html-and-browse ()
  "Export the current Org deck to Reveal.js HTML and open it in the browser."
  (interactive)
  (unless (require 'org-re-reveal nil t)
    (user-error "org-re-reveal is unavailable; install it with straight and try again"))
  (call-interactively #'org-re-reveal-export-to-html-and-browse))

(define-key my/slides-map (kbd "e") #'my/slides-export-html)
(define-key my/slides-map (kbd "E") #'my/slides-export-html-and-browse)

(defun my/slides-excali-status ()
  "Report non-invasive dslide/Excali prerequisites without loading native code."
  (interactive)
  (let* ((checkout (file-directory-p my/excali-local-directory))
         (ob-excali (locate-library "ob-excali"))
         (module-support (fboundp 'module-load))
         (canvas-support (or (featurep 'canvas) (locate-library "canvas")))
         (module-files (when checkout
                         (directory-files-recursively my/excali-local-directory
                                                      "\\.\\(so\\|dylib\\|dll\\)\\'"))))
    (message "%s"
             (mapconcat #'identity
                        (delq nil
                              (list
                               (format "Excali checkout: %s"
                                       (if checkout my/excali-local-directory "MISSING"))
                               (format "ob-excali: %s"
                                       (or ob-excali "MISSING (checkout may be incomplete)"))
                               (format "Native modules: %s"
                                       (if module-support "supported" "UNSUPPORTED by this Emacs"))
                               (format "Canvas support: %s"
                                       (if canvas-support "available" "not detected (may be optional/version-specific)"))
                               (format "Native module file: %s"
                                       (if module-files (car module-files)
                                         "not found (build Excali when needed)"))))
                        " | "))))

(unless (file-directory-p my/excali-local-directory)
  (display-warning 'my/slides
                   (format "Excali checkout not found: %s (Excali Babel support disabled)"
                           my/excali-local-directory)
                   :warning))

;; Do not load Excali or its native module here; its checkout is optional.

(provide 'slides)
;;; slides.el ends here
