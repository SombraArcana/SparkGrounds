--!strict
-- ResourceCounter009 (SPEC-009): ouve ON_RESOURCE_UPDATED e reflete no contador da 007.
-- Não altera a 007; atualiza via WaitForChild. Sem lógica de economia aqui.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local ResourceRemotes009 = require(Common:WaitForChild("ResourceRemotes009"))

local LOCAL_PLAYER = Players.LocalPlayer
local remote = ResourceRemotes009.getClient()

local function getCounter(): TextLabel?
	local playerGui = LOCAL_PLAYER:FindFirstChildOfClass("PlayerGui")
	if not playerGui then
		return nil
	end
	local buildUI = playerGui:FindFirstChild("BuildUI")
	if not buildUI then
		return nil
	end
	local counter = buildUI:FindFirstChild("ResourceCounter")
	if counter and counter:IsA("TextLabel") then
		return counter
	end
	return nil
end

remote.OnClientEvent:Connect(function(payload: ResourceRemotes009.ResourceUpdatedPayload)
	if payload.player_id ~= LOCAL_PLAYER.Name then
		return
	end
	local counter = getCounter()
	if counter then
		counter.Text = `Recursos: {payload.new_amount}`
	end
	print(`[ON_RESOURCE_UPDATED] {payload.new_amount} (delta {payload.delta})`)
end)
