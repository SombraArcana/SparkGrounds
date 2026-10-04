--!strict
-- ON_WALL_TOPOLOGY_EVALUATED (SPEC-004): evento client via BindableEvent, um fire por célula.
-- Payload exato do spec, sem campos extras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type WallTopologyPayload = {
	cell: Vector2,
	mask: number,
	variant: string,
}

local EVENT_NAME = "ON_WALL_TOPOLOGY_EVALUATED"

local function getEvent(): BindableEvent
	local existing = ReplicatedStorage:FindFirstChild(EVENT_NAME)
	if existing and existing:IsA("BindableEvent") then
		return existing
	end
	local created = Instance.new("BindableEvent")
	created.Name = EVENT_NAME
	created.Parent = ReplicatedStorage
	return created
end

local OnWallTopologyEvaluated004 = {}

function OnWallTopologyEvaluated004.fire(payload: WallTopologyPayload)
	getEvent():Fire(payload)
end

function OnWallTopologyEvaluated004.onEvent(callback: (WallTopologyPayload) -> ()): RBXScriptConnection
	return getEvent().Event:Connect(callback)
end

return OnWallTopologyEvaluated004
