local islandMarkers = {} -- Store one marker per island
-- === Helper Functions ===

local function getBestWorldPosition(instance)
    local success, worldPivot = pcall(function()
        return instance.WorldPivot
    end)
    if success and typeof(worldPivot) == "CFrame" then
        return worldPivot.Position
    end

    local success2, worldPos = pcall(function()
        return instance.WorldPosition
    end)
    if success2 and typeof(worldPos) == "Vector3" then
        return worldPos
    end

    local success3, localPos = pcall(function()
        return instance.Position
    end)
    if success3 and typeof(localPos) == "Vector3" then
        return localPos
    end

    return nil
end

local function getBestWorldCFrame(instance)
    local success, wp = pcall(function() return instance.WorldPivot end)
    if success and typeof(wp) == "CFrame" then return wp end

    local pos = getBestWorldPosition(instance)
    if pos then return CFrame.new(pos) end

    return nil
end

-- === Main Logic ===

local islandsFolder = workspace:WaitForChild("Islands")
for _, islandModel in ipairs(islandsFolder:GetChildren()) do
    print(islandModel.Name)

    local foundMarker = false

    -- Loop through children to find FIRST valid position
    for _, element in ipairs(islandModel:GetChildren()) do
        local worldPos = getBestWorldPosition(element)
        local worldCFrame = getBestWorldCFrame(element)

        if worldPos then
            -- ✅ Found first valid position → use as teleport marker
            table.insert(islandMarkers, {
                IslandName = islandModel.Name,
                MarkerElement = element,
                ClassName = element.ClassName,
                WorldPosition = worldPos,
                WorldCFrame = worldCFrame
            })

            -- print(("✅ Selected as teleport marker: %s (%s) at %s"):format(
            --     element.Name,
            --     element.ClassName,
            --     tostring(worldPos)
            -- ))

            foundMarker = true
            break -- Stop after first valid — we only need one per island
        end
    end

    if not foundMarker then
        warn("⚠️ No valid teleport marker found in island: " .. islandModel.Name)
    end
end

-- === Optional: Visualize Markers In-Game (DEBUG) ===

for _, markerData in ipairs(islandMarkers) do
    local visual = Instance.new("Part")
    visual.Name = "TeleportMarker_" .. markerData.IslandName
    visual.Size = Vector3.new(2, 0.5, 2)
    visual.Position = markerData.WorldPosition + Vector3.new(0, 3, 0) -- Float above ground
    visual.Anchored = true
    visual.CanCollide = false
    visual.Transparency = 0.7
    visual.BrickColor = BrickColor.Green()
    visual.Parent = workspace

    -- Optional: Add label
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = visual

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = markerData.IslandName
    textLabel.Parent = billboard
end

-- === Example: Teleport Player to Specific Island ===

local function teleportPlayerToIsland(player, islandName, coordinates)
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp and coordinates then
        hrp.CFrame = coordinates * CFrame.new(0, 5, 0)  -- Offset up to avoid clipping
        print(player.Name .. " teleported to " .. islandName)
        return true
    end
    warn("Island not found or no valid marker: " .. islandName)
    return false
end


-- for k, v in pairs(islandName) do
--     print(k,v)
-- end

-- 🧪 Example Usage:
local Players = game:GetService("Players")
local CurrentPlayer = Players.LocalPlayer
local Marker = CFrame.new(-2871.809326171875, 47.86968994140625, 1999.093017578125)
teleportPlayerToIsland(CurrentPlayer, "Kohana",Marker)
