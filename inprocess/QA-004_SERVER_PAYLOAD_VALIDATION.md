# SPEC-QA-004: Avaliar validação de payload no servidor
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / segurança e robustez  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Confirmar que o RemoteEvent de construção trata entradas de cliente como não confiáveis e rejeita payloads malformados sem erro não tratado nem mutação do estado.

## 2. Escopo
Examinar somente SPEC-005 e o caminho de recebimento em [BuildServer005.server.luau](../../src/ServerScriptService/BuildServer005.server.luau), [BuildRemotes005.luau](../../src/ReplicatedStorage/Common/BuildRemotes005.luau) e validador diretamente chamado. Não ler `specs/` inteira. Não alterar código nesta rodada.

## 3. Casos a investigar
- Payload `nil`, tipo incorreto, tabela sem campos requeridos ou `cells` com tipo incorreto.
- Células com tipo incorreto, coordenadas fracionárias ou valores não finitos.
- Seleção muito grande: identificar se há limite formal. Não inventar limite quando SPEC não o define.
- Verificar se rejeição mantém saldo e ocupação inalterados e se não deixa erro no servidor.

## 4. Teste de aceite
Em ambiente isolado do Studio, exercitar casos malformados com cliente de teste. Para cada caso, registrar entrada, resposta, Output do servidor e estado antes/depois. Critério: rejeição controlada, sem traceback e sem alteração de saldo/ocupação. Não executar testes contra produção.

## 5. Entrega desta rodada
Matriz de casos e resultados (ou testes não executados), análise do que está coberto e questões que exigem decisão. Sem correções de código nesta rodada; limite de tamanho precisa de decisão humana caso não esteja especificado.
