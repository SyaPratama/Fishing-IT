local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

-- GLOBAL UTILITIES

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players =  game:GetService("Players")
local currentPlayer = Players.LocalPlayer
print(currentPlayer)
local Utility = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
-- local Rod = Utility:WaitForChild()
local rodSignal = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/ChargeFishingRod")

while true do
    pcall( function ()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/EquipToolFromHotbar"):FireServer(1)
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/ChargeFishingRod"):InvokeServer(workspace:GetServerTimeNow())

        task.wait(1)

        local timestamp = workspace:GetServerTimeNow()

        rodSignal:InvokeServer(timestamp)

        local baseX, baseY = -0.7499996423721313, 0.991067629351885 

        x = baseX + (math.random(-500, 500) / 10000000)      
        y = baseY + (math.random(-500, 500) / 10000000)    

        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/RequestFishingMinigameStarted"):InvokeServer(x,y)


    end)
end

local args = {
	-0.5718746185302734,
	0.42538563801500523
}
game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/RequestFishingMinigameStarted"):InvokeServer(unpack(args))

game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/FishingCompleted"):FireServer()




