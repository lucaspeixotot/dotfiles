---
name: desenvolvimento-de-sistemas
description: >
  DESENVOLVIMENTO DE SISTEMAS playbook for fiscal exams (RFB/SEFAZ) and control
  (TCU/TCE, CGU/CGE). Load when the student asks for a summary or has doubts
  about: ciclo de vida de software, metodologias (ágeis, Scrum, Kanban,
  cascata), engenharia de requisitos, análise e projeto orientado a objetos
  (UML), padrões de projeto, arquitetura (microsserviços, APIs, REST), bancos
  de dados, testes, DevOps/CI-CD e gestão de projetos. Defines exam incidence,
  board style, pitfalls, and standards to verify.
---

NOTE: instructions are in English for token efficiency; exam content below stays in Portuguese because the exam and the output are in Portuguese. Always answer the student in the user's language (Portuguese).

# Desenvolvimento de Sistemas — study playbook (fiscal + control)

## 1. What this skill is

Guide to HOW the subject is tested — not the content (the model already masters it).
Use it to prioritize topics, calibrate the answer to the board, and avoid the
classic mistakes.

**Golden rule — source currency:** in software engineering, the risk is
terminology and versions of standards/frameworks. Use established concepts and,
when the question depends on a specific technology, confirm the context. For
regulations (digital government, LGPD), verify the current text (sections 5 and 7).

## 2. Exam incidence (what to prioritize)

- **Ciclo de vida e metodologias**: cascata × ágil; Scrum (accountabilities,
  artefatos e seus commitments, eventos), Kanban, XP; manifesto ágil.
  Terminologia do Scrum Guide 2020: "accountabilities" (não "papéis") e
  "commitments" dos artefatos (Product Goal, Sprint Goal, Definition of Done).
- **Engenharia de requisitos**: funcionais × não funcionais; elicitação,
  análise, validação.
- **Análise e projeto**: UML (casos de uso, classes, sequência, atividades),
  análise estruturada × orientada a objetos.
- **Arquitetura**: monolítica × microsserviços; SOA; APIs (REST, SOAP), padrões
  (MVC, camadas).
- **Bancos de dados**: modelagem, SQL, normalização; relacional × NoSQL.
- **Testes**: unitário, integração, sistema, aceitação; TDD; caixa-preta ×
  caixa-branca.
- **DevOps e integração/entrega contínua (CI/CD)**: pipeline, versionamento
  (Git), automação.
- **Gestão de projetos**: PMBOK (áreas, processos), escopo, cronograma, risco.

## 3. Board style

- **CEBRASPE/CESPE**: cobra definições e papéis/artefatos; inverte o gabarito
  trocando "funcional" × "não funcional", "classe" × "objeto", "Scrum Master" ×
  "Product Owner", "monolítica" × "microsserviços", "caixa-preta" ×
  "caixa-branca". Leia o item procurando a palavra trocada.
- **FGV**: valoriza interpretação, casos práticos e UML/metodologias.

## 4. Classic pitfalls ("não confunda")

- **Requisito funcional × não funcional**: o que o sistema faz × como se
  comporta (desempenho, segurança, usabilidade).
- **Classe × objeto**: classe é abstração/modelo; objeto é instância.
- **Agregação × composição**: vínculo fraco × forte (ciclo de vida).
- **Scrum Master × Product Owner**: remove impedimentos × prioriza o backlog.
- **Cascata × ágil**: sequencial/preditivo × iterativo/incremental.
- **Caixa-preta × caixa-branca**: testa comportamento × testa estrutura interna.
- **REST × SOAP**: estilos distintos de serviço.
- **Monolítico × microsserviços**: implantação e acoplamento distintos.
- **Validação × verificação**: construir o produto certo × construir certo o
  produto.

## 5. Standards and norms to verify (priority: context and version)

- **UML**: use a versão/notação consagrada (casos de uso, classes, sequência).
- **Scrum**: vigente é o **Scrum Guide nov/2020**. O "Expansion Pack 2025" é
  complemento e **não cai em prova** — não confundir com nova edição.
- **PMBOK**: vigente é a **8ª edição (nov/2025)** — 6 princípios, 7 domínios de
  desempenho (Governança, Escopo, Cronograma, Finanças, Partes Interessadas,
  Recursos, Risco) e 40 processos em 5 áreas de foco. Não use a 7ª edição como
  vigente.
- **Governo digital**: **Lei 14.129/2021** (base); **Decreto 12.069/2024**
  (Estratégia Nacional de Governo Digital 2024–2027 + Rede Gov.br) e
  **Decreto 12.198/2024** (Estratégia Federal de Governo Digital).
- **LGPD/ANPD**: lei sem alteração de mérito; regulamentos ANPD relevantes —
  **Res. 15/2024** (comunicação de incidentes), **Res. 19/2024** (transferência
  internacional), **Res. 32/2026** (UE como país adequado). Aplicar
  privacy by design/by default.

**Minimum check (mandatory):**
- Separate stable concept from version/tool-dependent detail.
- For regulations and versioned frameworks (Scrum Guide, PMBOK), note the edition
  and confirm the current one.

## 6. Suggested summary structure (for the summary agent)

- **Pergunta organizadora:** como um software é concebido, construído, testado,
  entregue e mantido, e como se organiza o trabalho para isso?
- **Fluxo principal:** requisitos → análise e projeto (UML, orientação a
  objetos) → arquitetura (monolítica × microsserviços, APIs REST/SOAP) →
  banco de dados → implementação → testes → DevOps/CI-CD → gestão de projetos
  (PMBOK), atravessado pela escolha de metodologia (cascata × ágil).
- **Eixos conceituais:** metodologias (cascata × ágil; Scrum × Kanban);
  análise estruturada × orientada a objetos; arquitetura monolítica ×
  microsserviços; testes (unitário × integração × sistema × aceitação;
  caixa-preta × caixa-branca).
- **Pares "não confunda":** requisito funcional × não funcional; classe ×
  objeto; agregação × composição; verificação × validação; Scrum Master ×
  Product Owner; REST × SOAP.

## 7. Official sources (always the most recent version)

- Scrum Guide (scrumguides.org) — edição vigente.
- PMI (pmi.org) — PMBOK na edição vigente.
- Documentação oficial de tecnologias/frameworks, quando aplicável.
- Planalto/ANPD — LGPD e normativos de governo digital, quando aplicável.

**Golden rule:** an official source is NOT synonymous with a current source. For versioned
frameworks, use the current edition. For concepts, use established terminology.
