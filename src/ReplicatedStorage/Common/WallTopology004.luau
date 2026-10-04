--!strict
-- WallTopology004 (SPEC-004): bitmask de vizinhança ortogonal + variante, sem `game`, sem UI.
-- Bits: 1=N, 2=E(Leste), 4=S, 8=W(Oeste). Convenção grid: N=Y-1, S=Y+1, E=X+1, W=X-1.

export type TopologyCell = {
	cell: Vector2,
	mask: number,
	variant: string,
}

local VARIANT_BY_MASK: { [number]: string } = {
	[0] = "isolada",
	[1] = "ponta",
	[2] = "ponta",
	[3] = "canto",
	[4] = "ponta",
	[5] = "reta",
	[6] = "canto",
	[7] = "t",
	[8] = "ponta",
	[9] = "canto",
	[10] = "reta",
	[11] = "t",
	[12] = "canto",
	[13] = "t",
	[14] = "t",
	[15] = "x",
}

local WallTopology004 = {}

function WallTopology004.maskOf(cell: Vector2, isWall: (Vector2) -> boolean): number
	local mask = 0
	if isWall(Vector2.new(cell.X, cell.Y - 1)) then
		mask += 1
	end
	if isWall(Vector2.new(cell.X + 1, cell.Y)) then
		mask += 2
	end
	if isWall(Vector2.new(cell.X, cell.Y + 1)) then
		mask += 4
	end
	if isWall(Vector2.new(cell.X - 1, cell.Y)) then
		mask += 8
	end
	return mask
end

function WallTopology004.variantOf(mask: number): string
	return VARIANT_BY_MASK[mask] or "isolada"
end

function WallTopology004.evaluate(cells: { Vector2 }, isWall: (Vector2) -> boolean): { TopologyCell }
	local out: { TopologyCell } = {}
	for _, cell in cells do
		local mask = WallTopology004.maskOf(cell, isWall)
		table.insert(out, {
			cell = cell,
			mask = mask,
			variant = WallTopology004.variantOf(mask),
		})
	end
	return out
end

function WallTopology004.setChecker(walls: { [string]: boolean }): (Vector2) -> boolean
	return function(cell: Vector2): boolean
		return walls[`{cell.X},{cell.Y}`] == true
	end
end

return WallTopology004
