--// AirWalk Script (Toggle with F + Platform mengikuti Jump Height + Gravity)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variabel
local airwalkEnabled = false
local offset = -6 -- jarak platform di bawah player
local airPlatform = Instance.new("Part")
airPlatform.Name = "AirWalkPlatform"
airPlatform.Size = Vector3.new(6, 1, 6)
airPlatform.Transparency = 1
airPlatform.Anchored = true
airPlatform.CanCollide = false
airPlatform.Parent = workspace

-- Tinggi platform awal
local platformY = humanoidRootPart.Position.Y + offset

-- Update posisi platform tiap frame
RunService.RenderStepped:Connect(function()
	if airwalkEnabled then
		-- Selalu ikuti posisi player dengan offset
		airPlatform.Position = Vector3.new(
			humanoidRootPart.Position.X,
			platformY,
			humanoidRootPart.Position.Z
		)
		airPlatform.CanCollide = true
	else
		airPlatform.CanCollide = false
	end
end)

-- Toggle dengan F
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.F then
		airwalkEnabled = not airwalkEnabled
		if airwalkEnabled then
			platformY = humanoidRootPart.Position.Y + offset
			print("✅ AirWalk Aktif")
		else
			print("🛑 AirWalk Nonaktif")
		end
	end
end)

-- Input Jump (Space) → platform naik sesuai JumpPower + Gravity
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.Space then
		if airwalkEnabled then
			local gravity = workspace.Gravity
			local jumpHeight = 0

			if humanoid.UseJumpPower then
				-- rumus: h = v^2 / (2 * g)
				local v = humanoid.JumpPower
				jumpHeight = (v * v) / (2 * gravity)
			else
				-- kalau pakai JumpHeight langsung
				jumpHeight = humanoid.JumpHeight
			end

			-- Naikkan platform sesuai tinggi natural
			platformY = platformY + jumpHeight

			-- Naikkan karakter juga biar sejajar
			humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, jumpHeight, 0)
		end
	end
end)
