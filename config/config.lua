Version = "1.6.51"

WindUI = loadstring(game:HttpGetAsync("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

WindUI:AddTheme({
    Name = "Oceanic",
    Accent = "#00b4ff",
    Text = "#ffffff",
    Background = "#0a1a2a",
    Button = "#0d2a40",
    Icon = "#80d0ff",
    Outline = "#33aaff",
    Placeholder = "#66b3ff",
    Dialog = "#0f253a",
    Input = "#0d2a40",
})

Window = WindUI:CreateWindow({
    Title = "Fishing Hub",
    Icon = "fish",
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
    ScrollBarEnabled = true,

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

local UIS = game:GetService("UserInputService")
local toggleKey = Enum.KeyCode.G

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        Window:Toggle()
    end
end)

-- Utilities
HttpService = game:GetService("HttpService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Players = game:GetService("Players")
CurrentPlayer = Players.LocalPlayer
Remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
PickRod = Remote:WaitForChild("RE/EquipToolFromHotbar")
ChargedRod = Remote:WaitForChild("RF/ChargeFishingRod")
FishingIndicator = Remote:WaitForChild("RF/RequestFishingMinigameStarted")
FishingCompleted = Remote:WaitForChild("RE/FishingCompleted")
SoundService = game:GetService("SoundService")
UserSettings():GetService("UserGameSettings")
Meta = getrawmetatable(game)

-- Data
IslandJSON = game:HttpGetAsync("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/refs/heads/main/data/islands.json")
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
Humanoid = Character:WaitForChild("Humanoid",10)