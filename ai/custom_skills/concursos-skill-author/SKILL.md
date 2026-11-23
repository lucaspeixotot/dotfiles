---
name: concursos-skill-author
description: >
  Meta-skill: creates and reviews discipline skills (playbooks) for fiscal exams
  (RFB/SEFAZ) and control (TCU/TCE, CGU/CGE). Load when the user asks to create,
  update, or review a subject skill (SKILL.md) in ~/custom_skills/. Defines the
  template, the creation process with embedded web research, and the variation
  by type (jurídica × exatas × TI).
---

NOTE: instructions are in English for token efficiency; exam content below stays in Portuguese because the exam and the output are in Portuguese. Always answer the student in the user's language (Portuguese).

# Discipline skill author — process

This skill teaches HOW to create a subject skill (a study "playbook"), not the
subject content itself. The agent that loads it will do the creation + review
work in a single flow, writing the final file.

## 1. What a subject skill (playbook) is

A =SKILL.md= is the guide to HOW the subject is tested on the exam — NOT the
subject content (the model already masters it). It exists to:

- Prioritize higher-incidence topics.
- Calibrate the answer to the board style (Cebraspe × FGV).
- List classic pitfalls ("não confunda X com Y").
- Indicate norms/standards to VERIFY (never paste the law's content — that goes
  stale).

## 2. Mandatory template (sections)

#+begin_src
---
name: <slug-da-disciplina>
description: >  (trigger: subject + "load when the student asks for a summary or has doubts about <key-topics>")
---

# <Disciplina> — study playbook (fiscal + control)

## 1. What this skill is
   + golden rule of source currency (varies by type — see section 3)

## 2. Exam incidence (what to prioritize)
## 3. Board style (Cebraspe × FGV)
## 4. Classic pitfalls ("não confunda")
## 5. Norms/standards to verify (priority: validity/version)
## 6. Suggested summary structure (narrative spine — mandatory)
## 7. Official sources (always the most recent version)
#+end_src

Template rules:
- =description= is MANDATORY and is the trigger: name the subject and when to
  load. Without it gptel-agent ignores the skill with a warning.
- =name=: unaccented, lowercase slug, hyphens. If state-specific, include the
  state (e.g., =legislacao-tributaria-estadual-alagoas=).
- Keep it lean and durable: a playbook, not a content dump.
- No pasted law: section 5 says VERIFY, never states the content.
- Section 6 CANNOT be a flat topic list: it must deliver the subject's narrative
  spine (organizing question + main flow + conceptual axes + "não confunda"
  pairs). See section 2.1.
- The skill must follow the Agent Skills pattern (see section 2.3): lean SKILL.md
  + =references/= and =assets/= for the detail.

## 2.1 Section 6 (the subject's narrative spine)

Section 6 is what the summary agent uses to structure the text. It CANNOT be a
flat topic list. It must contain, at minimum:

