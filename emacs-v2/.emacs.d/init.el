;; -*- lexical-binding: t -*-

;; Log warnings in the background without popping up the buffer
(setq native-comp-async-report-warnings-errors 'silent)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp/core" user-emacs-directory))
(require 'lpac-core-packages)
(require 'lpac-core-fonts)
(require 'lpac-core-basics)
(require 'lpac-core-sidebar)
(require 'lpac-core-notes)
(require 'lpac-core-themes)
(require 'lpac-core-tramp)
(require 'lpac-core-movements)
(require 'lpac-core-git)
(require 'lpac-core-utils)
(require 'lpac-core-completions)

(add-to-list 'load-path (expand-file-name "lisp/ide" user-emacs-directory))
(require 'lpac-ide-basics)
(require 'lpac-ide-treesit)
(require 'lpac-ide-fly)
(require 'lpac-ide-eglot)
(require 'lpac-ide-completion)
(require 'lpac-ide-perspective)

(add-to-list 'load-path (expand-file-name "lisp/ai" user-emacs-directory))
(require 'lpac-ai-basics)


(provide 'init)

;;; init.el ends here

