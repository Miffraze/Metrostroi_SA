include("shared.lua")
net.Receive("metrostroi-kgu-msa", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    ent.KGUSignalLink = net.ReadString()
    ent.KGULense = net.ReadString()
end)
function ENT:Initialize()
    self.AnimationOn = self:GetNetworkedBool("KGUState", false) 
    self:SetAnimation(self.AnimationOn)
    self.PhysgunDisabled = true
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
end

function ENT:Draw()
    self:DrawModel()
end
function ENT:Think()
    self:NextThink(CurTime())
    return true
end

net.Receive("KGU_Chat_Trigger", function()
    local lang = GetConVar("metrostroi_language"):GetString() == "en" and "en" or (GetConVar("metrostroi_language"):GetString() == "ru" and "ru" or "en")
    local files = {"msa_debug"}
    for _, suffix in ipairs(files) do
        local path = string.format("metrostroi_data/languages/%s_%s.lua", lang, suffix)
        include(path)
    end
    local link = net.ReadString()
    local state = net.ReadBool()

    local actionText_1 = state and Debug_KGU_Active_1 or Debug_KGU_DeActive_1
    local actionText_2 = state and Debug_KGU_Active_2 or Debug_KGU_DeActive_2
    local col = state and Color(255, 0, 0) or Color(0, 255, 0)
    
    chat.AddText(
        Color(0, 0, 255), "[MSA] ", 
        col, actionText_1, 
        col, link,
        col, actionText_2
    )
end)