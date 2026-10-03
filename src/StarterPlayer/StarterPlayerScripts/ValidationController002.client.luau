--!strict
-- ValidationController002 (SPEC-002): consome ON_DRAG_AREA_UPDATED, valida, emite ON_SELECTION_VALIDATED.
-- Só roda quando a seleção muda (chave start+current+mode). Contexto stub feio até o Grid real existir.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local DragArea001 = require(Common:WaitForChild("DragArea001"))
local Validator002 = require(Common:WaitForChild("Validator002"))
local OnDragAreaUpdated001 = require(Common:WaitForChild("OnDragAreaUpdated001"))
local OnSelectionValidated002 = require(Common:WaitForChild("OnSelectionValidated002"))

-- Stub feio: bounds 0..63, sem colisão, custo 10, saldo 100.
local context: Validator002.ValidationContext = {
	boundsMin = Vector2.new(0, 0),
	boundsMax = Vector2.new(63, 63),
	occupied = {},
	tileAt = nil,
	buildTile = "default",
	costPerTile = 10,
	balance = 100,
}

local lastKey: string? = nil

OnDragAreaUpdated001.onEvent(function(payload)
	local key =
		`{payload.start_cell.X},{payload.start_cell.Y}|{payload.current_cell.X},{payload.current_cell.Y}|{payload.mode}`
	if key == lastKey then
		return
	end
	lastKey = key

	local cells = DragArea001.getCells(payload.start_cell, payload.current_cell, payload.mode)
	local result = Validator002.validate(cells, context)

	OnSelectionValidated002.fire({
		cells = cells,
		valid_cells = result.valid_cells,
		invalid_cells = result.invalid_cells,
		total_cost = result.total_cost,
		can_afford = result.can_afford,
	})
	print(
		`[ON_SELECTION_VALIDATED] {#result.valid_cells} ok / {#result.invalid_cells} ruim custo={result.total_cost} afford={result.can_afford}`
	)
end)

local ValidationController002 = {}

function ValidationController002.setContext(newContext: Validator002.ValidationContext)
	context = newContext
	lastKey = nil
end

return ValidationController002
