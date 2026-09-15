---
name: concursos-skill-author
description: >
  Meta-skill: cria e revisa skills de disciplina (playbooks) para concursos
  fiscais (RFB/SEFAZ) e de controle (TCU/TCE, CGU/CGE). Carregar quando o
  usuário pedir para criar, atualizar ou revisar uma skill de assunto (SKILL.md)
  em ~/custom_skills/. Define o template, o processo de criação com pesquisa
  web embutida e a variação por tipo (jurídica × exatas × TI).
---

# Criadora de skills de disciplina — processo

Esta skill ensina COMO criar uma skill de disciplina (um "playbook" de estudo),
não o conteúdo da disciplina em si. O agente que a carregar fará o trabalho de
criação + revisão num único fluxo, escrevendo o arquivo final.

## 1. O que é uma skill de disciplina (playbook)

Um =SKILL.md= é o guia de COMO a disciplina é cobrada em prova — NÃO o conteúdo
da disciplina (o modelo já o domina). Ele existe para:

- Priorizar tópicos de maior incidência.
- Calibrar a resposta ao estilo da banca (Cebraspe × FGV).
- Listar pegadinhas clássicas ("não confunda X com Y").
- Indicar normas/padrões a VERIFICAR (nunca colar o teor da lei — isso
  desatualiza).

## 2. Template obrigatório (seções)

#+begin_src
---
name: <slug-da-disciplina>
description: >  (gatilho: disciplina + "carregar quando o aluno pedir resumo ou tirar dúvidas sobre <tópicos-chave>")
---

# <Disciplina> — playbook de estudo (fiscal + controle)

## 1. O que é esta skill
   + regra de ouro de atualidade (varia por tipo — ver seção 3)

## 2. Incidência em prova (o que priorizar)
## 3. Estilo por banca (Cebraspe × FGV)
## 4. Pegadinhas clássicas ("não confunda")
## 5. Normas/padrões a verificar (prioridade: vigência/versão)
## 6. Estrutura sugerida do resumo (espinha narrativa — obrigatório)
## 7. Fontes oficiais (sempre na versão mais recente)
#+end_src

Regras do template:
- =description= é OBRIGATÓRIA e é o gatilho: nomeie a disciplina e quando
  carregar. Sem ela o gptel-agent ignora a skill com warning.
- =name=: slug sem acento, minúsculo, hífens. Se for específico de um estado,
  inclua o estado (ex.: =legislacao-tributaria-estadual-alagoas=).
- Manter lean e durável: playbook, não dump de conteúdo.
- Nada de lei colada: a seção 5 manda VERIFICAR, nunca afirma o teor.
- Seção 6 NÃO pode ser lista plana de tópicos: deve entregar a espinha
  narrativa da disciplina (pergunta organizadora + fluxo principal + eixos
  conceituais + pares "não confunda"). Ver seção 2.1.
- A skill deve seguir o padrão Agent Skills (ver seção 2.3): SKILL.md enxuto +
  =references/= e =assets/= para o detalhe.

## 2.1 A seção 6 (espinha narrativa da disciplina)

A seção 6 é o que o agente de resumo usa para estruturar o texto. Ela NÃO pode
ser uma lista plana de tópicos. Deve conter, no mínimo:

