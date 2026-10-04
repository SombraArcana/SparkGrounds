# SPEC-QA-011: Reconciliar aprovações humanas e estado de QA
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / rastreabilidade de processo  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Reconciliar o estado de aprovação, implementação e validação das etapas de construção a partir das evidências disponíveis, sem inferir que um commit equivale a aprovação ou teste aceito.

## 2. Escopo
Usar histórico Git e registros explicitamente disponíveis ao Spark; consultar apenas um SPEC relevante por vez se necessário. Não ler `specs/` inteira. Não reconstruir planos apagados por iniciativa própria e não alterar código/documentos históricos nesta rodada.

## 3. Perguntas
- Que aprovação humana explícita existe para as etapas implementadas 003–005?
- Qual evidência indica implementação, teste de aceite e aprovação, separadamente?
- Há discrepância entre o fluxo no AGENTS.md e a sequência de commits visível?
- Qual formato mínimo de status seria necessário no futuro para distinguir rascunho, plano aprovado, implementado e validado? Solicitar decisão ao usuário em vez de instituí-lo.

## 4. Teste de aceite
Entregar tabela por etapa com status e fonte da evidência, distinguindo “não encontrado” de “não ocorreu”. Nenhum estado pode ser marcado aprovado/testado sem registro observável.

## 5. Entrega desta rodada
Relatório de rastreabilidade com questões que exigem Human Loop. Não reescrever planos apagados nem alterar governança do projeto sem solicitação/aprovação.
