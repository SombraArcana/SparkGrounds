# Questionário técnico de QA para o Spark

> **Fila organizada:** este questionário foi desmembrado em SPECs individuais em [specs/inprocess](../specs/inprocess/README.md). Use os arquivos da fila, um por vez; este documento fica como referência consolidada da revisão original.

**Snapshot examinado:** commit `732d665` (`SPEC-005`)  
**Data da revisão:** 2026-10-03  
**Objetivo:** obter explicações e evidências sobre riscos observados no código; não solicitar implementação nesta rodada.

## Instrução para responder

Spark, responda a cada item com:

1. **Conclusão:** confirmado, falso, intencional ou depende de decisão humana.
2. **Evidência:** fluxo de execução e arquivos/linhas que sustentam a conclusão.
3. **Reprodução/teste:** passos, resultado esperado e resultado observado. Se ainda não testou, diga explicitamente.
4. **Próximo passo:** correção dentro do SPEC aprovado, necessidade de novo SPEC ou decisão do Human Loop.

Não altere arquivos nesta rodada. Não leia `specs/` inteiro: consulte apenas o SPEC diretamente relacionado a cada pergunta, um por vez. Se algum requisito não estiver definido, registre a ambiguidade em vez de inventar comportamento.

## Achados prioritários

### QA-01 — Arrasto de uma única célula pode não emitir evento

**Prioridade:** Alta — risco de funcionalidade.  
**Evidência:** [DragController001.client.luau](../src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau) inicializa `lastCurrent` com a célula inicial no MouseDown; no `RenderStepped`, retorna quando `current == lastCurrent`. Assim, se o jogador pressionar e soltar sem atravessar para outra célula, não há `ON_DRAG_AREA_UPDATED` para validar/submeter a seleção de uma célula.

**Perguntas:**
- O fluxo deve permitir construir uma célula com um clique/arrasto sem cruzar uma borda?
- O evento inicial deve ser emitido ao iniciar o arrasto, ou o comportamento de “só emitir quando a célula mudar” exclui intencionalmente esse caso?

**Teste de aceite proposto:** MouseDown e MouseUp na mesma célula devem produzir exatamente uma seleção de uma célula, caso construção de célula única seja suportada; caso contrário, documentar explicitamente a interação requerida.

### QA-02 — Modo parede parece não ter caller acessível

**Prioridade:** Alta — risco de funcionalidade.  
**Evidência:** `DragController001.client.luau` começa com `mode = "chao"` e declara `DragController001.setMode()`, mas é um script `.client.luau` e não encontrei chamada para `setMode` em `src/`. A função retornada pelo script não é consumida por um módulo chamador no código pesquisado.

**Perguntas:**
- Qual componente seleciona o modo `parede` no estado atual?
- Existe caller fora de `src/`? Se sim, indique o caminho e como obtém a referência ao controller.
- Se a alternância ainda não foi implementada, o modo parede está conscientemente pendente ou o SPEC atual exige que já seja possível exercitá-lo?

**Teste de aceite proposto:** demonstrar uma interação verificável que altere o modo para parede e confirmar que o payload emitido carrega esse modo.

### QA-03 — Cancelamento pode deixar deduplicação/cache em estado antigo

**Prioridade:** Alta — risco de preview não voltar após cancelar.  
**Evidência:** [BuildSubmitter005.client.luau](../src/StarterPlayer/StarterPlayerScripts/BuildSubmitter005.client.luau) remove os filhos de `Preview003` ao cancelar. Não chama `PreviewRenderer003.clear()`. Em [PreviewRenderer003.client.luau](../src/StarterPlayer/StarterPlayerScripts/PreviewRenderer003.client.luau), `clear()` limpa `lastRenderKey` e devolve objetos ao pool; além disso, [ValidationController002.client.luau](../src/StarterPlayer/StarterPlayerScripts/ValidationController002.client.luau) mantém `lastKey` até `setContext()`.

