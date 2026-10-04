--!strict
-- ResourceLedger009 (SPEC-009): dono do saldo no servidor, sem `game` (callback injeta o transporte).
-- Todo adjust emite {player_id, new_amount, delta}. Delta zero é permitido, sem erro.

export type ChangeCallback = (player_id: string, new_amount: number, delta: number) -> ()

local ResourceLedger009 = {}
ResourceLedger009.__index = ResourceLedger009

function ResourceLedger009.new(onChanged: ChangeCallback, defaultBalance: number?): any
	return setmetatable({
		_onChanged = onChanged,
		_default = defaultBalance or 100,
		_balances = {},
	}, ResourceLedger009)
end

function ResourceLedger009:get(playerId: string): number
	local balance = self._balances[playerId]
	if balance == nil then
		balance = self._default
		self._balances[playerId] = balance
	end
	return balance
end

function ResourceLedger009:set(playerId: string, amount: number): number
	local previous = self:get(playerId)
	self._balances[playerId] = amount
	self._onChanged(playerId, amount, amount - previous)
	return amount
end

function ResourceLedger009:adjust(playerId: string, delta: number): number
	return self:set(playerId, self:get(playerId) + delta)
end

return ResourceLedger009
