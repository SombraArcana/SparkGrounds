--!strict
-- BuildServer005 (SPEC-005): autoridade final. Nunca confia no cliente:
-- revalida limites, colisões e custo, e só debita se aprovar. Estado stub feio em memória.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Validator002 = require(Common:WaitForChild("Validator002"))
local BuildRemotes005 = require(Common:WaitForChild("BuildRemotes005"))

-- Estado autoritativo stub (sem DataStore, sem grid real).
local occupied: { [string]: boolean } = {}
local balances: { [string]: number } = {}
local DEFAULT_BALANCE = 100
local COST_PER_TILE = 10

local remote = BuildRemotes005.ensureServer()

local function getBalance(playerId: string): number
	local balance = balances[playerId]
	if balance == nil then
		balance = DEFAULT_BALANCE
		balances[playerId] = balance
	end
	return balance
end

remote.OnServerEvent:Connect(function(player: Player, payload: BuildRemotes005.BuildRequestPayload)
	local playerId = player.Name
	if payload.player_id ~= playerId then
		remote:FireClient(player, { accepted = false, reason = "player_id divergente", total_cost = 0 })
		return
	end
	if #payload.cells == 0 then
		remote:FireClient(player, { accepted = false, reason = "nenhuma célula", total_cost = 0 })
		return
	end

	local ctx: Validator002.ValidationContext = {
		boundsMin = Vector2.new(0, 0),
		boundsMax = Vector2.new(63, 63),
		occupied = occupied,
		tileAt = nil,
		buildTile = "default",
		costPerTile = COST_PER_TILE,
		balance = getBalance(playerId),
	}
	local result = Validator002.validate(payload.cells, ctx)

	if #result.invalid_cells > 0 then
		remote:FireClient(player, {
			accepted = false,
			reason = `revalidacao: {#result.invalid_cells} células inválidas`,
			total_cost = result.total_cost,
		})
		print(`[ON_BUILD_REQUEST_SUBMITTED] REJEITADO {playerId}: {#result.invalid_cells} inválidas`)
		return
	end
	if result.total_cost ~= payload.total_cost then
		remote:FireClient(player, {
			accepted = false,
			reason = `custo divergente (cliente={payload.total_cost} servidor={result.total_cost})`,
			total_cost = result.total_cost,
		})
		print(`[ON_BUILD_REQUEST_SUBMITTED] REJEITADO {playerId}: custo divergente`)
		return
	end

	for _, cell in payload.cells do
		occupied[`{cell.X},{cell.Y}`] = true
	end
	balances[playerId] = getBalance(playerId) - result.total_cost
	remote:FireClient(player, { accepted = true, reason = "ok", total_cost = result.total_cost })
	print(`[ON_BUILD_REQUEST_SUBMITTED] APROVADO {playerId}: {#payload.cells} células custo={result.total_cost}`)
end)
