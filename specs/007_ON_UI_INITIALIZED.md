# SPEC-007: ON_UI_INITIALIZED
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-04

## 1. Comportamento Observado
O jogador precisa de uma interface mínima para interagir com o sistema de construção. A UI deve aparecer assim que o jogador entra no jogo e conter apenas o essencial: toolbar de modos e contador de recursos.

## 2. Evento (Fonte da Verdade)
```json
{
  "evento": "ON_UI_INITIALIZED",
  "atores": ["Interface"],
  "dados": {
    "player_id": "string",
    "timestamp": "number"
  }
}
```

## 3. Processo
```text
Jogador entra no jogo
↓
Criar ScreenGui com toolbar e label de recursos
↓
Emitir ON_UI_INITIALIZED
```

## 4. Critérios de Aceite
- [ ] ScreenGui é criada corretamente no PlayerGui
- [ ] Toolbar e contador de recursos ficam visíveis
- [ ] UI não atrapalha a câmera ou o movimento do personagem
- [ ] Sem erros no output do Studio

## 5. Fora do Escopo
Não implementa lógica de modos, não atualiza recursos, não mostra feedback de construção.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
