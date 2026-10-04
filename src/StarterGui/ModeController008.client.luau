--!strict
-- ModeController008 (SPEC-008): botões da toolbar 007 + teclas 1/2 alternam o modo.
-- Atualiza o estado, destaca o botão ativo e emite ON_BUILD_MODE_CHANGED.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Common = ReplicatedStorage:WaitForChild("Common")
local BuildModeState008 = require(Common:WaitForChild("BuildModeState008"))
local OnBuildModeChanged008 = require(Common:WaitForChild("OnBuildModeChanged008"))

local LOCAL_PLAYER = Players.LocalPlayer
local ACTIVE_COLOR = Color3.fromRGB(0, 200, 0)
local IDLE_COLOR = Color3.fromRGB(255, 255, 255)

local playerGui = LOCAL_PLAYER:WaitForChild("PlayerGui")
local buildUI = playerGui:WaitForChild("BuildUI")
local toolbar = buildUI:WaitForChild("ModeToolbar")
local chaoButton = toolbar:WaitForChild("ModeChao")
local paredeButton = toolbar:WaitForChild("ModeParede")

local function highlight()
	if not chaoButton:IsA("TextButton") or not paredeButton:IsA("TextButton") then
		return
	end
	local mode = BuildModeState008.get()
	chaoButton.BackgroundColor3 = if mode == "chao" then ACTIVE_COLOR else IDLE_COLOR
	paredeButton.BackgroundColor3 = if mode == "parede" then ACTIVE_COLOR else IDLE_COLOR
end

local function requestMode(mode: "chao" | "parede")
	local previous = BuildModeState008.get()
	if previous == mode then
		return
	end
	BuildModeState008.set(mode)
	highlight()
	OnBuildModeChanged008.fire({
		player_id = LOCAL_PLAYER.Name,
		new_mode = mode,
		previous_mode = previous,
	})
	print(`[ON_BUILD_MODE_CHANGED] {previous} -> {mode}`)
end

if chaoButton:IsA("TextButton") then
	chaoButton.MouseButton1Click:Connect(function()
		requestMode("chao")
	end)
end
if paredeButton:IsA("TextButton") then
	paredeButton.MouseButton1Click:Connect(function()
		requestMode("parede")
	end)
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.One then
		requestMode("chao")
	elseif input.KeyCode == Enum.KeyCode.Two then
		requestMode("parede")
	end
end)

highlight()
