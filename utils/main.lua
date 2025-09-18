function GetRandomCordinate()
    return math.random(MinCoordinateFishing * 1000, MaxCoordinateFishing * 1000) / 1000
end

function CastFishingRod()
    -- Get server time for charging
    local chargeTime = workspace:GetServerTimeNow()
    
    -- Equip Fishing Rod
    PickRod:FireServer(1)
    task.wait(0.1)
    
    -- Charge the rod
    ChargedRod:InvokeServer(chargeTime)
    
    -- Short delay
    task.wait(0.1)

    -- Random Coordinate
    local x = GetRandomCordinate()
    local y = GetRandomCordinate()
    print("Fishing coordinates:", x, y)

    local success, failed = pcall(function()
        return FishingIndicator:InvokeServer(x, y)
    end)

    if success then
        print("✅ Fishing minigame started!")
        
        -- Wait for charge speed
        task.wait(ChargeRodSpeed)

        -- Complete the fishing
        task.wait(0.3)
        pcall(function()
            FishingCompleted:FireServer()
        end)

        print("✅ Fishing completed!")
    else
        print("❌ Failed to start fishing:", failed)
        WindUI:Notify({
            Title = "Error",
            Content = "Failed to start fishing minigame",
            Duration = 2.5,
            Icon = "circle-x"
        })
    end
end


function AutoFishing()
    while ActiveAutoFishing do
        pcall(function (...)
            CastFishingRod()
            task.wait(2.5)
        end)
    end
end