1. **Pergunta organizadora** — a questão central que a disciplina responde
   (ex.: Direito Tributário = "como nasce, se constitui e se extingue a
   obrigação de pagar tributo?").
2. **Fluxo(s) principal(is)** — o encadeamento causal/temporal dos blocos
   (ex.: competência → obrigação → lançamento → crédito → prescrição/decadência).
   Exponha o fluxo ANTES dos tópicos, para o aluno ver o mapa.
3. **Eixos conceituais** — os pares estruturadores que organizam o texto
   (ex.: Auditoria = "documento × escrituração"; "regularidade = financeira +
   conformidade").
4. **Pares "não confunda"** — as oposições que devem aparecer AO LONGO do
   texto (e não só numa lista final).

A seção 6 é DERIVADA das seções 2–5 (incidência, banca, pegadinhas, normas):
não invente fluxo que não decorra delas.

## 2.2 Exemplos trabalhados (por tipo de disciplina)

Os exemplos COMPLETOS ficam em =references/exemplos-secao-6.md= — carregue esse
arquivo sempre que for escrever uma seção 6 (progressive disclosure: o detalhe
não fica no SKILL.md). Resumo mínimo para referência rápida:

- **Jurídica (Direito Tributário):** "como nasce, constitui e extingue a
  obrigação de pagar tributo?" → competência → obrigação → lançamento →
  crédito → prescrição/decadência → garantias.
- **Exatas (Matemática Financeira):** "como levar valores no tempo e comparar
  alternativas?" → juros → taxas → descontos → séries → amortização →
  equivalência → VPL/TIR.
- **TI (Desenvolvimento de Sistemas):** "como um software é concebido,
  construído, testado, entregue e mantido?" → requisitos → projeto →
  arquitetura → banco → implementação → testes → DevOps → gestão.

## 2.3 Padrão Agent Skills (obrigatório para TODAS as skills)

As skills de disciplina NÃO precisam condensar tudo no =SKILL.md=. Siga o
formato Agent Skills (https://agentskills.io/specification):

```
<nome-da-skill>/
├── SKILL.md          # obrigatório: frontmatter (name + description) + instruções
├── references/       # opcional: documentação carregada SOB DEMANDA
├── assets/           # opcional: templates, tabelas, quadros-resumo
└── ...
```

Regras práticas:

- **SKILL.md enxuto** (< 500 linhas): o essencial para decidir e estruturar
  (incidência, banca, pegadinhas, normas a verificar, espinha narrativa).
- **Material detalhado vai para =references/=** (ex.: quadros-resumo de
  incidência, tabelas de transição, glossário de "não confunda", listas de
  dispositivos por tópico). Referencie por caminho RELATIVO a partir do
  SKILL.md (ex.: "ver =references/quadro-transicao.md=").
- **=assets/= para templates e recursos estáticos** (ex.: modelo de resumo,
  tabela de alíquotas), não para instrução de comportamento.
- **Progressive disclosure:** o agente carrega o SKILL.md ao ativar a skill e
  só lê =references/=/=assets/= quando a tarefa exigir. Mantenha cada arquivo
  de =references/= focado (1 assunto), para leitura barata.
- A meta-skill já segue esse padrão (ver =references/exemplos-secao-6.md=). As
  skills de disciplina criadas/revisadas a partir de agora devem seguir o mesmo
  formato.

## 3. Variação da "regra de ouro" por tipo de disciplina

- **Jurídica (Direito, Auditoria, Finanças Públicas):**
  "Fonte oficial NÃO basta — boa fonte desatualizada pode afirmar como vigente
  algo já revogado/superado. Confirme a redação VIGENTE HOJE e a data da fonte.
  Verifique súmulas/julgados: se foi superado (overruling), cancelado ou
  modulado; jurisprudência recente pode ter virado o entendimento."

- **Exatas (Estatística, Matemática Financeira, Economia):**
  "O risco maior não é norma revogada, mas convenção/notação (amostral ×
  populacional; desconto por dentro × por fora; nominal × efetiva). Explicite a
  convenção usada e siga a da banca. Para Economia, separe TEORIA (estável) de
  CONJUNTURA (dados atuais)."

- **TI/Dados (Ciência de Dados, IA, Desenvolvimento, Infra):**
  "O risco é terminologia e versões de padrões/frameworks (ITIL, COBIT, ISO,
  NIST, Scrum, PMBOK, bibliotecas). Use terminologia consagrada; confirme a
  versão vigente quando a questão depender dela. Para normativos (LGPD, governo
  digital), confirme o texto vigente."

## 4. Processo de criação + revisão (fluxo único)

1. Receba o assunto e confirme com o usuário: (a) qual a disciplina/tema, (b)
   prova/banca/longo-prazo, (c) se há estado específico (ex.: SEFAZ AL).
2. **Pesquise ANTES de escrever** (WebSearch/WebFetch):
   - Incidência em prova (tópicos mais cobrados).
   - Estilo e pegadinhas da banca (trocas de termo clássicas).
   - Normas/versões VIGENTES na data atual (lei, súmula, jurisprudência; ou
     versão de framework/padrão).
   - O que um material de estudo costuma afirmar de forma DESATUALIZADA.
3. Escreva o =SKILL.md= já com a pesquisa incorporada (não criar-e-revisar em
   duas passadas separadas).
4. Crie o diretório =~/custom_skills/<slug>/= e o arquivo =SKILL.md=.
5. Rode =gptel-agent-update= (ou peça ao usuário) e valide que a skill aparece
   em =gptel-agent--skills= e no =<available_skills>= dos agentes.
6. Reporte ao usuário o que foi criado, o que foi verificado (com datas) e
   eventuais ressalvas de fontes divergentes.

### Modo de revisão estrutural (seção 6)

Quando o pedido for APENAS reescrever a seção 6 de uma skill existente:

- Derive a espinha narrativa das seções 2–5 da própria skill (incidência,
  banca, pegadinhas, normas) — não re-pesquise a norma do zero.
- Faça checagem LEVE de vigência apenas das normas já listadas na seção 5
  (WebSearch pontual); se algo estiver defasado, registre ressalva no relatório.
- NÃO expanda o escopo: neste modo, não reescreva a seção 5 nem faça pesquisa
  de incidência nova.

## 5. Checagens de qualidade antes de finalizar

- [ ] description presente e com gatilho claro.
- [ ] Incidência ordenada por peso (quando houver dados).
- [ ] Pegadinhas específicas da disciplina, não genéricas.
- [ ] Seção 5 aponta normas/versões a VERIFICAR, sem colar o teor.
- [ ] Regra de ouro de atualidade condizente com o tipo (jurídica/exatas/TI).
- [ ] Seção 6 tem pergunta organizadora + fluxo principal + eixos conceituais
      + pares "não confunda" — NÃO é lista plana de tópicos.
- [ ] Padrão Agent Skills respeitado: SKILL.md enxuto (< 500 linhas); detalhe
      em =references/= e =assets/=; caminhos relativos corretos.
- [ ] Fontes oficiais e data de consulta.
- [ ] Se o nome mudou (ex.: adicionar estado), renomear diretório e atualizar o
  =name:= sem deixar duplicidade.

## 6. Exemplo canônico

Os exemplos de seção 6 ficam em =references/exemplos-secao-6.md= (um por tipo
de disciplina). Use-os como modelo de forma. A skill =direito-tributario= (em
=~/custom_skills/direito-tributario/SKILL.md=) serve de referência adicional
de como uma skill jurídica completa fica — mas o modelo de seção 6 é o arquivo
de =references/=, não uma skill externa.
