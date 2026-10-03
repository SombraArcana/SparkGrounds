# SPEC-003: ON_PREVIEW_RENDER_REQUESTED
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-03

## 1. Comportamento Observado
O preview visual precisa ser leve e desacoplado. Deve reutilizar objetos via Object Pool e só atualizar quando a seleção de células muda.

## 2. Evento (Fonte da Verdade)
```json
{
  "evento": "ON_PREVIEW_RENDER_REQUESTED",
  "atores": ["Interface de Preview"],
  "dados": {
    "valid_cells": "array<Vector2>",
    "invalid_cells": "array<Vector2>",
    "mode": "chao | parede"
  }
}
```

## 3. Processo
```text
ON_SELECTION_VALIDATED
↓
Solicitar objetos do Pool
↓
Posicionar e colorir (verde/vermelho)
↓
Liberar objetos não usados de volta ao Pool
```

## 4. Critérios de Aceite
- [ ] Usa Object Pool (sem Create/Destroy durante arrasto)
- [ ] Preview só atualiza quando células mudam
- [ ] Performance estável a 60 FPS em seleções grandes
- [ ] Limpa completamente no cancelamento

## 5. Fora do Escopo
Não valida custo, não altera topologia real, não fala com servidor.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
