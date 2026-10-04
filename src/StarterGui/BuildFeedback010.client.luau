--!strict
-- BuildFeedback010 (SPEC-010): converte a resposta do servidor em toast único temporário.
-- Assina o Remote da 005 em paralelo ao submitter (sem editá-lo). Sem empilhar.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local BuildRemotes005 = require(Common:WaitForChild("BuildRemotes005"))
local OnBuildFeedbackShown010 = require(Common:WaitForChild("OnBuildFeedbackShown010"))

local LOCAL_PLAYER = Players.LocalPlayer
local HIDE_DELAY = 3
local SUCCESS_COLOR = Color3.fromRGB(0, 200, 0)
local ERROR_COLOR = Color3.fromRGB(200, 0, 0)

local remote = BuildRemotes005.getClient()
local hideThread: thread? = nil

local function getToast(): TextLabel?
	local playerGui = LOCAL_PLAYER:FindFirstChildOfClass("PlayerGui")
	if not playerGui then
		return nil
	end
	local buildUI = playerGui:FindFirstChild("BuildUI")
	if not buildUI or not buildUI:IsA("ScreenGui") then
		return nil
	end
	local existing = buildUI:FindFirstChild("FeedbackToast")
	if existing and existing:IsA("TextLabel") then
		return existing
	end
	local toast = Instance.new("TextLabel")
	toast.Name = "FeedbackToast"
	toast.AnchorPoint = Vector2.new(0.5, 0)
	toast.Position = UDim2.new(0.5, 0, 0, 56)
	toast.Size = UDim2.fromOffset(320, 40)
	toast.BackgroundTransparency = 0.3
	toast.Visible = false
	toast.Parent = buildUI
	return toast
end

remote.OnClientEvent:Connect(function(result: BuildRemotes005.BuildResultPayload)
	local message = OnBuildFeedbackShown010.format(result.accepted, result.reason, result.total_cost)
	OnBuildFeedbackShown010.fire({
		player_id = LOCAL_PLAYER.Name,
		success = result.accepted,
		message = message,
	})

	local toast = getToast()
	if toast then
		if hideThread then
			task.cancel(hideThread)
			hideThread = nil
		end
		toast.Text = message
		toast.BackgroundColor3 = if result.accepted then SUCCESS_COLOR else ERROR_COLOR
		toast.Visible = true
		hideThread = task.delay(HIDE_DELAY, function()
			toast.Visible = false
			hideThread = nil
		end)
	end
	print(`[ON_BUILD_FEEDBACK_SHOWN] {message}`)
end)
