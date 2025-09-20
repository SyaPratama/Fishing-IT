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
    print("ReplicateTextEffect fired with data:", data.TextData.EffectType)
    if ActiveAutoFishing and IsWaitingForExclaim then
        if data and data.TextData and data.TextData.EffectType == "Exclaim" then
            local MyHead = Character and Character:FindFirstChild("Head")
            if MyHead and data.Container == MyHead then
                IsWaitingForExclaim = false
                task.spawn(function()
                    for _ = 1, 5 do
                        task.wait(ByPassMiniGame)
                        FishingCompleted:FireServer()
                    end

                    print("✅ Perfect catch! Fish caught!")
                    -- Lakukan reset state seperti biasa
                    if Humanoid then
                        for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                        Humanoid.WalkSpeed = 16
                        Humanoid.JumpPower = 50
                    end
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
    while ActiveAutoFishing do
        pcall(CastFishingRod)
        if not ActiveAutoFishing then break end
        task.wait(0.5)
    end
    print("🛑 Auto fishing stopped")

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
