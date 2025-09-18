-- ▶️ AUTO-REBLOCK IF REMOTE IS RECREATED

local function hookUpdateOxygen()
    local mt = getrawmetatable(game)
    local oldNameCall = mt.__namecall

    mt.__namecall = newcclosure(function(self, method, ...)
        if method == "FireServer" and typeof(self) == "Instance" and self.Name == "URE/UpdateOxygen" then
            local args = {...}
            local newArgs = {}
            for i = 1, #args do
                table.insert(newArgs, nil)
            end
            print("[🔄 MODIFIED] URE/UpdateOxygen — args set to nil")
            return oldNameCall(self, method, unpack(newArgs))
        end
        return oldNameCall(self, method, ...)
    end)
    print("✅ URE/UpdateOxygen hooked!")
end

-- Hook pertama kali
hookUpdateOxygen()

-- Monitor jika ada remote baru dibuat
game:GetService("ReplicatedStorage"):GetDescendants():GetPropertyChangedSignal("Name"):Connect(function(child)
    if child.Name == "URE/UpdateOxygen" and (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) then
        hookUpdateOxygen()
    end
end)