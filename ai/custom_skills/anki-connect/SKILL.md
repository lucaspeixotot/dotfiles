---
name: anki-connect
description: >
  How to read the card currently shown on the Anki desktop review screen via
  AnkiConnect (the local HTTP API on 127.0.0.1:8765, already used by
  anki-editor). Covers the request format, guiCurrentCard/cardsInfo/deckNames,
  and the read-only limit (never answer/rate/advance cards). Load when reading
  Anki cards from an agent.
---
# AnkiConnect — reading the current card (read-only)

## 1. Endpoint and request format
- Base URL: =http://127.0.0.1:8765=.
- Requests are JSON POST bodies: ={"action": "...", "version": 6}=, optionally
  with ="params"=.
- Send via Bash/curl (the agent has Bash). Example pattern:
  curl -s http://127.0.0.1:8765 -d '{"action":"ACTION","version":6,...}'
- The result is JSON: ={"result": ..., "error": null}=. If ="error"= is not
  null, read it and report.

## 2. Reading the card being reviewed
Action =guiCurrentCard= (no params) returns the card on the review screen:
- =result.cardId=, =result.deckName=, =result.modelName= (Basic/Cloze).
- =result.question= — the FRONT as rendered (HTML).
- =result.answer= — the BACK as rendered (HTML).
- =result.fields= — the raw note fields (for Cloze, fields."Text".value holds
  the {{cN::...}} source; for Basic, the Front/Back fields).

Strip HTML tags to get the plain text; decode =\\uXXXX= escapes. For a Cloze,
the =fields."Text".value= already shows the {{c1::...}} markers, which reveal
what is being asked to recall.

## 3. When the card is empty / not on screen
If =guiCurrentCard= returns =result= as =null= (no card), tell the student to
open/start a review card in Anki first.

## 4. Other read-only helpers (as needed)
- =deckNames= — list decks.
- =cardsInfo= with params ={"cards": [id], "includeFields": true}= — fetch
  fields for a known card id (when you only have the id, not the current card).
- =findNotes=, =notesInfo= — search notes (rarely needed; prefer guiCurrentCard).

## 5. Strict read-only limit
- NEVER call =guiAnswerCard=, =answerCards=, =guiUndo=, =forgetCards=, or any
  action that rates, answers, advances, deletes, or modifies cards/scheduling.
- This skill is for READING the card; the student answers it themselves in
  Anki. The agent must not change review state.
