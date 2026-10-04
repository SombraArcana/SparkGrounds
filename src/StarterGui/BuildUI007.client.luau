--!strict
-- BuildUI007 (SPEC-007): monta a ScreenGui mínima ao entrar no jogo e emite ON_UI_INITIALIZED.
-- Toolbar e contador são estáticos (lógica real: 008/009/010). Não bloqueia câmera nem movimento.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local OnUIInitialized007 = require(Common:WaitForChild("OnUIInitialized007"))

local GUI_NAME = "BuildUI"

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild(GUI_NAME) then
	return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local toolbar = Instance.new("Frame")
toolbar.Name = "ModeToolbar"
toolbar.AnchorPoint = Vector2.new(0.5, 1)
toolbar.Position = UDim2.new(0.5, 0, 1, -16)
toolbar.Size = UDim2.fromOffset(280, 48)
toolbar.BackgroundTransparency = 0.3
toolbar.Active = false
toolbar.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 8)
layout.Parent = toolbar

local chaoButton = Instance.new("TextButton")
chaoButton.Name = "ModeChao"
chaoButton.Text = "Chão"
chaoButton.Size = UDim2.fromOffset(128, 36)
chaoButton.Parent = toolbar

local paredeButton = Instance.new("TextButton")
paredeButton.Name = "ModeParede"
paredeButton.Text = "Parede"
paredeButton.Size = UDim2.fromOffset(128, 36)
paredeButton.Parent = toolbar

local counter = Instance.new("TextLabel")
counter.Name = "ResourceCounter"
counter.Text = "Recursos: --"
counter.AnchorPoint = Vector2.new(0, 0)
counter.Position = UDim2.fromOffset(16, 16)
counter.Size = UDim2.fromOffset(200, 32)
counter.BackgroundTransparency = 0.3
counter.Active = false
counter.Parent = screenGui

screenGui.Parent = playerGui

local playerId = player.Name
OnUIInitialized007.fire({
	player_id = playerId,
	timestamp = os.clock(),
})
print(`[ON_UI_INITIALIZED] {playerId}`)
