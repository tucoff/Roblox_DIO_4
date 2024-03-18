local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")
local inviteFriendsButton:TextButton = hud:WaitForChild("Invite")
local SocialService = game:GetService("SocialService")
local player = Players.LocalPlayer

-- Function to check whether the player can send an invite
local function canSendGameInvite(sendingPlayer)
	local success, canSend = pcall(function()
		return SocialService:CanSendGameInviteAsync(sendingPlayer)
	end)
	return success and canSend
end

inviteFriendsButton.MouseButton1Click:Connect(function()
    local canInvite = canSendGameInvite(player)
    if canInvite then
        local success, errorMessage = pcall(function()
            SocialService:PromptGameInvite(player)
        end)
        if not success then
            warn(errorMessage)
        end
    end
end)