**Perguntas:**
- O que acontece ao cancelar e imediatamente selecionar a mesma área novamente? O preview e a validação são reemitidos?
- Como o cancelamento invalida, de forma coordenada, o cache do renderer, o pool e a chave de deduplicação da validação?
- A separação atual em LocalScripts permite chamar o `clear()` do renderer, ou exige um mecanismo de comunicação definido no escopo?

**Teste de aceite proposto:** renderizar uma área, cancelar, repetir a seleção idêntica e confirmar que o preview reaparece, sem duplicar Parts nem perder objetos do pool.

### QA-04 — Payload do RemoteEvent precisa ser validado em runtime

**Prioridade:** Alta — robustez e segurança do servidor.  
**Evidência:** [BuildServer005.server.luau](../src/ServerScriptService/BuildServer005.server.luau) anota o payload com um tipo Luau, mas acessa `payload.player_id`, `payload.cells` e `#payload.cells` diretamente. A tipagem estática não valida dados enviados por um cliente hostil.

**Perguntas:**
- Como o handler rejeita `nil`, payload que não seja tabela, campos ausentes, `cells` que não seja array e elementos que não sejam `Vector2`?
- Como são rejeitadas coordenadas fracionárias, NaN/infinito e uma seleção excessivamente grande?
- Um payload inválido provoca somente uma rejeição limpa para aquele jogador, ou pode gerar erro no callback do servidor?
- Existe limite de quantidade de células definido pelo SPEC? Se não, registre a necessidade de decisão em vez de inventar um limite.

**Testes de aceite propostos:** enviar, em ambiente de teste, payloads malformados de cada categoria; o servidor deve rejeitá-los sem traceback, alteração de saldo ou mutação do estado.

### QA-05 — Células duplicadas na mesma requisição

**Prioridade:** Alta — integridade do custo/estado.  
**Evidência:** [Validator002.luau](../src/ReplicatedStorage/Common/Validator002.luau) verifica `ctx.occupied`, que representa ocupação anterior, mas não mantém um conjunto das células já vistas na requisição atual. Duas ocorrências da mesma célula desocupada podem passar ambas pela validação; o servidor soma o custo de ambas e depois marca a mesma chave como ocupada.

**Perguntas:**
- `cells = {Vector2.new(1, 1), Vector2.new(1, 1)}` é aceito? Qual custo é debitado?
- A deduplicação é responsabilidade do cliente, do validador compartilhado ou do servidor autoritativo?
- Como garantir que cada célula seja cobrada e aplicada no máximo uma vez por requisição?

**Teste de aceite proposto:** duplicar uma célula em uma chamada direta ao RemoteEvent; rejeitar ou normalizar a entrada sem cobrança duplicada.

### QA-06 — Regra de substituir pelo mesmo tipo não é alcançada para célula ocupada

**Prioridade:** Alta — critério declarado no SPEC-002.  
**Evidência:** em [Validator002.luau](../src/ReplicatedStorage/Common/Validator002.luau), a célula ocupada é marcada inválida antes da consulta `tileAt`; portanto, a comparação `currentTile == buildTile` e o custo zero não são alcançados nesse caso. O servidor 005 configura `occupied` como mapa de booleanos e `tileAt = nil`, sem distinguir o tipo já construído.

**Perguntas:**
- Qual cenário concreto representa “substituir pelo mesmo tipo” no modelo de dados atual?
- A ocupação deveria impedir sempre a construção, ou o tipo existente deveria permitir substituição idempotente com custo zero?
- O estado stub do SPEC-005 é suficiente para demonstrar o critério, ou esse critério depende de um futuro Grid tipado?

**Teste de aceite proposto:** validar uma célula ocupada pelo mesmo tipo e outra ocupada por tipo diferente; registrar classificação e custo esperados conforme o SPEC aprovado.

### QA-07 — Assinatura do RemoteEvent antigo `lift`

**Prioridade:** Alta se o script estiver ativo.  
**Evidência:** [ServerHandler.server.lua](../src/ServerScriptService/Services/scripts/ServerHandler.server.lua) conecta `OnServerEvent` com um único parâmetro, `action`. No Roblox, o primeiro argumento do evento no servidor é o `Player`; logo, `actions[action]` usa o jogador como chave, não a string de ação. Também não encontrei no código pesquisado a criação de `ReplicatedStorage.lift`.

