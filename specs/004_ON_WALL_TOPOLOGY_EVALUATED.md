# SPEC-004: ON_WALL_TOPOLOGY_EVALUATED
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-03

## 1. Comportamento Observado
Paredes precisam se conectar automaticamente (Isolada, Reta, Canto L, T, X). O preview deve simular a reconfiguração visual das paredes existentes sem alterar o estado real.

## 2. Evento (Fonte da Verdade)
```json
{
  "evento": "ON_WALL_TOPOLOGY_EVALUATED",
  "atores": ["Motor de Topologia"],
  "dados": {
    "cell": "Vector2",
    "mask": "number",
    "variant": "string"
  }
}
```

## 3. Processo
```text
Para cada célula de parede na seleção
↓
Checar vizinhos ortogonais (N/S/L/O)
↓
Gerar bitmask (0-15)
↓
Emitir ON_WALL_TOPOLOGY_EVALUATED
```

## 4. Critérios de Aceite
- [ ] Máscara de bits correta (1=N, 2=E, 4=S, 8=W)
- [ ] Preview mostra a variante correta antes da confirmação
- [ ] Não altera paredes reais no servidor/cliente até confirmação
- [ ] Funciona com paredes já existentes no mapa

## 5. Fora do Escopo
Não aplica a mudança permanente, não valida custo.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
