;; -*- lexical-binding: t -*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp/core" user-emacs-directory))
(require 'lpac-core-packages)
(require 'lpac-core-fonts)
(require 'lpac-core-basics)
(require 'lpac-core-notes)
(require 'lpac-core-themes)
(require 'lpac-core-tramp)
(require 'lpac-core-movements)
(require 'lpac-core-git)
(require 'lpac-core-utils)
(require 'lpac-core-completions)

(add-to-list 'load-path (expand-file-name "lisp/ide" user-emacs-directory))
(require 'lpac-ide-basics)
(require 'lpac-ide-fly)
(require 'lpac-ide-eglot)
(require 'lpac-ide-completion)
(require 'lpac-ide-perspective)

(add-to-list 'load-path (expand-file-name "lisp/ai" user-emacs-directory))
(require 'lpac-ai-basics)


(provide 'init)

;;; init.el ends here

