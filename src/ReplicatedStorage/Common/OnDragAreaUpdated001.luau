--!strict
-- ON_DRAG_AREA_UPDATED (SPEC-001): evento client via BindableEvent.
-- Payload exato do spec, sem campos extras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type DragAreaPayload = {
	player_id: string,
	start_cell: Vector2,
	current_cell: Vector2,
	mode: "chao" | "parede",
	timestamp: number,
}

local EVENT_NAME = "ON_DRAG_AREA_UPDATED"

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

local OnDragAreaUpdated001 = {}

function OnDragAreaUpdated001.fire(payload: DragAreaPayload)
	getEvent():Fire(payload)
end

function OnDragAreaUpdated001.onEvent(callback: (DragAreaPayload) -> ()): RBXScriptConnection
	return getEvent().Event:Connect(callback)
end

return OnDragAreaUpdated001
