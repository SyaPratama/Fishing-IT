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
ReplicateTextEffect = Remote:WaitForChild("RE/ReplicateTextEffect")
TextNotification = Remote:WaitForChild("RE/TextNotification")
ObtainedNewFish = Remote:WaitForChild("RE/ObtainedNewFishNotification")

ObtainedNewFish.OnClientEvent:Connect(function(data)
    print("ObtainedNewFish:",data)
end)

TextNotification.OnClientEvent:Connect(function(data)
    for k, v in pairs(data) do
        print("TextNotification -", k, ":", v)
        wait(1)
    end
end)