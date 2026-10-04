# SPEC-QA-009: Verificar superfície aceita pelo raycast do arrasto
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / interação e precisão espacial  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Determinar quais superfícies podem definir a célula selecionada. O raycast observado usa o primeiro hit do Workspace; o plano Y=0 só é usado quando nenhum objeto é atingido.

## 2. Escopo
Ler apenas SPEC-001 e inspecionar [DragController001.client.luau](../../src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau), mapa e filtros relevantes. Não ler `specs/` inteira e não alterar código.

## 3. Perguntas
- O jogador deve selecionar sempre a projeção no chão/grid, ou o primeiro objeto atingido pode legitimamente definir a posição?
- O comportamento foi verificado com cursor sobre personagem, preview e objetos que não são chão?
- Qual superfície é considerada chão válido no mapa atual?

## 4. Teste de aceite
No Studio, arrastar sobre chão aberto, personagem, tile de preview e objeto sólido. Registrar hit, célula emitida e comportamento esperado segundo SPEC-001. Se superfície válida não estiver definida, pedir decisão humana sem inventar filtros ou tags.

## 5. Entrega desta rodada
Matriz de cenário/resultado e conclusão com evidência; marcar testes não executados honestamente. Sem código de correção até haver plano aprovado.
