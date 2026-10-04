# Plan 003 — SPEC 003_ON_PREVIEW_RENDER_REQUESTED

Spec único lido: `specs/003_ON_PREVIEW_RENDER_REQUESTED.md`
Aprovado? Aguardando Human Loop (não implementar sem aprovação).

## Comportamento → Evento → Dado → Sistema
- Comportamento: preview visual leve e desacoplado; reutiliza objetos via Object Pool; só atualiza quando as células mudam.
- Evento (fonte da verdade, único): `ON_PREVIEW_RENDER_REQUESTED`
- Dados exatos: `valid_cells: array<Vector2>`, `invalid_cells: array<Vector2>`, `mode: chao|parede`
- Sistema: client-only. Sem custo, sem topologia real, sem servidor (§5 fora do escopo).

## Entrada (do próprio spec §3, sem inventar)
- Consome `ON_SELECTION_VALIDATED` (002) → solicita do Pool → posiciona e colore (verde/vermelho) → devolve não-usados ao Pool.
- `mode` não vem no payload do 002: bridge guarda o último `mode` do `ON_DRAG_AREA_UPDATED` (001, já assinado no 002) e repassa. Sem evento novo.

## Regras (§4 aceite)
- Pool: zero `Instance.new`/`:Destroy()` durante o arrasto (cresce no máximo 1x por pico, depois só reusa).
- Dedupe: só renderiza quando `valid+invalid+mode` mudam (chave).
- `clear()` pública esvazia tudo; auto-clear quando validated chega com 0 células.
- Pendência: fim do arrasto (001 não emite evento de término) — wiring do `clear()` no cancelamento fica como TODO para decisão do Human Loop (revisão da 001 ou spec futura), sem inventar evento agora.

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/PreviewPool003.luau` — pool genérico testável: `new(createFn)` com `acquire()`, `release(obj)`, `releaseAll()`, `activeCount()`, `totalCount()`. Sem `game` (factory injeta criação).
2. `src/ReplicatedStorage/Common/OnPreviewRenderRequested003.luau` — wrapper `BindableEvent "ON_PREVIEW_RENDER_REQUESTED"`: `fire(payload)` / `onEvent(cb)`, payload com os 3 campos exatos.
3. `src/StarterPlayer/StarterPlayerScripts/PreviewRenderer003.client.luau` — bridge + render feio: assina `ON_SELECTION_VALIDATED`, monta payload com último `mode`, fire `ON_PREVIEW_RENDER_REQUESTED`; renderer (assinante do próprio evento): `acquire` N parts de pasta `Preview003` em `Workspace` (cria se faltar), posiciona `((X+0.5)*CELL_SIZE, GROUND+0.1, (Y+0.5)*CELL_SIZE)` tamanho `CELL_SIZE,0.2,CELL_SIZE`, `Anchored`, `CanCollide=false`, verde válido / vermelho inválido, `releaseAll` dos extras. Reusa `DragArea001.CELL_SIZE`.
4. Validar: `lune` asserts no pool (reuso sem criar, releaseAll, ativo/total), `selene src`, `stylua src`, `rojo sourcemap`, `rojo build`, manual `rojo serve` (arrastar: sem lag, sem parts novas no MicroProfiler; cancelar: `clear()`).

## Fora do spec (não fazer)
- 001/002 (só consomem, não alteram), 004/005, NOTAS_TECNICAS, custo, topologia real, servidor, evento de fim-de-arrasto.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
