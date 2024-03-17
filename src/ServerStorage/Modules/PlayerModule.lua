local PlayerModule = {}

-- Services
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- Constants
local PLAYER_DEFAULT_DATA = {
    hunger = 100,
    inventory = {},
    level = 0,
}

-- Members
local playersCached = {}
local database = DataStoreService:GetDataStore("Survival")
local PlayerLoaded:BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerLoaded
local PlayerUnloaded:BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerUnloaded

-- Functions
function PlayerModule.IsLoaded(player: Player)
    return playersCached[player.UserId] and true or false
end

function PlayerModule.SetHunger(player: Player, hunger: number): number
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

local function onPlayerAdded(player: Player)
    player.CharacterAdded:Connect(function(_)
        local data = database:GetAsync(player.UserId)
        if not data then
            data = PLAYER_DEFAULT_DATA
        end
        playersCached[player.UserId] = data
        PlayerLoaded:Fire(player)
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