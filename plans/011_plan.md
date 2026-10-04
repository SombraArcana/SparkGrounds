# Plan 011 — SPEC QA-001_SINGLE_CELL_DRAG (diagnóstico, sem código)

Spec único lido: `specs/QA-001_SINGLE_CELL_DRAG.md`
Aprovado? Aguardando Human Loop (não executar sem aprovação).

## Natureza (diferente das 001–010)
- Tipo QA/diagnóstico. Entrega = **relatório**, não código. Proibido alterar código nesta rodada (§2, §5).
- Escopo fechado pelo próprio spec: somente o SPEC-001 correspondente + `DragController001.client.luau` + `DragArea001.luau` + consumidores diretos. Não ler `specs/` inteira.

## Passos (só leitura + escrita do relatório)
1. Resgatar o SPEC-001 do GitHub (`git show origin/main:specs/001_ON_DRAG_AREA_UPDATED.md`, só leitura) — disco local não o tem mais.
2. Reler `DragController001.client.luau` (âncora `lastCurrent=start` no MouseDown + early-return no RenderStepped) e `DragArea001.luau` (`toCell`/`getCells`), rastreando emissão → validação → submit para célula única.
3. Responder as 3 perguntas do §3 (célula única deve construir? evento no início vs só-na-mudança? o que falta decidir) com conclusão por pergunta: confirmado/falso/intencional/depende + evidência arquivo/linha.
4. Teste de aceite §4 no Studio (`rojo serve`, MouseDown+MouseUp mesma célula, registrar eventos): se inviável nesta rodada, registrar explicitamente "não executado", sem alegar teste.
5. Entregar relatório em `Acompanhamento-Copilot/RELATORIO_QA-001_SINGLE_CELL.md` (conclusão, evidências, teste, recomendação: corrigir no 001, novo spec, ou documentar interação mínima) e commitar + push só o relatório.

## Fora do spec (não fazer)
- Qualquer edição em `src/`, outros specs/plans, outros QA-00x, implementação de correção.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
