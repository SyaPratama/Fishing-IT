Version = "1.6.41"

WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

-- Window Theme

WindUI:AddTheme({
    Name = "Oceanic",
    Accent = Color3.fromRGB(0, 180, 255), -- Bright ocean cyan
    Text = "#FFFFFF",                     -- White text
    Background = "#0a1a2a",               -- Deep ocean blue
    Button = "#0d2a40",                   -- Darker blue button
    Icon = "#80d0ff",                     -- Light cyan icons
    Outline = "#33aaff",                  -- Glowing outline
    Placeholder = "#66b3ff",              -- Soft blue placeholder
    Dialog = "#0f253a",                   -- Slightly lighter dialog bg
    Input = "#0c2035",                    -- Input background
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
            print("🐬 User button clicked!")
        end,
    },
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