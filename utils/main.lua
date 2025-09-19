-- Disable Sound
local GameOptions = UserSettings().GameSettings
GameOptions.MasterVolume = 0

(function()
    for _, g in ipairs(SoundService:GetChildren()) do
        if g:GetAttribute("OriginalVolume") then
            g.Volume = 0
            g.OriginalVolume = 0
        else
            g.Volume = 0
        end
    end
end)()

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
    task.wait(0.1)

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
            print("✅ Perfect catch! Fish caught!")
        else
            print("❌ Error completing fishing:", completeErr)
        end
    else
        -- pcall(function() PlayAnimation(AnimFailure) end)
        print("❌ Failed to start fishing:", err)
    end
end

function AutoFishing()
    print("🤖 Auto fishing started")
    while ActiveAutoFishing do
        pcall(CastFishingRod)
        -- Check if still active before waiting
        if not ActiveAutoFishing then break end
        task.wait(1)
    end
    print("🛑 Auto fishing stopped")

    -- Return to normal state
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
