Convertendo o material exportado para o formato de SPEC que você definiu, os comportamentos cristalizados se transformam naturalmente em eventos de domínio.

SPEC-001: SELEÇÃO_DE_ÁREA_ATUALIZADA

Status: RASCUNHO
 Criado por: Human Loop - Chatbot B
 Data: 2026-10-03



1. Comportamento Observado

Durante o modo de construção, o jogador arrasta o mouse sobre o grid para selecionar múltiplas células simultaneamente.

O sistema precisa recalcular a seleção à medida que o cursor muda de célula.

Para pisos, o comportamento esperado é preencher toda a área retangular. Para paredes, apenas o perímetro deve ser selecionado para evitar salas preenchidas.



2. Evento (Fonte da Verdade)
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

SPEC-002: SELEÇÃO_VALIDADA

Status: RASCUNHO
 Criado por: Human Loop - Chatbot B
 Data: 2026-10-03



1. Comportamento Observado

Enquanto o jogador arrasta uma seleção, cada célula precisa ser validada em tempo real.

O sistema verifica limites do mapa, colisões, ocupação atual, tipo de solo e disponibilidade de recursos.

A interface exibe feedback visual imediato indicando quais células podem ser construídas.



2. Evento (Fonte da Verdade)
{
  "evento": "SELECAO_VALIDADA",
  "atores": ["SistemaGrid"],
  "dados": {
    "player_id": "string",
    "celulas_validas": "GridCell[]",
    "celulas_invalidas": "GridCell[]",
    "custo_total": "number",
    "saldo_jogador": "number",
    "orcamento_suficiente": "boolean",
    "timestamp": "number"
  }
}

SPEC-003: PREVIEW_DE_CONSTRUÇÃO_ATUALIZADO

Status: RASCUNHO
 Criado por: Human Loop - Chatbot B
 Data: 2026-10-03



1. Comportamento Observado

O preview visual não representa entidades definitivas do mundo.

O sistema utiliza objetos reutilizáveis para mostrar ao jogador o resultado esperado da construção.

A atualização deve ocorrer somente quando houver alteração efetiva da célula final da seleção.



2. Evento (Fonte da Verdade)
{
  "evento": "PREVIEW_DE_CONSTRUCAO_ATUALIZADO",
  "atores": ["InterfacePreview"],
  "dados": {
    "player_id": "string",
    "quantidade_tiles": "number",
    "quantidade_validos": "number",
    "quantidade_invalidos": "number",
    "pool_utilizado": "number",
    "timestamp": "number"
  }
}

SPEC-004: TOPOLOGIA_DE_PAREDE_AVALIADA

Status: RASCUNHO
 Criado por: Human Loop - Chatbot B
 Data: 2026-10-03



1. Comportamento Observado

Paredes devem adaptar sua geometria conforme os vizinhos ortogonais existentes.

Durante o preview e após a confirmação da construção, o sistema recalcula automaticamente conexões para representar segmentos retos, cantos, cruzamentos e interseções.



2. Evento (Fonte da Verdade)
{
  "evento": "TOPOLOGIA_DE_PAREDE_AVALIADA",
  "atores": ["MotorTopologia"],
  "dados": {
    "cell_x": "number",
    "cell_z": "number",
    "mascara_vizinhos": "number",
    "tipo_topologia": "isolada|reta|canto|t|cruz",
    "timestamp": "number"
  }
}

SPEC-005: REQUISIÇÃO_DE_CONSTRUÇÃO_ENVIADA

Status: RASCUNHO
 Criado por: Human Loop - Chatbot B
 Data: 2026-10-03



1. Comportamento Observado

Ao liberar o botão do mouse, o jogador manifesta a intenção de executar a construção.

O cliente não efetiva alterações diretamente no mundo.

O servidor continua sendo a autoridade absoluta sobre custo, saldo, ocupação e resultado final.



2. Evento (Fonte da Verdade)
{
  "evento": "REQUISICAO_DE_CONSTRUCAO_ENVIADA",
  "atores": ["Jogador"],
  "dados": {
    "player_id": "string",
    "tipo_construcao": "floor|wall",
    "celulas_solicitadas": "GridCell[]",
    "custo_estimado_cliente": "number",
    "timestamp": "number"
  }
}

SPEC-006: CONSTRUÇÃO_CONFIRMADA

Status: RASCUNHO
 Criado por: Human Loop - Chatbot B
 Data: 2026-10-03



1. Comportamento Observado

O servidor revalida toda a operação.

Caso saldo, ocupação e permissões permaneçam válidos, a construção é aplicada de forma atômica.

Recursos são debitados apenas após a aprovação completa da operação.



2. Evento (Fonte da Verdade)
{
  "evento": "CONSTRUCAO_CONFIRMADA",
  "atores": ["Servidor"],
  "dados": {
    "player_id": "string",
    "celulas_construidas": "GridCell[]",
    "custo_final": "number",
    "saldo_restante": "number",
    "timestamp": "number"
  }
}

SPEC-007: CONSTRUÇÃO_CANCELADA

Status: RASCUNHO
 Criado por: Human Loop - Chatbot B
 Data: 2026-10-03



1. Comportamento Observado

O jogador pode interromper a operação utilizando ESC ou botão direito.

Nenhuma alteração definitiva deve ocorrer.

Todos os recursos visuais temporários devem ser liberados imediatamente.



2. Evento (Fonte da Verdade)
{
  "evento": "CONSTRUCAO_CANCELADA",
  "atores": ["Jogador"],
  "dados": {
    "player_id": "string",
    "motivo": "esc|right_click|tool_changed",
    "timestamp": "number"
  }
}

Observação de arquitetura

Os eventos acima revelam uma separação saudável em três contextos:

Input do Jogador

SELECAO_DE_AREA_ATUALIZADA
REQUISICAO_DE_CONSTRUCAO_ENVIADA
CONSTRUCAO_CANCELADA

Simulação Cliente

SELECAO_VALIDADA
PREVIEW_DE_CONSTRUCAO_ATUALIZADO
TOPOLOGIA_DE_PAREDE_AVALIADA

Autoridade Servidor

CONSTRUCAO_CONFIRMADA

Essa divisão ajuda a evitar exploits porque os eventos do cliente passam a representar apenas intenções, enquanto os eventos do servidor representam mudanças reais de estado.