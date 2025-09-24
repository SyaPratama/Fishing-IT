Players = game:GetService("Players")
CurrentPlayer = Players.LocalPlayer

function TeleportPlayerToIsland()
    local character = CurrentPlayer.Character
    -- for _, location in pairs(DataIslands.locations) do
        -- if islandName == location.name then
            local marker = CFrame.new(-633.302612, 1286.71631, 863.083069, 0.706737697, -0, -0.707475662, 0, 1, -0, 0.707475662, 0, 0.706737697)
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp and marker then
                hrp.CFrame = marker * CFrame.new(0, 5, 0)
                return
            end
        -- end
    -- end
end

TeleportPlayerToIsland()