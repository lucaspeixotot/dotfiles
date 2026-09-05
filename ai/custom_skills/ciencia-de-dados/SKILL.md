---
name: ciencia-de-dados
description: >
  Playbook de CIÊNCIA DE DADOS para concursos fiscais (RFB/SEFAZ) e de controle
  (TCU/TCE, CGU/CGE). Carregar quando o aluno pedir resumo ou tirar dúvidas
  sobre: dados estruturados/não estruturados, bancos relacionais e SQL,
  modelagem de dados, ETL/ELT, mineração de dados, detecção de anomalias,
  modelagem preditiva, aprendizado de máquina, Business Intelligence e
  visualização de dados aplicados à fiscalização tributária. Define incidência,
  estilo das bancas, pegadinhas e padrões a verificar.
---

# Ciência de Dados — playbook de estudo (fiscal + controle)

## 1. O que é esta skill

Guia de COMO a disciplina é cobrada — não o conteúdo (o modelo já o domina).
Use-o para priorizar tópicos, calibrar a resposta à banca e evitar os erros
clássicos.

**Regra de ouro — atualidade da fonte:** em TI/dados, o risco não é lei
revogada, mas terminologia e versões de padrões/ferramentas (SQL, bibliotecas,
modelos). Use definições consagradas e, quando a questão depender de versão,
confirme o contexto. Para aplicação à fiscalização, verifique os documentos
fiscais eletrônicos vigentes (seções 5 e 7).

## 2. Incidência em prova (o que priorizar)

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

## 3. Estilo por banca

- **CEBRASPE/CESPE**: cobra definições e a relação entre conceitos; inverte o
  gabarito trocando "estruturado" × "não estruturado", "supervisionado" × "não
  supervisionado", "precisão" × "recall", "OLTP" × "OLAP", "fato" × "dimensão".
  Leia o item procurando a palavra trocada.
- **FGV**: valoriza interpretação, casos aplicados e leitura de SQL/gráficos.

## 4. Pegadinhas clássicas ("não confunda")

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

## 5. Padrões e normas a verificar (prioridade: contexto e versão)

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

**Checagem mínima (obrigatória):**
- Separe conceito estável de detalhe dependente de versão/ferramenta.
- Para normativos fiscais e LGPD, anote a DATA e confirme a vigência.

## 6. Estrutura sugerida do resumo (para o agente de resumo)

1. **Dados e modelagem** (tipos, bancos relacionais, SQL, normalização,
   dimensional).
2. **Processo de ciência de dados (CRISP-DM)**.
3. **ETL/ELT e qualidade de dados**.
4. **Mineração de dados** (técnicas).
5. **Aprendizado de máquina** (tipos, treino/teste, métricas) + IA generativa.
6. **Detecção de anomalias**.
7. **BI e visualização**.
8. **Aplicação à fiscalização tributária** (cruzamento de dados fiscais).

## 7. Fontes oficiais (sempre na versão mais recente)

- Receita Federal/SEFAZ: leiautes e normativos do SPED e documentos fiscais
  eletrônicos.
- Bibliografia/consagrada para conceitos (ex.: Tan; Han, Kamber & Pei; Provost
  & Fawcett).
- Documentação oficial de bancos/ferramentas, quando aplicável.

**Regra de ouro:** fonte oficial NÃO é sinônimo de fonte atual. Para normativos
fiscais e LGPD, use a versão vigente e datada. Para conceitos, use terminologia
consagrada.
