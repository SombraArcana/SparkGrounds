--!strict
-- BuildRemotes005 (SPEC-005): transporte do ON_BUILD_REQUEST_SUBMITTED.
-- RemoteEvent criado pelo SERVIDOR (objeto de client não replica). Cliente usa WaitForChild.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type BuildRequestPayload = {
	player_id: string,
	cells: { Vector2 },
	mode: "chao" | "parede",
	total_cost: number,
}

export type BuildResultPayload = {
	accepted: boolean,
	reason: string,
	total_cost: number,
}

local EVENT_NAME = "ON_BUILD_REQUEST_SUBMITTED"

local BuildRemotes005 = {}

function BuildRemotes005.ensureServer(): RemoteEvent
	local existing = ReplicatedStorage:FindFirstChild(EVENT_NAME)
	if existing and existing:IsA("RemoteEvent") then
		return existing
	end
	local created = Instance.new("RemoteEvent")
	created.Name = EVENT_NAME
	created.Parent = ReplicatedStorage
	return created
end

function BuildRemotes005.getClient(timeout: number?): RemoteEvent
	local found = ReplicatedStorage:WaitForChild(EVENT_NAME, timeout or 10)
	assert(found and found:IsA("RemoteEvent"), "RemoteEvent ON_BUILD_REQUEST_SUBMITTED não encontrado")
	return found
end

return BuildRemotes005
