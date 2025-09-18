Version = "1.6.41"

WindUI = loadstring(game:HttpGetAsync("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

-- Window Theme
WindUI:AddTheme({
    Name = "Oceanic",
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(10, 26, 42),
    Button = Color3.fromRGB(13, 42, 64),
    Icon = Color3.fromRGB(128, 208, 255),
    Outline = Color3.fromRGB(51, 170, 255),
    Placeholder = Color3.fromRGB(102, 179, 255),
    Dialog = Color3.fromRGB(15, 37, 58),
    Input = Color3.fromRGB(12, 32, 53)
})

-- Initialize Windows
Window = WindUI:CreateWindow({
    Title = "Fishing Hub",
    Icon = "fish", -- 🐟 Valid Lucide icon
    Author = "By Tama",
    Folder = "Fishing",

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Acrylic = true,
    Transparent = true,
    Theme = "Oceanic",
    Resizable = true,
    SideBarWidth = 175,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("User button clicked!")
        end,
    },
})

WindUI:Notify({
    Title = "UI Loaded",
    Content = "Ready to Auto Fish",
    Duration = 2,
})

-- Utilities

ReplicatedStorage = game:GetService("ReplicatedStorage")
Players = game:GetService("Players")
CurrentPlayer = Players.LocalPlayer
Remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
PickRod = Remote:WaitForChild("RE/EquipToolFromHotbar")
ChargedRod = Remote:WaitForChild("RF/ChargeFishingRod")
FishingIndicator = Remote:WaitForChild("RF/RequestFishingMinigameStarted")
FishingCompleted = Remote:WaitForChild("RE/FishingCompleted")

-- Variabel
ActiveAutoFishing = false
ChargeRodSpeed = 0.1
MinCoordinateFishing = -10
MaxCoordinateFishing = 10