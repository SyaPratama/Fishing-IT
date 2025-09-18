function GetRandomCordinate()
    return math.random(MinCoordinateFishing * 1000, MaxCoordinateFishing * 1000) / 1000
end

function CastFishingRod()
    -- Equip Fishing Rod
    PickRod:FireServer(1)

    -- Delay
    task.wait(0.1)

    -- Random Coordinate
    local x = GetRandomCordinate()
    local y = GetRandomCordinate()

    local success, failed = pcall(function ()
        return FishingIndicator:InvokeServer(x,y)
    end)

    if success then
        task.spawn(
            function ()
                task.wait(ChargeRodSpeed)

                -- Current timestamp
                local chargeTime = tick() * 1000
                pcall(function ()
                  ChargedRod:InvokeServer(chargeTime)
                end)

                -- Delay 

                task.wait(0.5)
                pcall(function ()
                    FishingCompleted:FireServer()
                end)
            end
        )
    else
        print("Failed To Start Fishing: ", failed)
    end
end

function AutoFishing()
    spawn(function ()
        while ActiveAutoFishing do
            CastFishingRod()

            task.wait(2)
        end
    end)
end