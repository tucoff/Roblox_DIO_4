local PlayerHungerUpdated:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")
local leftBar: Frame = hud:WaitForChild("LeftBar")
local hungerUi: Frame = leftBar:WaitForChild("Hunger")
local hungerBar: Frame = hungerUi:WaitForChild("Bar")

PlayerHungerUpdated.OnClientEvent:Connect(function(hunger: number)
    hungerBar.Size = UDim2.fromScale(hunger/124,34/100)
    hungerBar.BackgroundColor3 = Color3.fromRGB(255-hunger,155+hunger, 50)
end)