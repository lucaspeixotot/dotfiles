---
name: matematica-financeira
description: >
  MATEMÁTICA FINANCEIRA playbook for fiscal exams (RFB/SEFAZ) and control
  (TCU/TCE, CGU/CGE). Load when the student asks for a summary or has doubts
  about: juros simples e compostos, taxas (nominal, efetiva, equivalente, real,
  aparente), descontos (racional, comercial), séries de pagamentos
  (antecipadas/postecipadas), sistemas de amortização (Price, SAC), equivalência
  de capitais e valor presente líquido/TIR. Defines exam incidence, board
  style, pitfalls, and conventions to verify.
---

NOTE: instructions are in English for token efficiency; exam content below stays in Portuguese because the exam and the output are in Portuguese. Always answer the student in the user's language (Portuguese).

# Matemática Financeira — study playbook (fiscal + control)

## 1. What this skill is

Guide to HOW the subject is tested — not the content (the model already masters it).
Use it to prioritize topics, calibrate the answer to the board, and avoid the
classic mistakes.

**Golden rule — source currency:** in exact sciences, the greater risk is not a
repealed norm, but convention (desconto comercial × racional, exponential ×
linear convention, rates). Before solving, make explicit the CONVENTION used
and, if the board adopts another, follow theirs (sections 5 and 7).

## 2. Exam incidence (what to prioritize)

- **Juros simples × compostos**: fórmulas, diferença, convenção exponencial ×
  linear.
- **Taxas**: proporcional, nominal, efetiva, equivalente, real × aparente
  (fórmula de Fischer), acumulada.
- **Descontos**: racional (por dentro) × comercial (por fora); simples e
  composto; relação com juros.
- **Séries de pagamentos**: uniformes e variáveis; antecipadas, postecipadas,
  diferidas; montante e valor presente.
- **Sistemas de amortização**: Price (prestações constantes) × SAC (amortização
  constante) × **SAM (misto)**; saldo devedor, juros, amortização.
- **Custo real e efetivo das operações** (financiamento, empréstimo,
  investimento) e **taxas de retorno** (além de TIR).
- **Equivalência de capitais e de taxas** (atenção à **data focal**) e
  **fluxos de caixa**.
- **Valor Presente Líquido (VPL) e Taxa Interna de Retorno (TIR)** — conceito
  e decisão; **análise de investimento em ambiente inflacionário** (taxa real ×
  aparente).

## 3. Board style

- **CEBRASPE/CESPE** (TCU/TCE, parte das SEFAZ): cobra cálculo e a distinção
  conceitual; inverte o gabarito trocando "simples" × "composto", "nominal" ×
  "efetiva" × "real", "por dentro" × "por fora", "Price" × "SAC". Leia o item
  procurando a palavra trocada. **Sem calculadora**: a banca fornece tabelas de
  fatores/multiplicadores — use a tabela dada e siga o arredondamento indicado.
- **FGV** (RFB): a matemática financeira está **diluída em Raciocínio
  Lógico-Matemático** (porcentagem e juros básicos) — peso bem menor.
- **SEFAZ**: bancas variadas (FGV, FCC, Cebraspe) e disciplina plena.

## 4. Classic pitfalls ("não confunda")

- **Taxa nominal × efetiva**: a nominal tem período de capitalização diferente
  do período da taxa; converter para a efetiva correspondente.
- **Taxa proporcional × equivalente**: proporcional em juros simples;
  equivalente em compostos.
- **Desconto comercial × racional**: comercial incide sobre o valor nominal (por
  fora); racional sobre o valor atual (por dentro).
- **Juros simples × compostos**: crescimento linear × exponencial.
- **Price × SAC**: Price tem prestações iguais (juros decrescentes,
  amortização crescente); SAC tem amortização constante (prestações
  decrescentes).
- **Antecipada × postecipada**: pagamento no início × fim do período — muda o
  fator.
- **Taxa real × aparente**: não subtraia; use (1 + aparente) = (1 + real) ×
  (1 + inflação).
- **VPL × TIR**: critérios de decisão distintos; TIR tem problemas (fluxos não
  convencionais).

## 5. Conventions and formulas to verify (priority: consistency)

- **Convenção exponencial × linear** (juros compostos em períodos fracionários):
  siga a da banca/questão.
- **Desconto comercial × racional**: a questão costuma especificar; quando não,
  siga a terminologia do edital.
- **Anuidades**: início/fim de período e data focal.
- **Arredondamento e número de casas**: siga a instrução da prova.
- **Tabelas financeiras**: use os fatores fornecidos na prova, se houver.

**Minimum check (mandatory):**
- Always declare the convention used.
- If the board/edital specifies another, follow theirs and flag it.

## 6. Suggested summary structure (narrative spine)

- **Pergunta organizadora:** como levar valores no tempo de forma equivalente e
  comparar alternativas de financiamento/investimento?
- **Fluxo principal:** juros (simples → composto) → taxas (nominal/efetiva/
  equivalente/real) → descontos → séries de pagamentos → sistemas de
  amortização → equivalência de capitais → VPL/TIR.
- **Eixos conceituais:** capitalização simples × composta; taxa nominal ×
  efetiva × real; desconto racional (por dentro) × comercial (por fora);
  prestação × juros × amortização; Price × SAC.
- **Pares "não confunda":** taxa nominal × efetiva × equivalente × real ×
  aparente; taxa proporcional × equivalente; desconto racional × comercial;
  antecipada × postecipada; Price × SAC; VPL × TIR.

## 7. Reference sources (best practices)

Use established bibliography (e.g., Assaf Neto; Hazzan & Pompeo; Mathias &
Gomes) and, when the edital indicates, the specific source. Editais normally do
NOT set a bibliography — that is why section 5 (convention) matters most.

**Golden rule:** in exact sciences, error comes from convention, not from an outdated
source. Always make explicit the convention and follow the board's.
