ReplicatedStorage = game:GetService("ReplicatedStorage")
Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild(
    "net")
RequestMiniGame = Net:WaitForChild("RF/RequestFishingMinigameStarted")
SellAllItem = Net:WaitForChild("RF/SellAllItems")

SellAllItem:InvokeServer()