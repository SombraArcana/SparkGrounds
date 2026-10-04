# Plan 010 — SPEC 010_ON_BUILD_FEEDBACK_SHOWN

Spec único lido: `specs/010_ON_BUILD_FEEDBACK_SHOWN.md`
Aprovado? Aguardando Human Loop (não implementar sem aprovação).

## Comportamento → Evento → Dado → Sistema
- Comportamento: após tentar construir, toast de sucesso/erro, temporário e sem empilhar.
- Evento (fonte da verdade, único): `ON_BUILD_FEEDBACK_SHOWN`
- Dados exatos: `player_id: string`, `success: boolean`, `message: string`
- Sistema: client-only. Sem validar, sem mexer em recursos, sem criar toolbar (§5).

## Entrada (do próprio spec §3, sem inventar, sem tocar 005)
- Servidor já responde no RemoteEvent da 005 (`FireClient {accepted, reason, total_cost}`); múltiplos `OnClientEvent` no mesmo Remote são permitidos — o novo script assina o **mesmo** Remote em paralelo ao submitter. Zero edição em arquivos anteriores.
- Mensagem feia: aceito → `"Construído! (-X)"`; rejeitado → `reason` do servidor (textos técnicos por ora; localização = futuro, fora do escopo).

## Passos (Luau + Rojo, evento antes de tela)
1. `src/ReplicatedStorage/Common/OnBuildFeedbackShown010.luau` — wrapper `BindableEvent "ON_BUILD_FEEDBACK_SHOWN"`: `fire`/`onEvent`, 3 campos exatos + `format(accepted, reason, cost): string` pura (testável).
2. `src/StarterGui/BuildFeedback010.client.luau` — LocalScript: cria `TextLabel "FeedbackToast"` no topo-centro da `BuildUI` (invisível inicial); assina o Remote da 005: monta payload (`success=accepted`), fire `ON_BUILD_FEEDBACK_SHOWN`, mostra toast (verde/vermelho), `task.cancel` no hide anterior (sem empilhar) + `task.delay(3)` para ocultar + `print` feio.
3. Validar: `lune` asserts no `format` (sucesso com custo, rejeição repassa reason, custo zero), `selene src`, `stylua src`, `rojo sourcemap`, `rojo build`, manual Studio (aceite verde 3s, rejeição vermelha, spam de cliques = 1 toast).

## Fora do spec (não fazer)
- 001–009 (nenhum alterado), validação, recursos, toolbar, localização de mensagens, sons/animações.
- Se pedir: `Fora do spec domain. Requer novo spec no Human Loop.`
