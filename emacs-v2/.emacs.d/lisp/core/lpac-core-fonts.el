;; -*- lexical-binding: t -*-

;; Set the default font globally
(set-face-attribute 'default nil :family "JetBrains Mono NL" :height 100 :weight 'normal)

;; Ensure consistency for fixed-pitch and variable-pitch faces
(set-face-attribute 'fixed-pitch nil :family "JetBrains Mono NL" :height 100)
(set-face-attribute 'variable-pitch nil :family "JetBrains Mono NL" :height 1.0)

;;
;; Fine-tune specific faces as desired
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
(set-face-attribute 'font-lock-string-face nil :slant 'italic)
(set-face-attribute 'bold nil :weight 'bold)

;; ;; Optional: Adjust frame-specific settings like line spacing
(setq-default line-spacing 0)

(provide 'lpac-core-fonts)
