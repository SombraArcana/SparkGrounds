# Relatório QA-001 — Arrasto de uma única célula

**Spec:** `specs/QA-001_SINGLE_CELL_DRAG.md` (diagnóstico, sem código alterado)
**SPEC-001 consultado via:** `git show ee419bb:specs/001_ON_DRAG_AREA_UPDATED.md` (só leitura; fora do disco local)
**Data:** 2026-10-04 — Nenhum arquivo `src/` foi modificado nesta rodada.

## Conclusão
**Confirmado e fiel ao texto do SPEC-001.** MouseDown + MouseUp na mesma célula não emite `ON_DRAG_AREA_UPDATED`, logo nada a jusante (validação, preview, submit, servidor) acontece. A implementação segue à risca o §3 ("Se célula mudou → emitir") e o §4 ("Evento só dispara quando a célula de grid realmente muda"). Não é bug contra o texto — é **lacuna de especificação**: o SPEC-001 não define se célula única é interação suportada.

## Evidência por arquivo/linha
- Emissão ausente — `src/StarterPlayer/StarterPlayerScripts/DragController001.client.luau:63-64` ancora `lastCurrent = startCell` no MouseDown; `:89-91` retorna sem fire enquanto `current == lastCurrent`. Sem cruzar borda, zero eventos.
- Matemática pronta — `src/ReplicatedStorage/Common/DragArea001.luau:17-28` (`chao`) e `:29-34` (`parede`, `is1Wide/is1Deep` cobrem 1x1): `start == current` retorna exatamente 1 célula. Suporte executado: `lune` CHECK001B (`parede 1x1 = 1`, PASS no build 001).
- Validação passiva — `ValidationController002` só reage a `ON_SELECTION_VALIDATED` sob evento; lista de 1 célula é caso trivial do mesmo caminho (sem branch especial).
- Submit bloqueado — `src/StarterPlayer/StarterPlayerScripts/BuildSubmitter005.client.luau:42-44` cacheia o validated; `:50-54` descarta o MouseUp quando `lastValidated` é nil. Sem drag event, nada é enviado.

## Respostas às 3 perguntas do §3
1. **Célula única deve construir?** Não especificado (depende do Human Loop). §1 fala em "área", §3 parte de "MouseMove".
2. **Emissão no início ou só na mudança?** Só na mudança — §3 passo 4 + §4 bullet 1. Implementação conforme.
3. **O que falta decidir?** SIM célula única → revisar o 001 (fire inicial no MouseDown com `current = start`) via plano; NÃO → documentar interação mínima (arrastar ao menos 1 borda).

## Teste de aceite (§4)
**Não executado** (sem Roblox Studio neste ambiente). Esperado se executado: MouseDown+MouseUp mesma célula → 0 eventos hoje; após eventual correção, exatamente 1 seleção de 1 célula. Evidência parcial executada: matemática 1x1 via `lune` (acima), que não substitui o teste de aceite.

## Recomendação
Decisão do Human Loop primeiro. Se SIM, a correção é pequena e cabe em revisão do SPEC-001 (não requer spec novo, mas requer aprovação pela regra). Nada a implementar até lá.
