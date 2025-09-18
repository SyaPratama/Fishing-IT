-- ✅ Unlock metatable dulu
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNameCall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and typeof(self) == "Instance" then
        -- Cek path lengkap biar 100% yakin
        if self:GetFullName():find("URE/UpdateOxygen") then
            print("[🛡️ BLOCKED] Remote blocked:", self:GetFullName())
            return nil -- stop, jangan kirim ke server
        end
    end

    return oldNameCall(self, ...)
end)

setreadonly(mt, true)
