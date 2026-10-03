local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lift = ReplicatedStorage.lift

local actions = {
	["Lift"] = function(...)
		-- body
	end,
}

-- estrutura de remotes..
lift.OnServerEvent:Connect(function(action)
	local ActionHandler = actions[action]
	if typeof(ActionHandler) == "function" then
		ActionHandler()
	end
end)
