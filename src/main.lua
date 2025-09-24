loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/refs/heads/main/config/config.lua"))()
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/refs/heads/main/utils/main.lua"))()
-- UI Sections
local Main = Window:Section({
    Title = "Main",
    Opened = true,
})

local Utility = Window:Section({
    Title = "Utility",
    Opened = true,
})

-- Tabs
local HomeTab = Main:Tab({
    Title = "Home",
    Icon = "house",
    IconThemed = "Oceanic",
})

local TeleportTab = Main:Tab({
    Title = "Teleport",
    Icon = "map",
    IconThemed = "Oceanic"
})

local ShopTab = Main:Tab({
    Title = "Shop",
    Icon = "shopping-cart",
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

-- UI Elements
HomeTab:Section({
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 16
})

HomeTab:Input({
    Title = "Bypass Charge Speed",
    Desc = "bypassing charge fishing",
    Value = tostring(MiniGameDelay),
    Type = "Input",
    Callback = function(v)
        MiniGameDelay = tonumber(v)
    end
})

local AutoFishing = HomeTab:Toggle({
    Title = "Auto Fishing",
    Desc = "Activated Auto Fishing",
    Icon = "fish",
    Type = "Checkbox",
    Default = false,
    Callback = function(v)
        ActiveAutoFishing = v
        if v then
            spawn(AutoFishing)
        else
            print("🛑 Auto fishing disabled")
        end
    end
})

AutoFishing:Set(ActiveAutoFishing)

HomeTab:Section({
    Title = "Sea",
    TextXAlignment = "Left",
    TextSize = 16
})

local Drowning = HomeTab:Toggle({
    Title = "Anti Drowning",
    Desc = "Prevents your character from drowning",
    Icon = "fish",
    Type = "Checkbox",
    Default = true,
    Callback = function(v)
        ActiveDrowning = v
        if v then
            SetupDrowningHook()
            print("🛡️ Anti Drowning enabled")
        else
            RemoveDrowningHook()
            print("⚠️ Anti Drowning disabled")
        end
    end
})

Drowning:Set(ActiveDrowning)

if ActiveDrowning then
    SetupDrowningHook()
end

TeleportTab:Section({
    Title = "Teleport",
    TextXAlignment = "Left",
    TextSize = 16
})

TeleportTab:Dropdown({
    Title = "Teleport",
    Values = DataIslandsName,
    Value = DataIslandsName[5],
    SearchBarEnabled = true,
    Callback = function(option)
        return TeleportPlayerToIsland(option)
    end
})