local Players = game:GetService("Players")
local PlayerModule = require(game:GetService("ServerStorage").Modules.PlayerModule)
local PlayerLoaded:BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerLoaded
local PlayerUnloaded:BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerUnloaded
local PlayerHungerUpdated:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated

local function coreLoop(player: Player)
    local isRunning = true 

    PlayerUnloaded.Event:Connect(function(PlayerUnloaded: Player)
        if PlayerUnloaded == player then    
            isRunning = false
        end
    end)

    while true do
        if not isRunning then
            break
        end

        if PlayerModule.IsLoaded(player) then        
            local currentHunger = PlayerModule.GetHunger(player)
            PlayerModule.SetHunger(player,currentHunger - 1)
            PlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))
        end

        wait(4)
    end
end

local function onPlayerLoaded(player: Player)
    spawn(function()
        coreLoop(player)
    end)
end

PlayerLoaded.Event:Connect(onPlayerLoaded)