--!strict
-- SELECAO_DE_AREA_ATUALIZADA: evento client (BindableEvent sob ReplicatedStorage).
-- Payload exato do spec001, sem campos extras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type SelectionPayload = {
	player_id: string,
	tipo_construcao: "floor" | "wall",
	grid_inicio: { x: number, z: number },
	grid_final: { x: number, z: number },
	celulas_selecionadas: { { x: number, z: number } },
	timestamp: number,
}

local EVENT_NAME = "SELECAO_DE_AREA_ATUALIZADA"

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

local SelectionEvent = {}

function SelectionEvent.fire(payload: SelectionPayload)
	getEvent():Fire(payload)
end

function SelectionEvent.onEvent(callback: (SelectionPayload) -> ()): RBXScriptConnection
	return getEvent().Event:Connect(callback)
end

return SelectionEvent
