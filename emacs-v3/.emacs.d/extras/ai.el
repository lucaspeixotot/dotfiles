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

(use-package gptel
  :straight (gptel :host github :repo "karthink/gptel" :branch "master")
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
  )

(use-package gptel-agent
  :straight (gptel-agent :host github :repo "karthink/gptel-agent" :branch "master")
  :config
  (advice-add 'gptel-agent--fontify-block :override 'ignore)
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
  ;; Personal agents directory (files read non-recursively). Skip if absent.
  (when (file-directory-p "~/custom_agents/")
    (add-to-list 'gptel-agent-dirs "~/custom_agents/"))
  (gptel-agent-update)
  ;; Register personal agents as gptel presets so they can be used directly
  ;; (via gptel-menu or the @name cookie). Skip if missing.
  (dolist (agent-name '("concursos-tutor"
                        "concursos-resumo"
                        "concursos-skillmaker"
                        "english-refine"))
    (when-let* ((agent (assoc-default agent-name gptel-agent--agents nil nil)))
      (apply #'gptel-make-preset (intern agent-name) agent)))
  )


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

;; Straight
(use-package gptel-inline
  :straight (:host github :repo "karthink/gptel-inline")
  :after gptel
  :bind
  (("C-c a i" . gptel-inline)))
