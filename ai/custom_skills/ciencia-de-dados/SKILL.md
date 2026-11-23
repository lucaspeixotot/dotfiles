---
name: ciencia-de-dados
description: >
  CIÊNCIA DE DADOS playbook for fiscal exams (RFB/SEFAZ) and control
  (TCU/TCE, CGU/CGE). Load when the student asks for a summary or has doubts
  about: dados estruturados/não estruturados, bancos relacionais e SQL,
  modelagem de dados, ETL/ELT, mineração de dados, detecção de anomalias,
  modelagem preditiva, aprendizado de máquina, Business Intelligence e
  visualização de dados aplicados à fiscalização tributária. Defines exam
  incidence, board style, pitfalls, and standards to verify.
---

NOTE: instructions are in English for token efficiency; exam content below stays in Portuguese because the exam and the output are in Portuguese. Always answer the student in the user's language (Portuguese).

# Ciência de Dados — study playbook (fiscal + control)

## 1. What this skill is

Guide to HOW the subject is tested — not the content (the model already masters it).
Use it to prioritize topics, calibrate the answer to the board, and avoid the
classic mistakes.

**Golden rule — source currency:** in IT/data, the risk is not repealed law, but
terminology and versions of standards/tools (SQL, libraries, models). Use
established definitions and, when the question depends on a version, confirm the
context. For fiscal application, verify the current electronic fiscal documents
(sections 5 and 7).

## 2. Exam incidence (what to prioritize)

- **Dados estruturados × semiestruturados × não estruturados**.
- **Bancos relacionais e SQL**: SELECT (JOIN, GROUP BY, HAVING, subconsultas),
  normalização, chaves, índices; integridade.
- **Modelagem de dados**: conceitual (entidade-relacionamento), lógica,
  física; dimensões e fatos (modelagem dimensional, star/snowflake).
- **ETL/ELT**: extração, transformação, carga; qualidade de dados.
- **Mineração de dados**: classificação, regressão, associação, agrupamento
  (clustering).
- **Aprendizado de máquina**: supervisionado × não supervisionado × por
  reforço; treino/teste; overfitting/underfitting; métricas (acurácia,
  precisão, recall, F1).
- **IA generativa, LLMs, GANs e deep learning**: crescente em prova — ver
  também o playbook de Inteligência Artificial.
- **Processo/ciclo de vida de ciência de dados (CRISP-DM)**: entendimento do
  negócio → entendimento dos dados → preparação → modelagem → avaliação →
  implantação.
- **Detecção de anomalias/outliers**: técnicas e aplicação.
- **Business Intelligence e visualização**: dashboards, KPIs, análise descritiva
  × diagnóstica × preditiva × prescritiva.
- **Aplicação à fiscalização**: cruzamento de documentos fiscais eletrônicos
  (NF-e, EFD ICMS/IPI, SPED, CT-e, MDF-e), omissão de receita, divergências,
  créditos indevidos.

## 3. Board style

- **CEBRASPE/CESPE**: cobra definições e a relação entre conceitos; inverte o
  gabarito trocando "estruturado" × "não estruturado", "supervisionado" × "não
  supervisionado", "precisão" × "recall", "OLTP" × "OLAP", "fato" × "dimensão".
  Leia o item procurando a palavra trocada.
- **FGV**: valoriza interpretação, casos aplicados e leitura de SQL/gráficos.

## 4. Classic pitfalls ("não confunda")

- **Supervisionado × não supervisionado**: rotulados × não rotulados.
- **Classificação × regressão**: saída categórica × numérica.
- **Precisão × recall × acurácia**: métricas distintas (especialmente com
  classes desbalanceadas).
- **Overfitting × underfitting**: alta variância × alto viés.
- **OLTP × OLAP**: transacional × analítico; normalização × desnormalização.
- **Modelo estrela (star) × floco de neve (snowflake)**: granularidade das
  dimensões.
- **ETL × ELT**: ordem de transformação e carga.
- **Dado × informação × conhecimento**: níveis distintos.
- **Ciência de Dados × ML × IA**: IA é o gênero; ML é conjunto de técnicas;
  ciência de dados usa ambos para extrair insights — hierarquia cobrada.
- **IA generativa × supervisionado**: a generativa apoia-se em aprendizado
  **não supervisionado/auto-supervisionado**, não no supervisionado clássico.
- **GAN**: rede **adversária generativa** — duas redes (gerador × discriminador)
  competindo.
- **KNN**: supervisionado, **não paramétrico**, serve para classificação **E**
  regressão.
- **Cruzamento fiscal**: cada documento eletrônico tem função específica
  (NF-e, EFD, CT-e, MDF-e) — não confunda.

## 5. Standards and norms to verify (priority: context and version)

- **SQL**: siga o dialeto/banco indicado na questão (quando houver); senão, use
  SQL padrão e avise se o dialeto importa.
- **Bibliotecas/ferramentas** (Pandas, scikit-learn, Power BI, etc.): use
  terminologia consagrada; se a questão depender de versão, confirme.
- **Documentos fiscais eletrônicos** (SPED, NF-e, EFD ICMS/IPI, CT-e, MDF-e):
  verifique os leiautes e normativos vigentes na Receita/SEFAZ. Desde 2026 há
  transição da Reforma Tributária: **EFD ICMS/IPI versão 020** (Ato COTEPE/ICMS
  79/2025, vigência 01/01/2026); NF-e com campos de IBS/CBS; em 2026 os valores
  de IBS/CBS/IS **não compõem o VL_DOC** (regra do ano de transição). A EFD
  ICMS/IPI **não serve** para apurar IBS/CBS/IS.
- **LGPD** (Lei 13.709/2018): núcleo da lei estável; o que evolui são os
  **regulamentos da ANPD** (transferência internacional — Res. 19/2024;
  dosimetria — Res. 4/2023; incidentes — Res. 15/2024) e a interseção LGPD × IA.

**Minimum check (mandatory):**
- Separate stable concept from version/tool-dependent detail.
- For fiscal regulations and LGPD, note the DATE and confirm validity.

## 6. Suggested summary structure (for the summary agent)

1. **Dados e modelagem** (tipos, bancos relacionais, SQL, normalização,
   dimensional).
2. **Processo de ciência de dados (CRISP-DM)**.
3. **ETL/ELT e qualidade de dados**.
4. **Mineração de dados** (técnicas).
5. **Aprendizado de máquina** (tipos, treino/teste, métricas) + IA generativa.
6. **Detecção de anomalias**.
7. **BI e visualização**.
8. **Aplicação à fiscalização tributária** (cruzamento de dados fiscais).

## 7. Official sources (always the most recent version)

- Receita Federal/SEFAZ: leiautes e normativos do SPED e documentos fiscais
  eletrônicos.
- Bibliografia/consagrada para conceitos (ex.: Tan; Han, Kamber & Pei; Provost
  & Fawcett).
- Documentação oficial de bancos/ferramentas, quando aplicável.

**Golden rule:** an official source is NOT synonymous with a current source. For fiscal
regulations and LGPD, use the current, dated version. For concepts, use established
terminology.
