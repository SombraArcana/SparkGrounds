# SPEC-009: ON_RESOURCE_UPDATED
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-04

## 1. Comportamento Observado
O contador de recursos na interface precisa refletir o saldo real do jogador em tempo real, tanto ao gastar quanto ao receber recursos.

## 2. Evento (Fonte da Verdade)
```json
{
  "evento": "ON_RESOURCE_UPDATED",
  "atores": ["Sistema de Recursos", "Interface"],
  "dados": {
    "player_id": "string",
    "new_amount": "number",
    "delta": "number"
  }
}
```

## 3. Processo
```text
Saldo do jogador muda (gasto ou ganho)
↓
Emitir ON_RESOURCE_UPDATED
↓
Interface atualiza o texto do contador
```

## 4. Critérios de Aceite
- [ ] Contador mostra o valor correto após qualquer mudança
- [ ] Atualização é instantânea (sem delay perceptível)
- [ ] Funciona tanto para gasto quanto para ganho de recursos
- [ ] Não ocorre erro se o valor for zero

## 5. Fora do Escopo
Não implementa o sistema de economia completo, não cria a UI, não valida construções.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
