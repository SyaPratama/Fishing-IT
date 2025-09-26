------------------------------------------
----- =======[ Load WindUI ]
-------------------------------------------

local Version = "1.6.4"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

-------------------------------------------
----- =======[ GLOBAL FUNCTION ]
-------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local net = ReplicatedStorage:WaitForChild("Packages")
	:WaitForChild("_Index")
	:WaitForChild("sleitnick_net@0.2.0")
	:WaitForChild("net")
	
local Notifs = {
	WBN = true,
	UniVBlockNotif = true,
	AcceptBN = true,
	TradeblockNotif = true,
	AutoTBlockNotif = true,
	floatBlockNotif = true,
	FavBlockNotif = true,
	FishBlockNotif = true,
	DelayBlockNotif = true,
	AFKBN = true,
	APIBN = true
}

local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

local Player = Players.LocalPlayer
local XPBar = Player:WaitForChild("PlayerGui"):WaitForChild("XP")

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

for i,v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
                    v:Disable()
end

task.spawn(function()
    if XPBar then
        XPBar.Enabled = true
    end
end)

local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId

local function AutoReconnect()
    while task.wait(5) do
        if not Players.LocalPlayer or not Players.LocalPlayer:IsDescendantOf(game) then
            TeleportService:Teleport(PlaceId)
        end
    end
end

Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        TeleportService:Teleport(PlaceId)
    end
end)

task.spawn(AutoReconnect)

local ijump = false

local RodIdle = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("FishingRodReelIdle")

local RodReel = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("EasyFishReelStart")

local RodShake = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("CastFromFullChargePosition1Hand")

local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")


local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

local RodShake = animator:LoadAnimation(RodShake)
local RodIdle = animator:LoadAnimation(RodIdle)
local RodReel = animator:LoadAnimation(RodReel)

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")


-------------------------------------------
----- =======[ NOTIFY FUNCTION ]
-------------------------------------------

local function NotifySuccess(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "circle-check"
    })
end

local function NotifyError(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "ban"
    })
end

local function NotifyInfo(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "info"
    })
end

local function NotifyWarning(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "triangle-alert"
    })
end


------------------------------------------
----- =======[ CHECK DATA ]
-----------------------------------------

local CheckData = {
	pasteURL = "https://raw.githubusercontent.com/dionendrahub99/raul/refs/heads/main/update.txt",
	interval = 30,
	kicked = false,
	notified = false
}

local function checkStatus()
	local success, result = pcall(function()
		return game:HttpGet(CheckData.pasteURL)
	end)

	if not success or typeof(result) ~= "string" then
		return
	end

	local response = result:upper():gsub("%s+", "")

	if response == "UPDATE" then
		if not CheckData.kicked then
			CheckData.kicked = true
			LocalPlayer:Kick("dionendrahub Premium Update Available!.")
		end
	elseif response == "LATEST" then
		if not CheckData.notified then
			CheckData.notified = true
			warn("[dionendrahub] Status: Latest version")
		end
	else
		warn("[dionendrahub] Status unknown:", response)
	end
end

checkStatus()

task.spawn(function()
	while not CheckData.kicked do
		task.wait(CheckData.interval)
		checkStatus()
	end
end)


local confirmed = false
WindUI:Popup({
    Title = "Important!",
    Icon = "rbxassetid://129260712070622",
    Content = [[
Thank you for using Premium script!.
Dont be a Stealer!
]],
    Buttons = {
        { Title = "Close", Variant = "Secondary", Callback = function() end },
        { Title = "Next", Variant = "Primary", Callback = function() confirmed = true end },
    }
})

repeat task.wait() until confirmed


-------------------------------------------
----- =======[ LOAD WINDOW ]
-------------------------------------------

WindUI.TransparencyValue = 0.3

local Window = WindUI:CreateWindow({
    Title = "Fish It Premium",
    Icon = "hop",
    Author = "by dio",
    Folder = "dionendrahub",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
    Theme = "Dark",
    KeySystem = false,
    ScrollBarEnabled = true,
    HideSearchBar = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
        end,
    }
})

Window:EditOpenButton({
    Title = "dionendrahub",
    Icon = "hop",
    CornerRadius = UDim.new(0,19),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("9600FF"), 
        Color3.fromHex("AEBAF8")
    ),
    Draggable = true,
})

Window:Tag({
    Title = "STABLE",
    Color = Color3.fromHex("#30ff6a")
})



local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("QuietXConfig")

WindUI:SetNotificationLower(true)

WindUI:Notify({
	Title = "dionendrahub",
	Content = "All Features Loaded!",
	Duration = 5,
	Image = "square-check-big"
})

-------------------------------------------
----- =======[ ALL TAB ]
-------------------------------------------

local Home = Window:Tab({
	Title = "Developer Info",
	Icon = "hard-drive"
})

local AllMenu = Window:Section({
	Title = "All Menu Here",
	Icon = "tally-3",
	Opened = false,
})

local AutoFish = AllMenu:Tab({ 
	Title = "Auto Fish", 
	Icon = "fish"
})

local AutoFav = AllMenu:Tab({
	Title = "Auto Favorite",
	Icon = "star"
})

local AutoFarmTab = AllMenu:Tab({
	Title = "Auto Farm",
	Icon = "leaf"
})

local Trade = AllMenu:Tab({
	Title = "Trade",
	Icon = "handshake"
})

local Player = AllMenu:Tab({
    Title = "Player",
    Icon = "users-round"
})

local Utils = AllMenu:Tab({
    Title = "Utility",
    Icon = "earth"
})

local FishNotif = AllMenu:Tab({
	Title = "Fish Notification",
	Icon = "bell-ring"
})

local SettingsTab = AllMenu:Tab({ 
	Title = "Settings", 
	Icon = "cog" 
})

-------------------------------------------
----- =======[ HOME TAB ]
-------------------------------------------

local	InviteAPI = "https://discord.com/api/v10/invites/"

local function LookupDiscordInvite(inviteCode)
    local url = InviteAPI .. inviteCode .. "?with_counts=true"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        return {
            name = data.guild and data.guild.name or "Unknown",
            id = data.guild and data.guild.id or "Unknown",
            online = data.approximate_presence_count or 0,
            members = data.approximate_member_count or 0,
            icon = data.guild and data.guild.icon
                and "https://cdn.discordapp.com/icons/"..data.guild.id.."/"..data.guild.icon..".png"
                or "",
        }
    else
        warn("Gagal mendapatkan data invite.")
        return nil
    end
end

local	inviteCode = ""
local inviteData = LookupDiscordInvite(inviteCode)

if inviteData then
    Home:Paragraph({
        Title = string.format("[DISCORD] %s", inviteData.name),
        Desc = string.format("Members: %d\nOnline: %d", inviteData.members, inviteData.online),
        Image = inviteData.icon,
        ImageSize = 50,
        Locked = true,
    })
else
    warn("Invite tidak valid.")
end

local GitHubAPI = "https://api.github.com/users/"

local function LookupGitHubUser(username)
    local url = GitHubAPI .. username
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        return {
            login = data.login or username,
            name = data.name or "No Name",
            bio = data.bio or "No bio available",
            followers = data.followers or 0,
            following = data.following or 0,
            repos = data.public_repos or 0,
            avatar = data.avatar_url or "",
            html_url = data.html_url or "",
        }
    else
        warn("Gagal mendapatkan data GitHub.")
        return nil
    end
end

local githubUsername = "" 
local githubData = LookupGitHubUser(githubUsername)

if githubData then
    Home:Paragraph({
        Title = string.format("[GITHUB] %s", githubData.name),
        Desc = string.format(
            "Username: %s\nRepos: %d",
            githubData.login,
            githubData.repos
        ),
        Image = githubData.avatar,
        ImageSize = 50,
        Locked = true,
    })
else
    warn("GitHub user tidak ditemukan.")
end

-------------------------------------------
----- =======[ AUTO FISH TAB ]
-------------------------------------------

local FuncAutoFish = {
	REReplicateTextEffect = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ReplicateTextEffect"],
	autofish = false,
	perfectCast = true,
	customDelay = 1,
	fishingActive = false,
	delayInitialized = false
}


local fastRods = {
	["Ares Rod"] = true,
	["Angler Rod"] = true,
	["Ghostfinn Rod"] = true 
}

local mediumRods = {
	["Astral Rod"] = true,
	["Chrome Rod"] = true,
	["Steampunk Rod"] = true
}

local veryLowRods = {
	["Lucky Rod"] = true,
	["Midnight Rod"] = true,
	["Demascus Rod"] = true,
	["Grass Rod"] = true,
	["Luck Rod"] = true,
	["Carbon Rod"] = true,
	["Lava Rod"] = true,
	["Starter Rod"] = true
}


local function getValidRodName()
local player = Players.LocalPlayer
local display = player.PlayerGui:WaitForChild("Backpack"):WaitForChild("Display")

for _, tile in ipairs(display:GetChildren()) do      
    local success, itemNamePath = pcall(function()      
        return tile.Inner.Tags.ItemName      
    end)      
    if success and itemNamePath and itemNamePath:IsA("TextLabel") then      
        local name = itemNamePath.Text      
        if veryLowRods[name] or fastRods[name] or mediumRods[name] then      
            return name      
        end      
    end      
end      
return nil

end

local function updateDelayBasedOnRod(showNotify)
if FuncAutoFish.delayInitialized then return end

local rodName = getValidRodName()      
if rodName then
    if fastRods[rodName] then      
        FuncAutoFish.customDelay = math.random(100, 120) / 100
    elseif mediumRods[rodName] then
    	  FuncAutoFish.customDelay = math.random(140, 200) / 100
    elseif veryLowRods[rodName] then
    	  FuncAutoFish.customDelay = math.random(300, 500) / 100
    else      
        FuncAutoFish.customDelay = 10      
    end      
    FuncAutoFish.delayInitialized = true      
    if showNotify and FuncAutoFish.autofish then      
        NotifySuccess("Rod Detected", string.format("Detected Rod: %s | Delay: %.2fs", rodName, FuncAutoFish.customDelay))      
    end      
else      
    FuncAutoFish.customDelay = 10      
    FuncAutoFish.delayInitialized = true       
    if showNotify and FuncAutoFish.autofish then      
        NotifyWarning("Rod Detection Failed", "No valid rod found in list. Default delay 10s applied.")      
    end      
end

end

local function setupRodWatcher()
    local player = Players.LocalPlayer
    local display = player.PlayerGui:WaitForChild("Backpack"):WaitForChild("Display")
    display.ChildAdded:Connect(function()
        task.wait(0.05)
        if not FuncAutoFish.delayInitialized then
            updateDelayBasedOnRod(true)
        end
    end)
