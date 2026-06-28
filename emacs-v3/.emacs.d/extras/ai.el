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


;;; Eca
(use-package eca
  :straight t
  :config
  (when (boundp 'user-login-name)
    (setq eca-custom-command
          (if (string-equal (getenv "USER") "hpedev")
              '("~/.emacs.d/eca/eca" "-Djavax.net.ssl.trustStore=/usr/lib/jvm/java-21-openjdk-amd64/lib/security/cacerts" "-Djavax.net.ssl.trustStorePassword=changeit" "server")
            '("~/.emacs.d/eca/eca" "server")))))

(defface my/org-gptel-user-face
  '((t :inherit font-lock-keyword-face :weight bold))
  "Face for @user markers.")

(defface my/org-gptel-assistant-face
  '((t :inherit font-lock-negation-char-face :weight bold))
  "Face for @assistant markers.")

(defface my/gptel-assistant-line-face
  '((t :inherit hl-line :extend t))
  "Face for @assistant lines.")

(defface my/gptel-user-line-face
  '((t :inherit hl-line :extend t))
  "Face for @assistant lines.")

(defvar-local my/org-gptel-font-lock-keywords
    '(("^\\(@user\\)\\b.*$"
       (0 'my/gptel-user-line-face prepend)
       (1 'my/org-gptel-user-face prepend))

      ("^\\(@assistant\\)\\b.*$"
       (0 'my/gptel-assistant-line-face prepend)
       (1 'my/org-gptel-assistant-face prepend)))
  "Font-lock rules for gptel role markers."
  )

(define-minor-mode my/org-gptel-highlight-mode
  "Toggle highlighting of @user and @assistant markers."
  :lighter " GPT-Hi"
  (if my/org-gptel-highlight-mode
      (font-lock-add-keywords nil my/org-gptel-font-lock-keywords 'append)
    (font-lock-remove-keywords nil my/org-gptel-font-lock-keywords))
  (font-lock-flush)
  (font-lock-ensure))

(use-package gptel
  :straight (gptel :type git :host github :repo "karthink/gptel")
  :init
  ()
  :hook (gptel-mode-hook .  (lambda () (my/org-gptel-highlight-mode 1)))
  :bind (
         ("C-c a n" . gptel)
         ("C-c a s" . gptel-send)
         ("C-c a r" . gptel-rewrite)
         ("C-c a m" . gptel-menu)
         ("C-c a a" . gptel-add)
         ("C-c a c a" . gptel-context-add)
         ("C-c a c f" . gptel-context-add-file)
         ("C-c a c R" . gptel-context-remove-all)
         )

  :custom
  (gptel-expert-commands t)
  (gptel-default-mode 'org-mode)
  :config
  (setf (alist-get 'org-mode gptel-prompt-prefix-alist) "@user\n")
  (setf (alist-get 'org-mode gptel-response-prefix-alist) "@assistant\n")
  (gptel-make-deepseek "PersonalDeepseek" ;Any name you want
    :stream t                             ;for streaming responses
    :key (getenv "DEEPSEEK_API_KEY_EMACS")) ;can be a function that returns the key
  (gptel-make-gh-copilot "HPECopilot")

  ;; 1) The directive: the actual prompt instructions
  (setf (alist-get 'english-refine gptel-directives)

        "You are my English writing assistant.

My native language is Brazilian Portuguese. I will give you English text that I want to improve for work, emails, or professional communication.

Your job is to:
1. Preserve the original meaning.
2. Improve clarity, readability, grammar, and naturalness.
3. Make the text sound closer to how a native English speaker would write it.
4. Provide 4 rewritten versions:
   - Loose: more casual, natural, and relaxed
   - Normal: balanced, clear, and professional
   - Formal: more polished, concise, and formal
   - Work email: specifically optimized for professional email communication, with a natural tone and good email etiquette
5. After the rewritten versions, provide constructive feedback that helps me learn:
   - grammar corrections
   - syntax or sentence structure issues
   - vocabulary improvements
   - tone and style notes
   - any awkward or unnatural phrasing
6. Keep the feedback practical and educational.

Rules:
- Do not change the meaning.
- Do not add unnecessary content.
- Keep names, technical terms, product names, and acronyms unchanged unless I ask otherwise.
- If my text is already good, still provide improvements and explain only the important points.
- If something is ambiguous, suggest the safest interpretation rather than inventing new meaning.
- Prefer natural English over literal translations from Portuguese.
- Do not use em dashes or semicolons in the rewritten text unless I explicitly ask for them.
- Prefer simple, natural punctuation such as periods, commas, and apostrophes.
- When relevant, make the work email version sound polite, concise, and appropriate for workplace communication.

Format your response exactly like this:

Loose:
[rewrite]

Normal:
[rewrite]

Formal:
[rewrite]

Work email:
[rewrite]

Feedback:
- [point 1]
- [point 2]
- [point 3]
- [point 4]
- [point 5]")

  ;; 2) The preset: bundles the directive with useful defaults
  (gptel-make-preset 'english-refine
    :description "Rewrite English text with 4 variants and feedback"
    :system 'english-refine
    :include-reasoning nil)
  )

(use-package gptel-agent
  :straight (gptel-agent :type git :host github :repo "karthink/gptel-agent")
  :config
  (when (string= (system-name) "hpedev")
    (add-to-list 'gptel-agent-dirs "~/glp/dev-env/ws/github.com/glcp/lucas-glp-sdlc-marketplace/plugins/glp-design-workflow/agents/"))
  (gptel-agent-update))
