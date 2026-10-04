Aqui estão os **4 SPECs** formalizados e prontos para colar na pasta `specs/`.

---

**Arquivo: `specs/007_ON_UI_INITIALIZED.md`**
```markdown
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
```

---

**Arquivo: `specs/008_ON_BUILD_MODE_CHANGED.md`**
```markdown
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
```

---

**Arquivo: `specs/009_ON_RESOURCE_UPDATED.md`**
```markdown
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
```

---

**Arquivo: `specs/010_ON_BUILD_FEEDBACK_SHOWN.md`**
```markdown
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
```

---

Pronto.  
Os 4 SPECs estão formalizados e seguem exatamente o template atômico.

Quer que eu gere agora o `plans/` do primeiro (007), ou prefere revisar/ajustar algum antes?