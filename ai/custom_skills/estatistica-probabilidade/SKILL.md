---
name: estatistica-probabilidade
description: >
  Playbook de ESTATÍSTICA E PROBABILIDADE para concursos fiscais (RFB/SEFAZ) e
  de controle (TCU/TCE, CGU/CGE). Carregar quando o aluno pedir resumo ou tirar
  dúvidas sobre: estatística descritiva (medidas de posição, dispersão e
  forma), probabilidade, variáveis aleatórias e distribuições, amostragem,
  inferência (intervalos de confiança, testes de hipóteses), regressão e
  correlação. Define incidência, estilo das bancas, pegadinhas e convenções a
  verificar.
---

# Estatística e Probabilidade — playbook de estudo (fiscal + controle)

## 1. O que é esta skill

Guia de COMO a disciplina é cobrada — não o conteúdo (o modelo já o domina).
Use-o para priorizar tópicos, calibrar a resposta à banca e evitar os erros
clássicos.

**Regra de ouro — atualidade da fonte:** em exatas, o risco maior não é norma
revogada, mas convenção e notação (amostral × populacional, definição de
quartis, curtose, etc.). Antes de afirmar uma fórmula, explicite a CONVENÇÃO
usada e, se a banca adota outra, sinalize (seções 5 e 7).

## 2. Incidência em prova (o que priorizar — por peso)

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

## 3. Estilo por banca

- **CEBRASPE/CESPE**: cobra cálculo e interpretação; inverte o gabarito trocando
  "média" × "mediana", "variância" × "desvio-padrão", "populacional" ×
  "amostral" (n × n−1), "tipo I" × "tipo II". Leia o item procurando a palavra
  trocada. Desconfie de definições incompletas/trocadas e de termos absolutos.
- **FGV** (RFB/TCU): valoriza interpretação, cálculos e leitura de tabelas/
  gráficos; usa o coeficiente percentílico de curtose.

## 4. Pegadinhas clássicas ("não confunda")

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

## 5. Convenções e fórmulas a verificar (prioridade: consistência)

Em exatas, não há "lei revogada", mas há convenções que mudam o resultado:

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

**Checagem mínima (obrigatória):**
- Sempre declare a convenção/notação usada ao apresentar uma fórmula.
- Se a banca/edital especificar outra convenção, siga a deles e avise.

## 6. Estrutura sugerida do resumo (para o agente de resumo)

1. **Estatística descritiva** (medidas de posição, dispersão, forma).
2. **Probabilidade** (axiomas, condicional, Bayes).
3. **Variáveis aleatórias e distribuições**.
4. **Amostragem**.
5. **Inferência** (intervalos e testes de hipóteses).
6. **Regressão e correlação**.

## 7. Fontes de referência (boas práticas)

Para exatas, use fontes acadêmicas/técnicas consagradas e, quando o edital
indicar, bibliografia específica. Referências usuais:
- Bussab & Morettin — "Estatística Básica" (9ª ed., 2017).
- Magalhães & Lima — "Noções de Probabilidade e Estatística" (7ª ed., 2015).
- Montgomery & Runger — "Estatística Aplicada e Probabilidade para Engenheiros".

Não há "texto oficial" único — por isso a seção 5 (convenção) é o que mais
importa.

**Regra de ouro:** em exatas, o erro vem de convenção/notação, não de fonte
desatualizada. Explicite sempre a convenção usada e siga a da banca quando
houver.