**Perguntas:**
- Esse script é legado, está ativo no projeto Rojo e o RemoteEvent `lift` existe em runtime?
- O Output do servidor mostra erro ao iniciar por `ReplicatedStorage.lift` ausente?
- Se o handler for utilizado, onde são recebidos a ação e seus argumentos depois do `Player`?

**Teste de aceite proposto:** iniciar servidor no Studio, conferir Output e acionar a ação `Lift`; demonstrar que o callback recebe jogador/ação corretamente e não gera erro.

## Achados adicionais

### QA-08 — `can_afford` mistura saldo com validade geral

**Prioridade:** Média — contrato do resultado.  
**Evidência:** `Validator002.validate()` retorna `can_afford = #invalid == 0`. Uma célula fora do mapa ou em colisão torna `can_afford` falso mesmo quando há saldo suficiente.

**Pergunta:** o campo significa “saldo cobre o custo” ou “a seleção inteira pode ser construída”? Se forem conceitos diferentes, qual campo/evento representa cada um segundo o SPEC, sem acrescentar contrato por conta própria?

**Teste de aceite proposto:** testar saldo suficiente com célula em colisão, saldo insuficiente sem colisão e seleção totalmente válida; documentar o resultado booleano esperado.

### QA-09 — Raycast pode usar personagem/objeto como superfície da célula

**Prioridade:** Média — precisão da seleção.  
**Evidência:** [DragController001.client.luau](../src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau) usa `Workspace:Raycast()` sem `RaycastParams`; qualquer primeiro hit retorna `result.Position`. O fallback ao plano Y=0 ocorre somente quando não há hit.

**Perguntas:**
- O teste de arrasto foi feito passando o cursor sobre personagem, preview e objetos que não são chão?
- O resultado esperado é sempre projetar no chão/grid, ou selecionar a superfície atingida faz parte do comportamento?
- Qual critério define uma superfície válida para o raycast segundo o escopo atual?

### QA-10 — Fluxos legados/paralelos e inicialização

**Prioridade:** Média — integração e manutenção.  
**Evidência:** existem [AreaSelection.luau](../src/ReplicatedStorage/Common/AreaSelection.luau) e `DragArea001.luau`, ambos calculando células, com shapes e nomes de modo diferentes. [SelectionController.luau](../src/StarterGui/Controller/SelectionController.luau) expõe `updateSelection()`, mas não encontrei consumidor em `src/`. O controller de arrasto também tem uma função `setMode()` sem caller encontrado.

**Perguntas:**
- Quais módulos são o fluxo canônico atual e quais são legado/test-drive?
- `SelectionController` deve ser iniciado por algum Script/LocalScript? Se não, deve ser documentado como legado?
- Como evitar que o fluxo antigo (`SELECAO_DE_AREA_ATUALIZADA`) e o fluxo SPEC-001 sejam confundidos nos testes?

### QA-11 — Estado de aprovação nos planos versus commits

**Prioridade:** Média — governança do fluxo.  
**Evidência:** no snapshot `732d665` há commits/código para os SPECs 003, 004 e 005, mas os planos correspondentes continuam com “Aguardando Human Loop”.

**Perguntas:**
- A aprovação humana ocorreu e os planos ficaram sem atualização, ou os commits foram feitos antes da aprovação prevista no fluxo?
- Qual é o estado real (rascunho, aprovado, implementado, validado) de cada SPEC 003–005?
- Há evidência de teste de aceite por etapa? Anexar comando/resultado ou marcar explicitamente como ainda não executado.

## Fechamento da rodada

Esta é uma revisão estática dos arquivos do snapshot indicado; não confirma comportamento em runtime. Não foi fornecido resultado de teste no Roblox Studio para este questionário. Depois das respostas do Spark, o usuário decide quais itens viram correção, plano ou novo SPEC.