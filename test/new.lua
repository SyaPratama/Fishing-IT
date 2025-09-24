local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait for character and humanoid
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Optional: Listen for character changes (e.g., respawn)
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
end)

-- Bind jump to 'E' key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.E then
        if humanoid and humanoid.Parent then
            humanoid.Jump = true    -- Trigger the jump
            humanoid.JumpPower = 50 -- Set jump strength (lower = weaker jump)
            print("🦘 Jumped with custom power: 50")
        else
            warn("Humanoid not found or invalid!")
        end
    end
end)