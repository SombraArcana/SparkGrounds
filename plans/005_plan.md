# Plan 005 — SPEC 005_ON_BUILD_REQUEST_SUBMITTED

Spec único lido: `specs/005_ON_BUILD_REQUEST_SUBMITTED.md`
Aprovado? Aguardando Human Loop (não implementar sem aprovação).

## Comportamento → Evento → Dado → Sistema
- Comportamento: no MouseUp o cliente envia só as células válidas; ESC/botão direito cancela sem custo.
- Evento (fonte da verdade, único): `ON_BUILD_REQUEST_SUBMITTED`
- Dados exatos: `player_id: string`, `cells: array<Vector2>`, `mode: chao|parede`, `total_cost: number`
- Sistema: primeiro cruzamento client→server. Servidor revalida tudo e só debita se aprovar (§4). Sem economia completa, sem animações (§5 fora do escopo).

## Decisões de fronteira (sem inventar eventos)
- Transporte: `RemoteEvent "ON_BUILD_REQUEST_SUBMITTED"` em `ReplicatedStorage`, **criado pelo servidor** (objeto criado por client não replica). Cliente usa `WaitForChild`.
- Feedback de rejeição (§4, sem evento novo): o mesmo RemoteEvent volta via `FireClient` com `{accepted: boolean, reason: string, total_cost: number}`; cliente só faz `print` feio (UI real = spec futura).
- Revalidação server rede: reutiliza `Validator002.validate` (mesmas regras dos dois lados — divergência zero por construção).
- Estado autoritativo stub feio no server: `occupied`, `balances`, `tileAt`, `costPerTile` em memória (sem DataStore, sem grid real). Aplica = marca occupied + debita saldo stub.
- Cancelamento: ESC/MouseButton2 limpam cache do submitter + pasta `Preview003` (reuso do nome, sem tocar no 003). `PreviewRenderer003.clear()` mora num LocalScript (não dá `require`) — duplicação feia assumida e anotada.
- Pendência: ESC pode chegar com `processed=true` (menu Roblox) — trata mesmo assim e anota para revisão futura.

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/BuildRemotes005.luau` — `ensureServer()` (cria o RemoteEvent) + `getClient()` (`WaitForChild` com timeout). Sem `game`? Não — precisa de `game`, é bridge de transporte como os wrappers anteriores.
2. `src/ServerScriptService/BuildServer005.server.luau` — Script: `ensureServer()`, estado stub, `OnServerEvent`: monta ctx autoritativo → `Validator002.validate(cells)` → compara `total_cost` do cliente (divergência = rejeita) → aprova (ocupa+debita) ou rejeita → `FireClient` resultado + `print`.
3. `src/StarterPlayer/StarterPlayerScripts/BuildSubmitter005.client.luau` — LocalScript: cacheia último `ON_SELECTION_VALIDATED` + `mode` do drag; `InputEnded` botão esquerdo com cache não-vazio → `FireServer` só `valid_cells`; ESC/botão direito → limpa cache + pasta `Preview003` + `print "cancelado"`; ouve `OnClientEvent` → `print` feedback.
4. Validar: `lune` regressão do `Validator002` (regras idênticas), `selene src`, `stylua src`, `rojo sourcemap`, `rojo build`, manual `rojo serve` + 2 clients? (aceite, rejeição por saldo server menor que client, cancel limpa preview).

## Fora do spec (não fazer)
- 001–004 (só consomem, não alteram), NOTAS_TECNICAS, DataStore/economia real, grid real, UI de feedback, animações.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
