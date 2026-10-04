# Plan 004 — SPEC 004_ON_WALL_TOPOLOGY_EVALUATED

Spec único lido: `specs/004_ON_WALL_TOPOLOGY_EVALUATED.md`
Aprovado? Aguardando Human Loop (não implementar sem aprovação).

## Comportamento → Evento → Dado → Sistema
- Comportamento: paredes se autoconectam; preview simula reconfiguração sem tocar no estado real.
- Evento (fonte da verdade, único, um fire por célula): `ON_WALL_TOPOLOGY_EVALUATED`
- Dados exatos: `cell: Vector2`, `mask: number`, `variant: string`
- Sistema: client-only. Sem mudança permanente, sem custo (§5 fora do escopo).

## Entrada (do próprio spec §3, sem inventar)
- Consome `ON_SELECTION_VALIDATED` (002) filtrando `mode == "parede"` (modo repassado pela bridge da 003? Não — 002 não tem mode; usa o último `mode` do `ON_DRAG_AREA_UPDATED`, mesmo truque da 003). Para cada célula válida: checa vizinhos ortogonais → bitmask → fire.

## Regras (§4 aceite + convenções feias)
- Bits: 1=N, 2=E(Leste), 4=S, 8=W(Oeste). Convenção grid: N=Y-1, S=Y+1, E=X+1, W=X-1 (documentada no módulo, reversível).
- Vizinhança = células da seleção ∪ paredes existentes (stub `existingWalls: {[string]:true}` feio até o Grid real existir — cobre "funciona com paredes já existentes").
- Mapeamento mask→variant (pendência aberta): `0=isolada`, `1/2/4/8=ponta`, `5/10=reta`, `3/6/9/12=canto`, `7/11/13/14=t`, `15=x`. O §1 lista 5 categorias mas 16 masks incluem pontas — proponho `ponta` extra; se preferir, dobro em `reta` (sua decisão na aprovação).
- Preview visual por variante (mesh/rotação): diferido — sem assets de parede ainda; eventos saem com `variant` pronta e o 003 segue colorindo. Aplicação visual = TODO para spec futura, sem inventar agora.

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/WallTopology004.luau` — puro, sem `game`: `evaluate(cells, isWall)` → array `{cell, mask, variant}`; `maskOf(cell, isWall)`; tabela `VARIANT_BY_MASK[0..15]`.
2. `src/ReplicatedStorage/Common/OnWallTopologyEvaluated004.luau` — wrapper `BindableEvent "ON_WALL_TOPOLOGY_EVALUATED"`: `fire(payload)` / `onEvent(cb)`, payload com os 3 campos exatos.
3. `src/StarterPlayer/StarterPlayerScripts/TopologyController004.client.luau` — assina `ON_SELECTION_VALIDATED` + guarda último `mode` do drag; se `parede`: monta set da seleção + stub existentes, `evaluate`, um fire por célula válida, `print` feio (`mask=X variant=Y`).
4. Validar: `lune` asserts (tabela completa 0-15, variantes, vizinho existente fora da seleção conta, célula isolada), `selene src`, `stylua src`, `rojo sourcemap`, `rojo build`.

## Fora do spec (não fazer)
- 001/002/003 (só consomem, não alteram), 005, NOTAS_TECNICAS, mutação de parede real, custo, troca visual de mesh.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
