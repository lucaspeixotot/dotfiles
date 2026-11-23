---
name: browser-nav-tec-concursos
description: >
  How to navigate Tec Concursos (question platform) with agent-browser: read
  the question, detect the answer state (answered/unanswered, right/wrong),
  open the professor solution and student discussion, and browse the study
  folders/cadernos. Load when using the browser on Tec Concursos.
---
# Tec Concursos — navigation

The site is in Portuguese. Quote exact on-screen text in double quotes.
Login is required: the session must already be authenticated; do NOT log in.

## 1. Reading a question
1. Attach to the browser (see skill =agent-browser=).
2. Read the page:
   agent-browser read
   If the statement is truncated or you need clickable elements:
   agent-browser snapshot -i

## 2. Detecting the answer state (always check and report it)
- UNANSWERED: the answer radios are unchecked (snapshot shows `checked=false`)
  and the button "RESOLVER QUESTÃO" is disabled.
- ANSWERED: a radio shows `checked=true` AND `read` contains the result line:
  "Você selecionou: <chosen>, alternativa <incorreta|correta>, a correta é: <key>"
  From that line you get: what the user chose, whether it was right/wrong, and
  the official answer key.

## 3. Professor solution
- Open: click the button "Comentário da questao" (note the missing accent on
  "questão" — it is "questao" on screen), or press the shortcut `o`.
- The panel is titled "Comentário do professor" and has sub-tabs
  "Comentário em Texto" / "Comentário em Vídeo" / "Pedir Comentário de IA".
- Read with: agent-browser read
- Close with the "FECHAR" button if you need to read the statement again.

## 4. Student discussion
- Open: click "Fórum de discussão da questão" (balloon icon + counter), or
  press the shortcut `f`.
- Posts show: author, date, points, and body. Sort options: "Data", "Pontos",
  "Usuário", "Meus votos".
- FILTER the noise:
  - Skip "Este comentário foi removido por violar os termos de uso do fórum de
    questões."
  - Skip "Este post está oculto porque você silenciou <user>. Exibir"
  - Some posts only vent or are conceptually wrong; treat points as a PRIORITY
    HINT, not proof of correctness. Cross-check against the law and the
    professor solution.
- Read with: agent-browser read

## 5. Other question-page controls (keyboard shortcuts)
- Professor: `o` · Student forum: `f` · Theory: `t` · Question info: `i`
- Performance: `h` · Reading mode: `k` · Previous: `←` · Next: `→`
- Resolve (submit): `Enter` — DO NOT press.

## 6. Browsing folders and cadernos
1. Open "Minhas pastas" (or go to /questoes/pastas).
2. Folders are listed with their caderno counts. The SEFAZ AL folder is:
   "Auditor Fiscal da Administração Tributária Estadual (SEFAZ AL)/2026"
   (19 cadernos) → /questoes/pastas/7529056
   ⚠ There is also a folder "Sefaz/AL" with 0 cadernos — NOT the right one.
3. Click a folder to list its cadernos; click a caderno to open it.
   Caderno URL pattern: /questoes/cadernos/<id>
   Example: "Finanças Públicas - SEFAZ AL - 2026" → /questoes/cadernos/102504296

## 7. Limits
- Do NOT click "Próxima questão" / "Questão anterior", do NOT resolve, do NOT
  change the student's progress — advancing is the user's job.
- If a section is behind login/paywall and you cannot read it, say so.
