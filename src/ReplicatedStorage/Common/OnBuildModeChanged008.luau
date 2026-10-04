--!strict
-- ON_BUILD_MODE_CHANGED (SPEC-008): evento client via BindableEvent.
-- Payload exato do spec, sem campos extras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type BuildModeChangedPayload = {
	player_id: string,
	new_mode: "chao" | "parede",
	previous_mode: "chao" | "parede",
}

local EVENT_NAME = "ON_BUILD_MODE_CHANGED"

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

local OnBuildModeChanged008 = {}

function OnBuildModeChanged008.fire(payload: BuildModeChangedPayload)
	getEvent():Fire(payload)
end

function OnBuildModeChanged008.onEvent(callback: (BuildModeChangedPayload) -> ()): RBXScriptConnection
	return getEvent().Event:Connect(callback)
end

return OnBuildModeChanged008
