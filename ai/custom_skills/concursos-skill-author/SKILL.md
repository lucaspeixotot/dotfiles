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
## 6. Estrutura sugerida do resumo (override do padrão do agente resumo)
## 7. Fontes oficiais (sempre na versão mais recente)
#+end_src

Regras do template:
- =description= é OBRIGATÓRIA e é o gatilho: nomeie a disciplina e quando
  carregar. Sem ela o gptel-agent ignora a skill com warning.
- =name=: slug sem acento, minúsculo, hífens. Se for específico de um estado,
  inclua o estado (ex.: =legislacao-tributaria-estadual-alagoas=).
- Manter lean e durável: playbook, não dump de conteúdo.
- Nada de lei colada: a seção 5 manda VERIFICAR, nunca afirma o teor.

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

## 5. Checagens de qualidade antes de finalizar

- [ ] description presente e com gatilho claro.
- [ ] Incidência ordenada por peso (quando houver dados).
- [ ] Pegadinhas específicas da disciplina, não genéricas.
- [ ] Seção 5 aponta normas/versões a VERIFICAR, sem colar o teor.
- [ ] Regra de ouro de atualidade condizente com o tipo (jurídica/exatas/TI).
- [ ] Estrutura sugerida do resumo adaptada à disciplina.
- [ ] Fontes oficiais e data de consulta.
- [ ] Se o nome mudou (ex.: adicionar estado), renomear diretório e atualizar o
  =name:= sem deixar duplicidade.

## 6. Exemplo canônico

A skill =direito-tributario= (em =~/custom_skills/direito-tributario/SKILL.md=)
é o modelo de referência. Leia-a antes de criar uma nova, para manter o padrão.
