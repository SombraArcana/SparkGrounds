# SPEC-QA-010: Mapear fluxos legados e inicialização dos controllers
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / integração e manutenção  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Identificar o fluxo canônico ativo de seleção e construção, e determinar se módulos legados/alternativos são inicializados ou consumidos.

## 2. Escopo
Examinar o SPEC-001 aplicável e rastrear referências em `src/` para [AreaSelection.luau](../../src/ReplicatedStorage/Common/AreaSelection.luau), `DragArea001.luau`, [SelectionController.luau](../../src/StarterGui/Controller/SelectionController.luau), [DragController001.client.luau](../../src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau), os eventos e seus consumidores. Não ler `specs/` inteira nem alterar fontes.

## 3. Perguntas
- Qual módulo/evento é o fluxo canônico em runtime e quais são test-drive/legado?
- `SelectionController` é carregado e `updateSelection()` chamado? Se não, há requisito que dependa dele?
- Existe caller para `DragController001.setMode()`?
- Os dois cálculos de seleção diferem em tipos, nomes e semântica; qual diferença é intencional?

## 4. Teste de aceite
Construir mapa de fluxo `entrada → controller → evento → consumidor`, confirmar inicialização no Studio e marcar componentes sem caller como não usados/indeterminados. Não apagar nem consolidar módulo sem confirmação.

## 5. Entrega desta rodada
Diagrama ou lista de chamadas com evidências, status runtime de cada caminho e recomendações/decisões pendentes. Sem mudanças de código nesta rodada.
