--!strict
-- SelectionController: ponte feia entre hover do grid e o evento do spec001.
-- Só recalcula quando a célula final muda. Sem preview visual (fora do spec).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local AreaSelection = require(Common:WaitForChild("AreaSelection"))
local SelectionEvent = require(Common:WaitForChild("SelectionEvent"))

local lastStartX: number? = nil
local lastStartZ: number? = nil
local lastFinalX: number? = nil
local lastFinalZ: number? = nil
local lastTipo: string? = nil

local function updateSelection(tipo: "floor" | "wall", inicio: { x: number, z: number }, fim: { x: number, z: number })
	if
		lastStartX == inicio.x
		and lastStartZ == inicio.z
		and lastFinalX == fim.x
		and lastFinalZ == fim.z
		and lastTipo == tipo
	then
		return
	end

	lastStartX = inicio.x
	lastStartZ = inicio.z
	lastFinalX = fim.x
	lastFinalZ = fim.z
	lastTipo = tipo

	local player = Players.LocalPlayer
	local playerId = if player then player.Name else "studio"

	local cells = AreaSelection.getCells(inicio, fim, tipo)

	SelectionEvent.fire({
		player_id = playerId,
		tipo_construcao = tipo,
		grid_inicio = { x = inicio.x, z = inicio.z },
		grid_final = { x = fim.x, z = fim.z },
		celulas_selecionadas = cells,
		timestamp = os.clock(),
	})

	print(`[SELECAO_DE_AREA_ATUALIZADA] {tipo} ({inicio.x},{inicio.z}) -> ({fim.x},{fim.z}) = {#cells}`)
end

-- Debug feio: ouvir o evento sem montar tela.
SelectionEvent.onEvent(function(payload)
	print(`[listen] {#payload.celulas_selecionadas} células para {payload.player_id}`)
end)

return {
	updateSelection = updateSelection,
}
