# SPEC-QA-001: Validar seleção por arrasto de uma única célula
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / diagnóstico  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Determinar se MouseDown e MouseUp na mesma célula devem selecionar uma célula. No código observado, `lastCurrent` começa igual à célula inicial e o loop ignora a célula enquanto ela não muda; pode não haver evento para validar/submeter.

## 2. Escopo
Examinar somente o SPEC-001 correspondente, [DragController001.client.luau](../../src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau), [DragArea001.luau](../../src/ReplicatedStorage/Common/DragArea001.luau) e consumidores diretos necessários para rastrear emissão/consumo. Não ler a pasta `specs/` inteira. Não alterar código nesta rodada.

## 3. Perguntas
- O produto deve permitir construção de uma célula via clique/arrasto sem cruzar borda de grid?
- O SPEC exige emissão no início do arrasto ou exclusivamente quando a célula atual muda?
- Se esse comportamento não estiver especificado, qual decisão precisa do Human Loop?

## 4. Teste de aceite
No Roblox Studio, pressionar e soltar dentro da mesma célula. Registrar eventos emitidos e resultado da validação. Se célula única for comportamento desejado, deve surgir exatamente uma seleção contendo uma célula; se não, documentar a interação requerida. Não alegar teste executado sem evidência.

## 5. Entrega desta rodada
Relatório com conclusão, evidência por arquivo/linha, passos e resultado de teste (ou “não executado”), além de recomendação. Não implementar correção; qualquer alteração requer plano e aprovação humana.
