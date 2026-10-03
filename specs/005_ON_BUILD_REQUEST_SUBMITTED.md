# SPEC-005: ON_BUILD_REQUEST_SUBMITTED
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-03

## 1. Comportamento Observado
Ao soltar o clique (MouseUp) o cliente deve enviar apenas as células válidas ao servidor. ESC ou botão direito cancela tudo sem custo.

## 2. Evento (Fonte da Verdade)
```json
{
  "evento": "ON_BUILD_REQUEST_SUBMITTED",
  "atores": ["Jogador", "Servidor"],
  "dados": {
    "player_id": "string",
    "cells": "array<Vector2>",
    "mode": "chao | parede",
    "total_cost": "number"
  }
}
```

## 3. Processo
```text
MouseUp
↓
Cliente envia células válidas via RemoteEvent
↓
Servidor revalida tudo (saldo + colisões + limites)
↓
Aplica ou rejeita + notifica cliente
```

## 4. Critérios de Aceite
- [ ] Servidor nunca confia nos dados do cliente
- [ ] ESC e botão direito cancelam e limpam preview
- [ ] Em caso de rejeição o cliente recebe feedback claro
- [ ] Custo só é debitado se o servidor aprovar

## 5. Fora do Escopo
Não implementa o sistema de economia completo, não faz animações complexas.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
