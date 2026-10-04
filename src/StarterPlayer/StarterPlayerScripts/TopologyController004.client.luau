--!strict
-- TopologyController004 (SPEC-004): consome ON_SELECTION_VALIDATED com mode parede,
-- avalia topologia por célula válida e emite ON_WALL_TOPOLOGY_EVALUATED. Só simula, não altera nada.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local WallTopology004 = require(Common:WaitForChild("WallTopology004"))
local OnDragAreaUpdated001 = require(Common:WaitForChild("OnDragAreaUpdated001"))
local OnSelectionValidated002 = require(Common:WaitForChild("OnSelectionValidated002"))
local OnWallTopologyEvaluated004 = require(Common:WaitForChild("OnWallTopologyEvaluated004"))

-- Stub feio: paredes já existentes no mapa, até o Grid real existir.
local existingWalls: { [string]: boolean } = {}

local lastMode: "chao" | "parede" = "chao"

OnDragAreaUpdated001.onEvent(function(payload)
	lastMode = payload.mode
end)

OnSelectionValidated002.onEvent(function(payload)
	if lastMode ~= "parede" then
		return
	end

	local selectionSet: { [string]: boolean } = {}
	for _, cell in payload.valid_cells do
		selectionSet[`{cell.X},{cell.Y}`] = true
	end

	local isWall = function(cell: Vector2): boolean
		local key = `{cell.X},{cell.Y}`
		return selectionSet[key] == true or existingWalls[key] == true
	end

	local results = WallTopology004.evaluate(payload.valid_cells, isWall)
	for _, entry in results do
		OnWallTopologyEvaluated004.fire({
			cell = entry.cell,
			mask = entry.mask,
			variant = entry.variant,
		})
	end
	print(`[ON_WALL_TOPOLOGY_EVALUATED] {#results} células de parede`)
end)

local TopologyController004 = {}

function TopologyController004.setExistingWalls(walls: { [string]: boolean })
	existingWalls = walls
end

return TopologyController004