end
setupRodWatcher()

-- FISH THRESHOLD V2
local obtainedFishUUIDs = {}
local obtainedLimit = 30

local RemoteV2 = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]
RemoteV2.OnClientEvent:Connect(function(_, _, data)
    if data and data.InventoryItem and data.InventoryItem.UUID then
        table.insert(obtainedFishUUIDs, data.InventoryItem.UUID)
    end
end)

local function sellItems()
    if #obtainedFishUUIDs > 0 then
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index")
            :WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/SellAllItems"):InvokeServer()
    end
    obtainedFishUUIDs = {}
end

local function monitorFishThreshold()
    task.spawn(function()
        while FuncAutoFish.autofish do
            if #obtainedFishUUIDs >= obtainedLimit then
                NotifyInfo("Fish Threshold Reached", "Selling all fishes...")
                sellItems()
                obtainedFishUUIDs = {}
                task.wait(0.5)
            end
            task.wait(0.3)
        end
    end)
end

FuncAutoFish.REReplicateTextEffect.OnClientEvent:Connect(function(data)
    if FuncAutoFish.autofish and FuncAutoFish.fishingActive
    and data
    and data.TextData
    and data.TextData.EffectType == "Exclaim" then

        local myHead = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Head")      
        if myHead and data.Container == myHead then      
            task.spawn(function()      
                for i = 1, 3 do
                    task.wait(BypassDelay)
                    finishRemote:FireServer()      
                    rconsoleclear()      
                end      
            end)      
        end      
    end
end)

function StartAutoFish()
FuncAutoFish.autofish = true
updateDelayBasedOnRod(true)
monitorFishThreshold()
task.spawn(function()      
    while FuncAutoFish.autofish do      
        pcall(function()      
            FuncAutoFish.fishingActive = true      
  
            local equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")      
            equipRemote:FireServer(1)      
            task.wait(0.1)      
  
            local chargeRemote = ReplicatedStorage      
                .Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]      
            chargeRemote:InvokeServer(workspace:GetServerTimeNow())      
                  
            task.wait(0.5)      
  
            local timestamp = workspace:GetServerTimeNow()      
            RodShake:Play()      
            rodRemote:InvokeServer(timestamp)      
  
            local baseX, baseY = -0.7499996423721313, 0.991067629351885      
            local x, y      
            if FuncAutoFish.perfectCast then      
                x = baseX + (math.random(-500, 500) / 10000000)      
                y = baseY + (math.random(-500, 500) / 10000000)      
            else      
                x = math.random(-1000, 1000) / 1000      
                y = math.random(0, 1000) / 1000      
            end      
  
            RodIdle:Play()      
            miniGameRemote:InvokeServer(x, y)      
  
            task.wait(FuncAutoFish.customDelay)      
  
            FuncAutoFish.fishingActive = false      
        end)      
    end      
end)

end

function StopAutoFish()
FuncAutoFish.autofish = false
FuncAutoFish.fishingActive = false
FuncAutoFish.delayInitialized = false
end

local FuncAutoFishV2 = {
	REReplicateTextEffectV2 = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ReplicateTextEffect"],
	autofishV2 = false,
	perfectCastV2 = true,
	fishingActiveV2 = false,
	delayInitializedV2 = false
}

local RodDelaysV2 = {
    ["Ares Rod"] = {custom = 1.12, bypass = 1.45},
    ["Angler Rod"] = {custom = 1.12, bypass = 1.45},
    ["Ghostfinn Rod"] = {custom = 1.12, bypass = 1.45},

    ["Astral Rod"] = {custom = 1.9, bypass = 1.45},
    ["Chrome Rod"] = {custom = 2.3, bypass = 2},
    ["Steampunk Rod"] = {custom = 2.5, bypass = 2.3},

    ["Lucky Rod"] = {custom = 3.5, bypass = 3.6},
    ["Midnight Rod"] = {custom = 3.3, bypass = 3.4},
    ["Demascus Rod"] = {custom = 3.9, bypass = 3.8},
    ["Grass Rod"] = {custom = 3.8, bypass = 3.9},
    ["Luck Rod"] = {custom = 4.2, bypass = 4.1},
    ["Carbon Rod"] = {custom = 4, bypass = 3.8},
    ["Lava Rod"] = {custom = 4.2, bypass = 4.1},
    ["Starter Rod"] = {custom = 4.3, bypass = 4.2},
}

local customDelayV2 = 1
local BypassDelayV2 = 0.5

local function getValidRodNameV2()
    local player = Players.LocalPlayer
    local display = player.PlayerGui:WaitForChild("Backpack"):WaitForChild("Display")
    for _, tile in ipairs(display:GetChildren()) do
        local success, itemNamePath = pcall(function()
            return tile.Inner.Tags.ItemName
        end)
        if success and itemNamePath and itemNamePath:IsA("TextLabel") then
            local name = itemNamePath.Text
            if RodDelaysV2[name] then
                return name
            end
        end
    end
    return nil
end

local function updateDelayBasedOnRodV2(showNotify)
    if FuncAutoFishV2.delayInitializedV2 then return end
    local rodName = getValidRodNameV2()
    if rodName and RodDelaysV2[rodName] then
        customDelayV2 = RodDelaysV2[rodName].custom
        BypassDelayV2 = RodDelaysV2[rodName].bypass
        FuncAutoFishV2.delayInitializedV2 = true
        if showNotify and FuncAutoFishV2.autofishV2 then
            NotifySuccess("Rod Detected (V2)", string.format("Detected Rod: %s | Delay: %.2fs | Bypass: %.2fs", rodName, customDelayV2, BypassDelayV2))
        end
    else
        customDelayV2 = 10
        BypassDelayV2 = 1
        FuncAutoFishV2.delayInitializedV2 = true
        if showNotify and FuncAutoFishV2.autofishV2 then
            NotifyWarning("Rod Detection Failed (V2)", "No valid rod found. Default delay applied.")
        end
    end
end

-- FISH THRESHOLD V2
local obtainedFishUUIDsV2 = {}
local obtainedLimitV2 = 30

local RemoteV2 = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]
RemoteV2.OnClientEvent:Connect(function(_, _, data)
    if data and data.InventoryItem and data.InventoryItem.UUID then
        table.insert(obtainedFishUUIDsV2, data.InventoryItem.UUID)
    end
end)

local function sellItemsV2()
    if #obtainedFishUUIDsV2 > 0 then
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index")
            :WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/SellAllItems"):InvokeServer()
    end
    obtainedFishUUIDsV2 = {}
end

local function monitorFishThresholdV2()
    task.spawn(function()
        while FuncAutoFishV2.autofishV2 do
            if #obtainedFishUUIDsV2 >= obtainedLimitV2 then
                NotifyInfo("Fish Threshold Reached (V2)", "Selling all fishes...")
                sellItemsV2()
                obtainedFishUUIDsV2 = {}
                task.wait(0.5)
            end
            task.wait(0.3)
        end
    end)
end


FuncAutoFishV2.REReplicateTextEffectV2.OnClientEvent:Connect(function(data)
    if FuncAutoFishV2.autofishV2 and FuncAutoFishV2.fishingActiveV2
    and data
    and data.TextData
    and data.TextData.EffectType == "Exclaim" then

        local myHead = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Head")
        if myHead and data.Container == myHead then
            task.spawn(function()
                for i = 1, 3 do
                    task.wait(BypassDelayV2)
                    finishRemote:FireServer()
                    rconsoleclear()
                end
            end)
        end
    end
end)

function StartAutoFishV2()
    FuncAutoFishV2.autofishV2 = true
    updateDelayBasedOnRodV2(true)
    monitorFishThresholdV2()
    task.spawn(function()
        while FuncAutoFishV2.autofishV2 do
            pcall(function()
                FuncAutoFishV2.fishingActiveV2 = true

                local equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")
                equipRemote:FireServer(1)
                task.wait(0.1)

                local chargeRemote = ReplicatedStorage
                    .Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]
                chargeRemote:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.5)

                local timestamp = workspace:GetServerTimeNow()
                RodShake:Play()
                rodRemote:InvokeServer(timestamp)

                local baseX, baseY = -0.7499996423721313, 1
                local x, y
                if FuncAutoFishV2.perfectCastV2 then
                    x = baseX + (math.random(-500, 500) / 10000000)
                    y = baseY + (math.random(-500, 500) / 10000000)
                else
                    x = math.random(-1000, 1000) / 1000
                    y = math.random(0, 1000) / 1000
                end

                RodIdle:Play()
                miniGameRemote:InvokeServer(x, y)

                task.wait(customDelayV2)
                FuncAutoFishV2.fishingActiveV2 = false
            end)
        end
    end)
end

function StopAutoFishV2()
    FuncAutoFishV2.autofishV2 = false
    FuncAutoFishV2.fishingActiveV2 = false
    FuncAutoFishV2.delayInitializedV2 = false
    RodIdle:Stop()
    RodShake:Stop()
    RodReel:Stop()
end

AutoFish:Input({
	Title = "Bypass Delay",
	Desc = "Use 1 for rod above a Ares",
	Placeholder = "Example: 1",
	Value = nil,
	Callback = function(value)
		if Notifs.DelayBlockNotif then
			Notifs.DelayBlockNotif = false
			return
		end
		local number = tonumber(value)
		if number then
		  BypassDelay = number
			NotifySuccess("Bypass Delay", "Bypass Delay set to " .. number)
		else
		  NotifyError("Invalid Input", "Failed to convert input to number.")
		end
	end,
})

local FishThres = AutoFish:Input({
	Title = "Fish Threshold",
	Placeholder = "Example: 1500",
	Value = nil,
	Callback = function(value)
		if Notifs.FishBlockNotif then
			Notifs.FishBlockNotif = false
			return
		end
		local number = tonumber(value)
		if number then
		  obtainedLimit = number
		  obtainedLimitV2 = number
			NotifySuccess("Threshold Set", "Fish threshold set to " .. number)
		else
		  NotifyError("Invalid Input", "Failed to convert input to number.")
		end
	end,
})

myConfig:Register("FishThreshold", FishThres)

AutoFish:Toggle({
	Title = "Auto Fish V2",
	Callback = function(value)
		if value then
			StartAutoFishV2()
		else
			StopAutoFishV2()
		end
	end
})

AutoFish:Toggle({
    Title = "Auto Fish (Custom Delay)",
    Callback = function(value)
        if value then
            StartAutoFish()
        else
            StopAutoFish()
        end
    end
})


