Version = "1.6.41"

WindUI = loadstring(game:HttpGetAsync("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

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

WindUI:Notify({
    Title = "✅ UI Loaded",
    Content = "Ready to Auto Fish",
    Duration = 2.5,
    Icon = "check"
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

function GetRandomCordinate()
    return math.random(MinCoordinateFishing * 1000, MaxCoordinateFishing * 1000) / 1000
end

function CastFishingRod()
    -- ServerTime
    local chargeTime = workspace.GetServerTimeNow()
    -- Equip Fishing Rod
    PickRod:FireServer(1)
    ChargeRod:InvokeServer(chargeTime)

    -- Delay
    task.wait(0.1)

    -- Random Coordinate
    local x = GetRandomCordinate()
    local y = GetRandomCordinate()

    print(x,y)

    local success, failed = pcall(function ()
        return FishingIndicator:InvokeServer(x,y)
    end)

    if success then
        task.spawn(
            function ()
                task.wait(ChargeRodSpeed)

                -- Current timestamp
                pcall(function ()
                  ChargedRod:InvokeServer(chargeTime)
                end)

                -- Delay 
                task.wait(0.3)
                pcall(function ()
                    FishingCompleted:FireServer()
                end)

                print("✅ Fishing completed!")
            end
        )
    else
        print("❌ Failed to start fishing:", failed)
        WindUI:Notify({
            Title = "Error",
            Content = "Failed to start fishing minigame",
            Duration = 2.5,
            Icon = "circle-x"
        })
    end
end

function AutoFishing()
    spawn(function ()
        while ActiveAutoFishing do
            CastFishingRod()
            task.wait(2.5)
        end
    end)
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/main/config/config.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/main/utils/main.lua"))()

local Main = Window:Section({
    Title = "Main",
    Opened = true,
})

local Utility = Window:Section({
    Title = "Utility",
    Opened = true,
})

-- ✅ ADD TABS — jangan pakai Locked biar bisa diklik
local HomeTab = Main:Tab({
    Title = "Home",
    Icon = "house",
    IconThemed = "Oceanic",
})

local ToolTab = Main:Tab({
    Title = "Tools",
    Icon = "wrench",
    IconThemed = "Oceanic",
})

local SettingTab = Utility:Tab({
    Title = "Settings",
    Icon = "cog",
    IconThemed = "Oceanic",
})

-- ✅ ADD SECTIONS
HomeTab:Section({
    Title = "Home Section",
    TextXAlignment = "Left",
    TextSize = 20
})

HomeTab:Section({
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 16
})

HomeTab:Slider({
    Title = "Bypass Charge Rod",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 2,
        Default = 0.1,
    },
    Callback = function(v)
        ChargeRodSpeed = v
    end
})

HomeTab:Toggle({
    Title = "Auto Fishing",
    Desc = "Activated Auto Fishing",
    Icon = "fish",
    Type = "Checkbox",
    Default = false,
    Callback = function(v)
        ActiveAutoFishing = v
        if v then
            AutoFishing()  
        end
    end
})

ToolTab:Section({
    Title = "Tools Section",
    TextXAlignment = "Left",
    TextSize = 20
})

SettingTab:Section({
    Title = "Setting Section",
    TextXAlignment = "Left",
    TextSize = 20
})
