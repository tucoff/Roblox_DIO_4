local ProximityPromptService = game: GetService("ProximityPromptService")
local PlayerModule = require(game:GetService("ServerStorage").Modules.PlayerModule)
local PlayerInventoryUpdated:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerInventoryUpdated
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://16789528850"

local PROXIMITY_ACTION = "Mining"
local isMining = false

local function playMiningSound (mineral)
    local pitch = {
        ["Stone"] = 1,
        ["Gold"] = 2,
    }
    
    wait(0.5)
    local miningSound = Instance.new("Sound", game:GetService("Workspace"))
    miningSound.SoundId = "rbxassetid://5772362759"
    miningSound.Pitch = pitch[mineral]
    miningSound.Parent = workspace
    miningSound:Play()
end

local function onPromptTriggered (promptObject, player)
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end

    local miningModel:Instance = promptObject.Parent
    local miningValue = miningModel:FindFirstChildWhichIsA("IntValue")

    PlayerModule.AddToInventory(player, miningValue.Name, miningValue.Value)
    PlayerInventoryUpdated:FireClient(player,PlayerModule.GetInventory(player))
    miningModel:Destroy()
end


local function onPromptHoldEnded(promptObject, player: Player)
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end
    isMining = false
end

local function onPromptHoldBegan(promptObject, player: Player)
    wait(0.5)
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end
    
    isMining = true
    local char = player.Character
    local humanoid = char.Humanoid

    local humanoidAnimator:Animator = humanoid.Animator
    local animationTrack:AnimationTrack = humanoidAnimator:LoadAnimation(animation)
    while isMining do
        animationTrack:Play()
        playMiningSound(promptObject.Parent:FindFirstChildWhichIsA("IntValue").Name)
        wait(0.5)
    end
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)
ProximityPromptService.PromptButtonHoldBegan:Connect(onPromptHoldBegan)
ProximityPromptService.PromptButtonHoldEnded:Connect(onPromptHoldEnded)