local PerfectCast = AutoFish:Toggle({
    Title = "Auto Perfect Cast",
    Value = true,
    Callback = function(value)
        FuncAutoFish.perfectCast = value
    end
})
myConfig:Register("Prefect", PerfectCast)

local REEquipItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipItem"]
local RFSellItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellItem"]

local autoSellMythic = false
local SMBlockNotif = true

function ToggleAutoSellMythic(state)
	if SMBlockNotif then
		SMBlockNotif = false
		return
	end
	autoSellMythic = state
	if autoSellMythic then
		NotifySuccess("AutoSellMythic", "Status: ON")
	else
		NotifyWarning("AutoSellMythic", "Status: OFF")
	end
end

local oldFireServer
oldFireServer = hookmetamethod(game, "__namecall", function(self, ...)
	local args = {...}
	local method = getnamecallmethod()

	if autoSellMythic
		and method == "FireServer"
		and self == REEquipItem
		and typeof(args[1]) == "string"
		and args[2] == "Fishes" then

		local uuid = args[1]

		task.delay(1, function()
			pcall(function()
				local result = RFSellItem:InvokeServer(uuid)
				if result then
					NotifySuccess("AutoSellMythic", "Items Sold!!")
				else
					NotifyError("AutoSellMythic", "Failed to sell item!!")
				end
			end)
		end)
	end

	return oldFireServer(self, ...)
end)

AutoFish:Toggle({
	Title = "Auto Sell Mythic",
	Desc = "Automatically sells clicked fish",
	Default = false,
	Callback = function(state)
		ToggleAutoSellMythic(state)
	end
})


function sellAllFishes()
	local charFolder = workspace:FindFirstChild("Characters")
	local char = charFolder and charFolder:FindFirstChild(LocalPlayer.Name)
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		NotifyError("Character Not Found", "HRP tidak ditemukan.")
		return
	end

	local originalPos = hrp.CFrame
	local sellRemote = net:WaitForChild("RF/SellAllItems")

	task.spawn(function()
		NotifyInfo("Selling...", "I'm going to sell all the fish, please wait...", 3)

		task.wait(1)
		local success, err = pcall(function()
			sellRemote:InvokeServer()
		end)

		if success then
			NotifySuccess("Sold!", "All the fish were sold successfully.", 3)
		else
			NotifyError("Sell Failed", tostring(err, 3))
		end

	end)
end

AutoFish:Button({
    Title = "Sell All Fishes",
    Locked = false,
    Callback = function()
        sellAllFishes()
    end
})

AutoFish:Button({
    Title = "Auto Enchant Rod",
    Callback = function()
        local ENCHANT_POSITION = Vector3.new(3231, -1303, 1402)
		local char = workspace:WaitForChild("Characters"):FindFirstChild(LocalPlayer.Name)
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if not hrp then
			NotifyError("Auto Enchant Rod", "Failed to get character HRP.")
			return
		end

		NotifyInfo("Preparing Enchant...", "Please manually place Enchant Stone into slot 5 before we begin...", 5)

		task.wait(3)

		local Player = game:GetService("Players").LocalPlayer
		local slot5 = Player.PlayerGui.Backpack.Display:GetChildren()[10]

		local itemName = slot5 and slot5:FindFirstChild("Inner") and slot5.Inner:FindFirstChild("Tags") and slot5.Inner.Tags:FindFirstChild("ItemName")

		if not itemName or not itemName.Text:lower():find("enchant") then
			NotifyError("Auto Enchant Rod", "Slot 5 does not contain an Enchant Stone.")
			return
		end

		NotifyInfo("Enchanting...", "It is in the process of Enchanting, please wait until the Enchantment is complete", 7)

		local originalPosition = hrp.Position
		task.wait(1)
		hrp.CFrame = CFrame.new(ENCHANT_POSITION + Vector3.new(0, 5, 0))
		task.wait(1.2)

		local equipRod = net:WaitForChild("RE/EquipToolFromHotbar")
		local activateEnchant = net:WaitForChild("RE/ActivateEnchantingAltar")

		pcall(function()
			equipRod:FireServer(5)
			task.wait(0.5)
			activateEnchant:FireServer()
			task.wait(7)
			NotifySuccess("Enchant", "Successfully Enchanted!", 3)
		end)

		task.wait(0.9)
		hrp.CFrame = CFrame.new(originalPosition + Vector3.new(0, 3, 0))
    end
})

-------------------------------------------
----- =======[ AUTO FAV TAB ]
-------------------------------------------


local GlobalFav = {
	REObtainedNewFishNotification = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"],
	REFavoriteItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FavoriteItem"],

	FishIdToName = {},
	FishNameToId = {},
	FishNames = {},
	Variants = {},
	SelectedFishIds = {},
	SelectedVariants = {},
	AutoFavoriteEnabled = false
}

-- Load Fish Names
for _, item in pairs(ReplicatedStorage.Items:GetChildren()) do
	local ok, data = pcall(require, item)
	if ok and data.Data and data.Data.Type == "Fishes" then
		local id = data.Data.Id
		local name = data.Data.Name
		GlobalFav.FishIdToName[id] = name
		GlobalFav.FishNameToId[name] = id
		table.insert(GlobalFav.FishNames, name)
	end
end

-- Load Variants
for _, variantModule in pairs(ReplicatedStorage.Variants:GetChildren()) do
	local ok, variantData = pcall(require, variantModule)
	if ok and variantData.Data.Name then
		local name = variantData.Data.Name
		GlobalFav.Variants[name] = name
	end
end


AutoFav:Toggle({
	Title = "Enable Auto Favorite",
	Value = false,
	Callback = function(state)
		if Notifs.FavBlockNotif then
			Notifs.FavBlockNotif = false
			return
		end
		GlobalFav.AutoFavoriteEnabled = state
		if state then
			NotifySuccess("Auto Favorite", "Auto Favorite feature enabled")
		else
			NotifyWarning("Auto Favorite", "Auto Favorite feature disabled")
		end
	end
})


AutoFav:Dropdown({
	Title = "Auto Favorite Fishes",
	Values = GlobalFav.FishNames,
	Multi = true,
	AllowNone = true,
	Callback = function(selectedNames)
		GlobalFav.SelectedFishIds = {}
		for _, name in ipairs(selectedNames) do
			local id = GlobalFav.FishNameToId[name]
			if id then
				GlobalFav.SelectedFishIds[id] = true
			end
		end
		NotifyInfo("Auto Favorite", "Favoriting active for fish: " .. HttpService:JSONEncode(selectedNames))
	end
})


AutoFav:Dropdown({
	Title = "Auto Favorite Variants",
	Values = GlobalFav.Variants,
	Multi = true,
	AllowNone = true,
	Callback = function(selectedVariants)
		GlobalFav.SelectedVariants = {}
		for _, vName in ipairs(selectedVariants) do
			for vId, name in pairs(GlobalFav.Variants) do
				if name == vName then
					GlobalFav.SelectedVariants[vId] = true
				end
			end
		end
		NotifyInfo("Auto Favorite", "Favoriting active for variants: " .. HttpService:JSONEncode(selectedVariants))
	end
})


GlobalFav.REObtainedNewFishNotification.OnClientEvent:Connect(function(itemId, _, data)
	if not GlobalFav.AutoFavoriteEnabled then return end

	local uuid = data.InventoryItem and data.InventoryItem.UUID
	local fishName = GlobalFav.FishIdToName[itemId] or "Unknown"
	local variantId = data.InventoryItem.Metadata and data.InventoryItem.Metadata.VariantId

	if not uuid then return end

	local matchByName = GlobalFav.SelectedFishIds[itemId]
	local matchByVariant = variantId and GlobalFav.SelectedVariants[variantId]

	
	local shouldFavorite = false

	if matchByName and matchByVariant then
		shouldFavorite = true
	elseif matchByName and not next(GlobalFav.SelectedVariants) then
		shouldFavorite = true
	elseif matchByVariant and not matchByName then
		shouldFavorite = true
	end

	if shouldFavorite then
		GlobalFav.REFavoriteItem:FireServer(uuid)
		local msg = "Favorited " .. fishName
		if matchByVariant then
			msg = msg .. " (" .. (GlobalFav.Variants[variantId] or variantId) .. " Variant)"
		end
		NotifySuccess("Auto Favorite", msg .. "!")
	end
end)


-------------------------------------------
----- =======[ AUTO FARM TAB ]
-------------------------------------------


local floatPlatform = nil

local function floatingPlat(enabled)
	if Notifs.floatBlockNotif then
		Notifs.floatBlockNotif = false
		return
	end
	if enabled then
			local charFolder = workspace:WaitForChild("Characters", 5)
			local char = charFolder:FindFirstChild(LocalPlayer.Name)
			if not char then return end

			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			floatPlatform = Instance.new("Part")
			floatPlatform.Anchored = true
			floatPlatform.Size = Vector3.new(10, 1, 10)
			floatPlatform.Transparency = 1
			floatPlatform.CanCollide = true
			floatPlatform.Name = "FloatPlatform"
			floatPlatform.Parent = workspace

			task.spawn(function()
				while floatPlatform and floatPlatform.Parent do
					pcall(function()
						floatPlatform.Position = hrp.Position - Vector3.new(0, 3.5, 0)
					end)
					task.wait(0.1)
				end
			end)

			NotifySuccess("Float Enabled", "This feature has been successfully activated!")
		else
			if floatPlatform then
				floatPlatform:Destroy()
				floatPlatform = nil
			end
			NotifyWarning("Float Disabled", "Feature disabled")
		end
end

  
  
local workspace = game:GetService("Workspace")  
  
local knownEvents = {}

local eventCodes = {
	["1"] = "Ghost Shark Hunt",
	["2"] = "Shark Hunt",
	["3"] = "Worm Hunt",
	["4"] = "Black Hole",
	["5"] = "Meteor Rain",
	["6"] = "Ghost Worm",
	["7"] = "Shocked"
}

local function teleportTo(position)
	local char = workspace:FindFirstChild("Characters"):FindFirstChild(LocalPlayer.Name)
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = CFrame.new(position + Vector3.new(0, 20, 0))
		end
	end
end

local function updateKnownEvents()
	knownEvents = {}

	local props = workspace:FindFirstChild("Props")
	if props then
		for _, child in ipairs(props:GetChildren()) do
			if child:IsA("Model") and child.PrimaryPart then
				knownEvents[child.Name:lower()] = child
			end
		end
	end
end

local function monitorEvents()
	local props = workspace:FindFirstChild("Props")
	if not props then
		workspace.ChildAdded:Connect(function(child)
			if child.Name == "Props" then
				task.wait(0.3)
				monitorEvents()
			end
		end)
		return
	end

	props.ChildAdded:Connect(function()
		task.wait(0.3)
		updateKnownEvents()
	end)

	props.ChildRemoved:Connect(function()
		task.wait(0.3)
		updateKnownEvents()
	end)

	updateKnownEvents()
