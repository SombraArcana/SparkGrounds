# Plan 009 — SPEC 009_ON_RESOURCE_UPDATED

Spec único lido: `specs/009_ON_RESOURCE_UPDATED.md`
Aprovado? Aguardando Human Loop (não implementar sem aprovação).

## Comportamento → Evento → Dado → Sistema
- Comportamento: contador reflete o saldo real em tempo real, no gasto e no ganho.
- Evento (fonte da verdade, único): `ON_RESOURCE_UPDATED`
- Dados exatos: `player_id: string`, `new_amount: number`, `delta: number`
- Sistema: server→client. Sem economia completa, sem criar UI, sem validar construção (§5).

## Transporte e atores (sem inventar eventos)
- Atores são Sistema de Recursos + Interface em lados opostos da fronteira → transporte `RemoteEvent "ON_RESOURCE_UPDATED"` criado pelo servidor (padrão da 005); Interface ouve via `OnClientEvent`.
- Dono do saldo: novo `ResourceLedger009` (ModuleScript em `ServerStorage`): `new(onChanged)` com `get/set/adjust`; todo `adjust` dispara `{player_id, new_amount, delta}`. Ganho = `adjust` positivo (sem fonte de renda ainda — API pronta para o futuro).
- Edição cirúrgica em `BuildServer005.server.luau` (única alteração anterior, exigida pelo fluxo "saldo muda → emitir"): troca as tabelas locais pelo ledger e emite no débito. Sem mudar regras de aprovação.

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/ResourceRemotes009.luau` — `ensureServer()` + `getClient()`, tipos do payload (padrão da 005).
2. `src/ServerStorage/ResourceLedger009.luau` — ledger com callback: default 100, `adjust` soma (zero permitido, sem erro), sempre emite. Testável via `lune` com `fire` stub.
3. Editar `BuildServer005.server.luau`: usa o ledger (leitura de saldo para o ctx + `adjust(-custo)` na aprovação).
4. `src/StarterGui/ResourceCounter009.client.luau` — LocalScript: `OnClientEvent` → atualiza `BuildUI/ResourceCounter.Text = "Recursos: N"` (via `WaitForChild`, sem alterar a 007) + `print` feio.
5. Validar: `lune` asserts no ledger (default, gasto, ganho, delta zero, sequência), `selene src`, `stylua src`, `rojo sourcemap`, `rojo build`, manual Studio (construir → contador cai na hora; zerar não quebra).

## Fora do spec (não fazer)
- 001–004/006–008 (só o 005 é tocado no mínimo acima), 010, DataStore/renda, validação, criação de UI.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
