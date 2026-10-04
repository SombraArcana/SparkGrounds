--!strict
-- ON_PREVIEW_RENDER_REQUESTED (SPEC-003): evento client via BindableEvent.
-- Payload exato do spec, sem campos extras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type PreviewRenderPayload = {
	valid_cells: { Vector2 },
	invalid_cells: { Vector2 },
	mode: "chao" | "parede",
}

local EVENT_NAME = "ON_PREVIEW_RENDER_REQUESTED"

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

local OnPreviewRenderRequested003 = {}

function OnPreviewRenderRequested003.fire(payload: PreviewRenderPayload)
	getEvent():Fire(payload)
end

function OnPreviewRenderRequested003.onEvent(callback: (PreviewRenderPayload) -> ()): RBXScriptConnection
	return getEvent().Event:Connect(callback)
end

return OnPreviewRenderRequested003
