# SPEC-QA-005: Verificar células duplicadas em requisição
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / integridade de custo e estado  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Determinar o resultado quando uma requisição de construção contém a mesma célula mais de uma vez. O validador observado consulta ocupação prévia, mas não aparenta deduplicar a entrada corrente.

## 2. Escopo
Examinar somente SPECs 002 e 005, um por vez, e fluxo relevante em [Validator002.luau](../../src/ReplicatedStorage/Common/Validator002.luau) e [BuildServer005.server.luau](../../src/ServerScriptService/BuildServer005.server.luau). Não ler `specs/` inteira; não editar código.

## 3. Perguntas
- `{Vector2.new(1, 1), Vector2.new(1, 1)}` passa pela validação atual?
- Que custo é calculado/debitado e quantas células são marcadas?
- A entrada duplicada deve ser rejeitada ou normalizada? Quem define esse comportamento: SPEC atual ou Human Loop?

## 4. Teste de aceite
Em Studio isolado, comparar requisição com uma célula única e requisição com essa célula repetida. Registrar validação, custo, ocupação e resposta. Critério de integridade: uma célula lógica não pode causar cobrança ou aplicação duplicada; a política de rejeitar versus normalizar deve ser aprovada/documentada.

## 5. Entrega desta rodada
Evidência de análise e teste (ou “não executado”), política atual e recomendação. Não implementar sem plano aprovado.
