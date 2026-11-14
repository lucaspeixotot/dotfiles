;;; -*- lexical-binding: t; -*-
;;; WSL-specific integrations: Windows browser and clipboard image paste.
;;; Loaded from init.el only when running inside WSL.

;;;; Browser: open links in the Windows default browser via wslview (wslu)
(if (executable-find "wslview")
    (setq browse-url-generic-program "wslview"
          browse-url-browser-function #'browse-url-generic)
  ;; Fallback: powershell
  (setq browse-url-browser-function
        (lambda (url &rest _)
          (call-process "powershell.exe" nil 0 nil
                        "-NoProfile" "Start-Process"
                        (shell-quote-argument url)))))

;;;; Clipboard image paste (C-S-y)
;; WSLg only syncs text between the Windows and Linux clipboards, so
;; yank-media / wl-paste never see images.  We fetch the image directly
;; from the Windows clipboard via powershell, save it to a fixed
;; directory, and insert a reference appropriate for the current mode:
;; - eca-chat / agent-shell: an @path mention (their attach mechanism)
;; - org-mode: a [[file:...]] link
;; - elsewhere: the plain file path

(defvar my/wsl-image-dir "~/Pictures/clipboard/"
  "Directory where images pasted from the Windows clipboard are saved.")

(defun my/wsl-clipboard-has-image-p ()
  "Return non-nil if the Windows clipboard contains an image."
  (string-prefix-p
   "True"
   (string-trim
    (shell-command-to-string
     "powershell.exe -NoProfile -Command \"[bool](Get-Clipboard -Format Image)\""))))

(defun my/wsl-save-clipboard-image ()
  "Save Windows clipboard image to `my/wsl-image-dir'.
Return the file path, or nil if nothing was saved."
  (let* ((file (expand-file-name
                (format-time-string "img-%Y%m%d-%H%M%S.png")
                my/wsl-image-dir))
         (winpath (string-trim
                   (shell-command-to-string
                    (concat "wslpath -w " (shell-quote-argument file))))))
    (make-directory (file-name-directory file) t)
    (call-process "powershell.exe" nil nil nil
                  "-NoProfile" "-Command"
                  (format "(Get-Clipboard -Format Image).Save('%s')" winpath))
    (when (file-exists-p file) file)))

(defun my/wsl-yank-image ()
  "Paste an image from the Windows clipboard into the current buffer."
  (interactive)
  (let ((file (and (my/wsl-clipboard-has-image-p)
                   (my/wsl-save-clipboard-image))))
    (cond
     ((null file)
      (message "Nenhuma imagem no clipboard do Windows"))
     ((derived-mode-p 'eca-chat-mode 'agent-shell-mode)
      (insert "@" file " "))
     ((derived-mode-p 'org-mode)
      (insert (format "[[file:%s]]" file))
      (org-display-inline-images))
     (t
      (insert file)))))

(keymap-global-set "C-S-y" #'my/wsl-yank-image)
