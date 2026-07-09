;;; setup-transients.el --- Workflow menus -*- lexical-binding: t; -*-

(require 'transient)

;;; ─────────────────────────────────────────────────────────────
;;; Prevent `repeat-mode' from hijacking transient prefixes.
;;;
;;; Some commands (e.g. `diff-hl-next-hunk') set a `repeat-map' so
;;; that `repeat-mode' installs an overriding transient keymap after
;;; each invocation.  That map shadows the currently active transient
;;; prefix (so, e.g., pressing `n' twice in `my/diff-hl-menu' invokes
;;; `diff-hl-revert-hunk' instead of `diff-hl-next-hunk').  Skip
;;; `repeat-post-hook' whenever a transient prefix is active.
;;; ─────────────────────────────────────────────────────────────
(with-eval-after-load 'repeat
  (define-advice repeat-post-hook
      (:around (orig-fn &rest args) my/skip-when-transient-active)
    (unless (bound-and-true-p transient--prefix)
      (apply orig-fn args))))

;;; ─────────────────────────────────────────────────────────────
;;; Jinx (spell)
;;; ─────────────────────────────────────────────────────────────
(transient-define-prefix my/jinx-menu ()
  "Jinx spell-check workflow."
  [["Navigate"
    ("n" "next"          jinx-next            :transient t)
    ("p" "previous"      jinx-previous        :transient t)]
   ["Correct"
    ("c" "nearest"       jinx-correct-nearest :transient t)
    ("$" "dispatch"      jinx-correct         :transient t)
    ("a" "all in buffer" jinx-correct-all     :transient t)
    ("w" "word at point" jinx-correct-word    :transient t)]
   ["Session"
    ("l" "languages"     jinx-languages)
    ("m" "jinx-mode"     jinx-mode)
    ("M" "global"        global-jinx-mode)
    ("q" "quit"          transient-quit-one)]])

;;; ─────────────────────────────────────────────────────────────
;;; Smerge (merge conflicts)
;;; ─────────────────────────────────────────────────────────────
(transient-define-prefix my/smerge-menu ()
  "Resolve merge conflicts with smerge."
  [["Navigate"
    ("n" "next"     smerge-next :transient t)
    ("p" "previous" smerge-prev :transient t)]
   ["Keep"
    ("u" "upper (mine)"   smerge-keep-upper   :transient t)
    ("l" "lower (theirs)" smerge-keep-lower   :transient t)
    ("b" "base"           smerge-keep-base    :transient t)
    ("a" "all (both)"     smerge-keep-all     :transient t)
    ("c" "at point"       smerge-keep-current :transient t)]
   ["Diff"
    ("<" "base ↔ upper"  smerge-diff-base-upper)
    (">" "base ↔ lower"  smerge-diff-base-lower)
    ("=" "upper ↔ lower" smerge-diff-upper-lower)]
   ["Actions"
    ("R" "refine hunk"    smerge-refine            :transient t)
    ("r" "auto-resolve"   smerge-resolve           :transient t)
    ("C" "combine w/next" smerge-combine-with-next :transient t)
    ("s" "swap up/down"   smerge-swap              :transient t)
    ("E" "ediff"          smerge-ediff)]
   ["Mode"
    ("m" "smerge-mode" smerge-mode)
    ("q" "quit"        transient-quit-one)]])

;;; ─────────────────────────────────────────────────────────────
;;; diff-hl (VC hunks)
;;; ─────────────────────────────────────────────────────────────
(transient-define-prefix my/diff-hl-menu ()
  "Navigate and act on VC hunks with diff-hl."
  [["Navigate"
    ("n" "next"     diff-hl-next-hunk     :transient t)
    ("p" "previous" diff-hl-previous-hunk :transient t)]
   ["Hunk"
    ("s"   "show popup" diff-hl-show-hunk       :transient t)
    ("r"   "revert"     diff-hl-revert-hunk     :transient t)
    ("SPC" "mark"       diff-hl-mark-hunk       :transient t)
    ("g"   "diff+goto"  diff-hl-diff-goto-hunk)
    ("G"   "diff (ref)" diff-hl-diff-reference-goto-hunk)
    ("S"   "stage"      diff-hl-stage-dwim)]
   ["Reference"
    ("R" "set rev"        diff-hl-set-reference-rev)
    ("P" "set rev (proj)" diff-hl-set-reference-rev-in-project)
    ("X" "reset"          diff-hl-reset-reference-rev)]
   ["Mode"
    ("m" "diff-hl-mode"        diff-hl-mode)
    ("M" "global-diff-hl-mode" global-diff-hl-mode)
    ("F" "flydiff"             diff-hl-flydiff-mode)
    ("A" "amend"               diff-hl-amend-mode)
    ("q" "quit"                transient-quit-one)]])

;;; ─────────────────────────────────────────────────────────────
;;; Flymake (diagnostics)
;;; ─────────────────────────────────────────────────────────────
(transient-define-prefix my/flymake-menu ()
  "Flymake diagnostics workflow."
  [["Navigate"
    ("n" "next"     flymake-goto-next-error :transient t)
    ("p" "previous" flymake-goto-prev-error :transient t)]
   ["List"
    ("l" "buffer diagnostics"  flymake-show-buffer-diagnostics)
    ("P" "project diagnostics" flymake-show-project-diagnostics)
    ("c" "consult-flymake"     consult-flymake)]
   ["Backends"
    ("s" "start"     flymake-start)
    ("r" "running"   flymake-running-backends)
    ("R" "reporting" flymake-reporting-backends)
    ("d" "disabled"  flymake-disabled-backends)
    ("L" "log buffer" flymake-switch-to-log-buffer)]
   ["Mode"
    ("m" "flymake-mode" flymake-mode)
    ("q" "quit"         transient-quit-one)]])

;;; ─────────────────────────────────────────────────────────────
;;; Top-level dispatcher
;;; ─────────────────────────────────────────────────────────────
(transient-define-prefix my/menu ()
  "Dispatch to a workflow menu."
  ["Menus"
   ("j" "Jinx (spell check)" my/jinx-menu)
   ("s" "Smerge (conflicts)" my/smerge-menu)
   ("f" "Flymake (diagnostics)" my/flymake-menu)
   ("d" "diff-hl (VC hunks)" my/diff-hl-menu)

   ;; Add here as you build them:
   ;; ("t" "Text scale"       my/text-scale-menu)
   ;; ("w" "Windows"          my/windows-menu)
   ""
   ("q" "quit" transient-quit-one)])

(keymap-global-set "M-$"   #'my/jinx-menu) ;; direct
(keymap-global-set "M-2"  #'my/menu)      ;; dispatcher

(provide 'setup-transients)
;;; setup-transients.el ends here
