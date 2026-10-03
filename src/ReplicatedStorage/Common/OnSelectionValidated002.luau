--!strict
-- ON_SELECTION_VALIDATED (SPEC-002): evento client via BindableEvent.
-- Payload exato do spec, sem campos extras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type SelectionValidatedPayload = {
	cells: { Vector2 },
	valid_cells: { Vector2 },
	invalid_cells: { Vector2 },
	total_cost: number,
	can_afford: boolean,
}

local EVENT_NAME = "ON_SELECTION_VALIDATED"

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

local OnSelectionValidated002 = {}

function OnSelectionValidated002.fire(payload: SelectionValidatedPayload)
	getEvent():Fire(payload)
end

function OnSelectionValidated002.onEvent(callback: (SelectionValidatedPayload) -> ()): RBXScriptConnection
	return getEvent().Event:Connect(callback)
end

return OnSelectionValidated002
