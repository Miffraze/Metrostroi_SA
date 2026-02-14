AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("metrostroi-kgu-msa")
util.AddNetworkString("KGU_Chat_Trigger")

function Metrostroi.ForceKGUState(link, state)
    local found = false
    for _, ent in pairs(ents.FindByClass("gmod_track_kgu_msa")) do
        if ent.KGUSignalLink == link then
            ent:SetKGUState(state, true)
            found = true
        end
    end
    return found
end
function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
    self:SetCollisionBounds(Vector(-10,-10,0), Vector(10,10,10))

    self.KGUSignalLink = self.KGUSignalLink
    self.KGULense = tostring(self.KGULense)

    self.Triggered = false

    self:SetKGUState(false)

    self:NextThink(CurTime() + 0.1)
end

function ENT:SetKGUState(state, suppress_chat)
    if self.Triggered == state then return end

    self.Triggered = state

    local sig_link = self.KGUSignalLink
    local target_lense = self.KGULense
    local signal_ent = Metrostroi.GetSignalByName(sig_link)

    if not suppress_chat then
        self:NotifyClients(state)
    end

    if not state then
        if IsValid(signal_ent) and signal_ent.SetKGUOverride then
            signal_ent:SetKGUOverride(false)
        end
    else
        if IsValid(signal_ent) and signal_ent.SetKGUOverride then
            signal_ent:SetKGUOverride(true, target_lense)
        end
    end
end

function ENT:CheckRaycast()
    local height = 8  --смещение центра вверх
    local side = -32 --смещение центра вправо
    local startPos = self:GetPos() + (self:GetRight() * side) + (self:GetUp() * height)
    local length = 64 --длина влево
    local endPos = startPos + self:GetRight() * length

    local trace = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = self,
        mask = MASK_ALL 
    })

    local lineContextColor = trace.Hit and Color(0, 0, 255) or Color(0, 255, 0)
    debugoverlay.Line(startPos, trace.HitPos, 1, lineContextColor, true)
    
    if trace.Hit then
        debugoverlay.Cross(trace.HitPos, 2, 0.1, Color(255, 255, 0), true)
    end

    if IsValid(trace.Entity) then
        if not trace.Entity:IsPlayer() then
            if not self.Triggered then
                self:SetKGUState(true)
            end
        end
    end
end

function ENT:Think()
    if not self.Triggered then
        self:CheckRaycast()
    end
    
    self:NextThink(CurTime() + 0.1)
    return true
end

function ENT:NotifyClients(is_triggered)
    local link = self.KGUSignalLink
    if link == "" or link == " " then return end
    
    net.Start("KGU_Chat_Trigger")
    net.WriteString(link)
    net.WriteBool(is_triggered)
    net.Broadcast()
end
function ENT:SendUpdate(ply)
    net.Start("metrostroi-kgu-msa")
        net.WriteEntity(self)
        net.WriteString(tostring(self.KGULense) or "0")
        net.WriteString(self.KGUSignalLink or "")
    if ply then net.Send(ply) else net.Broadcast() end
end

net.Receive("metrostroi-kgu-msa", function(_, ply)
    local ent = net.ReadEntity()
    if IsValid(ent) and ent.SendUpdate then
        ent:SendUpdate(ply)
    end
end)