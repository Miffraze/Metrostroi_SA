include("shared.lua")

function ENT:Initialize()
    self.AnimationOn = self:GetNetworkedBool("KGUState", false) 
    self:SetAnimation(self.AnimationOn)
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:OnNetworkDataChanged(key, value)
    if key == "KGUState" then 
        self:SetAnimation(value)
    end
end

function ENT:SetAnimation(state)
    if state == self.AnimationOn then return end
    self.AnimationOn = state

    local sequenceName = state and "activate" or "idle"
    local seqID = self.KGU_Model:LookupSequence(sequenceName)
    
    if seqID == -1 then 
        self.KGU_Model:SetPoseParameter("hit_state", state and 1 or 0)
        return 
    end

    self.KGU_Model:SetSequence(seqID)
    self.KGU_Model:SetPlaybackRate(1)
    self.KGU_Model:SetCycle(0)
end

function ENT:Think()
    self:NextThink(CurTime())
    return true
end

net.Receive("KGU_Chat_Trigger", function()
    local link = net.ReadString()
    local state = net.ReadBool()
    local action = net.ReadString()
    
    local col = state and Color(255, 0, 0) or Color(0, 255, 0)
    chat.AddText(Color(100, 100, 255), "[MSA] ", col, action .. " КГУ: " .. link)
end)