# SPEC-QA-007: Verificar handler legado `lift`
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / integração server-side  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Determinar se o script legado de `lift` está incluído/ativo e se seu handler corresponde à assinatura Roblox de `RemoteEvent.OnServerEvent`.

## 2. Escopo
Inspecionar [ServerHandler.server.lua](../../src/ServerScriptService/Services/scripts/ServerHandler.server.lua), configuração Rojo e referências/criação direta do remote `lift`. Ler apenas documentação SPEC necessária, se houver. Não alterar/remover código durante o diagnóstico.

## 3. Perguntas
- O arquivo é incluído pelo projeto Rojo e executado no servidor?
- `ReplicatedStorage.lift` é criado por algum script ativo? Se não, ocorre erro na inicialização?
- O callback recebe `Player` como primeiro argumento? Como são interpretados ação e parâmetros enviados pelo cliente?
- O módulo/script está obsoleto? Essa conclusão depende de confirmação humana?

## 4. Teste de aceite
No Roblox Studio, iniciar sessão e observar Output do servidor; se o fluxo for ativo, acionar `Lift` e registrar argumentos recebidos e efeito. Se não houver produtor do remote ou não fizer parte do jogo atual, documentar evidência e não inventar uso.

## 5. Entrega desta rodada
Conclusão sobre inclusão, existência do RemoteEvent e assinatura; evidência estática/runtime ou indicação de teste não executado. Não corrigir nem remover o script sem decisão/aprovação.