end

monitorEvents()

local autoTPEvent = false
local savedCFrame = nil
local monitoringTP = false
local alreadyTeleported = false
local teleportTime = nil
local eventTarget = nil

local function saveOriginalPosition()
	local char = workspace:FindFirstChild("Characters"):FindFirstChild(LocalPlayer.Name)
	if char and char:FindFirstChild("HumanoidRootPart") then
		savedCFrame = char.HumanoidRootPart.CFrame
	end
end

local function returnToOriginalPosition()
	if savedCFrame then
		local char = workspace:FindFirstChild("Characters"):FindFirstChild(LocalPlayer.Name)
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = savedCFrame
		end
	end
end

local function isEventStillActive(name)
	updateKnownEvents()
	return knownEvents[name:lower()] ~= nil
end

local function monitorAutoTP()
	if monitoringTP then return end
	monitoringTP = true

	while true do
		if autoTPEvent then
			if not alreadyTeleported then
				updateKnownEvents()
				for _, eventModel in pairs(knownEvents) do
					saveOriginalPosition()
					teleportTo(eventModel:GetPivot().Position)
					if typeof(floatingPlat) == "function" then
						floatingPlat(true)
					end
					alreadyTeleported = true
					teleportTime = tick()
					eventTarget = eventModel.Name
					NotifyError("Event Farm", "Teleported to: " .. eventTarget)
					break
				end
			else
				if teleportTime and (tick() - teleportTime >= 900) then
					returnToOriginalPosition()
					if typeof(floatingPlat) == "function" then
						floatingPlat(false)
					end
					alreadyTeleported = false
					teleportTime = nil
					eventTarget = nil
					NotifyInfo("Event Timeout", "Returned after 15 minutes.")
				elseif eventTarget and not isEventStillActive(eventTarget) then
					returnToOriginalPosition()
					if typeof(floatingPlat) == "function" then
						floatingPlat(false)
					end
					alreadyTeleported = false
					teleportTime = nil
					NotifyInfo("Event Ended", "Returned to start position.")
				end
			end
		else
			if alreadyTeleported then
				returnToOriginalPosition()
				if typeof(floatingPlat) == "function" then
					floatingPlat(false)
				end
				alreadyTeleported = false
				teleportTime = nil
				eventTarget = nil
			end
		end

		task.wait(1)
	end
end

task.spawn(monitorAutoTP)

local selectedIsland = "09"
local isAutoFarmRunning = false

local islandCodes = {
    ["01"] = "Crater Islands",
    ["02"] = "Tropical Grove",
    ["03"] = "Vulcano",
    ["04"] = "Coral Reefs",
    ["05"] = "Winter",
    ["06"] = "Machine",
    ["07"] = "Treasure Room",
    ["08"] = "Sisyphus Statue",
    ["09"] = "Fisherman Island",
    ["10"] = "Esoteric Depths",
}

local farmLocations = {
    ["Crater Islands"] = {
    	CFrame.new(1066.1864, 57.2025681, 5045.5542, -0.682534158, 1.00865822e-08, 0.730853677, -5.8900711e-09, 1, -1.93017531e-08, -0.730853677, -1.74788859e-08, -0.682534158),
    	CFrame.new(1057.28992, 33.0884132, 5133.79883, 0.833871782, 5.44149223e-08, 0.551958203, -6.58184218e-09, 1, -8.86416984e-08, -0.551958203, 7.02829084e-08, 0.833871782),
    	CFrame.new(988.954712, 42.8254471, 5088.71289, -0.849417388, -9.89310394e-08, 0.527721584, -5.96115086e-08, 1, 9.15179328e-08, -0.527721584, 4.62786431e-08, -0.849417388),
    	CFrame.new(1006.70685, 17.2302666, 5092.14844, -0.989664078, 5.6538525e-09, -0.143405005, 9.14879283e-09, 1, -2.3711717e-08, 0.143405005, -2.47786183e-08, -0.989664078),
    	CFrame.new(1025.02356, 2.77259707, 5011.47021, -0.974474192, -6.87871804e-08, 0.224499553, -4.47472104e-08, 1, 1.12170284e-07, -0.224499553, 9.92613209e-08, -0.974474192),
    	CFrame.new(1071.14551, 3.528404, 5038.00293, -0.532300115, 3.38677708e-08, 0.84655571, 6.69992914e-08, 1, 2.12149165e-09, -0.84655571, 5.7847906e-08, -0.532300115),
    	CFrame.new(1022.55457, 16.6277809, 5066.28223, 0.721996129, 0, -0.691897094, 0, 1, 0, 0.691897094, 0, 0.721996129),
    },
    ["Tropical Grove"] = {
    	CFrame.new(-2165.05469, 2.77070165, 3639.87451, -0.589090407, -3.61497356e-08, -0.808067143, -3.20645626e-08, 1, -2.13606164e-08, 0.808067143, 1.3326984e-08, -0.589090407)
    },
    ["Vulcano"] = {
    	CFrame.new(-701.447937, 48.1446075, 93.1546631, -0.0770962164, 1.34335654e-08, -0.997023642, 9.84464776e-09, 1, 1.27124169e-08, 0.997023642, -8.83526763e-09, -0.0770962164),
    	CFrame.new(-654.994934, 57.2567711, 75.098526, -0.540957272, 2.58946509e-09, -0.841050088, -7.58775585e-08, 1, 5.18827363e-08, 0.841050088, 9.1883166e-08, -0.540957272),
    },
    ["Coral Reefs"] = {
    	CFrame.new(-3118.39624, 2.42531538, 2135.26392, 0.92336154, -1.0069185e-07, -0.383931547, 8.0607947e-08, 1, -6.84016968e-08, 0.383931547, 3.22115596e-08, 0.92336154),
    },
    ["Winter"] = {
    	CFrame.new(2036.15308, 6.54998732, 3381.88916, 0.943401575, 4.71338666e-08, -0.331652641, -3.28136842e-08, 1, 4.87781051e-08, 0.331652641, -3.51345975e-08, 0.943401575),
    },
    ["Machine"] = {
    	CFrame.new(-1459.3772, 14.7103214, 1831.5188, 0.777951121, 2.52131862e-08, -0.628324807, -5.24126378e-08, 1, -2.47663063e-08, 0.628324807, 5.21991339e-08, 0.777951121)
    },
    ["Treasure Room"] = {
    	CFrame.new(-3625.0708, -279.074219, -1594.57605, 0.918176472, -3.97606392e-09, -0.396171629, -1.12946204e-08, 1, -3.62128851e-08, 0.396171629, 3.77244298e-08, 0.918176472),
    	CFrame.new(-3600.72632, -276.06427, -1640.79663, -0.696130812, -6.0491181e-09, 0.717914939, -1.09490363e-08, 1, -2.19084972e-09, -0.717914939, -9.38559541e-09, -0.696130812),
    	CFrame.new(-3548.52222, -269.309845, -1659.26685, 0.0472991578, -4.08685423e-08, 0.998880744, -7.68598838e-08, 1, 4.45538149e-08, -0.998880744, -7.88812216e-08, 0.0472991578),
    	CFrame.new(-3581.84155, -279.09021, -1696.15637, -0.999634147, -0.000535600528, -0.0270430837, -0.000448358158, 0.999994695, -0.00323198596, 0.0270446707, -0.00321867829, -0.99962908),
    	CFrame.new(-3601.34302, -282.790955, -1629.37036, -0.526346684, 0.00143659476, 0.850268841, -0.000266355521, 0.999998271, -0.00185445137, -0.850269973, -0.00120255165, -0.526345372)
    },
    ["Sisyphus Statue"] = {
    	CFrame.new(-3777.43433, -135.074417, -975.198975, -0.284491211, -1.02338751e-08, -0.958678663, 6.38407585e-08, 1, -2.96199456e-08, 0.958678663, -6.96293867e-08, -0.284491211),
    	CFrame.new(-3697.77124, -135.074417, -886.946411, 0.979794085, -9.24526766e-09, 0.200008959, 1.35701708e-08, 1, -2.02526174e-08, -0.200008959, 2.25575487e-08, 0.979794085),
    	CFrame.new(-3764.021, -135.074417, -903.742493, 0.785813689, -3.05788426e-08, -0.618463278, -4.87374336e-08, 1, -1.11368585e-07, 0.618463278, 1.17657272e-07, 0.785813689)
    },
    ["Fisherman Island"] = {
    	CFrame.new(-75.2439423, 3.24433279, 3103.45093, -0.996514142, -3.14880424e-08, -0.0834242329, -3.84156422e-08, 1, 8.14354024e-08, 0.0834242329, 8.43563228e-08, -0.996514142),
    	CFrame.new(-162.285294, 3.26205397, 2954.47412, -0.74356699, -1.93168272e-08, -0.668661416, 1.03873425e-08, 1, -4.04397653e-08, 0.668661416, -3.70152904e-08, -0.74356699),
    	CFrame.new(-69.8645096, 3.2620542, 2866.48096, 0.342575252, 8.79649331e-09, 0.939490378, 4.78986739e-10, 1, -9.53770485e-09, -0.939490378, 3.71738529e-09, 0.342575252),
    	CFrame.new(247.130951, 2.47001815, 3001.72412, -0.724809051, -8.27166033e-08, -0.688949764, -8.16509669e-08, 1, -3.41610367e-08, 0.688949764, 3.14931867e-08, -0.724809051)
    },
    ["Esoteric Depths"] = {
    	CFrame.new(3253.26099, -1293.7677, 1435.24756, 0.21652025, -3.88184027e-08, -0.976278126, 1.20091812e-08, 1, -3.70982107e-08, 0.976278126, -3.69178754e-09, 0.21652025),
    	CFrame.new(3299.66333, -1302.85474, 1370.98621, -0.440755099, -5.91509552e-09, 0.897627413, -2.5926683e-09, 1, 5.31664224e-09, -0.897627413, 1.60869356e-11, -0.440755099),
    	CFrame.new(3250.94531, -1302.85547, 1324.77942, -0.998184919, 5.84032058e-08, 0.0602233484, 5.50187451e-08, 1, -5.78567096e-08, -0.0602233484, -5.44382814e-08, -0.998184919),
    	CFrame.new(3219.16309, -1294.03394, 1364.41492, 0.676777482, -4.18104094e-08, -0.736187637, 8.28715798e-08, 1, 1.93907237e-08, 0.736187637, -7.41322381e-08, 0.676777482)
    }
}

