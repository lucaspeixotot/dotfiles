---
name: desenvolvimento-de-sistemas
description: >
  Playbook de DESENVOLVIMENTO DE SISTEMAS para concursos fiscais (RFB/SEFAZ) e
  de controle (TCU/TCE, CGU/CGE). Carregar quando o aluno pedir resumo ou tirar
  dúvidas sobre: ciclo de vida de software, metodologias (ágeis, Scrum, Kanban,
  cascata), engenharia de requisitos, análise e projeto orientado a objetos
  (UML), padrões de projeto, arquitetura (microsserviços, APIs, REST),
  bancos de dados, testes, DevOps/CI-CD e gestão de projetos. Define
  incidência, estilo das bancas, pegadinhas e padrões a verificar.
---

# Desenvolvimento de Sistemas — playbook de estudo (fiscal + controle)

## 1. O que é esta skill

Guia de COMO a disciplina é cobrada — não o conteúdo (o modelo já o domina).
Use-o para priorizar tópicos, calibrar a resposta à banca e evitar os erros
clássicos.

**Regra de ouro — atualidade da fonte:** em engenharia de software, o risco é
terminologia e versões de padrões/frameworks. Use conceitos consagrados e,
quando a questão depender de uma tecnologia específica, confirme o contexto.
Para normativos (governo digital, LGPD), verifique o texto vigente (seções 5 e 7).

## 2. Incidência em prova (o que priorizar)

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

## 3. Estilo por banca

- **CEBRASPE/CESPE**: cobra definições e papéis/artefatos; inverte o gabarito
  trocando "funcional" × "não funcional", "classe" × "objeto", "Scrum Master" ×
  "Product Owner", "monolítica" × "microsserviços", "caixa-preta" ×
  "caixa-branca". Leia o item procurando a palavra trocada.
- **FGV**: valoriza interpretação, casos práticos e UML/metodologias.

## 4. Pegadinhas clássicas ("não confunda")

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

## 5. Padrões e normas a verificar (prioridade: contexto e versão)

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

**Checagem mínima (obrigatória):**
- Separe conceito estável de detalhe dependente de versão/ferramenta.
- Para normativos e frameworks versionados (Scrum Guide, PMBOK), anote a edição
  e confirme a vigente.

## 6. Estrutura sugerida do resumo (para o agente de resumo)

1. **Ciclo de vida e metodologias** (cascata, ágeis, Scrum, Kanban).
2. **Engenharia de requisitos**.
3. **Análise e projeto** (UML, orientação a objetos).
4. **Arquitetura e APIs** (monolítica, microsserviços, REST/SOAP).
5. **Bancos de dados**.
6. **Testes**.
7. **DevOps e CI/CD**.
8. **Gestão de projetos** (PMBOK).

## 7. Fontes oficiais (sempre na versão mais recente)

- Scrum Guide (scrumguides.org) — edição vigente.
- PMI (pmi.org) — PMBOK na edição vigente.
- Documentação oficial de tecnologias/frameworks, quando aplicável.
- Planalto/ANPD — LGPD e normativos de governo digital, quando aplicável.

**Regra de ouro:** fonte oficial NÃO é sinônimo de fonte atual. Para frameworks
versionados, use a edição vigente. Para conceitos, use terminologia consagrada.
