local PlayerInventoryUpdated:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerInventoryUpdated
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")
local leftBar: Frame = hud:WaitForChild("LeftBar")
local inventoryUi: Frame = leftBar:WaitForChild("Inventory")
local inventoryButton: TextButton = inventoryUi:WaitForChild("OpenInventory")
local inventoryScreen: Frame = hud:WaitForChild("InventoryScreen")
local inventoryScreenOriginPos = inventoryScreen.Position 
local inventoryScreenEndPos = UDim2.fromScale(-1,inventoryScreen.Position.Y.Scale)
inventoryScreen.Position = inventoryScreenEndPos
local isVisible = false
local stoneNumberLabel:TextLabel = inventoryScreen.Stone.Number
local goldNumberLabel:TextLabel = inventoryScreen.Gold.Number

inventoryButton.MouseButton1Click:Connect(function()
    local nextPos = isVisible and inventoryScreenEndPos or inventoryScreenOriginPos
    isVisible = not isVisible
    inventoryScreen:TweenPosition(nextPos)
end)

PlayerInventoryUpdated.OnClientEvent:Connect(function(inventory: table)
    stoneNumberLabel.Text = inventory.Stone and inventory.Stone or 0
    goldNumberLabel.Text = inventory.Gold and inventory.Gold or 0
end)