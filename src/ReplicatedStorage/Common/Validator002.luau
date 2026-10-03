--!strict
-- Validator002 (SPEC-002): validação pura célula por célula, sem `game`, sem UI.
-- Limites, colisão, mesmo-tipo custo 0, custo sequencial com corte no estouro do saldo.

export type ValidationContext = {
	boundsMin: Vector2,
	boundsMax: Vector2,
	occupied: { [string]: boolean },
	tileAt: ((Vector2) -> string?)?,
	buildTile: string,
	costPerTile: number,
	balance: number,
}

export type ValidationResult = {
	valid_cells: { Vector2 },
	invalid_cells: { Vector2 },
	total_cost: number,
	can_afford: boolean,
}

local Validator002 = {}

local function cellKey(cell: Vector2): string
	return `{cell.X},{cell.Y}`
end

function Validator002.validate(cells: { Vector2 }, ctx: ValidationContext): ValidationResult
	local valid: { Vector2 } = {}
	local invalid: { Vector2 } = {}
	local running = 0

	for _, cell in cells do
		local outOfBounds = cell.X < ctx.boundsMin.X
			or cell.X > ctx.boundsMax.X
			or cell.Y < ctx.boundsMin.Y
			or cell.Y > ctx.boundsMax.Y
		if outOfBounds or ctx.occupied[cellKey(cell)] then
			table.insert(invalid, cell)
		else
			local currentTile = if ctx.tileAt then ctx.tileAt(cell) else nil
			local cost = if currentTile == ctx.buildTile then 0 else ctx.costPerTile
			if running + cost > ctx.balance then
				table.insert(invalid, cell)
			else
				running += cost
				table.insert(valid, cell)
			end
		end
	end

	return {
		valid_cells = valid,
		invalid_cells = invalid,
		total_cost = running,
		can_afford = #invalid == 0,
	}
end

return Validator002
