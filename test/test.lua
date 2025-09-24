local Version = "1.6.51"

local WindUI = loadstring(game:HttpGetAsync("https://github.com/Footagesus/WindUI/releases/download/" ..
    Version .. "/main.lua"))()

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

local Window = WindUI:CreateWindow({
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


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild(
        "net")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CurrentPlayer = Players.LocalPlayer
local RequestMiniGame = Net:WaitForChild("RF/RequestFishingMinigameStarted")
local SellAllItem = Net:WaitForChild("RF/SellAllItems")
local SellItem = Net:WaitForChild("RF/SellItem")
local UpdateAutoSellThreshold = Net:WaitForChild("RF/UpdateAutoSellThreshold")
local EnchantItem = Net:WaitForChild("RE/ActivateEnchantingAltar")
local DestroyEffect = Net:WaitForChild("RE/DestroyEffect")
local EquipToolFromHotbar = Net:WaitForChild("RE/EquipToolFromHotbar")
local ChargedRod = Net:WaitForChild("RF/ChargeFishingRod")
local FavoriteItem = Net:WaitForChild("RE/FavoriteItem")
local FavoriteStateChange = Net:WaitForChild("RE/FavoriteStateChanged")
local FishCaught = Net:WaitForChild("RE/FishCaught")
local FishComplete = Net:WaitForChild("RE/FishingCompleted")
local FishStopped = Net:WaitForChild("RE/FishingStopped")
local ReplicateTextEffect = Net:WaitForChild("RE/ReplicateTextEffect")
local OxygenUpdate = Net:WaitForChild("URE/UpdateOxygen")
local CancelInput = Net:WaitForChild("RF/CancelFishingInputs")
local Character = CurrentPlayer.Character or CurrentPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 10)
local CoordRange = 0.02
local BaseX = -0.75
local BaseY = 0.99

local autoFish = false
local pullDelays = { 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.4, 1.6, 1.8, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0 }
local nextCast = 0
local delayIdx = 1

local failCount = 0

local DelayJSON = game:HttpGetAsync(
    "https://raw.githubusercontent.com/SyaPratama/Fishing-IT/refs/heads/main/data/delay.json")
local DataDelay = HttpService:JSONDecode(DelayJSON)

local function GetRandomCoordinate()
    return math.random(-CoordRange * 10000, CoordRange * 10000) / 10000
end

local function getCurrentRod()
    local Display = CurrentPlayer.PlayerGui:WaitForChild("Backpack"):WaitForChild("Display")
    for _, item in ipairs(Display:GetChildren()) do
        local success, ItemNamePath = pcall(function()
            return item.Inner.Tags.ItemName
        end)

        if success and ItemNamePath and ItemNamePath:IsA("TextLabel") then
            local Name = tostring(ItemNamePath.Text)
            print("Current Rod: " .. Name)
            return Name
        end
    end
end

local function getStartingDelayIndex()
    local currentRod = getCurrentRod() or "Starter Rod"

    for _, rodData in ipairs(DataDelay.rods) do
        if rodData.name == currentRod then
            print("Using delay settings for rod:", currentRod)
            return rodData
        end
    end
end


local function FishOnce()
    if not autoFish then
        return
    end

    local bypassdelay = 0.6
    local waitTime

    pcall(function()
        EquipToolFromHotbar:FireServer(1)
        wait(0.1)

        local chargedTime = workspace:GetServerTimeNow()
        ChargedRod:InvokeServer(chargedTime)
        wait(0.1)

        print("🎣 Casting fishing rod...")
    end)


    local x = BaseX + GetRandomCoordinate()
    local y = BaseY + GetRandomCoordinate()
    local success, fishData = RequestMiniGame:InvokeServer(x, y)
    print("")
    task.wait(pullDelays[delayIdx])


    if not success then
        print("❌ Failedf to invoke RequestMiniGame:", fishData)
        CancelInput:InvokeServer()
        nextCast = workspace:GetServerTimeNow() + 1.0
        return
    end

    task.wait(0.1)

    ReplicateTextEffect.OnClientEvent:Connect(function(data)
        if not autoFish then return end 

        local textData = data.TextData
        local container = data.Container

        if textData and textData.EffectType == "Exclaim" then
            local MyHead = Character and Character:FindFirstChild("Head")
            if MyHead and container == MyHead then
                if bypassdelay < nextCast then
                    waitTime = nextCast
                    for _ = 1, 3 do
                        for i, k in ipairs(fishData) do
                            print(i, k)
                        end
                        task.wait(waitTime)
                        FishComplete:FireServer()
                    end
                    print("| Pull Delay: " .. pullDelays[delayIdx] .. "s")
                    print("⏳ Waiting for cooldown: " .. string.format("%.2f", waitTime) .. "s")
                end
            end
        end
    end)

    local stop
    local stopped = false
    stop = FishStopped.OnClientEvent:Connect(function(data)
        print("data", data)
        stopped = true
        if stop then stop:Disconnect() end
    end)


    if stop then stop:Disconnect() end

    if not stopped then
        failCount = failCount + 1
        CancelInput:InvokeServer()

        if failCount >= 5 and delayIdx < #pullDelays then
            delayIdx = delayIdx + 1
            nextCast = pullDelays[delayIdx] - 0.1
            print("⚠️ Increased pull delay to " .. pullDelays[delayIdx] .. "s due to consecutive failures.")
            failCount = 0
        end
    else
        failCount = 0
    end
end

local function Autofish()
    print("🤖 Auto fishing started")
    while autoFish do
        pcall(FishOnce)
        wait(0.1)
    end
end

local HomeTab = Window:Tab({
    Title = "Home",
    Icon = "house",
    Description = "Home Tab",
})

HomeTab:Toggle({
    Text = "Fish auto",
    Description = "auto fishing",
    Value = false,
    Callback = function(v)
        autoFish = v
        if autoFish then
            pcall(Autofish)
        end
    end,
})
