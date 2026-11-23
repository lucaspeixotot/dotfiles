---
name: agent-browser
description: >
  How to operate agent-browser (Vercel) from the Bash tool: verify the
  install, detect or open Chromium, attach to it, drive the read/act loop, and
  manage tabs. Load whenever using the browser via Bash.
---
# agent-browser — operation

Use the Bash tool to run `agent-browser` commands.

## 1. Verify the install (once per session, if needed)
    agent-browser --version
    agent-browser doctor
If "not found": the binary is not on the Emacs process PATH; tell the user.

## 2. Ensure there is a browser to attach to
Preference: ATTACH to a Chromium the user already has open (preserves login and
the current page). Do NOT launch a fresh browser unless the user allows it.

    # 1) Try the explicit CDP port first (most reliable for a user-started
    #    Chromium opened with --remote-debugging-port=9222):
    agent-browser --cdp 9222 snapshot

    # 2) If that fails (nothing on the port), ASK the user before opening one:
    #    "May I open Chromium? Run: chromium --remote-debugging-port=9222"
    #    Then retry step 1 once it is up.

    # 3) --auto-connect is a LAST RESORT: it can relaunch an EMPTY browser
    #    instead of finding the existing one. Prefer --cdp <port>.
    agent-browser --auto-connect snapshot

Once attached, the session persists; later commands can omit the flag, but
passing `--cdp 9222` on each command is the safe, explicit default.

## 3. Core loop (mandatory)
1. READ content: prefer `agent-browser read` (rendered text/Markdown of the
   DOM). It is cheaper and cleaner than a snapshot for prose.
2. FIND elements to act on: use `agent-browser snapshot -i` (lists interactive
   elements with @eN refs).
3. ACT: `agent-browser click @eN` (or fill/type/select/press).
4. RE-SNAPSHOT: after ANY action/navigation that changes the DOM, take a new
   snapshot/read. @eN refs EXPIRE after a page change.

## 4. Tabs
    agent-browser tab                     # list tabs (t1, t2, ...)
    agent-browser tab t3                  # switch to tab t3
    agent-browser click @eN --new-tab     # open a link in a new tab

## 5. Rules
- Transcribe faithfully what you read; never invent page content.
- Do NOT change the user's state without need (do not log in, do not submit
  forms, do not advance questions) unless explicitly asked.
- When targeting an element on a Portuguese site, quote the exact visible text
  between double quotes, e.g. click "Finanças Públicas - SEFAZ AL - 2026".
- Use `--session <name>` when more than one flow shares the same browser.
- In doubt about syntax: `agent-browser --help` or
  `agent-browser skills get core`.
