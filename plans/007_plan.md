# Plan 007 — SPEC 007_ON_UI_INITIALIZED

Spec único lido: `specs/007_ON_UI_INITIALIZED.md`
Aprovado? Aguardando Human Loop (não implementar sem aprovação).

## Comportamento → Evento → Dado → Sistema
- Comportamento: ao entrar no jogo, UI mínima aparece — toolbar de modos + contador de recursos, só o essencial.
- Evento (fonte da verdade, único): `ON_UI_INITIALIZED`
- Dados exatos: `player_id: string`, `timestamp: number`
- Sistema: client-only. Sem lógica de modos, sem atualizar recursos, sem feedback (§5 fora do escopo — 008/009/010).

## Regras (§4 aceite)
- `ScreenGui "BuildUI"` criada no `PlayerGui` do jogador local.
- Toolbar: `Frame` inferior-central com 2 `TextButton` estáticos ("Chão", "Parede") — visuais, sem ação.
- Contador: `TextLabel "Recursos: --"` estático (valor real vem na 009).
- Não bloqueia jogo: `Frame.Active=false`, fundo translúcido, fora do centro da tela; `ScreenGui.ResetOnSpawn=false` para não duplicar em respawn.
- Zero erro no Output.

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/OnUIInitialized007.luau` — wrapper `BindableEvent "ON_UI_INITIALIZED"`: `fire(payload)` / `onEvent(cb)`, payload com os 2 campos exatos (mesmo padrão 001–004).
2. `src/StarterGui/BuildUI007.client.luau` — LocalScript: `Players.LocalPlayer:WaitForChild("PlayerGui")`, monta ScreenGui+toolbar+label via código, parenta, fire com `Name` + `os.clock()`, `print` feio.
3. Validar: `selene src`, `stylua src`, `rojo sourcemap`, `rojo build` + manual no Studio (`rojo serve`, Play: checar PlayerGui, visibilidade, câmera/movimento livres, Output limpo). Sem `lune` (módulo é `game`-bound; registrar como limitação honesta).

## Fora do spec (não fazer)
- 001–004 (não altera), 008/009/010, NOTAS (se existir), lógica de troca de modo, atualização de recursos, feedback, servidor.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
