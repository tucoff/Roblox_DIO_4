local ProximityPromptService = game: GetService("ProximityPromptService")
local PlayerModule = require(game:GetService("ServerStorage").Modules.PlayerModule)
local PlayerHungerUpdated:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated

local PROXIMITY_ACTION = "Eat"

local function playEatingSound ()
    local eatingSound = Instance.new("Sound", game:GetService("Workspace"))
    eatingSound.SoundId = "rbxassetid://625712280"
    local random = Random.new()
    local value = random:NextNumber(0.5,1)

    eatingSound.Pitch = value
    eatingSound.Parent = workspace
    eatingSound:Play()
end

local function onPromptTriggered (promptObject, player)
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end
    
    playEatingSound()

    local foodModel = promptObject.Parent
    local foodValue = foodModel.Food.Value
    local currentHunger = PlayerModule.GetHunger(player)
    PlayerModule.SetHunger(player,currentHunger+foodValue)
    PlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))
    foodModel:Destroy()
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)