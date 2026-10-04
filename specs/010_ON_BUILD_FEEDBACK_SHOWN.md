# SPEC-010: ON_BUILD_FEEDBACK_SHOWN
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-04

## 1. Comportamento Observado
Após o jogador tentar construir, a interface precisa mostrar um feedback claro de sucesso ou de erro (ex: sem recursos, posição inválida).

## 2. Evento (Fonte da Verdade)
```json
{
  "evento": "ON_BUILD_FEEDBACK_SHOWN",
  "atores": ["Interface"],
  "dados": {
    "player_id": "string",
    "success": "boolean",
    "message": "string"
  }
}
```

## 3. Processo
```text
Servidor responde à requisição de construção
↓
Cliente recebe resultado
↓
Emitir ON_BUILD_FEEDBACK_SHOWN
↓
Mostrar mensagem temporária na tela
```

## 4. Critérios de Aceite
- [ ] Mensagem de sucesso aparece quando a construção é aceita
- [ ] Mensagem de erro aparece quando a construção é rejeitada
- [ ] Feedback desaparece automaticamente após poucos segundos
- [ ] Não empilha várias mensagens ao mesmo tempo

## 5. Fora do Escopo
Não valida a construção, não altera recursos, não cria a toolbar.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
