--!strict
-- ON_BUILD_FEEDBACK_SHOWN (SPEC-010): evento client via BindableEvent + format puro.
-- Payload exato do spec, sem campos extras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type BuildFeedbackPayload = {
	player_id: string,
	success: boolean,
	message: string,
}

local EVENT_NAME = "ON_BUILD_FEEDBACK_SHOWN"

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

local OnBuildFeedbackShown010 = {}

function OnBuildFeedbackShown010.format(accepted: boolean, reason: string, totalCost: number): string
	if accepted then
		return `Construído! (-{totalCost})`
	end
	return reason
end

function OnBuildFeedbackShown010.fire(payload: BuildFeedbackPayload)
	getEvent():Fire(payload)
end

function OnBuildFeedbackShown010.onEvent(callback: (BuildFeedbackPayload) -> ()): RBXScriptConnection
	return getEvent().Event:Connect(callback)
end

return OnBuildFeedbackShown010
