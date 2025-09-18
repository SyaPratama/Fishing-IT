function GetRandomCordinate()
    return math.random(MinCoordinateFishing * 1000, MaxCoordinateFishing * 1000) / 1000
end

function CastFishingRod()
    -- ServerTime
    local chargeTime = workspace.GetServerTimeNow()
    -- Equip Fishing Rod
    PickRod:FireServer(1)
    ChargeRod:InvokeServer(chargeTime)

    -- Delay
    task.wait(0.1)

    -- Random Coordinate
    local x = GetRandomCordinate()
    local y = GetRandomCordinate()

    print(x,y)

    local success, failed = pcall(function ()
        return FishingIndicator:InvokeServer(x,y)
    end)

    if success then
        task.spawn(
            function ()
                task.wait(ChargeRodSpeed)

                -- Current timestamp
                pcall(function ()
                  ChargedRod:InvokeServer(chargeTime)
                end)

                -- Delay 
                task.wait(0.3)
                pcall(function ()
                    FishingCompleted:FireServer()
                end)

                print("✅ Fishing completed!")
            end
        )
    else
        print("❌ Failed to start fishing:", failed)
        WindUI:Notify({
            Title = "Error",
            Content = "Failed to start fishing minigame",
            Duration = 2,
            Icon = "circle-x"
        })
    end
end

function AutoFishing()
    spawn(function ()
        while ActiveAutoFishing do
            CastFishingRod()
            task.wait(2.5)
        end
    end)
end