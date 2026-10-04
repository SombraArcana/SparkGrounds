# Plan 008 — SPEC 008_ON_BUILD_MODE_CHANGED

Spec único lido: `specs/008_ON_BUILD_MODE_CHANGED.md`
Aprovado? Aguardando Human Loop (não implementar sem aprovação).

## Comportamento → Evento → Dado → Sistema
- Comportamento: alternar Chão/Parede via toolbar ou teclas 1/2; atualiza estado interno + destaca botão.
- Evento (fonte da verdade, único): `ON_BUILD_MODE_CHANGED`
- Dados exatos: `player_id: string`, `new_mode: chao|parede`, `previous_mode: chao|parede`
- Sistema: client-only. Não cria UI (usa a da 007), não valida, não mexe em recursos (§5).

## Integração com o legado (resolve QA-02)
- Fonte única de verdade: novo `BuildModeState008` (puro, sem `game`); default `"chao"`.
- Edição cirúrgica em `DragController001.client.luau` (única alteração em arquivo de spec anterior, exigida pelo aceite "modo respeitado pelo drag"): lê `BuildModeState008.get()` na hora do fire; `setMode` legado vira passthrough com `--TODO legado` (sem quebrar nada).
- `ModeController008` encontra os botões `ModeChao`/`ModeParede` da 007 via `WaitForChild` (sem alterar a 007).

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/BuildModeState008.luau` — puro: `get()`, `set(mode)` retorna previous, `isValid(mode)`. Testável via `lune`.
2. `src/ReplicatedStorage/Common/OnBuildModeChanged008.luau` — wrapper `BindableEvent "ON_BUILD_MODE_CHANGED"`: `fire`/`onEvent`, 3 campos exatos.
3. `src/StarterGui/ModeController008.client.luau` — LocalScript: `WaitForChild("BuildUI")`, conecta `ModeChao`/`ModeParede` + teclas `One`/`Two` (ignora `processed` nas teclas), `set` + destaque do ativo (`BackgroundColor3` verde vs padrão) + fire com previous/new + `print` feio.
4. Editar `DragController001`: `require` do state + `mode = BuildModeState008.get()` no fire (remove o `local mode` como fonte; mantém `setMode` delegando).
5. Validar: `lune` asserts no state (default chao, troca retorna previous, inválido rejeitado), `selene src`, `stylua src`, `rojo sourcemap`, `rojo build`, manual Studio (clique, 1/2, destaque, drag em parede gera perímetro).

## Fora do spec (não fazer)
- 002–007 (só consomem/estendem o mínimo acima), 009/010, validação, recursos, servidor.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
