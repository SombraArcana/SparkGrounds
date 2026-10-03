--!strict
-- AreaSelection: função pura de seleção em área (spec001).
-- floor = retângulo cheio, wall = só perímetro.

export type GridCell = {
	x: number,
	z: number,
}

export type BuildType = "floor" | "wall"

local AreaSelection = {}

function AreaSelection.getCells(inicio: GridCell, fim: GridCell, tipo: BuildType): { GridCell }
	assert(tipo == "floor" or tipo == "wall", "tipo_construcao inválido, esperado floor|wall")

	local minX = math.min(inicio.x, fim.x)
	local maxX = math.max(inicio.x, fim.x)
	local minZ = math.min(inicio.z, fim.z)
	local maxZ = math.max(inicio.z, fim.z)

	local cells: { GridCell } = {}

	for x = minX, maxX do
		for z = minZ, maxZ do
			if tipo == "floor" then
				table.insert(cells, { x = x, z = z })
			else
				local is1Wide = (maxX - minX) == 0
				local is1Deep = (maxZ - minZ) == 0
				local isBorder = x == minX or x == maxX or z == minZ or z == maxZ
				if is1Wide or is1Deep or isBorder then
					table.insert(cells, { x = x, z = z })
				end
			end
		end
	end

	return cells
end

return AreaSelection
