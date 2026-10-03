# Plan 002 — SPEC 002_ON_SELECTION_VALIDATED

Spec único lido: `specs/002_ON_SELECTION_VALIDATED.md`
Aprovado pelo Human Loop — implementado.

## Comportamento → Evento → Dado → Sistema
- Comportamento: a cada mudança de seleção, validar célula por célula (limites, colisão, tipo de piso) e calcular custo acumulado em tempo real.
- Evento (fonte da verdade, único): `ON_SELECTION_VALIDATED`
- Dados exatos: `cells: array<Vector2>`, `valid_cells:  array<Vector2>`, `invalid_cells: array<Vector2>`, `total_cost: number`, `can_afford: boolean`
- Sistema: client-only. Sem visual, sem servidor, sem alterar o grid real (§5 fora do escopo — verde/vermelho é só classificação `valid/invalid`; quem pinta é spec futura).

## Entrada (do próprio spec §3, sem inventar)
- Consome `ON_DRAG_AREA_UPDATED` (001) → pipeline de validação → cálculo sequencial → emite `ON_SELECTION_VALIDATED`.

## Regras (§4 aceite)
- Custo sequencial: acumula na ordem das células; a partir do ponto onde o acumulado estoura o saldo, o restante vai para `invalid_cells`.
- Colisão (ocupada) ou fora dos limites → `invalid_cells` direto, sem custo.
- Substituir pelo mesmo tipo → custo 0.
- Só roda quando a seleção muda (chave `start+current+mode`; upstream 001 já dedupeia).

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/Validator002.luau` — puro, sem `game`: `validate(cells, ctx)` onde `ctx = { boundsMin: Vector2, boundsMax: Vector2, occupied: {[string]: true} ("x,y"), tileAt: (Vector2)->string?, buildTile: string, costPerTile: number, balance: number }`. Retorna `{valid_cells, invalid_cells, total_cost, can_afford}`. Stubs feios no topo (bounds 0..63, custo 10) até o Grid real existir.
2. `src/ReplicatedStorage/Common/OnSelectionValidated002.luau` — wrapper `BindableEvent "ON_SELECTION_VALIDATED"`: `fire(payload)` / `onEvent(cb)`, payload com os 5 campos exatos.
3. `src/StarterPlayer/StarterPlayerScripts/ValidationController002.client.luau` — assina `ON_DRAG_AREA_UPDATED`, guarda última chave vista, chama `Validator002.validate` com ctx stub, fire `ON_SELECTION_VALIDATED`, `print` feio (`#valid/#invalid custo=X afford=Y`).
4. Validar: `lune` asserts (tudo-válido, estouro sequencial corta resto, colisão inválida, mesmo-tipo custo 0, lista vazia), `selene src`, `stylua src`, `rojo sourcemap`, `rojo build`.

## Fora do spec (não fazer)
- 001 (só consome, não altera), 003/004/005, NOTAS_TECNICAS, render/verde-vermelho visual, servidor, mutação do grid.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
