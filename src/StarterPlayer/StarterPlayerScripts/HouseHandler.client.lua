local PlayerLevelChanged:RemoteEvent = game.ReplicatedStorage.Network.PlayerLevelChanged
local homeStorage:Folder = game.ReplicatedStorage.HomeStorage

local function onPlayerLevelChanged(level)
    for _, instance in workspace.Home:GetChildren() do
        instance:Destroy()
    end

    if level >= 3 then
        level = 3
    end

    local home = homeStorage:WaitForChild(level):Clone()
    home.Parent = workspace.Home  
end

PlayerLevelChanged.OnClientEvent:Connect(onPlayerLevelChanged)