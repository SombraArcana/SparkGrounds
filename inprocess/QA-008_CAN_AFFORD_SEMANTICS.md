# SPEC-QA-008: Definir semântica de `can_afford`
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / contrato de dados  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Determinar se `can_afford` significa apenas que o saldo cobre o custo ou que toda a seleção é válida/construível. A implementação observada deriva o booleano da ausência total de células inválidas.

## 2. Escopo
Ler apenas SPEC-002 e inspecionar [Validator002.luau](../../src/ReplicatedStorage/Common/Validator002.luau) e consumidor direto [ValidationController002.client.luau](../../src/StarterPlayer/StarterPlayerScripts/ValidationController002.client.luau). Não ler `specs/` inteira nem modificar payloads.

## 3. Pergunta
Com saldo suficiente e uma célula inválida por limite/colisão, `can_afford` deve continuar true? O nome representa capacidade financeira ou aptidão integral da seleção? Se o SPEC não resolve essa distinção, registrar como decisão pendente; não criar novo campo por conta própria.

## 4. Teste de aceite
Registrar resultado para: saldo suficiente + seleção válida; saldo suficiente + colisão/fora dos limites; saldo insuficiente + células sem colisão. Comparar implementação com semântica aprovada e identificar ambiguidades.

## 5. Entrega desta rodada
Conclusão, tabela de casos/resultado atual/resultado esperado segundo o SPEC, e pergunta ao Human Loop se houver ambiguidade. Sem alteração de código nesta rodada.
