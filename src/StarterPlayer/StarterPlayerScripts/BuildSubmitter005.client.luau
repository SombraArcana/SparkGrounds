--!strict
-- BuildSubmitter005 (SPEC-005): no MouseUp envia só as válidas; ESC/botão direito cancela sem custo.
-- Feedback do servidor via print feio (UI real = spec futura).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Common = ReplicatedStorage:WaitForChild("Common")
local BuildRemotes005 = require(Common:WaitForChild("BuildRemotes005"))
local OnDragAreaUpdated001 = require(Common:WaitForChild("OnDragAreaUpdated001"))
local OnSelectionValidated002 = require(Common:WaitForChild("OnSelectionValidated002"))

local PREVIEW_FOLDER = "Preview003"

local LOCAL_PLAYER = Players.LocalPlayer
local remote = BuildRemotes005.getClient()

local lastValidated: OnSelectionValidated002.SelectionValidatedPayload? = nil
local lastMode: "chao" | "parede" = "chao"

local function clearPreviewFolder()
	local folder = Workspace:FindFirstChild(PREVIEW_FOLDER)
	if folder then
		for _, child in folder:GetChildren() do
			child.Parent = nil
		end
	end
end

local function cancel(reason: string)
	lastValidated = nil
	clearPreviewFolder()
	print(`[ON_BUILD_REQUEST_SUBMITTED] cancelado ({reason}), sem custo`)
end

OnDragAreaUpdated001.onEvent(function(payload)
	lastMode = payload.mode
end)

OnSelectionValidated002.onEvent(function(payload)
	lastValidated = payload
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end
	local cached = lastValidated
	lastValidated = nil
	if not cached or #cached.valid_cells == 0 then
		return
	end
	local playerId = if LOCAL_PLAYER then LOCAL_PLAYER.Name else "studio"
	remote:FireServer({
		player_id = playerId,
		cells = cached.valid_cells,
		mode = lastMode,
		total_cost = cached.total_cost,
	})
	print(`[ON_BUILD_REQUEST_SUBMITTED] enviado {#cached.valid_cells} células custo={cached.total_cost}`)
end)

UserInputService.InputBegan:Connect(function(_input, _processed)
	local isCancelKey = _input.KeyCode == Enum.KeyCode.Escape
	local isCancelClick = _input.UserInputType == Enum.UserInputType.MouseButton2
	if not isCancelKey and not isCancelClick then
		return
	end
	cancel(if isCancelKey then "ESC" else "botão direito")
end)

remote.OnClientEvent:Connect(function(result: BuildRemotes005.BuildResultPayload)
	if result.accepted then
		print(`[ON_BUILD_REQUEST_SUBMITTED] servidor APROVOU custo={result.total_cost}`)
	else
		print(`[ON_BUILD_REQUEST_SUBMITTED] servidor REJEITOU: {result.reason}`)
	end
end)
