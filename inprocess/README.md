# Fila de SPECs em processo — QA

Esta pasta contém SPECs diagnósticos de QA separados do backlog funcional. Todos estão em **RASCUNHO**, não aprovados.

## Como entregar ao Spark

Entregar **um caminho de SPEC por vez**. O Spark deve seguir o fluxo do AGENTS.md: ler somente o SPEC nomeado, produzir um plano, aguardar aprovação humana e não implementar antes dela. Estes itens pedem primeiro diagnóstico/evidência; não autorizam correções de código.

## Ordem sugerida

1. [QA-001 — seleção de uma célula](QA-001_SINGLE_CELL_DRAG.md)
2. [QA-002 — acesso ao modo parede](QA-002_WALL_MODE_ACCESSIBILITY.md)
3. [QA-003 — reset do estado ao cancelar](QA-003_CANCEL_RESET_STATE.md)
4. [QA-004 — validação do payload no servidor](QA-004_SERVER_PAYLOAD_VALIDATION.md)
5. [QA-005 — células duplicadas](QA-005_DUPLICATE_CELLS.md)
6. [QA-006 — substituição pelo mesmo tipo](QA-006_SAME_TYPE_REPLACEMENT.md)
7. [QA-007 — handler legado `lift`](QA-007_LEGACY_LIFT_REMOTE.md)
8. [QA-008 — semântica de `can_afford`](QA-008_CAN_AFFORD_SEMANTICS.md)
9. [QA-009 — superfícies do raycast](QA-009_RAYCAST_SURFACE_FILTER.md)
10. [QA-010 — fluxos legados e inicialização](QA-010_LEGACY_FLOW_INITIALIZATION.md)
11. [QA-011 — rastreabilidade de aprovação e QA](QA-011_APPROVAL_TRACEABILITY.md)

A numeração indica apenas a ordem sugerida; cada SPEC é independente. Se a análise encontrar requisito ambíguo, Spark deve registrar a pergunta ao Human Loop e não inventar uma solução.
