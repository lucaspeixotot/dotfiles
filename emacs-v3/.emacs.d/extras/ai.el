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
  :straight (eca :host github :repo "editor-code-assistant/eca-emacs" :branch "master")
  :config
  (setq eca-extra-args '("--log-level" "debug"))
  (setq eca-extra-args '("--verbose"))
)

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
  :straight (gptel :host github :repo "karthink/gptel" :branch "master")
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
  :straight (gptel-agent :host github :repo "karthink/gptel-agent" :branch "master")
  :config
  ;; GLP SDLC marketplace: design-workflow agents and skills.
  ;; Agents dir: files are read directly (non-recursive) as agent definitions.
  (let ((glp-workflow "~/glcp/glp-sdlc-marketplace/plugins/glp-design-workflow/"))
    (when (file-directory-p glp-workflow)
      (add-to-list 'gptel-agent-dirs (expand-file-name "agents/" glp-workflow))
      ;; Skills dir: scanned recursively for */SKILL.md.
      (add-to-list 'gptel-agent-skill-dirs (expand-file-name "skills/" glp-workflow))))
  ;; Personal skills directory. Each skill is a sub-folder containing a
  ;; SKILL.md file (see https://agentskills.io).
  (add-to-list 'gptel-agent-skill-dirs "~/custom_skills/")
  (gptel-agent-update))


(use-package mcp
  :straight t
  :config
  (setq mcp-hub-servers
        `(("mcp-atlassian" . (:command "uvx"
                              :args ("mcp-atlassian")
                              :env (:JIRA_URL "https://hpe.atlassian.net/"
                                    :JIRA_USERNAME ,(getenv "JIRA_USERNAME")
                                    :JIRA_API_TOKEN ,(getenv "JIRA_API_TOKEN")
                                    :CONFLUENCE_URL "https://hpe.atlassian.net/wiki"
                                    :CONFLUENCE_USERNAME ,(getenv "CONFLUENCE_USERNAME")
                                    :CONFLUENCE_API_TOKEN ,(getenv "CONFLUENCE_API_TOKEN"))))
          ("github" . (:command "docker"
                       :args ("run"
                              "-i"
                              "--rm"
                              "-e"
                              "GITHUB_PERSONAL_ACCESS_TOKEN"
                              "-e"
                              "GITHUB_HOST"
                              "ghcr.io/github/github-mcp-server")
                       :env (:GITHUB_PERSONAL_ACCESS_TOKEN ,(getenv "GITHUB_PERSONAL_ACCESS_TOKEN")
                             :GITHUB_HOST , (or (getenv "GITHUB_HOST") "https://github.com"))))))
  (require 'gptel-integrations))
