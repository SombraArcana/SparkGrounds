# SPEC-008: ON_BUILD_MODE_CHANGED
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-04

## 1. Comportamento Observado
O jogador precisa alternar facilmente entre construir Chão e construir Parede. A mudança de modo deve atualizar o estado interno e dar feedback visual na toolbar.

## 2. Evento (Fonte da Verdade)
```json
{
  "evento": "ON_BUILD_MODE_CHANGED",
  "atores": ["Jogador", "Interface"],
  "dados": {
    "player_id": "string",
    "new_mode": "chao | parede",
    "previous_mode": "chao | parede"
  }
}
```

## 3. Processo
```text
Jogador clica no botão ou pressiona tecla de atalho
↓
Atualizar modo atual
↓
Destacar botão correspondente na toolbar
↓
Emitir ON_BUILD_MODE_CHANGED
```

## 4. Critérios de Aceite
- [ ] Botões de Chão e Parede alternam o modo corretamente
- [ ] Teclas de atalho (ex: 1 e 2) também funcionam
- [ ] Botão ativo fica visualmente destacado
- [ ] Modo atual é respeitado pelo sistema de drag

## 5. Fora do Escopo
Não cria a UI, não valida construção, não atualiza recursos.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
