---
name: infraestrutura-tic-seguranca
description: >
  Playbook de INFRAESTRUTURA DE TIC E SEGURANÇA DA INFORMAÇÃO para concursos
  fiscais (RFB/SEFAZ) e de controle (TCU/TCE, CGU/CGE). Carregar quando o aluno
  pedir resumo ou tirar dúvidas sobre: redes, computação em nuvem, virtualização,
  sistemas operacionais, data centers, gestão de serviços de TI (ITIL/COBIT),
  governança de TI, segurança da informação (confidencialidade/integridade/
  disponibilidade), criptografia, controles de acesso, gestão de riscos,
  incidentes, continuidade, LGPD e ISO 27001/27002. Define incidência, estilo
  das bancas, pegadinhas e normas a verificar.
---

# Infraestrutura de TIC e Segurança da Informação — playbook (fiscal + controle)

## 1. O que é esta skill

Guia de COMO a disciplina é cobrada — não o conteúdo (o modelo já o domina).
Use-o para priorizar tópicos, calibrar a resposta à banca e evitar os erros
clássicos.

**Regra de ouro — atualidade da fonte:** em TI, o risco é terminologia e versões
de padrões/frameworks (ITIL, COBIT, ISO, NIST). Para normativos (LGPD, segurança
pública, governo digital), confirme o texto VIGENTE HOJE e a data da fonte
(seções 5 e 7).

## 2. Incidência em prova (o que priorizar)

- **Redes**: modelo OSI × TCP/IP, camadas, protocolos (TCP/UDP, IP, HTTP/HTTPS,
  DNS, DHCP), endereçamento, VPN, firewalls, roteamento.
- **Computação em nuvem**: modelos de serviço (IaaS, PaaS, SaaS) e de
  implantação (pública, privada, híbrida, comunitária); virtualização.
- **Sistemas operacionais e data centers**: conceitos, disponibilidade,
  redundância.
- **Gestão de serviços de TI**: ITIL (práticas, cadeia de valor) × COBIT
  (governança); incidente × problema × mudança.
- **Segurança da informação**: pilares (confidencialidade, integridade,
  disponibilidade), autenticidade, não repúdio; classificação da informação;
  **vulnerabilidade × ameaça × risco × impacto**.
- **Zero Trust / IAM / RBAC / MFA** e **dado em repouso × em trânsito × em uso**.
- **Criptografia**: simétrica × assimétrica, hash, assinatura digital, PKI,
  certificados.
- **Controles de acesso**: autenticação × autorização; AAA; RBAC; MFA.
- **Gestão de riscos e continuidade**: análise de riscos, BIA, RTO/RPO, plano de
  continuidade e de recuperação de desastres.
- **Gestão de incidentes**: detecção, resposta, notificação.
- **Normas e leis**: ISO 27001/27002, NIST, LGPD (Lei 13.709/2018).

## 3. Estilo por banca

- **CEBRASPE/CESPE**: cobra definições e a distinção entre conceitos; inverte o
  gabarito trocando "IaaS" × "PaaS" × "SaaS", "simétrica" × "assimétrica",
  "autenticação" × "autorização", "incidente" × "problema", "RTO" × "RPO".
  Leia o item procurando a palavra trocada.
- **FGV**: valoriza interpretação, casos práticos e governança/normas.

## 4. Pegadinhas clássicas ("não confunda")

- **IaaS × PaaS × SaaS**: o que o provedor gerencia muda em cada modelo.
- **Nuvem pública × privada × híbrida × comunitária**: propriedade e
  compartilhamento distintos.
- **Criptografia simétrica × assimétrica**: mesma chave × par de chaves;
  desempenho × distribuição de chave.
- **Hash × criptografia**: hash é unidirecional (integridade), criptografia é
  reversível (confidencialidade).
- **Assinatura digital ≠ cifragem**: assinatura garante autoria/integridade e
  usa a chave privada; cifragem usa a chave pública do destinatário.
