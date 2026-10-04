--!strict
-- ON_UI_INITIALIZED (SPEC-007): evento client via BindableEvent.
-- Payload exato do spec, sem campos extras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type UIInitializedPayload = {
	player_id: string,
	timestamp: number,
}

local EVENT_NAME = "ON_UI_INITIALIZED"

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

local OnUIInitialized007 = {}

function OnUIInitialized007.fire(payload: UIInitializedPayload)
	getEvent():Fire(payload)
end

function OnUIInitialized007.onEvent(callback: (UIInitializedPayload) -> ()): RBXScriptConnection
	return getEvent().Event:Connect(callback)
end

return OnUIInitialized007
