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
Remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")
PickRod = Remote:WaitForChild("RE/EquipToolFromHotbar")
ChargedRod = Remote:WaitForChild("RF/ChargeFishingRod")
FishingIndicator = Remote:WaitForChild("RF/RequestFishingMinigameStarted")
FishingCompleted = Remote:WaitForChild("RE/FishingCompleted")
ReplicateTextEffect = Remote:WaitForChild("RE/ReplicateTextEffect")
SoundService = game:GetService("SoundService")
UserSettings():GetService("UserGameSettings")
Meta = getrawmetatable(game)

-- Data
IslandJSON = game:HttpGetAsync(
    "https://raw.githubusercontent.com/SyaPratama/Fishing-IT/refs/heads/main/data/islands.json")
DataIslands = HttpService:JSONDecode(IslandJSON)
DataIslandsName = {}

DelayJSON = game:HttpGetAsync("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/refs/heads/main/data/delay.json")
DataDelay = HttpService:JSONDecode(DelayJSON)

-- Variables
ActiveAutoFishing = false
ChargeRodSpeed = 0.1
MinCoordinateFishing = -10
MaxCoordinateFishing = 10
CoordRange = 0.02
MiniGameDelay = 2.5
ByPassMiniGame = 2.3
BaseX = -0.75
BaseY = 0.99
ActiveDrowning = true
OldNameCall = Meta.__namecall
IsWaitingForExclaim = false
FishingTask = nil


-- Character and Humanoid setup
Character = CurrentPlayer.Character or CurrentPlayer.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid", 10)


-- Anim
RodEasyReel = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("EasyFishReel")
RodEasyReelStart = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("EasyFishReelStart")
RodIdle = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("FishingRodReelIdle")
RodCharacterIdle = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations")
    :WaitForChild("FishingRodCharacterIdle2")
RodFinishChargeOneHand = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations")
    :WaitForChild("FinishChargingRod1Hand")
RodReel = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("EasyFishReelStart")
RodShake = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild(
    "CastFromFullChargePosition1Hand")
StartChargeRodOneHand = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations")
    :WaitForChild("StartChargingRod1Hand")
Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)

-- safely Load Animations
function SafeLoadAnimation(animator, animation)
    if not animation then
        warn("⚠️ Animation is nil")
        return nil
    end
    if not animation.AnimationId or animation.AnimationId == "" then
        warn("⚠️ AnimationId is missing for: " .. animation.Name)
        return nil
    end
    local track = animator:LoadAnimation(animation)
    if not track then
        warn("⚠️ Failed to load animation track for: " .. animation.Name)
    end
    return track
end

-- Load Animations Safely
RodAnimIdle = SafeLoadAnimation(Animator, RodIdle)
RodAnimShake = SafeLoadAnimation(Animator, RodShake)
RodAnimReel = SafeLoadAnimation(Animator, RodReel)