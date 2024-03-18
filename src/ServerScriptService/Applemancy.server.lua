local applemancyRemoteEvent = game:GetService("ReplicatedStorage").Network.Applemancy
local appleFolder = game:GetService("ReplicatedStorage").Prefabs
local appleTemplate = appleFolder.Apple

applemancyRemoteEvent.OnServerEvent:Connect(function(player)
	local apple = appleTemplate:Clone()
	apple.CFrame = player.Character.PrimaryPart.CFrame
	apple.Parent = workspace.Food
end)
