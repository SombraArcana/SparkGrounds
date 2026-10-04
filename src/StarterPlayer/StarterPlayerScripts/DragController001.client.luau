--!strict
-- DragController001 (SPEC-001): MouseMove durante arrasto vira ON_DRAG_AREA_UPDATED.
-- Só fire quando current_cell muda, máx 1/frame (leitura no RenderStepped). Sem preview/servidor.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Common = ReplicatedStorage:WaitForChild("Common")
local DragArea001 = require(Common:WaitForChild("DragArea001"))
local OnDragAreaUpdated001 = require(Common:WaitForChild("OnDragAreaUpdated001"))
local BuildModeState008 = require(Common:WaitForChild("BuildModeState008"))

local LOCAL_PLAYER = Players.LocalPlayer
local RAY_DISTANCE = 1000
local GROUND_Y = 0

local dragging = false
local mode: "chao" | "parede" = "chao"
local startCell: Vector2? = nil
local lastCurrent: Vector2? = nil

local function getMouseWorldPosition(camera: Camera): Vector3?
	local mousePos = UserInputService:GetMouseLocation()
	local ray = camera:ScreenPointToRay(mousePos.X, mousePos.Y)
	local result = Workspace:Raycast(ray.Origin, ray.Direction * RAY_DISTANCE)
	if result then
		return result.Position
	end
	if ray.Direction.Y < -1e-6 then
		local t = (GROUND_Y - ray.Origin.Y) / ray.Direction.Y
		if t > 0 and t <= RAY_DISTANCE then
			return ray.Origin + ray.Direction * t
		end
	end
	return nil
end

local function setDragging(value: boolean)
	if value == dragging then
		return
	end
	dragging = value
	if not dragging then
		startCell = nil
		lastCurrent = nil
	end
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local camera = Workspace.CurrentCamera
		if not camera then
			return
		end
		local worldPos = getMouseWorldPosition(camera)
		if worldPos then
			local cell = DragArea001.toCell(worldPos.X, worldPos.Z)
			startCell = cell
			lastCurrent = cell
			setDragging(true)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		setDragging(false)
	end
end)

RunService.RenderStepped:Connect(function()
	if not dragging or not startCell then
		return
	end
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local worldPos = getMouseWorldPosition(camera)
	if not worldPos then
		return
	end
	local current = DragArea001.toCell(worldPos.X, worldPos.Z)
	if lastCurrent and current == lastCurrent then
		return
	end
	lastCurrent = current

	-- SPEC-008: fonte única do modo é o BuildModeState008.
	mode = BuildModeState008.get()
	local playerId = if LOCAL_PLAYER then LOCAL_PLAYER.Name else "studio"
	OnDragAreaUpdated001.fire({
		player_id = playerId,
		start_cell = startCell,
		current_cell = current,
		mode = mode,
		timestamp = os.clock(),
	})
	print(`[ON_DRAG_AREA_UPDATED] {mode} start=({startCell.X},{startCell.Y}) current=({current.X},{current.Y})`)
end)

local DragController001 = {}

-- TODO legado (SPEC-008): mantido por compatibilidade; delega para a fonte única.
function DragController001.setMode(newMode: "chao" | "parede")
	BuildModeState008.set(newMode)
	mode = newMode
end

return DragController001
