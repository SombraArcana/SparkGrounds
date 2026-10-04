# SPEC-QA-006: Verificar substituição de célula pelo mesmo tipo
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / coerência do validador  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Investigar o critério do SPEC-002 segundo o qual substituir pelo mesmo tipo custa zero e compará-lo com o tratamento de ocupação do validador e estado stub do servidor.

## 2. Escopo
Ler apenas o SPEC-002 relacionado e inspecionar [Validator002.luau](../../src/ReplicatedStorage/Common/Validator002.luau), [BuildServer005.server.luau](../../src/ServerScriptService/BuildServer005.server.luau) e tipos/estado diretamente usados. Não ler `specs/` inteira nem alterar código.

## 3. Perguntas
- Qual cenário de jogo significa “substituir” uma célula já ocupada pelo mesmo tipo?
- O validador permite que `tileAt` determine tipo de célula ocupada, ou a ocupação sempre a torna inválida antes dessa consulta?
- O estado stub do servidor diferencia tipo de construção ou usa só booleano de ocupado?
- O critério pode ser exercitado com o modelo atual ou requer decisão/representação de Grid ainda inexistente?

## 4. Teste de aceite
Testar/documentar três casos: célula vazia, ocupada pelo mesmo tipo e ocupada por tipo diferente. Registrar `valid_cells`, `invalid_cells` e custo. Se o runtime atual não representa tipos, declarar o teste bloqueado por requisito/modelo ausente, sem inventar regra.

## 5. Entrega desta rodada
Conclusão fundamentada no SPEC e código, resultados ou bloqueios e recomendação. Não alterar validador nesta etapa; correções exigem aprovação humana.
