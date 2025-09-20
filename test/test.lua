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

    -- Variables
    ActiveAutoFishing = false
    ChargeRodSpeed = 0.1
    MinCoordinateFishing = -10
    MaxCoordinateFishing = 10
    CoordRange = 0.02
    MiniGameDelay = 2.2
    ByPassMiniGame = 1.4
    BaseX = -0.75
    BaseY = 0.99
    ActiveDrowning = true
    OldNameCall = Meta.__namecall
    IsWaitingForExclaim = false
    FishingTask = nil

    -- Character and Humanoid setup
    Character = CurrentPlayer.Character or CurrentPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid", 10)

    -- Disable Sound
    local GameOptions = UserSettings().GameSettings
    GameOptions.MasterVolume = 0

    (function()
        for _, group in ipairs(SoundService:GetChildren()) do
            if group:IsA("SoundGroup") then
                group.Volume = 0
            end
        end
    end)()


    ReplicateTextEffect.OnClientEvent:Connect(function(data)
        if ActiveAutoFishing and IsWaitingForExclaim then
            if data and data.TextData and data.TextData.EffectType == "Exclaim" then
                local MyHead = Character and Character:FindFirstChild("Head")
                if MyHead and data.Container == MyHead then
                    IsWaitingForExclaim = false
                    task.spawn(function()
                        for i = 1, 3 do
                            print("🎣 Reeling in the fish... (" .. i .. "/3)")
                            FishingCompleted:FireServer()
                            if i < 3 then
                                task.wait(ByPassMiniGame)
                            end
                        end

                        task.wait(0.1)
                    end)
                end
            end
        end
    end)

    function SetupDrowningHook()
        local Meta = getrawmetatable(game)
        setreadonly(Meta, false)

        OldNameCall = Meta.__namecall

        Meta.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()

            if ActiveDrowning and method == "FireServer" and self.name == "URE/UpdateOxygen" then
                print("Jalan")
                return nil
            end
            return OldNameCall(self, ...)
        end)

        setreadonly(Meta, true)
    end

    function RemoveDrowningHook()
        if OldNameCall then
            local Meta = getrawmetatable(game)
            setreadonly(Meta, false)
            Meta.__namecall = OldNameCall -- restore fungsi asli
            setreadonly(Meta, true)
            print("[🎣] Drowning hook removed")
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("Sound") and obj.SoundId == "rbxassetid://303632290" then
            obj:Destroy()
        end
    end)

    -- Update character on respawn
    CurrentPlayer.CharacterAdded:Connect(function(char)
        Character = char
        Humanoid = char:WaitForChild("Humanoid", 5)
    end)

    function GetRandomCoordinate()
        return math.random(-CoordRange * 10000, CoordRange * 10000) / 10000
    end

    function EquipRod()
        pcall(function()
            PickRod:FireServer(1)
        end)
    end

    function CastFishingRod()
        if not ActiveAutoFishing then return end
        if IsWaitingForExclaim then return end
        print("🎣 Casting fishing rod...")

        EquipRod()
        task.wait(0.1)

        local chargeTime = workspace:GetServerTimeNow()
        pcall(function()
            ChargedRod:InvokeServer(chargeTime)
        end)

        task.wait(ChargeRodSpeed)
        local x = BaseX + GetRandomCoordinate()
        local y = BaseY + GetRandomCoordinate()

        FishingIndicator:InvokeServer(x, y)

        IsWaitingForExclaim = true
    end

    function AutoFishing()
        print("🤖 Auto fishing started")
        ActiveAutoFishing = true
        IsWaitingForExclaim = false


        FishingTask = task.spawn(
            function()
                while ActiveAutoFishing do
                    if not IsWaitingForExclaim then
                        pcall(CastFishingRod)
                    end
                    task.wait(0.1)
                end
            end
        )
    end

    function StopAutoFishing()
        ActiveAutoFishing = false
        IsWaitingForExclaim = false
        if FishingTask then
            task.cancel(FishingTask)
        end
        -- Reset player state
        if Humanoid then
            for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            Humanoid.WalkSpeed = 16
            Humanoid.JumpPower = 50
        end
        print("🎮 Player returned to normal state")
    end

    function TeleportPlayerToIsland(islandName)
        local character = CurrentPlayer.Character
        for _, location in ipairs(DataIslands.locations) do
            if islandName == location.name then
                local x, y, z = location.coordinated:match("([^,]+),%s*([^,]+),%s*(.+)")
                x, y, z = tonumber(x), tonumber(y), tonumber(z)
                local position = Vector3.new(x, y, z)
                local marker = CFrame.new(position)
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if hrp and marker then
                    hrp.CFrame = marker * CFrame.new(0, 5, 0)
                    return
                end
            end
        end
    end

    (function()
        for _, island in ipairs(DataIslands.locations) do
            if island.name and island.coordinated then
                table.insert(DataIslandsName, island.name)
            end
        end
    end)()

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
                spawn(StopAutoFishing)
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
