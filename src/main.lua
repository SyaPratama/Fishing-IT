loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/main/config/config.lua"))()
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/main/utils/main.lua"))()

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
    Title = "Charge Rod Delay",
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
            spawn(AutoFishing)
        else
            print("🛑 Auto fishing disabled")
        end
    end
})

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
            print("🛡️ Anti Drowning enabled")
        else
            print("⚠️ Anti Drowning disabled")
        end
    end
})

TeleportTab:Section({
    Title = "Teleport Section",
    TextXAlignment = "Left",
    TextSize = 20
})

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

(function ()
    Drowning:Set(ActiveDrowning)
end)()