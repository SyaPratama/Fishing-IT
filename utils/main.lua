function GetRandomCordinate()
    return math.random(-CoordRange*10000, CoordRange*10000)/10000
end

function CastFishingRod()
    -- Get server time for charging
    pcall(function ()
        PickRod:FireServer(1)
    end)

    local timestamp = workspace:GetServerTimeNow()
    pcall(function()
        ChargeRod:InvokeServer(timestamp)
    end)

    task.wait(ChargeRodDelay)

    -- Random Coordinate
    local x = BaseX + GetRandomCordinate()
    local y = BaseY + GetRandomCordinate()
    
    print("Fishing coordinates:", x, y)

    local success, failed = pcall(function()
        return FishingIndicator:InvokeServer(x, y)
    end)

    if success then                -- Wait for charge speed
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