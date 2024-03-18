local applemancyRemoteEvent = game:GetService("ReplicatedStorage").Network.Applemancy
local contextActionService = game:GetService("ContextActionService")

local ACTION_KEY = Enum.KeyCode.R
local GAMEPAD_ACTION_KEY = Enum.KeyCode.ButtonR1

local function dropApple()
	applemancyRemoteEvent:FireServer()
end

local function handleDropAppleInput(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		dropApple()
	end
end

contextActionService:BindAction("DropApple", handleDropAppleInput, true, ACTION_KEY, GAMEPAD_ACTION_KEY)
contextActionService:SetPosition("DropApple", UDim2.new(1, -70, 0, 10))
contextActionService:SetTitle("DropApple", "Apple!")