local WAIT_INTERVAL = 1/30

local minutesAfterMidnight :number

while true do
    minutesAfterMidnight = game:GetService("Lighting"):GetMinutesAfterMidnight() + 0.4
    game:GetService("Lighting"):SetMinutesAfterMidnight(minutesAfterMidnight)
    wait(WAIT_INTERVAL)
end