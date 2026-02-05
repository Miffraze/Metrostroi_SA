AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString "metrostroi-autostop"

function ENT:LinkToSignal()
    --есть таблица Metrostroi.SignalEntitiesByName[self.SignalLink], но она инициилизируется для меня слишком поздно (при загрузке из файла)
    self.Sig = nil
    if self.SignalLink then
        for k, v in pairs(ents.FindByClass("gmod_track_signal")) do
            if not IsValid(v) then continue end
            if v.Name == self.SignalLink then
                self.Sig = v
                break
            end
        end
    end
end

function ENT:Initialize()
    self.Type = tonumber(self.Type) or 1
    self.ModelPath = self.ModelsTable[self.Type][1]
    self.MaxSpeed = tonumber(self.MaxSpeed) or 35
    if not self.SignalLink or self.SignalLink == "" then self.SignalLink = nil end
    self:LinkToSignal()
    self:SetNW2Int("type", self.Type)

    self.Trigger = ents.Create("msa_autostop_trigger")
    if IsValid(self.Trigger) then
        self.Trigger:SetPos(self:GetPos())
        self.Trigger:SetParent(self)
        self.Trigger:Spawn()
        self.Trigger:Activate()
    end
end

function ENT:Think()
    self:SetNW2Bool("Autostop", IsValid(self.Sig) and self.Sig.Red or false)
    self:NextThink(CurTime() + 2)
    return true
end
