print(DataIslands)

-- Update character on respawn
CurrentPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid", 5)
end)

-- Store animation tracks to stop them later
local currentAnimationTrack = nil

function StopCurrentAnimation()
    if currentAnimationTrack and currentAnimationTrack.IsPlaying then
        pcall(function()
            currentAnimationTrack:Stop()
        end)
    end
end

function PlayAnimation(anim)
    if not anim or not Humanoid then return end

    -- Stop any current animation
    StopCurrentAnimation()

    local success, track = pcall(function()
        local t = Humanoid:LoadAnimation(anim)
        t:Play()
        currentAnimationTrack = t
        return t
    end)
    return success and track or nil
end

function GetRandomCoordinate()
    return math.random(-CoordRange * 10000, CoordRange * 10000) / 10000
end

function EquipRod()
    pcall(function()
        PickRod:FireServer(1)
    end)
end

function ChargeRodSafely()
    local timestamp = workspace:GetServerTimeNow()
    pcall(function()
        ChargedRod:InvokeServer(timestamp)
    end)
end

function CastFishingRod()
    -- Check if still active before proceeding
    if not ActiveAutoFishing then return end

    print("🎣 Casting fishing rod...")

    -- Equip rod
    EquipRod()
    task.wait(0.3)

    -- Play cast animation
    pcall(function() PlayAnimation(AnimCast) end)

    -- Charge the rod with proper timestamp
    local chargeTime = workspace:GetServerTimeNow()
    pcall(function()
        ChargedRod:InvokeServer(chargeTime)
    end)
    task.wait(ChargeRodSpeed)

    -- Check again if still active
    if not ActiveAutoFishing then return end

    -- Use known good coordinates for perfect catch
    local x = BaseX + GetRandomCoordinate()
    local y = BaseY + GetRandomCoordinate()

    local success, err = pcall(function()
        return FishingIndicator:InvokeServer(x, y)
    end)

    if success then
        print("🎮 Fishing minigame started!")

        -- Play reel animation
        pcall(function() PlayAnimation(AnimEasyReel) end)

        -- Check again before waiting
        if not ActiveAutoFishing then return end

        -- Wait for perfect timing
        task.wait(MiniGameDelay)

        -- Check again before completing
        if not ActiveAutoFishing then return end

        -- Complete fishing with verification
        local completeSuccess, completeErr = pcall(function()
            FishingCompleted:FireServer()
        end)

        if completeSuccess then
            pcall(function() PlayAnimation(AnimCatch) end)
            print("✅ Perfect catch! Fish caught!")
        else
            print("❌ Error completing fishing:", completeErr)
        end
    else
        pcall(function() PlayAnimation(AnimFailure) end)
        print("❌ Failed to start fishing:", err)
    end
end

function AutoFishing()
    print("🤖 Auto fishing started")
    while ActiveAutoFishing do
        pcall(CastFishingRod)
        -- Check if still active before waiting
        if not ActiveAutoFishing then break end
        task.wait(3)
    end
    print("🛑 Auto fishing stopped")

    -- Return to normal state
    StopCurrentAnimation()
    pcall(function() PlayAnimation(AnimIdle) end)
    print("🎮 Player returned to normal state")
end

function TeleportPlayerToIsland(islandName)
    local character = CurrentPlayer.Character
    for _, location in pairs(DataIslands.locations) do
        if islandName == location.name then
            local marker = CFrame.new(location.coordinated)
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
