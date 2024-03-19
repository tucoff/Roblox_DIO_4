local PlayerModule = require(game:GetService("ServerStorage").Modules.PlayerModule)
local ProximityPromptService = game:GetService("ProximityPromptService")
local PlayerInventoryUpdated:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerInventoryUpdated
local PlayerLevelChanged:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerLevelChanged
local PROXIMITY_ACTION = "Upgrade"

local UPGRADE_REQUIRED = {
    [1] = {
        Stone = 0,
        Gold = 10
    },
    [2] = {
        Stone = 50,
        Gold = 20
    },
    [3] = {
        Stone = 500,
        Gold = 100
    }
}

local function onPromptTriggered(promptObject:ProximityPrompt, player)
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end

    local level = PlayerModule.GetLevel(player)
    local inventory = PlayerModule.GetInventory(player)
    local required = UPGRADE_REQUIRED[level+1]

    if level >= 3 then
        level = 3
        return
    end

    if inventory.Stone < required.Stone then
        return
    end

    if inventory.Gold < required.Gold then
        return
    end

    inventory.Stone -= required.Stone
    inventory.Gold -= required.Gold

    PlayerModule.SetLevel(player, level+1)
    PlayerInventoryUpdated:FireClient(player,inventory)
    PlayerLevelChanged:FireClient(player, PlayerModule.GetLevel(player))
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)