# SPEC-QA-003: Verificar reset de estado ao cancelar seleção
**Status:** RASCUNHO — fila `inprocess`  
**Tipo:** QA / diagnóstico  
**Origem:** revisão técnica Copilot, 2026-10-03

## 1. Comportamento a verificar
Determinar se cancelar uma seleção e desenhar novamente a mesma área restaura validação e preview. O submitter observado remove filhos da pasta de preview; renderer e validador mantêm chaves de deduplicação próprias.

## 2. Escopo
Examinar somente SPECs 001, 002 e 005, um por vez, conforme necessário; ler [BuildSubmitter005.client.luau](../../src/StarterPlayer/StarterPlayerScripts/BuildSubmitter005.client.luau), [PreviewRenderer003.client.luau](../../src/StarterPlayer/StarterPlayerScripts/PreviewRenderer003.client.luau), [ValidationController002.client.luau](../../src/StarterPlayer/StarterPlayerScripts/ValidationController002.client.luau) e fluxo direto de eventos. Não ler `specs/` inteira nem alterar código.

## 3. Perguntas
- Após cancelar, selecionar novamente exatamente a mesma área reemite validação e preview?
- Como são invalidados os caches do renderer, pool e validador?
- O renderer e submitter conseguem coordenar o clear dentro da arquitetura atual?
- O comportamento de cancelamento e fim de arrasto está definido pelos SPECs aplicáveis?

## 4. Teste de aceite
No Studio: gerar preview, cancelar, repetir seleção idêntica. Confirmar que preview e validação reaparecem, a pasta não contém duplicatas e o pool mantém contagens coerentes. Relatar cada etapa e evidência; não presumir resultado.

## 5. Entrega desta rodada
Fluxo de estado/caches, resultado reproduzido ou não executado, divergências de requisito e recomendação. Não implementar alteração nem inventar evento; aguardar aprovação humana.