local function startAutoFarmLoop()
    NotifySuccess("Auto Farm Enabled", "Fishing started on island: " .. selectedIsland)

    while isAutoFarmRunning do  
        local islandSpots = farmLocations[selectedIsland]  
        if type(islandSpots) == "table" and #islandSpots > 0 then  
            location = islandSpots[math.random(1, #islandSpots)]  
        else  
            location = islandSpots  
        end  

        if not location then  
            NotifyError("Invalid Island", "Selected island name not found.")  
            return  
        end  

        local char = workspace:FindFirstChild("Characters"):FindFirstChild(LocalPlayer.Name)  
        local hrp = char and char:FindFirstChild("HumanoidRootPart")  
        if not hrp then  
            NotifyError("Teleport Failed", "HumanoidRootPart not found.")  
            return  
        end  

        hrp.CFrame = location  
        task.wait(1.5)  

        StartAutoFish()
        
        while isAutoFarmRunning do
            if not isAutoFarmRunning then  
                StopAutoFish()  
                NotifyWarning("Auto Farm Stopped", "Auto Farm manually disabled. Auto Fish stopped.")  
                break  
            end  
            task.wait(0.5)
        end
    end
end      

local nameList = {}
local islandNamesToCode = {}

for code, name in pairs(islandCodes) do
    table.insert(nameList, name)
    islandNamesToCode[name] = code
end

table.sort(nameList)

local CodeIsland = AutoFarmTab:Dropdown({
    Title = "Farm Island",
    Values = nameList,
    Value = nameList[9],
    Callback = function(selectedName)
        local code = islandNamesToCode[selectedName]
        local islandName = islandCodes[code]
        if islandName and farmLocations[islandName] then
            selectedIsland = islandName
            NotifySuccess("Island Selected", "Farming location set to " .. islandName)
        else
            NotifyError("Invalid Selection", "The island name is not recognized.")
        end
    end
})

myConfig:Register("IslCode", CodeIsland)

local AutoFarm = AutoFarmTab:Toggle({
	Title = "Start Auto Farm",
	Callback = function(state)
		isAutoFarmRunning = state
		if state then
			startAutoFarmLoop()
		else
			StopAutoFish()
		end
	end
})

myConfig:Register("AutoFarmStart", AutoFarm)

AutoFarmTab:Toggle({
	Title = "Auto Farm Event",
	Desc = "!! DO WITH YOUR OWN RISK !!",
	Value = false,
	Callback = function(state)
		autoTPEvent = state
		if autoTPEvent then
			monitorAutoTP()
		else
			if alreadyTeleported then
				returnToOriginalPosition()
				if typeof(floatingPlat) == "function" then
					floatingPlat(false)
				end
				alreadyTeleported = false
			end
		end
	end
})


-------------------------------------------
----- =======[ MASS TRADE TAB ]
-------------------------------------------

local TradeFunction = {
	TempTradeList = {},
	saveTempMode = false,
	onTrade = false,
	targetUserId = nil,
	tradingInProgress = false,
	autoAcceptTrade = false,
	AutoTrade = false
}

local RETextNotification = net["RE/TextNotification"]
local RFAwaitTradeResponse = net["RF/AwaitTradeResponse"]
local InitiateTrade = net["RF/InitiateTrade"]

local function getPlayerList()
    local list = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.DisplayName .. " (" .. player.Name .. ")")
        end
    end
    return list
end

local TradeTargetDropdown = Trade:Dropdown({
    Title = "Select Trade Target",
    Values = getPlayerList(),
    Value = getPlayerList()[1] or nil,
    Callback = function(selected)
        local username = selected:match("%((.-)%)")
        local player = Players:FindFirstChild(username)
        if player then
            TradeFunction.targetUserId = player.UserId
            NotifySuccess("Trade Target", "Target found: " .. player.Name)
        else
            NotifyError("Trade Target", "Player not found!")
        end
    end
})

local function refreshDropdown()
    local updatedList = getPlayerList()
    TradeTargetDropdown:Refresh(updatedList)
end

Players.PlayerAdded:Connect(refreshDropdown)
Players.PlayerRemoving:Connect(refreshDropdown)

refreshDropdown()

Trade:Toggle({
    Title = "Mode Save Items",
    Desc = "Click inventory item to add for Mass Trade",
    Value = false,
    Callback = function(state)
        if Notifs.TradeblockNotif then
        	Notifs.TradeblockNotif = false
					return
				end
        TradeFunction.saveTempMode = state
        if state then
            TradeFunction.TempTradeList = {}
            NotifySuccess("Save Mode", "Enabled - Click items to save")
        else
            NotifyInfo("Save Mode", "Disabled - "..#TradeFunction.TempTradeList.." items saved")
        end
    end
})

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if TradeFunction.saveTempMode and tostring(self) == "RE/EquipItem" and method == "FireServer" then
    	  local uuid, categoryName = args[1], args[2]
        if uuid and categoryName then
            table.insert(TradeFunction.TempTradeList, {UUID = uuid, Category = categoryName})
            NotifySuccess("Save Mode", "Added item: " .. uuid .. " ("..categoryName..")")
        end
        return nil
        
    elseif TradeFunction.onTrade and tostring(self) == "RE/EquipItem" and method == "FireServer" then
        local uuid = args[1]
        if uuid and TradeFunction.targetUserId then
            InitiateTrade:InvokeServer(TradeFunction.targetUserId, uuid)
            NotifySuccess("Trade Sent", "Trade sent to " .. TradeFunction.targetUserId)
        else
            NotifyError("Trade Error", "Invalid target or item.")
        end
        return nil
    end

    return oldNamecall(self, unpack(args))
end)

setreadonly(mt, true)

local function TradeAll()        
    if TradeFunction.tradingInProgress then        
        NotifyWarning("Mass Trade", "Trade already in progress!")        
        return        
    end        
    if not TradeFunction.targetUserId then        
        NotifyError("Mass Trade", "Set trade target first!")        
        return        
    end        
    if #TradeFunction.TempTradeList == 0 then        
        NotifyWarning("Mass Trade", "No items saved!")        
        return        
    end        
        
    TradeFunction.tradingInProgress = true        
    NotifyInfo("Mass Trade", "Starting trade of "..#TradeFunction.TempTradeList.." items...")        
        
    task.spawn(function()        
        for i, item in ipairs(TradeFunction.TempTradeList) do        
            if not TradeFunction.AutoTrade then        
                NotifyWarning("Mass Trade", "Auto Trade stopped!")        
                break        
            end        
        
            local uuid = item.UUID        
            local category = item.Category        
        
            NotifyInfo("Mass Trade", "Trade item "..i.." of "..#TradeFunction.TempTradeList)        
            InitiateTrade:InvokeServer(TradeFunction.targetUserId, uuid, category)        
        
            local tradeCompleted = false        
            local timeout = 10        
            local elapsed = 0        
            local lastTrigger = 0
            local cooldown = 0.5        
        
            local notifGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Text Notifications")
            local connection
            connection = notifGui.Frame.ChildAdded:Connect(function(child)
                if child.Name == "TextTile" then
                    task.wait(0.5)
                    local header = child:FindFirstChild("Header")
                    if header and header:IsA("TextLabel") and header.Text == "Trade completed!" then
                        local now = tick()
                        if now - lastTrigger > cooldown then
                            lastTrigger = now
                            tradeCompleted = true
                            NotifySuccess("Mass Trade", "Success "..i.." of "..#TradeFunction.TempTradeList)
                        end
                    end
                end
            end)        
        
            repeat        
                task.wait(0.2)        
                elapsed += 0.2        
            until tradeCompleted or elapsed >= timeout        
        
            if connection then        
                connection:Disconnect()        
            end        
        
            if not tradeCompleted then        
                NotifyWarning("Mass Trade", "Trade timeout for item "..i)        
            else        
                task.wait(6.5)        
            end        
        end        
        
        NotifySuccess("Mass Trade", "Finished trading!")        
        TradeFunction.tradingInProgress = false        
        TradeFunction.TempTradeList = {}        
    end)        
end

Trade:Toggle({
    Title = "Auto Trade",
    Desc = "Trade all saved items automatically",
    Value = false,
    Callback = function(state)
				if Notifs.AutoTBlockNotif then
					Notifs.AutoTBlockNotif = false
					return
				end
        TradeFunction.AutoTrade = state
        if TradeFunction.AutoTrade then
            if #TradeFunction.TempTradeList == 0 then
                NotifyError("Mass Trade", "No items saved to trade!")
                TradeFunction.AutoTrade = false
                return
            end
            TradeAll()
            NotifySuccess("Mass Trade", "Auto Trade Enabled")
        else
            NotifyWarning("Mass Trade", "Auto Trade Disabled")
        end
    end
})

local OTBlockNotif = true

Trade:Toggle({
    Title = "Trade (Original)",
    Desc = "Click inventory items to Send Trade",
    Value = false,
    Callback = function(state)
				if OTBlockNotif then
					OTBlockNotif = false
					return
				end
        TradeFunction.onTrade = state
        if state then
            NotifySuccess("Trade", "Trade Mode Enabled. Click an item to send trade.")
        else
            NotifyWarning("Trade", "Trade Mode Disabled.")
        end
    end
})

RFAwaitTradeResponse.OnClientInvoke = function(fromPlayer, timeNow)
    if TradeFunction.autoAcceptTrade then
        return true
    else
        return nil
    end
end


Trade:Toggle({
    Title = "Auto Accept Trade",
    Desc = "Automatically accept trade requests",
    Value = false,
    Callback = function(state)
				if Notifs.AcceptBN then
					Notifs.AcceptBN = false
					return
				end
        TradeFunction.autoAcceptTrade = state
        if state then
            NotifySuccess("Auto Accept Trade", "Enabled")
        else
            NotifyWarning("Auto Accept Trade", "Disabled")
        end
    end
})


-------------------------------------------
----- =======[ PLAYER TAB ]
-------------------------------------------

local currentDropdown = nil

local function getPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.DisplayName)
        end
    end
    return list
end


local function teleportToPlayerExact(target)
    local characters = workspace:FindFirstChild("Characters")
    if not characters then return end

    local targetChar = characters:FindFirstChild(target)
    local myChar = characters:FindFirstChild(LocalPlayer.Name)

    if targetChar and myChar then
        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if targetHRP and myHRP then
            myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 0)
        end
    end
end

local function refreshDropdown()
    if currentDropdown then
        currentDropdown:Refresh(getPlayerList())
    end
end

currentDropdown = Player:Dropdown({
    Title = "Teleport to Player",
    Desc = "Select player to teleport",
    Values = getPlayerList(),
    Callback = function(selectedDisplayName)
        for _, p in pairs(Players:GetPlayers()) do
            if p.DisplayName == selectedDisplayName then
                teleportToPlayerExact(p.Name)
                NotifySuccess("Teleport Successfully", "Successfully Teleported to " .. p.DisplayName .. "!", 3)
                break
            end
        end
    end
})

Players.PlayerAdded:Connect(function()
    task.delay(0.1, refreshDropdown)
end)

Players.PlayerRemoving:Connect(function()
    task.delay(0.1, refreshDropdown)
end)

refreshDropdown()


local defaultMinZoom = LocalPlayer.CameraMinZoomDistance
local defaultMaxZoom = LocalPlayer.CameraMaxZoomDistance

Player:Toggle({
    Title = "Unlimited Zoom",
    Desc = "Unlimited Camera Zoom for take a Picture",
    Value = false,
    Callback = function(state)
        if state then
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 9999
        else
            LocalPlayer.CameraMinZoomDistance = defaultMinZoom
            LocalPlayer.CameraMaxZoomDistance = defaultMaxZoom
        end
    end
})


local function accessAllBoats()
    local vehicles = workspace:FindFirstChild("Vehicles")
    if not vehicles then
        NotifyError("Not Found", "Vehicles container not found.")
        return
    end

    local count = 0

    for _, boat in ipairs(vehicles:GetChildren()) do
        if boat:IsA("Model") and boat:GetAttribute("OwnerId") then
            local currentOwner = boat:GetAttribute("OwnerId")
            if currentOwner ~= LocalPlayer.UserId then
                boat:SetAttribute("OwnerId", LocalPlayer.UserId)
                count += 1
            end
        end
    end

    NotifySuccess("Access Granted", "You now own " .. count .. " boat(s).", 3)
end

Player:Button({
    Title = "Access All Boats",
    Callback = accessAllBoats
})

Player:Toggle({
	Title = "Infinity Jump",
	Callback = function(val)
		ijump = val
	end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
	if ijump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

local EnableFloat = Player:Toggle({
	Title = "Enable Float",
	Value = false,
	Callback = function(enabled)
			floatingPlat(enabled)
	end,
})

myConfig:Register("ActiveFloat", EnableFloat)

local universalNoclip = false
local originalCollisionState = {}

local NoClip = Player:Toggle({
	Title = "Universal No Clip",
	Value = false,
	Callback = function(val)
		if Notifs.UniVBlockNotif then
			Notifs.UniVBlockNotif = false
			return
		end
		universalNoclip = val

		if val then
			NotifySuccess("Universal Noclip Active", "You & your vehicle can penetrate all objects.", 3)
		else

			for part, state in pairs(originalCollisionState) do
				if part and part:IsA("BasePart") then
					part.CanCollide = state
				end
			end
			originalCollisionState = {}
			NotifyWarning("Universal Noclip Disabled", "All collisions are returned to their original state.", 3)
		end
	end,
})

game:GetService("RunService").Stepped:Connect(function()
	if not universalNoclip then return end

	local char = LocalPlayer.Character
	if char then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide == true then
				originalCollisionState[part] = true
				part.CanCollide = false
			end
		end
	end

	for _, model in ipairs(workspace:GetChildren()) do
		if model:IsA("Model") and model:FindFirstChildWhichIsA("VehicleSeat", true) then
			for _, part in ipairs(model:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide == true then
					originalCollisionState[part] = true
					part.CanCollide = false
				end
			end
		end
	end
end)

myConfig:Register("NoClip", NoClip)

local AntiDrown_Enabled = false
local rawmt = getrawmetatable(game)
setreadonly(rawmt, false)
local oldNamecall = rawmt.__namecall

rawmt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if tostring(self) == "URE/UpdateOxygen" and method == "FireServer" and AntiDrown_Enabled then
        return nil
    end

    return oldNamecall(self, ...)
end)

local DrownBN = true

local ADrown = Player:Toggle({
	Title = "Anti Drown (Oxygen Bypass)",
	Callback = function(state)
		AntiDrown_Enabled = state
		if DrownBN then
			DrownBN = false
			return
		end
		if state then
			NotifySuccess("Anti Drown Active", "Oxygen loss has been blocked.", 3)
		else
			NotifyWarning("Anti Drown Disabled", "You're vulnerable to drowning again.", 3)
		end
	end,
})

myConfig:Register("AntiDrown", ADrown)

local Speed = Player:Slider({
	Title = "WalkSpeed",
	Value = {
	    Min = 16,
	    Max = 200,
	    Default = 20
	},
	Step = 1,
	Callback = function(val)
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = val end
	end,
})

myConfig:Register("PlayerSpeed", Speed)

local Jp = Player:Slider({
	Title = "Jump Power",
	Value = {
	    Min = 50, 
	    Max = 500,
	    Default = 35
	},
	Step = 10,
	Callback = function(val)
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.UseJumpPower = true
				hum.JumpPower = val
			end
		end
	end,
})

myConfig:Register("JumpPower", Jp)


-------------------------------------------
----- =======[ UTILITY TAB ]
-------------------------------------------

local weatherActive = {}
local weatherData = {
    ["Storm"] = { duration = 900 },
    ["Cloudy"] = { duration = 900 },
    ["Snow"] = { duration = 900 },
    ["Wind"] = { duration = 900 },
    ["Radiant"] = { duration = 900 }
}

local function randomDelay(min, max)
    return math.random(min * 100, max * 100) / 100
end

local function autoBuyWeather(weatherType)
    local purchaseRemote = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net")
        :WaitForChild("RF/PurchaseWeatherEvent")

    task.spawn(function()
        while weatherActive[weatherType] do
            pcall(function()
                purchaseRemote:InvokeServer(weatherType)
                NotifySuccess("Weather Purchased", "Successfully activated " .. weatherType)

                task.wait(weatherData[weatherType].duration)

                local randomWait = randomDelay(1, 5)
                NotifyInfo("Waiting...", "Delay before next purchase: " .. tostring(randomWait) .. "s")
                task.wait(randomWait)
            end)
        end
    end)
end

local WeatherDropdown = Utils:Dropdown({
    Title = "Auto Buy Weather",
    Values = { "Storm", "Cloudy", "Snow", "Wind", "Radiant" },
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
    	  if Notifs.WBN then
    	  	Notifs.WBN = false
    	  	return
    	  end
        for weatherType, active in pairs(weatherActive) do
            if active and not table.find(selected, weatherType) then
                weatherActive[weatherType] = false
                NotifyWarning("Auto Weather", "Auto buying " .. weatherType .. " has been stopped.")
            end
        end
        for _, weatherType in pairs(selected) do
            if not weatherActive[weatherType] then
                weatherActive[weatherType] = true
                NotifyInfo("Auto Weather", "Auto buying " .. weatherType .. " has started!")
                autoBuyWeather(weatherType)
            end
        end
    end
})

myConfig:Register("WeatherDropdown", WeatherDropdown)


local RodItemsPath = game:GetService("ReplicatedStorage"):WaitForChild("Items")

local BaitsPath = ReplicatedStorage:WaitForChild("Baits")

local lastModifiedRod = nil
local originalRodData = {}

local lastModifiedBait = nil
local originalBaitData = {}

local function deepCopyTable(tbl)
	local copy = {}
	for k, v in pairs(tbl) do
		copy[k] = typeof(v) == "table" and deepCopyTable(v) or v
	end
	return copy
end

local function resetPreviousRod()
	if lastModifiedRod and originalRodData[lastModifiedRod] then
		local rodModule = RodItemsPath:FindFirstChild(lastModifiedRod)
		if rodModule and rodModule:IsA("ModuleScript") then
			local rodData = require(rodModule)
			local originalData = originalRodData[lastModifiedRod]

			for key, value in pairs(originalData) do
				rodData[key] = value
			end
			NotifyWarning("Rod Reset", "Rod '" .. lastModifiedRod .. "' has been reset.", 3)
		end
	end
end

local function modifyRodData(rodNameInput)
	local targetModule = RodItemsPath:FindFirstChild(rodNameInput)
	if not targetModule then
		NotifyError("Rod Not Found", "No rod matched: " .. rodNameInput, 3)
		return
	end

	resetPreviousRod()

	local rodData = require(targetModule)
	if rodData.Data and rodData.Data.Type == "Fishing Rods" then
		originalRodData[rodNameInput] = deepCopyTable(rodData)
		lastModifiedRod = rodNameInput

		if rodData.RollData and rodData.RollData.BaseLuck then
			rodData.RollData.BaseLuck *= 1.35
		end
		if rodData.ClickPower then
			rodData.ClickPower *= 1.25
		end
		if rodData.Resilience then
			rodData.Resilience *= 1.25
		end
		if typeof(rodData.Windup) == "NumberRange" then
			local newMin = rodData.Windup.Min * 0.50
			local newMax = rodData.Windup.Max * 0.50
			rodData.Windup = NumberRange.new(newMin, newMax)
		end
		if rodData.MaxWeight then
			rodData.MaxWeight *= 1.25
		end

		NotifySuccess("Rod Modified", "Rod '" .. rodData.Data.Name .. "' successfully boosted.", 3)
	else
		NotifyError("Invalid Rod", "The selected module is not a valid rod.", 3)
	end
end

local function resetPreviousBait()
	if lastModifiedBait and originalBaitData[lastModifiedBait] then
		local bait = BaitsPath:FindFirstChild(lastModifiedBait)
		if bait and bait:IsA("ModuleScript") then
			local baitData = require(bait)
			local originalData = originalBaitData[lastModifiedBait]

			for key, value in pairs(originalData) do
				baitData[key] = value
			end

			NotifyWarning("Bait Reset", "Bait '" .. lastModifiedBait .. "' has been reset.", 3)
		end
	end
end

local function modifyBaitData(baitName)
	local baitModule = BaitsPath:FindFirstChild(baitName)
	if not baitModule then
		NotifyError("Bait Not Found", "No bait matched: " .. baitName, 3)
		return
	end

	resetPreviousBait()

	local baitData = require(baitModule)
	originalBaitData[baitName] = deepCopyTable(baitData)
	lastModifiedBait = baitName

	if baitData.Modifiers and baitData.Modifiers.BaseLuck then
		baitData.Modifiers.BaseLuck *= 1.4
	end

	NotifySuccess("Bait Modified", "Bait '" .. baitName .. "' successfully boosted.", 3)
end

local rodOptions = {}
local rodNameMap = {}

for _, item in pairs(RodItemsPath:GetChildren()) do
	if item:IsA("ModuleScript") and item.Name:sub(1,3) == "!!!" then
		local displayName = item.Name:gsub("^!!!", "")
		table.insert(rodOptions, displayName)
		rodNameMap[displayName] = item.Name
	end
end

Utils:Dropdown({
	Title = "Rod Modifiers",
	Values = rodOptions,
	Multi = false,
	Callback = function(displayedRodName)
		local actualRodName = rodNameMap[displayedRodName]
		if actualRodName then
			modifyRodData(actualRodName)
		end
	end
})


local baitOptions = {}
for _, bait in pairs(BaitsPath:GetChildren()) do
	if bait:IsA("ModuleScript") then
		table.insert(baitOptions, bait.Name)
	end
end

Utils:Dropdown({
	Title = "Bait Modifier",
	Values = baitOptions,
	Multi = false,
	Callback = function(option)
		modifyBaitData(option)
	end
})

Utils:Button({
	Title = "Reset Last Modified Bait",
	Callback = function()
		if lastModifiedBait then
			resetPreviousBait()
			lastModifiedBait = nil
		else
			NotifyWarning("No Bait", "No bait has been modified yet.", 3)
		end
	end
})

Utils:Button({
	Title = "Reset Last Modified Rod",
	Callback = function()
		if lastModifiedRod then
			resetPreviousRod()
			lastModifiedRod = nil
		else
			NotifyWarning("No Rod", "No rod has been modified yet.", 3)
		end
	end
})

local islandCoords = {
	["01"] = { name = "Weather Machine", position = Vector3.new(-1471, -3, 1929) },
	["02"] = { name = "Esoteric Depths", position = Vector3.new(3157, -1303, 1439) },
	["03"] = { name = "Tropical Grove", position = Vector3.new(-2038, 3, 3650) },
	["04"] = { name = "Stingray Shores", position = Vector3.new(-32, 4, 2773) },
	["05"] = { name = "Kohana Volcano", position = Vector3.new(-519, 24, 189) },
	["06"] = { name = "Coral Reefs", position = Vector3.new(-3095, 1, 2177) },
	["07"] = { name = "Crater Island", position = Vector3.new(968, 1, 4854) },
	["08"] = { name = "Kohana", position = Vector3.new(-658, 3, 719) },
	["09"] = { name = "Winter Fest", position = Vector3.new(1611, 4, 3280) },
	["10"] = { name = "Isoteric Island", position = Vector3.new(1987, 4, 1400) },
	["11"] = { name = "Treasure Hall", position = Vector3.new(-3600, -267, -1558) },
	["12"] = { name = "Lost Shore", position = Vector3.new(-3663, 38, -989 ) },
	["13"] = { name = "Sishypus Statue", position = Vector3.new(-3792, -135, -986) }
}

local islandNames = {}
for _, data in pairs(islandCoords) do
    table.insert(islandNames, data.name)
end

Utils:Dropdown({
    Title = "Island Selector",
    Desc = "Select island to teleport",
    Values = islandNames,
    Value = islandNames[1],
    Callback = function(selectedName)
        for code, data in pairs(islandCoords) do
            if data.name == selectedName then
                local success, err = pcall(function()
                    local charFolder = workspace:WaitForChild("Characters", 5)
                    local char = charFolder:FindFirstChild(LocalPlayer.Name)
                    if not char then error("Character not found") end
                    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
                    if not hrp then error("HumanoidRootPart not found") end
                    hrp.CFrame = CFrame.new(data.position + Vector3.new(0, 5, 0))
                end)

                if success then
                    NotifySuccess("Teleported!", "You are now at " .. selectedName)
                else
                    NotifyError("Teleport Failed", tostring(err))
                end
                break
            end
        end
    end
})

local eventsList = { "Shark Hunt", "Ghost Shark Hunt", "Worm Hunt", "Black Hole", "Shocked", "Ghost Worm", "Meteor Rain" }

Utils:Dropdown({
    Title = "Teleport Event",
    Values = eventsList,
    Value = "Shark Hunt",
    Callback = function(option)
        local props = workspace:FindFirstChild("Props")
        if props and props:FindFirstChild(option) and props[option]:FindFirstChild("Fishing Boat") then
            local fishingBoat = props[option]["Fishing Boat"]
            local boatCFrame = fishingBoat:GetPivot()
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = boatCFrame + Vector3.new(0, 15, 0)
                WindUI:Notify({
                	Title = "Event Available!",
                	Content = "Teleported To " .. option,
                	Icon = "circle-check",
                	Duration = 3
                })
            end
        else
            WindUI:Notify({
                Title = "Event Not Found",
                Text = option .. " Not Found!",
                Icon = "ban",
                Duration = 3
            })
        end
    end
})

local TweenService = game:GetService("TweenService")

local HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local Items = ReplicatedStorage:WaitForChild("Items")
local Baits = ReplicatedStorage:WaitForChild("Baits")
local net = ReplicatedStorage:WaitForChild("Packages")
	:WaitForChild("_Index")
	:WaitForChild("sleitnick_net@0.2.0")
	:WaitForChild("net")


local npcCFrame = CFrame.new(
	66.866745, 4.62500143, 2858.98535,
	-0.981261611, 5.77215005e-08, -0.192680314,
	6.94250204e-08, 1, -5.39889484e-08,
	0.192680314, -6.63541186e-08, -0.981261611
)


local function FadeScreen(duration)
	local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false

	local frame = Instance.new("Frame", gui)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 0.1

	local tweenIn = TweenService:Create(frame, TweenInfo.new(0.2), { BackgroundTransparency = 0.1 })
	tweenIn:Play()
	tweenIn.Completed:Wait()

	wait(duration)

	local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 0.1 })
	tweenOut:Play()
	tweenOut.Completed:Wait()
	gui:Destroy()
end

local function SafePurchase(callback)
	local originalCFrame = HRP.CFrame
	HRP.CFrame = npcCFrame
	FadeScreen(0.2)
	pcall(callback)
	wait(0.1)
	HRP.CFrame = originalCFrame
end

local rodOptions = {}
local rodData = {}

for _, rod in ipairs(Items:GetChildren()) do
	if rod:IsA("ModuleScript") and rod.Name:find("!!!") then
		local success, module = pcall(require, rod)
		if success and module and module.Data then
			local id = module.Data.Id
			local name = module.Data.Name or rod.Name
			local price = module.Price or module.Data.Price

			if price then
				table.insert(rodOptions, name .. " | Price: " .. tostring(price))
				rodData[name] = id
			end
		end
	end
end

Utils:Dropdown({
	Title = "Rod Shop",
	Desc = "Select Rod to Buy",
	Values = rodOptions,
	Value = nil,
	Callback = function(option)
		local selectedName = option:split(" |")[1]
		local id = rodData[selectedName]

		SafePurchase(function()
			net:WaitForChild("RF/PurchaseFishingRod"):InvokeServer(id)
			NotifySuccess("Rod Purchased", selectedName .. " has been successfully purchased!")
		end)
	end,
})


local baitOptions = {}
local baitData = {}

for _, bait in ipairs(Baits:GetChildren()) do
	if bait:IsA("ModuleScript") then
		local success, module = pcall(require, bait)
		if success and module and module.Data then
			local id = module.Data.Id
			local name = module.Data.Name or bait.Name
			local price = module.Price or module.Data.Price

			if price then
				table.insert(baitOptions, name .. " | Price: " .. tostring(price))
				baitData[name] = id
			end
		end
	end
end

Utils:Dropdown({
	Title = "Baits Shop",
	Desc = "Select Baits to Buy",
	Values = baitOptions,
	Value = nil,
	Callback = function(option)
		local selectedName = option:split(" |")[1]
		local id = baitData[selectedName]

		SafePurchase(function()
			net:WaitForChild("RF/PurchaseBait"):InvokeServer(id)
			NotifySuccess("Bait Purchased", selectedName .. " has been successfully purchased!")
		end)
	end,
})

local npcFolder = game:GetService("ReplicatedStorage"):WaitForChild("NPC")

local npcList = {}
for _, npc in pairs(npcFolder:GetChildren()) do
	if npc:IsA("Model") then
		local hrp = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
		if hrp then
			table.insert(npcList, npc.Name)
		end
	end
end


Utils:Dropdown({
	Title = "NPC",
	Desc = "Select NPC to Teleport",
	Values = npcList,
	Value = nil,
	Callback = function(selectedName)
		local npc = npcFolder:FindFirstChild(selectedName)
		if npc and npc:IsA("Model") then
			local hrp = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
			if hrp then
				local charFolder = workspace:FindFirstChild("Characters", 5)
				local char = charFolder and charFolder:FindFirstChild(LocalPlayer.Name)
				if not char then return end
				local myHRP = char:FindFirstChild("HumanoidRootPart")
				if myHRP then
					myHRP.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
					NotifySuccess("Teleported!", "You are now near: " .. selectedName)
				end
			end
		end
	end
})

-------------------------------------------
----- =======[ FISH NOTIF TAB ]
-------------------------------------------

local LocalPlayer = game:GetService("Players").LocalPlayer
local REObtainedNewFishNotification = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]

local webhookPath = nil
local FishWebhookEnabled = true

FishNotif:Paragraph({
	Title = "Fish Notification",
	Color = "Green",
	Desc = [[
This is a Fish Notification that functions to display fish in the channel server.
You can buy a Key for the custom Channel you want.
Price : 100K IDR
]]
})

local function validateWebhook(path)
	if not path:match("^%d+/.+") then
		return false, "Invalid format"
	end

	local url = "https://discord.com/api/webhooks/" .. path
	local success, response = pcall(function()
		return game:HttpGet(url)
	end)

	if not success then
		return false, "Failed to connect to Discord"
	end

	local ok, data = pcall(function()
		return HttpService:JSONDecode(response)
	end)

	if not ok or not data or not data.channel_id then
		return false, "Invalid"
	end

	return true, data.channel_id
end

local apiKey = FishNotif:Input({
    Title = "Key Notification",
    Desc = "Input your private key!",
    Placeholder = "Enter Key....",
    Callback = function(text)
	    	if Notifs.APIBN then
	    		Notifs.APIBN = false
	    		return
	    	end
      
        webhookPath = text
        local isValid, result = validateWebhook(webhookPath)
        if isValid then
            WindUI:Notify({
                Title = "Key Valid",
                Content = "Channel ID: " .. tostring(result),
                Duration = 5,
                Icon = "circle-check"
            })
        else
            WindUI:Notify({
                Title = "Key Invalid",
                Content = tostring(result),
                Duration = 5,
                Icon = "ban"
            })
        end
    end
})

myConfig:Register("FishApiKey", apiKey)

FishNotif:Toggle({
    Title = "Fish Notification",
    Desc = "Send fish notifications to Discord",
    Value = true,
    Callback = function(state)
        FishWebhookEnabled = state
    end
})

local FishCategories = {
	["Secret"] = {
		"Blob Shark","Great Christmas Whale","Frostborn Shark","Great Whale","Worm Fish","Robot Kraken",
		"Giant Squid","Ghost Worm Fish","Ghost Shark","Queen Crab","Orca","Crystal Crab","Monster Shark","Eerie Shark", "Scare", "Thin Armor Shark", "Orca"
	},
	["Mythic"] = {
		"Gingerbread Shark","Loving Shark","King Crab","Blob Fish","Hermit Crab","Luminous Fish",
		"Plasma Shark","Abyss Seahorse","Blueflame Ray","Hammerhead Shark","Hawks Turtle",
		"Manta Rey","Loggerhead Turtle","Prismy Seahorse","Gingerbread Turtle", "Armor Catfish", "Armor Thin Shark", "Strippled Seahorse","Thresher Shark","Dotted Stingray"
	},
	["Legendary"] = {
		"Yellowfin Tuna","Lake Sturgeon","Lined Cardinal Fish","Saw Fish","Slurpfish Chromis","Chrome Tuna","Lobster",
		"Bumblebee Grouper","Lavafin Tuna","Blue Lobster","Greenbee Grouper","Starjam Tang","Magic Tang",
		"Enchanted Angelfish","Axolotl","Deep Sea Crab"
	},
}


local FishDataById = {}
for _, item in pairs(ReplicatedStorage.Items:GetChildren()) do
	local ok, data = pcall(require, item)
	if ok and data.Data and data.Data.Type == "Fishes" then
		FishDataById[data.Data.Id] = {
			Name = data.Data.Name,
			SellPrice = data.SellPrice or 0
		}
	end
end


local VariantsByName = {}
for _, v in pairs(ReplicatedStorage.Variants:GetChildren()) do
	local ok, data = pcall(require, v)
	if ok and data.Data and data.Data.Type == "Variant" then
		VariantsByName[data.Data.Name] = data.SellMultiplier or 1
	end
end


local SelectedCategories = {}

FishNotif:Dropdown({
	Title = "Select Fish Categories",
	Desc = "Choose which categories to send to webhook",
	Values = {"Secret", "Legendary", "Mythic"},
	Multi = true,
	Default = {"Secret"},
	Callback = function(selected)
		SelectedCategories = selected
		WindUI:Notify({
			Title = "Fish Category Updated",
			Content = "Now tracking: " .. table.concat(SelectedCategories, ", "),
			Duration = 5,
			Icon = "circle-check"
		})
	end
})

--// Button
FishNotif:Button({
    Title = "Test Webhook",
    Description = "Trigger Test Fish Notification",
    Callback = function()
        local randomWeight = math.random(20000, 25000)

        firesignal(REObtainedNewFishNotification.OnClientEvent, 
            218,
            {
                Weight = randomWeight
            },
            {
                CustomDuration = 5,
                Type = "Item",
                ItemType = "Fishes",
                _newlyIndexed = false,
                InventoryItem = {
                    Id = 218,
                    Favorited = false,
                    UUID = game:GetService("HttpService"):GenerateGUID(false),
                    Metadata = {
                        Weight = randomWeight
                    }
                },
                ItemId = 218
            },
            false
        )
    end
})

local function isTargetFish(fishName)
	for _, category in pairs(SelectedCategories) do
		local list = FishCategories[category]
		if list then
			for _, keyword in pairs(list) do
				if string.find(string.lower(fishName), string.lower(keyword)) then
					return true
				end
			end
		end
	end
	return false
end

-- Roblox image fetcher
local function GetRobloxImage(assetId)
	local url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. assetId .. "&size=420x420&format=Png&isCircular=false"
	local success, response = pcall(game.HttpGet, game, url)
	if success then
		local data = HttpService:JSONDecode(response)
		if data and data.data and data.data[1] and data.data[1].imageUrl then
			return data.data[1].imageUrl
		end
	end
	return nil
end

-- Send Webhook
local function sendFishWebhook(fishName, rarityText, assetId, itemId, variantId)
	if not webhookPath or webhookPath == "" then
		warn("Invalid Webhook Path")
		return
	end

	local WebhookURL = "https://discord.com/api/webhooks/" .. webhookPath
	local username = LocalPlayer.DisplayName
	local imageUrl = GetRobloxImage(assetId)
	if not imageUrl then return end

	-- Leaderstats
	local caught = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Caught")
	local rarest = LocalPlayer.leaderstats and LocalPlayer.leaderstats:FindFirstChild("Rarest Fish")

	-- Sell Price calculation
	local basePrice = 0
	if itemId and FishDataById[itemId] then
		basePrice = FishDataById[itemId].SellPrice
	end

	if variantId and VariantsByName[variantId] then
		basePrice = basePrice * VariantsByName[variantId]
	end

	local embedDesc = string.format([[
Hei **%s**! 🎣
You have successfully caught a fish.

====| FISH DATA |====
🧾 Name : **%s**
🌟 Rarity : **%s**
💰 Sell Price : **%s**

====| ACCOUNT DATA |====
🎯 Total Caught : **%s**
🏆 Rarest Fish : **%s**
]],
		username,
		fishName,
		rarityText,
		tostring(basePrice),
		caught and caught.Value or "N/A",
		rarest and rarest.Value or "N/A"
	)

	local data = {
		["username"] = "dionendrahub",
		["embeds"] = {{
			["title"] = "Fish Caught!",
			["description"] = embedDesc,
			["color"] = tonumber("0x00bfff"),
			["image"] = { ["url"] = imageUrl },
			["footer"] = { ["text"] = "Fish Notification • " .. os.date("%d %B %Y, %H:%M:%S") }
		}}
	}

	local requestFunc = syn and syn.request or http and http.request or http_request or request or fluxus and fluxus.request
	if requestFunc then
		requestFunc({
			Url = WebhookURL,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(data)
		})
	else
		warn("HttpRequest tidak tersedia di executor ini.")
	end
end

-- Save last catch info from Event
local LastCatchData = {}

REObtainedNewFishNotification.OnClientEvent:Connect(function(itemId, metadata)
	LastCatchData.ItemId = itemId
	LastCatchData.VariantId = metadata and metadata.VariantId
end)

-- GUI Detection (Trigger)
local function startFishDetection()
	local plr = LocalPlayer
	local guiNotif = plr.PlayerGui:WaitForChild("Small Notification"):WaitForChild("Display"):WaitForChild("Container")

	local fishText = guiNotif:WaitForChild("ItemName")
	local rarityText = guiNotif:WaitForChild("Rarity")
	local imageFrame = plr.PlayerGui["Small Notification"]:WaitForChild("Display"):WaitForChild("VectorFrame"):WaitForChild("Vector")

	fishText:GetPropertyChangedSignal("Text"):Connect(function()
		local fishName = fishText.Text
		if isTargetFish(fishName) then
			local rarity = rarityText.Text
			local assetId = string.match(imageFrame.Image, "%d+")
			if assetId then
				sendFishWebhook(fishName, rarity, assetId, LastCatchData.ItemId, LastCatchData.VariantId)
			end
		end
	end)
end

startFishDetection()



-------------------------------------------
----- =======[ SETTINGS TAB ]
-------------------------------------------


local AntiAFKEnabled = true
local AFKConnection = nil

SettingsTab:Toggle({
	Title = "Anti-AFK",
	Value = true,
	Callback = function(Value)
		if Notifs.AFKBN then
			Notifs.AFKBN = false
			return
		end
  
		AntiAFKEnabled = Value
		if AntiAFKEnabled then
			if AFKConnection then
				AFKConnection:Disconnect()
			end

			
			
			local VirtualUser = game:GetService("VirtualUser")

			AFKConnection = LocalPlayer.Idled:Connect(function()
				pcall(function()
					VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
					task.wait(1)
					VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
				end)
			end)

			if NotifySuccess then
				NotifySuccess("Anti-AFK Activated", "You will now avoid being kicked.")
			end

		else
			if AFKConnection then
				AFKConnection:Disconnect()
				AFKConnection = nil
			end

			if NotifySuccess then
				NotifySuccess("Anti-AFK Deactivated", "You can now go idle again.")
			end
		end
	end,
})

SettingsTab:Button({
	Title = "Boost FPS (Maximize Performance)",
	Callback = function()
		for _, v in pairs(game:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
				v.Reflectance = 0
			elseif v:IsA("Decal") or v:IsA("Texture") then
				v.Transparency = 1
			end
		end

		local Lighting = game:GetService("Lighting")
		for _, effect in pairs(Lighting:GetChildren()) do
			if effect:IsA("PostEffect") then
				effect.Enabled = false
			end
		end

		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1e10

		settings().Rendering.QualityLevel = "Level01"
	end
})

SettingsTab:Button({
	Title = "HDR Shader",
	Callback = function()
		loadstring(game:HttpGet("https://paste.monster/IVE9Xt3YJWkp/raw/"))()
	end,
})

local TeleportService = game:GetService("TeleportService")

local function Rejoin()
	local player = Players.LocalPlayer
	if player then
		TeleportService:Teleport(game.PlaceId, player)
	end
end

local function ServerHop()
	local placeId = game.PlaceId
	local servers = {}
	local cursor = ""
	local found = false

	repeat
		local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then
			url = url .. "&cursor=" .. cursor
		end

		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)

		if success and result and result.data then
			for _, server in pairs(result.data) do
				if server.playing < server.maxPlayers and server.id ~= game.JobId then
					table.insert(servers, server.id)
				end
			end
			cursor = result.nextPageCursor or ""
		else
			break
		end
	until not cursor or #servers > 0

	if #servers > 0 then
		local targetServer = servers[math.random(1, #servers)]
		TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
	else
		NotifyError("Server Hop Failed", "No servers available or all are full!")
	end
end

local Keybind = SettingsTab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

myConfig:Register("Keybind", Keybind)

SettingsTab:Button({
	Title = "Rejoin Server",
	Callback = function()
		Rejoin()
	end,
})

SettingsTab:Button({
	Title = "Server Hop (New Server)",
	Callback = function()
		ServerHop()
	end,
})


SettingsTab:Button({
    Title = "Save",
    Desc = "Save Settings to config",
    Callback = function()
        myConfig:Save()
        NotifySuccess("Config Saved", "Config has been saved!")
    end
})

SettingsTab:Button({
    Title = "Load",
    Desc = "Loads Settings from config",
    Callback = function()
        myConfig:Load()
        NotifySuccess("Config Loaded", "Config has beed loaded!")
    end
})
