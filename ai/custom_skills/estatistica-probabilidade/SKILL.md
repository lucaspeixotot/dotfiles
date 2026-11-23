---
name: estatistica-probabilidade
description: >
  ESTATÍSTICA E PROBABILIDADE playbook for fiscal exams (RFB/SEFAZ) and
  control (TCU/TCE, CGU/CGE). Load when the student asks for a summary or has
  doubts about: estatística descritiva (medidas de posição, dispersão e forma),
  probabilidade, variáveis aleatórias e distribuições, amostragem, inferência
  (intervalos de confiança, testes de hipóteses), regressão e correlação.
  Defines exam incidence, board style, pitfalls, and conventions to verify.
---

NOTE: instructions are in English for token efficiency; exam content below stays in Portuguese because the exam and the output are in Portuguese. Always answer the student in the user's language (Portuguese).

# Estatística e Probabilidade — study playbook (fiscal + control)

## 1. What this skill is

Guide to HOW the subject is tested — not the content (the model already masters it).
Use it to prioritize topics, calibrate the answer to the board, and avoid the
classic mistakes.

**Golden rule — source currency:** in exact sciences, the greater risk is not a
repealed norm, but convention and notation (amostral × populacional, quartile
definition, kurtosis, etc.). Before stating a formula, make explicit the
CONVENTION used and, if the board adopts another, flag it (sections 5 and 7).

## 2. Exam incidence (what to prioritize — by weight)

1. **Probabilidade** (condicional, total, Bayes, combinatória) — bloco mais pesado.
2. **Testes de hipóteses** (erros I/II, p-valor, poder, qui-quadrado, testes de
   médias) e **intervalos de confiança**.
3. **Distribuições contínuas** (normal, uniforme, exponencial, qui-quadrado,
   t de Student, F).
4. **Estatística descritiva** (posição, dispersão, forma).
5. **Regressão linear** (simples/múltipla, R², ANOVA, teste F).
6. **Distribuições discretas** (binomial, Poisson, geométrica,
   hipergeométrica).
7. **Teorema Central do Limite (TCL)** e **Lei dos Grandes Números**.
8. **Estimadores e distribuições amostrais**; **amostragem** (aleatória simples,
   estratificada, sistemática, conglomerados; fator de correção para população
   finita).
9. **Testes não paramétricos** (qui-quadrado, Wilcoxon/Mann-Whitney) — RFB.
10. **Séries temporais e modelos logit/probit** — tema de edital RFB (não
    universal para TCE/TCU/CGU).

## 3. Board style

- **CEBRASPE/CESPE**: cobra cálculo e interpretação; inverte o gabarito trocando
  "média" × "mediana", "variância" × "desvio-padrão", "populacional" ×
  "amostral" (n × n−1), "tipo I" × "tipo II". Leia o item procurando a palavra
  trocada. Desconfie de definições incompletas/trocadas e de termos absolutos.
- **FGV** (RFB/TCU): valoriza interpretação, cálculos e leitura de tabelas/
  gráficos; usa o coeficiente percentílico de curtose.

## 4. Classic pitfalls ("não confunda")

- **Variância/desvio populacional × amostral**: denominador n × n−1.
- **Média × mediana × moda**: comportamentos distintos com outliers e
  distribuições assimétricas.
- **Erro tipo I × tipo II**: rejeitar H0 verdadeira × não rejeitar H0 falsa;
  nível de significância × poder.
- **Correlação × causalidade**: correlação alta não implica causa.
- **Independência × correlação**: independência implica correlação zero, mas o
  inverso não vale.
- **Quartis**: há convenções diferentes de cálculo — confirme a definição usada
  pela banca/matéria.
- **Binomial × Poisson × normal**: condições de aplicação distintas.
- **R²**: proporção da variância explicada; não é o coeficiente de correlação.
- **TCL × consistência de estimadores**: o TCL trata da distribuição da média
  amostral; a consistência é propriedade do estimador (a variância amostral com
  n−1 é não viesada/consistente). Não confunda.

## 5. Conventions and formulas to verify (priority: consistency)

In exact sciences, there is no "repealed law", but there are conventions that change the result:

- **Populacional × amostral**: deixe explícito o denominador (n ou n−1) e siga
  a convenção do edital/banca.
- **Quartis e percentis**: confirme o método (ex.: inclusivo/exclusivo) quando
  a questão pedir.
- **Curtose**: três convenções — excesso (0 = mesocúrtica) × coeficiente por
  momentos (3 = mesocúrtica) × **coeficiente percentílico** (0,263 = mesocúrtica,
  usado pela FGV). Especifique qual usar.
- **Quartis**: métodos inclusivo/exclusivo e **Tukey (bigodes)** — confirme o
  método pedido.
- **Aproximação normal da binomial**: condições e correção de continuidade.
- **Tabelas**: distribuição normal padrão, t de Student, qui-quadrado — use os
  valores da tabela fornecida na prova, se houver.

**Minimum check (mandatory):**
- Always declare the convention/notation used when presenting a formula.
- If the board/edital specifies another convention, follow theirs and flag it.

## 6. Suggested summary structure (narrative spine)

- **Pergunta organizadora:** como descrever um conjunto de dados, quantificar a
  incerteza e generalizar da amostra para a população (inferir) com erro
  controlado?
- **Fluxo principal:** descrição (posição → dispersão → forma) → probabilidade
  (condicional, total, Bayes) → variáveis aleatórias e distribuições (discreta
  → contínua) → amostragem → estimação (pontual → por intervalo) → testes de
  hipóteses → regressão e correlação.
- **Eixos conceituais:** descrição × inferência; população × amostra; estimação
  pontual × intervalar; distribuição discreta × contínua.
- **Pares "não confunda":** média × mediana × moda; variância × desvio-padrão;
  denominador n × n−1; erro tipo I × tipo II; correlação × causalidade;
  independência × correlação; R² × coeficiente de correlação; TCL × consistência
  do estimador.

## 7. Reference sources (best practices)

For exact sciences, use established academic/technical sources and, when the
edital indicates, specific bibliography. Usual references:
- Bussab & Morettin — "Estatística Básica" (9ª ed., 2017).
- Magalhães & Lima — "Noções de Probabilidade e Estatística" (7ª ed., 2015).
- Montgomery & Runger — "Estatística Aplicada e Probabilidade para Engenheiros".

There is no single "official text" — that is why section 5 (convention) matters most.

**Golden rule:** in exact sciences, error comes from convention/notation, not from an
outdated source. Always make explicit the convention used and follow the board's when
there is one.
