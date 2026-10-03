--!strict
-- DragArea001 (SPEC-001): matemática pura de grid, sem `game`, sem UI.
-- mode "chao" = retângulo cheio, "parede" = só perímetro oco.

local DragArea001 = {}

DragArea001.CELL_SIZE = 4

function DragArea001.toCell(worldX: number, worldZ: number, cellSize: number?): Vector2
	local size = cellSize or DragArea001.CELL_SIZE
	return Vector2.new(math.floor(worldX / size), math.floor(worldZ / size))
end

function DragArea001.getCells(startCell: Vector2, currentCell: Vector2, mode: "chao" | "parede"): { Vector2 }
	assert(mode == "chao" or mode == "parede", "mode inválido, esperado chao|parede")

	local minX = math.min(startCell.X, currentCell.X)
	local maxX = math.max(startCell.X, currentCell.X)
	local minY = math.min(startCell.Y, currentCell.Y)
	local maxY = math.max(startCell.Y, currentCell.Y)

	local cells: { Vector2 } = {}

	for x = minX, maxX do
		for y = minY, maxY do
			if mode == "chao" then
				table.insert(cells, Vector2.new(x, y))
			else
				local is1Wide = (maxX - minX) == 0
				local is1Deep = (maxY - minY) == 0
				local isBorder = x == minX or x == maxX or y == minY or y == maxY
				if is1Wide or is1Deep or isBorder then
					table.insert(cells, Vector2.new(x, y))
				end
			end
		end
	end

	return cells
end

return DragArea001