1. **Organizing question** — the central question the subject answers
   (e.g., Direito Tributário = "como nasce, se constitui e se extingue a
   obrigação de pagar tributo?").
2. **Main flow(s)** — the causal/temporal chaining of the blocks
   (e.g., competência → obrigação → lançamento → crédito → prescrição/decadência).
   Expose the flow BEFORE the topics, so the student sees the map.
3. **Conceptual axes** — the structuring pairs that organize the text
   (e.g., Auditoria = "documento × escrituração"; "regularidade = financeira +
   conformidade").
4. **"não confunda" pairs** — the oppositions that must appear THROUGHOUT the
   text (not only in a final list).

Section 6 is DERIVED from sections 2–5 (incidence, board, pitfalls, norms):
do not invent a flow that does not follow from them.

## 2.2 Worked examples (by subject type)

The COMPLETE examples are in =references/exemplos-secao-6.md= — load that file
whenever you write a section 6 (progressive disclosure: the detail does not stay
in the SKILL.md). Minimum summary for quick reference:

- **Legal (Direito Tributário):** "como nasce, constitui e extingue a
  obrigação de pagar tributo?" → competência → obrigação → lançamento →
  crédito → prescrição/decadência → garantias.
- **Exact sciences (Matemática Financeira):** "como levar valores no tempo e
  comparar alternativas?" → juros → taxas → descontos → séries → amortização →
  equivalência → VPL/TIR.
- **IT (Desenvolvimento de Sistemas):** "como um software é concebido,
  construído, testado, entregue e mantido?" → requisitos → projeto →
  arquitetura → banco → implementação → testes → DevOps → gestão.

## 2.3 Agent Skills pattern (mandatory for ALL skills)

Subject skills do NOT need to condense everything into =SKILL.md=. Follow the
Agent Skills format (https://agentskills.io/specification):

```
<nome-da-skill>/
├── SKILL.md          # mandatory: frontmatter (name + description) + instructions
├── references/       # optional: documentation loaded ON DEMAND
├── assets/           # optional: templates, tables, summary boards
└── ...
```

Practical rules:

- **Lean SKILL.md** (< 500 lines): the essential to decide and structure
  (incidence, board, pitfalls, norms to verify, narrative spine).
- **Detailed material goes to =references/=** (e.g., incidence summary boards,
  transition tables, "não confunda" glossary, provision lists per topic).
  Reference by RELATIVE path from SKILL.md (e.g., "see =references/quadro-transicao.md=").
- **=assets/= for templates and static resources** (e.g., summary model, rate
  table), not for behavior instructions.
- **Progressive disclosure:** the agent loads SKILL.md when activating the skill
  and only reads =references/=/=assets/= when the task requires. Keep each
  =references/= file focused (1 subject), for cheap reading.
- This meta-skill already follows that pattern (see =references/exemplos-secao-6.md=).
  Subject skills created/revised from now on must follow the same format.

## 3. Variation of the "golden rule" by subject type

- **Legal (Direito, Auditoria, Finanças Públicas):**
  "An official source is NOT enough — a good outdated source may state as current
  something already repealed/overruled. Confirm the CURRENT wording TODAY and the
  date of the source. Verify súmulas/julgados: whether it was overruled, canceled
  or modulated; recent case law may have flipped the understanding."

- **Exact sciences (Estatística, Matemática Financeira, Economia):**
  "The greater risk is not a repealed norm, but convention/notation (amostral ×
  populacional; desconto por dentro × por fora; nominal × efetiva). Make explicit
  the convention used and follow the board's. For Economia, separate TEORIA
  (stable) from CONJUNTURA (current data)."

- **IT/Data (Ciência de Dados, IA, Desenvolvimento, Infra):**
  "The risk is terminology and versions of standards/frameworks (ITIL, COBIT, ISO,
  NIST, Scrum, PMBOK, libraries). Use established terminology; confirm the current
  version when the question depends on it. For regulations (LGPD, governo digital),
  confirm the current text."

## 4. Creation + review process (single flow)

1. Receive the subject and confirm with the user: (a) which subject/topic, (b)
   exam/board/long-term, (c) whether there is a specific state (e.g., SEFAZ AL).
2. **Research BEFORE writing** (WebSearch/WebFetch):
   - Exam incidence (most-tested topics).
   - Board style and pitfalls (classic term swaps).
   - Norms/versions CURRENT on today's date (law, súmula, case law; or
     framework/standard version).
   - What study material usually states in an OUTDATED way.
3. Write the =SKILL.md= already with the research incorporated (do not
   create-and-review in two separate passes).
4. Create the =~/custom_skills/<slug>/= directory and the =SKILL.md= file.
5. Run =gptel-agent-update= (or ask the user) and validate that the skill appears
   in =gptel-agent--skills= and in the agents' =<available_skills>=.
6. Report to the user what was created, what was verified (with dates), and any
   caveats about divergent sources.

### Structural review mode (section 6)

When the request is ONLY to rewrite section 6 of an existing skill:

- Derive the narrative spine from sections 2–5 of the skill itself (incidence,
  board, pitfalls, norms) — do not re-research the norm from scratch.
- Do a LIGHT validity check only of the norms already listed in section 5
  (spot WebSearch); if something is outdated, record a caveat in the report.
- Do NOT expand scope: in this mode, do not rewrite section 5 nor do new
  incidence research.

## 5. Quality checks before finishing

- [ ] description present and with a clear trigger.
- [ ] Incidence ordered by weight (when data exists).
- [ ] Pitfalls specific to the subject, not generic.
- [ ] Section 5 points to norms/versions to VERIFY, without pasting the content.
- [ ] Golden rule of source currency matching the type (legal/exact/IT).
- [ ] Section 6 has organizing question + main flow + conceptual axes
      + "não confunda" pairs — NOT a flat topic list.
- [ ] Agent Skills pattern respected: lean SKILL.md (< 500 lines); detail in
      =references/= and =assets/=; correct relative paths.
- [ ] Official sources and consultation date.
- [ ] If the name changed (e.g., adding a state), rename the directory and update
  =name:= without leaving a duplicate.

## 6. Canonical example

The section 6 examples are in =references/exemplos-secao-6.md= (one per subject
type). Use them as a model of form. The =direito-tributario= skill (at
=~/custom_skills/direito-tributario/SKILL.md=) serves as an additional reference
for how a complete legal skill looks — but the section 6 model is the
=references/= file, not an external skill.
