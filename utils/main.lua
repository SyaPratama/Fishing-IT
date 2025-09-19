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
        return OldNameCall(self,...)
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
    task.wait(0.3)

    local chargeTime = workspace:GetServerTimeNow()
    pcall(function()
        ChargedRod:InvokeServer(chargeTime)
    end)
    task.wait(ChargeRodSpeed)
    local x = BaseX + GetRandomCoordinate()
    local y = BaseY + GetRandomCoordinate()

    local success, err = pcall(function()
        return FishingIndicator:InvokeServer(x, y)
    end)

    if success then
        print("🎮 Fishing minigame started!")

        task.wait(MiniGameDelay)

        local completeSuccess, completeErr = pcall(function()
            FishingCompleted:FireServer()
        end)

        if completeSuccess then
            print("✅ Perfect catch! Fish caught!")

            -- ✅ RESET SEMUA STATE
            if Humanoid then
                -- Hentikan semua animasi yang mungkin dimainkan server
                for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                -- Reset kecepatan
                Humanoid.WalkSpeed = 16
                Humanoid.JumpPower = 50
            end
        else
            print("❌ Error completing fishing:", completeErr)
        end
    else
        print("❌ Failed to start fishing:", err)
    end
end

function AutoFishing()
    print("🤖 Auto fishing started")
    while ActiveAutoFishing do
        pcall(CastFishingRod)
        if not ActiveAutoFishing then break end
        task.wait(2)
    end
    print("🛑 Auto fishing stopped")

    -- ✅ FINAL RESET
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
