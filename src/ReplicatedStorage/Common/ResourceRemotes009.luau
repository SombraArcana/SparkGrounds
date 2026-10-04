--!strict
-- ON_RESOURCE_UPDATED, transporte (SPEC-009): RemoteEvent server -> client.
-- Criado pelo SERVIDOR. Cliente usa WaitForChild.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type ResourceUpdatedPayload = {
	player_id: string,
	new_amount: number,
	delta: number,
}

local EVENT_NAME = "ON_RESOURCE_UPDATED"

local ResourceRemotes009 = {}

function ResourceRemotes009.ensureServer(): RemoteEvent
	local existing = ReplicatedStorage:FindFirstChild(EVENT_NAME)
	if existing and existing:IsA("RemoteEvent") then
		return existing
	end
	local created = Instance.new("RemoteEvent")
	created.Name = EVENT_NAME
	created.Parent = ReplicatedStorage
	return created
end

function ResourceRemotes009.getClient(timeout: number?): RemoteEvent
	local found = ReplicatedStorage:WaitForChild(EVENT_NAME, timeout or 10)
	assert(found and found:IsA("RemoteEvent"), "RemoteEvent ON_RESOURCE_UPDATED não encontrado")
	return found
end

return ResourceRemotes009
