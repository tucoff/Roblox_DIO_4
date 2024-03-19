local PlayerModule = {}

-- Services
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- Constants
local PLAYER_DEFAULT_DATA = {
    hunger = 100,
    inventory = {
        Stone = 0,
        Gold = 0
    },
    level = 0,
}

-- Members
local playersCached = {}
local database = DataStoreService:GetDataStore("Survival")
local PlayerLoaded:BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerLoaded
local PlayerUnloaded:BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerUnloaded
local PlayerHungerUpdated:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated
local PlayerInventoryUpdated:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerInventoryUpdated
local PlayerLevelChanged:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerLevelChanged

-- Functions
function PlayerModule.IsLoaded(player: Player)
    return playersCached[player.UserId] and true or false
end

function PlayerModule.SetLevel(player: Player, level: number)
    playersCached[player.UserId].level = level
end

function PlayerModule.GetLevel(player: Player): number
    local level = playersCached[player.UserId].level
    return level
end

function PlayerModule.SetHunger(player: Player, hunger: number)
    playersCached[player.UserId].hunger = hunger
end

function PlayerModule.GetHunger(player: Player): number
    local hunger = playersCached[player.UserId].hunger
    
    if hunger < 0 then
        hunger = 0
    end

    if hunger > 100 then
        hunger = 100
    end

    return hunger
end

function PlayerModule.SetInventory(player: Player, inventory)
    playersCached[player.UserId].inventory = inventory
end

function PlayerModule.GetInventory(player: Player)
    local inventory = playersCached[player.UserId].inventory
    return inventory
end

function PlayerModule.AddToInventory(player: Player, key: string, value: number)
    local inventory = PlayerModule.GetInventory(player)

    if inventory[key] then
        inventory[key] += value
        return
    end

    inventory[key] = value
end

local function onPlayerAdded(player: Player)
    player.CharacterAdded:Connect(function(_)
        ---MANUAL RESET
        --database:SetAsync(player.UserId, false)
        local data = database:GetAsync(player.UserId)
        if not data then
            data = PLAYER_DEFAULT_DATA
        end
        playersCached[player.UserId] = data
        PlayerLoaded:Fire(player)
        
        PlayerHungerUpdated:FireClient(player,PlayerModule.GetHunger(player))
        PlayerInventoryUpdated:FireClient(player,PlayerModule.GetInventory(player))
        PlayerLevelChanged:FireClient(player,PlayerModule.GetLevel(player))
    end)
end
local function onPlayerRemoving(player: Player)
    PlayerUnloaded:Fire(player)
    database:SetAsync(player.UserId, playersCached[player.UserId])
    playersCached[player.UserId] = nil
end

-- Connection
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return PlayerModule