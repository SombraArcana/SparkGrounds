Durante o modo de construção, o jogador arrasta o mouse sobre o grid para selecionar múltiplas células simultaneamente.

O sistema precisa recalcular a seleção à medida que o cursor muda de célula.

Para pisos, o comportamento esperado é preencher toda a área retangular. Para paredes, apenas o perímetro deve ser selecionado para evitar salas preenchidas.

{
  "evento": "SELECAO_DE_AREA_ATUALIZADA",
  "atores": ["Jogador"],
  "dados": {
    "player_id": "string",
    "tipo_construcao": "floor|wall",
    "grid_inicio": {
      "x": "number",
      "z": "number"
    },
    "grid_final": {
      "x": "number",
      "z": "number"
    },
    "celulas_selecionadas": "GridCell[]",
    "timestamp": "number"
  }
}