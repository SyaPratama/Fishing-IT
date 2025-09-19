local HttpService = game:GetService("HttpService")

-- Fetch the raw JSON string
local islandJSON = game:HttpGet("https://raw.githubusercontent.com/SyaPratama/Fishing-IT/main/data/islands.json")

-- Decode it into a Lua table
local DataIslands = HttpService:JSONDecode(islandJSON)

-- Print the table (you may want to loop or print specific keys)
for i, island in ipairs(DataIslands.locations) do
    if island.name and island.coordinated then
        print(("[#%d] %s at %s"):format(i, island.name, island.coordinated))
    end
end
