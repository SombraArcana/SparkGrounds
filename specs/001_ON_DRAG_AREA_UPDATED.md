# SPEC-001: ON_DRAG_AREA_UPDATED
**Status:** RASCUNHO
**Criado por:** Human Loop - Chatbot B
**Data:** 2026-10-03

## 1. Comportamento Observado
Jogador arrasta o mouse no chão para selecionar área de construção. Sistema precisa converter raycast contínuo em coordenadas de grid discretas e distinguir entre preenchimento de chão vs perímetro de paredes.

## 2. Evento (Fonte da Verdade)
```json
{
	"evento": "ON_DRAG_AREA_UPDATED",
	"atores": ["Jogador"],
	"dados": {
		"player_id": "string",
		"start_cell": "Vector2",
		"current_cell": "Vector2",
		"mode": "chao | parede",
		"timestamp": "number"
	}
}
```

## 3. Processo
```text
MouseMove durante arrasto
↓
Raycast câmera → chão
↓
Converter para célula de grid
↓
Se célula mudou → emitir ON_DRAG_AREA_UPDATED
```

## 4. Critérios de Aceite
- [ ] Evento só dispara quando a célula de grid realmente muda
- [ ] Mode "chao" retorna área retangular completa
- [ ] Mode "parede" retorna apenas perímetro oco
- [ ] Sem spam de eventos no mesmo frame

## 5. Fora do Escopo
Não valida custo, não renderiza preview, não fala com servidor.

## 6. Stack Alvo
Roblox + Luau + Rojo + VS Code
