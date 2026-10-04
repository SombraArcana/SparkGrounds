# Relatório do projeto — acompanhamento com Copilot

**Atualizado:** 2026-10-03  
**Objetivo:** ponto de retomada rápido para o usuário e o Copilot. Este documento resume o que foi registrado e observado; os SPECs, planos e fontes vinculados continuam sendo as referências detalhadas.

## Visão geral

Projeto Roblox escrito em Luau e organizado com Rojo. A implementação usa módulos comuns em `src/ReplicatedStorage/Common` e controllers do cliente em `src/StarterPlayer/StarterPlayerScripts`. O fluxo de construção está sendo desenvolvido por etapas: seleção, validação, preview, topologia de paredes e, futuramente, submissão ao servidor.

## Trabalho documentado

- A pedido do usuário, os SPECs e planos funcionais antigos foram removidos do workspace. A implementação existente em `src/` não foi apagada.
- O questionário de QA foi dividido em onze SPECs diagnósticos independentes, todos em rascunho, na [fila `specs/inprocess`](../specs/inprocess/README.md).
- O questionário consolidado permanece em [QA_TECNICO_PARA_SPARK.md](QA_TECNICO_PARA_SPARK.md); material histórico adicional está em [trabalhointermediario.md](../meu/trabalhointermediario.md).

## Implementação encontrada em `src/`

- **SPEC-001 — arrasto e área:** cálculo de célula/área, evento local e controller de arrasto. Referências: [DragArea001.luau](../src/ReplicatedStorage/Common/DragArea001.luau), [OnDragAreaUpdated001.luau](../src/ReplicatedStorage/Common/OnDragAreaUpdated001.luau), [DragController001.client.luau](../src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau).
- **SPEC-002 — validação:** validador puro, evento local e controller que consome o evento 001. Referências: [Validator002.luau](../src/ReplicatedStorage/Common/Validator002.luau), [OnSelectionValidated002.luau](../src/ReplicatedStorage/Common/OnSelectionValidated002.luau), [ValidationController002.client.luau](../src/StarterPlayer/StarterPlayerScripts/ValidationController002.client.luau).
- **SPEC-003 — preview:** pool reutilizável, evento e renderer cliente. Referências: [PreviewPool003.luau](../src/ReplicatedStorage/Common/PreviewPool003.luau), [OnPreviewRenderRequested003.luau](../src/ReplicatedStorage/Common/OnPreviewRenderRequested003.luau), [PreviewRenderer003.client.luau](../src/StarterPlayer/StarterPlayerScripts/PreviewRenderer003.client.luau).
- **SPEC-004 — topologia de paredes:** bitmask ortogonal, mapeamento de variantes e controller de avaliação. Referências: [WallTopology004.luau](../src/ReplicatedStorage/Common/WallTopology004.luau), [OnWallTopologyEvaluated004.luau](../src/ReplicatedStorage/Common/OnWallTopologyEvaluated004.luau), [TopologyController004.client.luau](../src/StarterPlayer/StarterPlayerScripts/TopologyController004.client.luau).
- **SPEC-005 — pedido de construção:** agora há RemoteEvent, validação/aplicação server-side stub e submitter cliente. Referências: [BuildRemotes005.luau](../src/ReplicatedStorage/Common/BuildRemotes005.luau), [BuildServer005.server.luau](../src/ServerScriptService/BuildServer005.server.luau), [BuildSubmitter005.client.luau](../src/StarterPlayer/StarterPlayerScripts/BuildSubmitter005.client.luau).

## Git no momento da consulta

- A consulta anterior encontrou o branch `main`, com `origin` apontando para `https://github.com/SombraArcana/SparkGrounds.git` e o commit `732d665` (SPEC-005).
- Os onze SPECs na fila são documentos locais novos. Não foi feito commit nesta tarefa; estarão disponíveis ao Spark quando o workspace/alterações forem compartilhados com a sessão dele.

## Pontos de QA registrados

Revisão estática anterior, sem alterações no código, sinalizou estes itens para confirmar/corrigir:

1. **Validador:** a verificação de `occupied` acontece antes da consulta `tileAt`; assim, uma célula ocupada não chega à regra de custo zero para substituição pelo mesmo tipo. Veja [Validator002.luau](../src/ReplicatedStorage/Common/Validator002.luau#L38-L43).
2. **`can_afford`:** é calculado como “não há nenhuma célula inválida”, misturando falta de saldo com colisão e limites. Veja [Validator002.luau](../src/ReplicatedStorage/Common/Validator002.luau#L56).
3. **Handler de servidor existente:** o callback de `OnServerEvent` recebe apenas um parâmetro e o consulta como se fosse a ação; no Roblox o primeiro argumento recebido é o jogador. Veja [ServerHandler.server.lua](../src/ServerScriptService/Services/scripts/ServerHandler.server.lua#L11-L14).
4. **Raycast do arrasto:** aceita o primeiro objeto atingido, sem parâmetros para excluir personagem/objetos que não sejam o chão. Veja [DragController001.client.luau](../src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau#L24-L33).
5. **Seleção duplicada:** `AreaSelection` e `DragArea001` contêm cálculos de área em paralelo, com tipos/nomes de modo diferentes; convém confirmar qual fluxo deve permanecer. Veja [AreaSelection.luau](../src/ReplicatedStorage/Common/AreaSelection.luau) e [DragArea001.luau](../src/ReplicatedStorage/Common/DragArea001.luau).
6. **Inicialização de `SelectionController`:** na busca anterior não foi encontrada chamada `require` para esse módulo; confirmar no Studio se é legado ou se está faltando inicialização. Veja [SelectionController.luau](../src/StarterGui/Controller/SelectionController.luau).

Esses são apontamentos da revisão estática do snapshot `732d665`; não foram revalidados em runtime nesta tarefa. Consulte [a fila de SPECs QA](../specs/inprocess/README.md) para perguntas, escopo e testes de aceite individuais. A análise estática anterior não reportou erros do editor naquele momento; não foi feito teste no Roblox Studio nesta conversa.

## Papel do Copilot até aqui

- Organizou os SPECs e as notas técnicas a partir do conteúdo enviado pelo usuário.
- Fez uma revisão estática de QA e registrou possíveis problemas, sem editar `src/`.
- Este relatório é um resumo auxiliar para continuidade; decisões e aprovações continuam com o usuário.

## Próximos passos possíveis

1. Entregar ao Spark um único SPEC da [fila `inprocess`](../specs/inprocess/README.md) por vez.
2. Exigir o plano do item selecionado e aprová-lo antes de qualquer implementação ou alteração de código.
3. Após o diagnóstico, decidir se cada apontamento requer correção, novo SPEC ou apenas documentação.
