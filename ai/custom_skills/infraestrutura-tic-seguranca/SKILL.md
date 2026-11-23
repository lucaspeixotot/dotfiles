---
name: infraestrutura-tic-seguranca
description: >
  INFRAESTRUTURA DE TIC E SEGURANÇA DA INFORMAÇÃO playbook for fiscal exams
  (RFB/SEFAZ) and control (TCU/TCE, CGU/CGE). Load when the student asks for a
  summary or has doubts about: redes, computação em nuvem, virtualização,
  sistemas operacionais, data centers, gestão de serviços de TI (ITIL/COBIT),
  governança de TI, segurança da informação (confidencialidade/integridade/
  disponibilidade), criptografia, controles de acesso, gestão de riscos,
  incidentes, continuidade, LGPD e ISO 27001/27002. Defines exam incidence,
  board style, pitfalls, and norms to verify.
---

NOTE: instructions are in English for token efficiency; exam content below stays in Portuguese because the exam and the output are in Portuguese. Always answer the student in the user's language (Portuguese).

# Infraestrutura de TIC e Segurança da Informação — playbook (fiscal + control)

## 1. What this skill is

Guide to HOW the subject is tested — not the content (the model already masters it).
Use it to prioritize topics, calibrate the answer to the board, and avoid the
classic mistakes.

**Golden rule — source currency:** in IT, the risk is terminology and versions
of standards/frameworks (ITIL, COBIT, ISO, NIST). For regulations (LGPD, public
security, digital government), confirm the text CURRENT TODAY and the date of
the source (sections 5 and 7).

## 2. Exam incidence (what to prioritize)

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

## 3. Board style

- **CEBRASPE/CESPE**: cobra definições e a distinção entre conceitos; inverte o
  gabarito trocando "IaaS" × "PaaS" × "SaaS", "simétrica" × "assimétrica",
  "autenticação" × "autorização", "incidente" × "problema", "RTO" × "RPO".
  Leia o item procurando a palavra trocada.
- **FGV**: valoriza interpretação, casos práticos e governança/normas.

## 4. Classic pitfalls ("não confunda")

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

## 5. Norms and standards to verify (priority: validity and version)

Do not state the content without verifying the CURRENT VERSION and the DATE of the source:

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

**Minimum currency check (mandatory):**
- For versioned frameworks, note the EDITION and confirm the current one.
- For laws/regulations, confirm the current wording and the DATE.

## 6. Suggested summary structure (for the summary agent)

- **Pergunta organizadora:** como a infraestrutura de TIC é organizada e como
  proteger a informação (confidencialidade, integridade, disponibilidade)
  contra ameaças, garantindo continuidade e conformidade?
- **Fluxo principal:** redes (OSI × TCP/IP, protocolos) → computação em nuvem
  e virtualização → sistemas operacionais e data centers → gestão de serviços
  (ITIL) e governança (COBIT) → segurança da informação (pilares;
  vulnerabilidade × ameaça × risco × impacto) → criptografia e assinatura
  digital → controles de acesso e gestão de identidades → riscos, continuidade
  e incidentes → normas e leis (ISO 27001/27002, NIST, LGPD).
- **Eixos conceituais:** modelos de serviço de nuvem (IaaS × PaaS × SaaS);
  pilares da segurança (confidencialidade × integridade × disponibilidade);
  gestão de serviços (ITIL) × governança (COBIT); criptografia (simétrica ×
  assimétrica; hash × cifragem).
- **Pares "não confunda":** autenticação × autorização; incidente × problema;
  RTO × RPO; vulnerabilidade × ameaça × risco × impacto; DRP × BCP × BIA;
  anonimização × pseudonimização; OSI × TCP/IP.

## 7. Official sources (always the most recent version)

- ISO/IEC: 27001 e 27002 na versão vigente.
- NIST: CSF e SP 800-53 na versão atual.
- PeopleCert: ITIL 5 (e ITIL 4 em coexistência); ISACA: COBIT 2019.
- Planalto/ANPD: LGPD e normativos (gov.br/anpd).

**Golden rule:** an official source is NOT synonymous with a current source. For frameworks
and norms, use the current, dated version/edition. For concepts, use established
terminology.
