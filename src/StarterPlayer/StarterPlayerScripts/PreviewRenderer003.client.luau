--!strict
-- PreviewRenderer003 (SPEC-003): bridge ON_SELECTION_VALIDATED -> ON_PREVIEW_RENDER_REQUESTED + render via pool.
-- Só renderiza quando valid+invalid+mode mudam. Sem Create/Destroy durante o arrasto.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Common = ReplicatedStorage:WaitForChild("Common")
local DragArea001 = require(Common:WaitForChild("DragArea001"))
local PreviewPool003 = require(Common:WaitForChild("PreviewPool003"))
local OnDragAreaUpdated001 = require(Common:WaitForChild("OnDragAreaUpdated001"))
local OnSelectionValidated002 = require(Common:WaitForChild("OnSelectionValidated002"))
local OnPreviewRenderRequested003 = require(Common:WaitForChild("OnPreviewRenderRequested003"))

local FOLDER_NAME = "Preview003"
local TILE_HEIGHT = 0.2
local TILE_LIFT = 0.15
local VALID_COLOR = Color3.fromRGB(0, 255, 0)
local INVALID_COLOR = Color3.fromRGB(255, 0, 0)

local lastMode: "chao" | "parede" = "chao"
local lastRenderKey: string? = nil

local function getFolder(): Folder
	local existing = Workspace:FindFirstChild(FOLDER_NAME)
	if existing and existing:IsA("Folder") then
		return existing
	end
	local created = Instance.new("Folder")
	created.Name = FOLDER_NAME
	created.Parent = Workspace
	return created
end

local CELL_SIZE = DragArea001.CELL_SIZE
local pool = PreviewPool003.new(function()
	local part = Instance.new("Part")
	part.Name = "PreviewTile"
	part.Size = Vector3.new(CELL_SIZE, TILE_HEIGHT, CELL_SIZE)
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.Transparency = 0.5
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end)

local function cellsKey(valid: { Vector2 }, invalid: { Vector2 }, mode: string): string
	local parts: { string } = { mode, "#" .. #valid .. "/" .. #invalid }
	for _, cell in valid do
		table.insert(parts, `v{cell.X},{cell.Y}`)
	end
	for _, cell in invalid do
		table.insert(parts, `i{cell.X},{cell.Y}`)
	end
	return table.concat(parts, "|")
end

local function hideAll(folder: Folder)
	for _, child in folder:GetChildren() do
		child.Parent = nil
	end
	pool:releaseAll()
end

local function render(payload: OnPreviewRenderRequested003.PreviewRenderPayload)
	local key = cellsKey(payload.valid_cells, payload.invalid_cells, payload.mode)
	if key == lastRenderKey then
		return
	end
	lastRenderKey = key

	local folder = getFolder()
	hideAll(folder)

	for _, cell in payload.valid_cells do
		local tile: Part = pool:acquire()
		tile.Color = VALID_COLOR
		tile.Position = Vector3.new((cell.X + 0.5) * CELL_SIZE, TILE_LIFT, (cell.Y + 0.5) * CELL_SIZE)
		tile.Parent = folder
	end
	for _, cell in payload.invalid_cells do
		local tile: Part = pool:acquire()
		tile.Color = INVALID_COLOR
		tile.Position = Vector3.new((cell.X + 0.5) * CELL_SIZE, TILE_LIFT, (cell.Y + 0.5) * CELL_SIZE)
		tile.Parent = folder
	end
	print(
		`[ON_PREVIEW_RENDER_REQUESTED] {#payload.valid_cells} ok / {#payload.invalid_cells} ruim pool={pool:activeCount()}/{pool:totalCount()}`
	)
end

local function clear()
	lastRenderKey = nil
	local folder = Workspace:FindFirstChild(FOLDER_NAME)
	if folder and folder:IsA("Folder") then
		hideAll(folder)
	end
	print("[ON_PREVIEW_RENDER_REQUESTED] clear")
end

OnDragAreaUpdated001.onEvent(function(payload)
	lastMode = payload.mode
end)

OnSelectionValidated002.onEvent(function(payload)
	if #payload.cells == 0 then
		clear()
		return
	end
	OnPreviewRenderRequested003.fire({
		valid_cells = payload.valid_cells,
		invalid_cells = payload.invalid_cells,
		mode = lastMode,
	})
end)

OnPreviewRenderRequested003.onEvent(render)

local PreviewRenderer003 = {}

function PreviewRenderer003.clear()
	clear()
end

return PreviewRenderer003
