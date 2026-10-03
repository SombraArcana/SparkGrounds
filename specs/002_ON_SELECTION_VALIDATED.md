# SPEC-002: ON_SELECTION_VALIDATED
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-03

## 1. Comportamento Observado
A cada mudança de seleção o sistema precisa validar célula por célula (limites, colisão, tipo de piso) e calcular custo acumulado em tempo real, pintando tiles de verde/vermelho.

## 2. Evento (Fonte da Verdade)
```json
{
  "evento": "ON_SELECTION_VALIDATED",
  "atores": ["Sistema de Grid"],
  "dados": {
    "cells": "array<Vector2>",
    "valid_cells": "array<Vector2>",
    "invalid_cells": "array<Vector2>",
    "total_cost": "number",
    "can_afford": "boolean"
  }
}
```

## 3. Processo
```text
ON_DRAG_AREA_UPDATED
↓
Pipeline de validação por célula
↓
Cálculo de custo sequencial
↓
Emitir ON_SELECTION_VALIDATED
```

## 4. Critérios de Aceite
- [ ] Tiles dentro do orçamento ficam verdes
- [ ] Tiles que excedem saldo ou colidem ficam vermelhos
- [ ] Custo de substituir pelo mesmo tipo = 0
- [ ] Validação roda apenas quando a célula muda

## 5. Fora do Escopo
Não renderiza visual, não envia ao servidor, não altera o grid real.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
