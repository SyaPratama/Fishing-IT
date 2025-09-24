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
    if not ActiveAutoFishing or not IsWaitingForExclaim then
        return -- Exit early if not actively waiting
    end

    local textData = data.TextData   -- Or data[1] ?
    local container = data.Container -- Or data[2] ?

    if textData and textData.EffectType == "Exclaim" then
        local MyHead = Character and Character:FindFirstChild("Head")
        if MyHead and container == MyHead then
            print("✅ Fish bite detected on player's head!")
            IsWaitingForExclaim = false

            pcall(function()
                if RodAnimIdle then RodAnimIdle:Stop() end
                if RodAnimShake then
                    RodAnimShake:Play()
                    print("🎬 Playing Rod Shake Animation")
                end
            end)

            task.spawn(function() -- Handle the catch in a separate thread
                task.wait(0.2)    -- Briefly show shake

                pcall(function()
                    if RodAnimShake then RodAnimShake:Stop() end
                    if RodAnimReel then
                        RodAnimReel:Play()
                        print("🎬 Playing Rod Reel Animation")
                    end
                end)

                for i = 1, 3 do
                    print("🎣 Reeling in the fish... (" .. i .. "/3)")
                    FishingCompleted:FireServer()
                    if i < 3 then
                        task.wait(ByPassMiniGame)
                    end
                end

                pcall(function()
                    if RodAnimReel then
                        RodAnimReel:Stop()
                        print("🎬 Stopping Rod Reel Animation")
                    end
                    if RodAnimIdle and ActiveAutoFishing then
                        RodAnimIdle:Play()
                    end
                end)

                print("✅ Perfect catch! Fish caught!")
            end)
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
    if not ActiveAutoFishing or IsWaitingForExclaim then
        return -- Guard clause
    end

    print("🎣 Casting fishing rod...")

    EquipRod()
    task.wait(0.1) -- Small delay after equipping

    local chargeTime = workspace:GetServerTimeNow()
    pcall(function()
        ChargedRod:InvokeServer(chargeTime)
    end)

    task.wait(ChargeRodSpeed) -- Wait for the rod to charge (this is usually short)

    pcall(function()
        if RodAnimShake then RodAnimShake:Stop() end
        if RodAnimReel then RodAnimReel:Stop() end
        if RodAnimIdle then
            RodAnimIdle:Play()
            print("🎬 Playing Rod Idle Animation")
        end
    end)

    local x = BaseX + GetRandomCoordinate()
    local y = BaseY + GetRandomCoordinate()

    local success, err = pcall(function()
        FishingIndicator:InvokeServer(x, y)
    end)

    if success then
        IsWaitingForExclaim = true
        print("⏳ Waiting for fish bite... (Relying on ReplicateTextEffect event)")
    else
        print("❌ Failed to invoke FishingIndicator:", err)
    end
end

function AutoFishing()
    print("🤖 Auto fishing started")
    ActiveAutoFishing = true
    IsWaitingForExclaim = false -- Ensure we start fresh

    pcall(function()
        if RodAnimShake then RodAnimShake:Stop() end
        if RodAnimReel then RodAnimReel:Stop() end
        if RodAnimIdle then RodAnimIdle:Stop() end
    end)

    while ActiveAutoFishing do
        if not IsWaitingForExclaim then
            pcall(CastFishingRod)
        end
        task.wait(0.1) -- Reduced check interval for responsiveness
    end

    print("🛑 Auto fishing stopped")

    pcall(function()
        if RodAnimShake then RodAnimShake:Stop() end
        if RodAnimReel then RodAnimReel:Stop() end
        if RodAnimIdle then RodAnimIdle:Stop() end
    end)

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

function GetRodNames()
    local Display = CurrentPlayer.PlayerGui:WaitForChild("Backpack"):WaitForChild("Display")
    for _, item in ipairs(Display:GetChildren()) do
        local success, ItemNamePath = pcall(function()
            return item.Inner.Tags.ItemName
        end)

        if success and ItemNamePath and ItemNamePath:IsA("TextLabel") then
            local Name = tostring(ItemNamePath.Text)
            print("Current Rod: " .. Name)
            return Name
        else
            warn("⚠️ Unable to retrieve ItemName from item: " .. tostring(item.Name))
        end
    end
end

CurrentPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid", 5)

    if Humanoid then
        Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
        pcall(function()
            RodAnimIdle = SafeLoadAnimation(Animator, RodIdle)
            RodAnimShake = SafeLoadAnimation(Animator, RodShake)
            RodAnimReel = SafeLoadAnimation(Animator, RodReel)
        end)

        task.spawn(function()
            task.wait(1) -- Wait a bit for GUI/Backpack to populate
            SetRodDelay() -- Use the improved SetRodDelay function from previous help
        end)
    end
end)

    (function()
        local RodName = GetRodNames()
        for _, island in ipairs(DataIslands.locations) do
            if island.name and island.coordinated then
                table.insert(DataIslandsName, island.name)
            end
        end

        for _, island in ipairs(DataDelay.rods) do
            if island.name == RodName then
                MiniGameDelay = island.MiniGameDelay
                ByPassMiniGame = island.BypassDelay
                print(island.name, island.MiniGameDelay, island.BypassDelay)
            end
        end
    end)()