- **Autenticação × autorização**: quem é × o que pode fazer.
- **Incidente × problema**: interrupção/evento × causa raiz.
- **RTO × RPO**: tempo máximo de recuperação × perda máxima de dados aceitável.
- **ITIL × COBIT**: gestão de serviços × governança corporativa de TI.
- **Confidencialidade × integridade × disponibilidade**: pilares distintos.
- **Vulnerabilidade × ameaça × risco × impacto**: definições distintas (ISO
  27000/27005) — a banca troca.
- **DRP × BCP × BIA**: recuperação de desastres × continuidade de negócios ×
  análise de impacto.
- **Backup × arquivamento**; **RTO × RPO × MTTR × MTBF**.
- **Controlador × operador × encarregado (DPO)** na LGPD.
- **Anonimização × pseudonimização**; **dado pessoal × dado pessoal sensível**.
- **Hash × criptografia × assinatura**: assinatura garante integridade/
  autenticidade/não repúdio, **NÃO confidencialidade**.
- **OSI (7 camadas) × TCP/IP (4 camadas)**: não troque os nomes das camadas.

## 5. Normas e padrões a verificar (prioridade: vigência e versão)

Não afirme o teor sem verificar a VERSÃO VIGENTE e a DATA da fonte:

- **ITIL**: vigente é o **ITIL 5** (lançado 29/01/2026 pela PeopleCert) — amplia
  de ITSM para Digital Product and Service Management (DPSM), IA nativa. As 34
  práticas e o SVS do ITIL 4 foram mantidos; ITIL 4 ainda é aceito/cobrado.
- **COBIT 2019** — versão vigente (ISACA mantém atualizações contínuas).
- **ISO/IEC 27001:2022 + Amd 1:2024** (mudanças climáticas no contexto);
  transição para 2022 encerrada em 31/10/2025 — só vale 2022.
- **ISO/IEC 27002:2022** — 93 controles em 4 temas (organizacional, pessoas,
  físicos, tecnológicos).
- **NIST CSF 2.0** (fev/2024) — 6 funções, incluindo a nova **Govern**;
  **NIST SP 800-53 Rev. 5**.
- **LGPD (Lei 13.709/2018)** — sem alteração de mérito; regulamentos ANPD:
  **Res. 15/2024** (incidentes), **18/2024** (DPO), **19/2024** (transferência
  internacional), **4/2023** (sanções).
- **Normativos federais de cibersegurança**: **Decreto 11.856/2023** (PNCiber/
  CNCiber) e **Decreto 12.573/2025** (Plano Nacional); **IN GSI/PR nº 1/2020**
  (gestão de SI, alterada pela **nº 9/2026**); **IN GSI/PR nº 5/2021** (nuvem).
  A **ANCiber ainda NÃO é lei** (anteprojeto) — não afirmar que foi criada.

**Checagem mínima de atualidade (obrigatória):**
- Para frameworks versionados, anote a EDIÇÃO e confirme a vigente.
- Para leis/normativos, confirme a redação vigente e a DATA.

## 6. Estrutura sugerida do resumo (para o agente de resumo)

1. **Redes** (OSI/TCP-IP, protocolos).
2. **Computação em nuvem e virtualização**.
3. **Sistemas operacionais e data centers**.
4. **Gestão de serviços de TI (ITIL) e governança (COBIT)**.
5. **Segurança da informação** (pilares, classificação).
6. **Criptografia e assinatura digital**.
7. **Controles de acesso e gestão de identidades**.
8. **Gestão de riscos, continuidade e incidentes**.
9. **Normas e leis** (ISO 27001/27002, NIST, LGPD).

## 7. Fontes oficiais (sempre na versão mais recente)

- ISO/IEC: 27001 e 27002 na versão vigente.
- NIST: CSF e SP 800-53 na versão atual.
- PeopleCert: ITIL 5 (e ITIL 4 em coexistência); ISACA: COBIT 2019.
- Planalto/ANPD: LGPD e normativos (gov.br/anpd).

**Regra de ouro:** fonte oficial NÃO é sinônimo de fonte atual. Para frameworks
e normas, use a versão/edição vigente e datada. Para conceitos, use terminologia
consagrada.
