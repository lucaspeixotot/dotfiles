---
name: inteligencia-artificial
description: >
  Playbook de INTELIGÊNCIA ARTIFICIAL para concursos fiscais (RFB/SEFAZ) e de
  controle (TCU/TCE, CGU/CGE). Carregar quando o aluno pedir resumo ou tirar
  dúvidas sobre: conceitos e histórico de IA, aprendizado de máquina, redes
  neurais, deep learning, processamento de linguagem natural, visão
  computacional, IA generativa, ética e regulação de IA, e aplicações na
  administração tributária. Define incidência, estilo das bancas, pegadinhas e
  normas a verificar.
---

# Inteligência Artificial — playbook de estudo (fiscal + controle)

## 1. O que é esta skill

Guia de COMO a disciplina é cobrada — não o conteúdo (o modelo já o domina).
Use-o para priorizar tópicos, calibrar a resposta à banca e evitar os erros
clássicos.

**Regra de ouro — atualidade da fonte:** em IA, o risco maior é terminologia e
o estado da regulação (muda rápido no Brasil e no mundo). Use conceitos
consagrados e, para regulação/ética, confirme o normativo VIGENTE HOJE e a data
da fonte (seções 5 e 7).

## 2. Incidência em prova (o que priorizar)

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

## 3. Estilo por banca

- **CEBRASPE/CESPE**: cobra definições e hierarquia de conceitos; inverte o
  gabarito trocando "forte" × "fraca", "supervisionado" × "não supervisionado",
  "discriminativo" × "generativo", "precisão" × "recall". Leia o item procurando
  a palavra trocada.
- **FGV**: valoriza interpretação, casos de aplicação e ética/regulação.

## 4. Pegadinhas clássicas ("não confunda")

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

## 5. Normas e regulação a verificar (prioridade: vigência e atualidade)

Não afirme o teor sem verificar a REDAÇÃO VIGENTE HOJE e a DATA da fonte:

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

**Checagem mínima de atualidade (obrigatória):**
- IA regulatória muda rápido: anote a DATA da consulta e o estado da norma
  (tramitando, aprovada, em vigor).
- Desconfie de textos sobre "Marco Legal de IA" sem conferir a fase atual.

**Checagem mínima de atualidade (obrigatória):**
- IA regulatória muda rápido: anote a DATA da consulta e o estado da norma
  (tramitando, aprovada, em vigor).
- Desconfie de textos sobre "Marco Legal de IA" sem conferir a fase atual.

## 6. Estrutura sugerida do resumo (para o agente de resumo)

1. **Conceitos e histórico** (forte/fraca, simbólica/conexionista).
2. **Aprendizado de máquina** (tipos, métricas, viés/variância).
3. **Redes neurais e deep learning**.
4. **PLN e visão computacional**.
5. **IA generativa e LLMs**.
6. **Ética e regulação** (Brasil e LGPD).
7. **Aplicações na administração tributária**.

## 7. Fontes oficiais (sempre na versão mais recente)

- Planalto/Congresso: texto do Marco Legal de IA e tramitação (planalto.gov.br,
  camara.leg.br, senado.leg.br).
- ANPD: orientações sobre IA e LGPD (gov.br/anpd).
- Bibliografia consagrada para conceitos (ex.: Russell & Norvig; Goodfellow).

**Regra de ouro:** fonte oficial NÃO é sinônimo de fonte atual. Para regulação,
use a versão vigente e datada. Para conceitos, use terminologia consagrada.
