-- Utilities
HttpService = game:GetService("HttpService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Players = game:GetService("Players")
CurrentPlayer = Players.LocalPlayer
Remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")
PickRod = Remote:WaitForChild("RE/EquipToolFromHotbar")
ChargedRod = Remote:WaitForChild("RF/ChargeFishingRod")
FishingIndicator = Remote:WaitForChild("RF/RequestFishingMinigameStarted")
FishingCompleted = Remote:WaitForChild("RE/FishingCompleted")
SoundService = game:GetService("SoundService")
UserSettings():GetService("UserGameSettings")
Meta = getrawmetatable(game)

-- Data
IslandJSON = game:HttpGetAsync(
    "https://raw.githubusercontent.com/SyaPratama/Fishing-IT/refs/heads/main/data/islands.json")
DataIslands = HttpService:JSONDecode(IslandJSON)
DataIslandsName = {}

-- Variables
ActiveAutoFishing = false
ChargeRodSpeed = 0.1
MinCoordinateFishing = -10
MaxCoordinateFishing = 10
CoordRange = 0.02
MiniGameDelay = 1.5
BaseX = -0.75
BaseY = 0.99
ActiveDrowning = true
OldNameCall = Meta.__namecall

-- Character and Humanoid setup
Character = CurrentPlayer.Character or CurrentPlayer.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid", 10)

function SetupDrowningHook()
    local Meta = getrawmetatable(game)
    setreadonly(Meta, false)

    OldNameCall = Meta.__namecall

    Meta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if ActiveDrowning and method == "FireServer" and self.name == "URE/UpdateOxygen" then
            print("Jalan")
            return nil
        end
        return OldNameCall(self,...)
    end)

    setreadonly(Meta, true)
end

SetupDrowningHook()
