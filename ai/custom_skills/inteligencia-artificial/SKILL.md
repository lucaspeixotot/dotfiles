---
name: inteligencia-artificial
description: >
  INTELIGÊNCIA ARTIFICIAL playbook for fiscal exams (RFB/SEFAZ) and control
  (TCU/TCE, CGU/CGE). Load when the student asks for a summary or has doubts
  about: conceitos e histórico de IA, aprendizado de máquina, redes neurais,
  deep learning, processamento de linguagem natural, visão computacional, IA
  generativa, ética e regulação de IA, e aplicações na administração
  tributária. Defines exam incidence, board style, pitfalls, and norms to
  verify.
---

NOTE: instructions are in English for token efficiency; exam content below stays in Portuguese because the exam and the output are in Portuguese. Always answer the student in the user's language (Portuguese).

# Inteligência Artificial — study playbook (fiscal + control)

## 1. What this skill is

Guide to HOW the subject is tested — not the content (the model already masters it).
Use it to prioritize topics, calibrate the answer to the board, and avoid the
classic mistakes.

**Golden rule — source currency:** in AI, the greater risk is terminology and the
state of regulation (changes fast in Brazil and worldwide). Use established
concepts and, for regulation/ethics, confirm the norm CURRENT TODAY and the date
of the source (sections 5 and 7).

## 2. Exam incidence (what to prioritize)

- **Conceitos e histórico**: IA forte × fraca (geral × estreita), símbolista ×
  conexionista, aprendizado de máquina como subárea.
- **Aprendizado de máquina**: supervisionado × não supervisionado × por
  reforço; treino/validação/teste; overfitting/underfitting; métricas.
- **Redes neurais e deep learning**: neurônio, camadas, ativação,
  backpropagation; CNNs (visão), RNNs/LSTMs (sequências), transformers.
- **Processamento de linguagem natural (PLN)**: tokenização, embeddings,
  LLMs, aplicações.
- **Visão computacional**: reconhecimento de imagem, OCR.
- **IA generativa**: LLMs, modelos de difusão, GANs; alucinação; **agentes de IA
  (IA agêntica)** e modelos de raciocínio (fronteira emergente).
- **Percepção × ação**: percepção = captar/interpretar o ambiente (sensores,
  visão); ação = provocar mudanças no ambiente.
- **Ética e regulação**: vieses, explicabilidade, transparência, responsabilidade;
  regulação de IA (Brasil: PL 2338/2023 + PL 6237/2025/SIA; ANPD; LGPD art. 20).
- **Aplicações na administração tributária**: classificação de contribuintes,
  detecção de fraude, análise de risco, atendimento automatizado.

## 3. Board style

- **CEBRASPE/CESPE**: cobra definições e hierarquia de conceitos; inverte o
  gabarito trocando "forte" × "fraca", "supervisionado" × "não supervisionado",
  "discriminativo" × "generativo", "precisão" × "recall". Leia o item procurando
  a palavra trocada.
- **FGV**: valoriza interpretação, casos de aplicação e ética/regulação.

## 4. Classic pitfalls ("não confunda")

- **IA forte × fraca**: geral (consciência) × específica (tarefa restrita).
- **Aprendizado de máquina × IA × deep learning**: hierarquia (ML ⊂ IA; deep
  learning ⊂ ML).
- **Supervisionado × não supervisionado × reforço**: rotulados × não rotulados ×
  recompensa.
- **Discriminativo × generativo**: modela fronteira × modela distribuição dos
  dados.
- **Overfitting × underfitting**: alta variância × alto viés.
- **Precisão × recall × acurácia**: métricas distintas.
- **LLM × PLN × IA generativa**: subconjuntos e sobreposições — não tratar como
  sinônimos.
- **ML × mineração de dados**: não são sinônimos (mineração = descoberta de
  padrões; ML = modelos que aprendem e preveem).
- **Percepção × ação**: percepção capta/interpreta; ação provoca mudanças.
- **Tipos de aprendizado**: "autônomo"/"gerenciado" **não existem** como
  categorias formais de ML.
- **Alucinação**: LLM pode gerar conteúdo plausível mas falso; não confundir com
  erro de código.

## 5. Norms and regulation to verify (priority: validity and currency)

Do not state the content without verifying the CURRENT wording TODAY and the DATE of the source:

- **Marco Legal de IA**: **PL 2338/2023** (aprovado no Senado, na Câmara;
  **NÃO sancionado** até meados de 2026 — confirme antes de afirmar que é lei).
- **PL 6237/2025** (projeto do Executivo): cria o **SIA** (Sistema Nacional de
  IA) e posiciona a **ANPD como coordenadora** (corrige vício de iniciativa do
  PL 2338/2023).
- **ANPD (já atuante)**: sandbox regulatório de IA; **Mapa de Temas Prioritários
  2026-2027** (IA como eixo); fiscalizações (Meta, World/Worldcoin).
- **LGPD art. 20** (revisão de decisões automatizadas) — em vigor; ver redação
  (o veto da Lei 13.853/2019 retirou a exigência de revisão "por pessoa
  natural").
- **Regulação internacional**: EU AI Act (Reg. UE 2024/1689), com 4 níveis de
  risco; o PL brasileiro prevê **3 níveis** (excessivo, alto, demais) — não
  confundir.

**Minimum currency check (mandatory):**
- Regulatory AI changes fast: note the DATE of the consultation and the state of the norm
  (in progress, approved, in force).
- Distrust texts about the "Marco Legal de IA" without checking the current phase.

## 6. Suggested summary structure (for the summary agent)

- **Pergunta organizadora:** como máquinas aprendem a partir de dados e o que
  isso muda para a administração tributária, sob que limites éticos e
  regulatórios?
- **Fluxo principal:** conceitos e histórico (forte × fraca, simbólica ×
  conexionista) → aprendizado de máquina (supervisionado × não supervisionado
  × reforço; treino/validação/teste; métricas; viés × variância) → redes
  neurais e deep learning (CNN, RNN/LSTM, transformers) → PLN e visão
  computacional (percepção) → IA generativa, LLMs e agentes → ética e
  regulação → aplicações na administração tributária.
- **Eixos conceituais:** IA forte × fraca; hierarquia ML ⊂ IA e deep learning
  ⊂ ML; paradigmas de aprendizado (supervisionado × não supervisionado ×
  reforço); percepção × ação.
- **Pares "não confunda":** discriminativo × generativo; overfitting ×
  underfitting; precisão × recall × acurácia; LLM × PLN × IA generativa; ML ×
  mineração de dados; alucinação × erro de código.

## 7. Official sources (always the most recent version)

- Planalto/Congresso: texto do Marco Legal de IA e tramitação (planalto.gov.br,
  camara.leg.br, senado.leg.br).
- ANPD: orientações sobre IA e LGPD (gov.br/anpd).
- Bibliografia consagrada para conceitos (ex.: Russell & Norvig; Goodfellow).

**Golden rule:** an official source is NOT synonymous with a current source. For regulation,
use the current, dated version. For concepts, use established terminology.
