# Plan 001 — SPEC 001_ON_DRAG_AREA_UPDATED

Spec único lido: `specs/001_ON_DRAG_AREA_UPDATED.md`
Aprovado pelo Human Loop. Legado test-drive (`SELECAO_DE_AREA_ATUALIZADA`, `AreaSelection`) intocado.

## Comportamento → Evento → Dado → Sistema
- Comportamento: arrastar mouse no chão seleciona área; raycast contínuo vira célula discreta.
- Evento (fonte da verdade, único): `ON_DRAG_AREA_UPDATED`
- Dados exatos: `player_id: string`, `start_cell: Vector2`, `current_cell: Vector2`, `mode: chao|parede`, `timestamp: number`
- Sistema: client-only. Sem custo, sem preview, sem servidor (§5 fora do escopo).

## Regras (§4 aceite)
- Só fire quando `current_cell` realmente muda.
- `chao` = área retangular completa normalizada (min/max, qualquer direção de arrasto).
- `parede` = só perímetro oco (1xN/Nx1 = todas, 1x1 = 1).
- Sem spam no mesmo frame (trava 1 fire/frame).

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/DragArea001.luau` — puro, sem `game`: `CELL_SIZE=4`, `toCell(worldPos, cellSize): Vector2` (origem 0,0 XZ, `math.floor`), `getCells(start, current, mode)` com as regras acima.
2. `src/ReplicatedStorage/Common/OnDragAreaUpdated001.luau` — wrapper `BindableEvent "ON_DRAG_AREA_UPDATED"` sob `ReplicatedStorage`: `fire(payload)` / `onEvent(cb)`, payload com os 5 campos exatos.
3. `src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau` — `UserInputService` marca arrasto (botão esquerdo), a cada frame com arrasto: raycast câmera→chão (`Workspace`, fallback plano Y=0), `toCell`, dedupe por `current_cell` + flag 1/frame, fire com `Players.LocalPlayer.Name` e `os.clock()`, `print` feio.
4. Validar: `lune` asserts (chao 3x2=6, parede 3x3=8, invertido normaliza), `selene src`, `stylua src`, `rojo sourcemap`, `rojo build`, manual `rojo serve` + arrastar.

## Fora do spec (não fazer)
- 002/003/004/005, NOTAS_TECNICAS, custo, preview, servidor.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
