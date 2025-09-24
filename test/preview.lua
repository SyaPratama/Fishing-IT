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


ReplicatedStorage = game:GetService("ReplicatedStorage")
Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild(
    "net")
RequestMiniGame = Net:WaitForChild("RF/RequestFishingMinigameStarted")
SellAllItem = Net:WaitForChild("RF/SellAllItems")
SellItem = Net:WaitForChild("RF/SellItem")
UpdateAutoSellThreshold = Net:WaitForChild("RF/UpdateAutoSellThreshold")
EnchantItem = Net:WaitForChild("RE/ActivateEnchantingAltar")
DestroyEffect = Net:WaitForChild("RE/DestroyEffect")
EquipToolFromHotbar = Net:WaitForChild("RE/EquipToolFromHotbar")
ChargedRod = Net:WaitForChild("RF/ChargeFishingRod")
FavoriteItem = Net:WaitForChild("RE/FavoriteItem")
FavoriteStateChange = Net:WaitForChild("RE/FavoriteStateChanged")
FishCaught = Net:WaitForChild("RE/FishCaught")
FishComplete = Net:WaitForChild("RE/FishingCompleted")
FishStopped = Net:WaitForChild("RE/FishingStopped")
ReplicateTextEffect = Net:WaitForChild("RE/ReplicateTextEffect")
OxygenUpdate = Net:WaitForChild("URE/UpdateOxygen")
CancelInput = Net:WaitForChild("RF/CancelFishingInputs")
CoordRange = 0.02
BaseX = -0.75
BaseY = 0.99
ByPassDelayV2 = 2.3
MiniGameDelayV2 = 2.2

Players = game:GetService("Players")
CurrentPlayer = Players.LocalPlayer
Character = CurrentPlayer.Character or CurrentPlayer.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid", 10)

ActiveAutoFishing = false

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "house",
    IconThemed = "Oceanic",
})

MainTab:Section({
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 16
})

MainTab:Toggle({
    Title = "Auto Fish",
    Desc = "Automatically fish for you",
    Value = false,
    Type = "Checkbox",
    Callback = function(v)
        ActiveAutoFishing = v
        if ActiveAutoFishing then
            spawn(function()
                print("▶️ Auto fishing started")
                StartAutoFishing()
            end)
        end
    end
})

MainTab:Input({
    Title = "Bypass delay V2",
    Desc = "bypassing charge fishing",
    Value = tostring(ByPassDelayV2),
    Type = "Input",
    Callback = function(v)
        ByPassDelayV2 = tonumber(v)
    end
})

MainTab:Input({
    Title = "Minigame delay V2",
    Desc = "minigame delay",
    Value = tostring(MiniGameDelayV2),
    Type = "Input",
    Callback = function(v)
        MiniGameDelayV2 = tonumber(v)
    end
})

function GetRandomCoordinate()
    return math.random(-CoordRange * 10000, CoordRange * 10000) / 10000
end

function StartAutoFishing()
    if not ActiveAutoFishing then return end

    local player = game.Players.LocalPlayer
    local consecutiveFailures = 0
    local MAX_FAILURES = 5
    local obtainedFish = false

    local connections = {}

    local function onFishCaught(plr)
        if plr ~= player then return end
        consecutiveFailures = 0
        print("🎣 Fish caught!")
    end

    local function  onObtainedFish()
        if not ActiveAutoFishing or obtainedFish then return end
        obtainedFish = true
        print("🎉 New fish obtained!")
    end

    local function onFishStopped(plr)
        if plr ~= player then return end
        consecutiveFailures = consecutiveFailures + 1
        print("❌ Failed cast #" .. consecutiveFailures)

        if consecutiveFailures >= MAX_FAILURES then
            print("⚠️ Max failures! Restarting...")
            consecutiveFailures = 0
            wait(1) -- cooldown before restart
            if ActiveAutoFishing then
                StartAutoFishing()
            end
            return
        end

        wait(1) -- 1.5-3s
        if ActiveAutoFishing then
            castRod()
        end
    end

    local function castRod()
        if not ActiveAutoFishing then return end

        pcall(function()
            EquipToolFromHotbar:FireServer(1)
            wait(0.1)

            local now = workspace:GetServerTimeNow()
            ChargedRod:InvokeServer(now)

            wait(0.1)
        end)

        local x = BaseX + GetRandomCoordinate()
        local y = BaseY + GetRandomCoordinate()

        RequestMiniGame:InvokeServer(x, y)

        wait(MiniGameDelayV2)
    end

    -- Connect events
    table.insert(connections, FishCaught.OnClientEvent:Connect(onObtainedFish))
    table.insert(connections, FishCaught.OnClientEvent:Connect(onFishCaught))
    table.insert(connections, FishStopped.OnClientEvent:Connect(onFishStopped))

    -- Start fishing loop
    spawn(function()
        while ActiveAutoFishing do
            castRod()
            wait(0.1)
        end
    end)

    -- Cleanup on stop
    spawn(function()
        repeat wait(MiniGameDelayV2) until not ActiveAutoFishing
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        print("⏹️ Auto Fishing stopped.")
    end)


    ReplicateTextEffect.OnClientEvent:Connect(function(data)
        if not ActiveAutoFishing then
            return
        end

        local textData = data.TextData   -- Or data[1] ?
        local container = data.Container -- Or data[2] ?

        local obtainedDelay = tick() + 10
        local currentTIme = tick()

        if textData and textData.EffectType == "Exclaim" then
            local MyHead = Character and Character:FindFirstChild("Head")
            if MyHead and container == MyHead then
                print("✅ Fish bite detected on player's head!")
                spawn(function()
                    for _ = 1, 3 do
                        wait(ByPassDelayV2)
                        FishComplete:FireServer()
                    end
                end)
            end
        end
    end)
end
