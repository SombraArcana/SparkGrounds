# SPEC-QA-002: Verificar acesso ao modo parede
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / diagnóstico  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Descobrir como o fluxo ativo permite selecionar `parede`. O controller de arrasto observado inicia em `chao` e expõe `setMode()`, mas não foi encontrado caller em `src/`.

## 2. Escopo
Examinar somente o SPEC-001 correspondente, [DragController001.client.luau](../../src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau) e callers/integrações diretamente relevantes. Não ler `specs/` inteira. Não criar UI, input, evento nem editar código durante o diagnóstico.

## 3. Perguntas
- Qual interação ou sistema atual muda o modo para `parede`?
- Existe caller fora de `src/`? Identificar caminho e forma de acesso.
- Se não há interação implementada, isso é pendência consciente ou requisito em aberto para o Human Loop?

## 4. Teste de aceite
Demonstrar no Studio uma interação reproduzível que define o modo parede e confirmar que o evento `ON_DRAG_AREA_UPDATED` contém `mode = "parede"`. Se não houver caller/integração, registrar como não exercitável, sem inventar uma tecla ou controle.

## 5. Entrega desta rodada
Conclusão, caminho de chamada ou evidência da ausência na busca, evidência de teste (ou “não executado”) e recomendação. Sem código de correção; aguardar plano aprovado.
