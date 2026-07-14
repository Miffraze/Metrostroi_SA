AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("metrostroi-autostop-msa")

function ENT:LinkToSignal()
    --есть таблица Metrostroi.SignalEntitiesByName[self.ASSignalLink], но она инициилизируется для меня слишком поздно (при загрузке из файла)
    self.Sig = nil
    if self.ASSignalLink then
        for k, v in pairs(ents.FindByClass("gmod_track_signal")) do
            if not IsValid(v) then continue end
            if v.Name == self.ASSignalLink then
                self.Sig = v
                break
            end
        end
    end
end
function ENT:Initialize()
    local tr = Metrostroi.RerailGetTrackData(self:GetPos(), self:GetAngles():Forward())
    if tr and tr.node1 then
        self.TrackPos = tr.pos
        self.TrackX = tr.x
        self.TrackDir = tr.dir
        self.TrackNode = tr.node1
        Metrostroi.AutostopsForNode[tr.node1] = Metrostroi.AutostopsForNode[tr.node1] or {}
        Metrostroi.AutostopsForNode[tr.node1][tr.dir] = Metrostroi.AutostopsForNode[tr.node1][tr.dir] or { [true] = {}, [false] = {} }
        table.insert(Metrostroi.AutostopsForNode[tr.node1][tr.dir][true], self)
        table.insert(Metrostroi.AutostopsForNode[tr.node1][tr.dir][false], self)
    end

    self:SetNW2Int("type", self.ASType)
    self:SendUpdate()
end
function ENT:Think()
    if not IsValid(self.Sig) and self.ASSignalLink and self.ASSignalLink != "" then
        self:LinkToSignal()
    end
    --это чисто для отвязки AutostopEnabled и самой энтити автостопа
    if IsValid(self.Sig) then
        local AuState = self.Sig.AutoEnabled or false
        if self:GetNW2Bool("AuState") != AuState then
            self:SetNW2Bool("AuState", AuState)
        end
    else
        if self:GetNW2Bool("AuState") != false then
            self:SetNW2Bool("AuState", false)
        end
    end

    self:NextThink(CurTime() + 0.2)
    return true
end
local et = {}

timer.Create("Metrostroi Autostop network sync", 0.75, 0, function()
    for _, ent in pairs(ents.FindByClass("gmod_track_autostop_msa")) do
        if IsValid(ent) then
            ent:SetNW2Bool("Autostop", not (IsValid(ent.Sig) and not ent.Sig.Red))
        end
    end
end)

timer.Create("Metrostroi Autostop physics think", 0.1, 0, function()
    for train, pos in pairs(Metrostroi.TrainPositions or et) do
        pos = pos[1]

        if  not IsValid(train) or 
            not train.SubwayTrain or 
            not train.SubwayTrain.ALS or 
            not train.SubwayTrain.ALS.HaveAutostop or 
            not pos or 
            Metrostroi.TrainDirections[train] == nil or 
            not Metrostroi.AutostopsForNode or 
            not Metrostroi.AutostopsForNode[pos.node1] or 
            not Metrostroi.AutostopsForNode[pos.node1][Metrostroi.TrainDirections[train]] 
        then continue end

        local forws, backs = {}, {}
        for i = 0, 1 do
            for _, autostop in pairs(Metrostroi.AutostopsForNode[pos.node1][Metrostroi.TrainDirections[train]][i == 1] or et) do
                if not IsValid(autostop) then continue end
                if i == 1 then
                    if not (autostop.TrackDir and autostop.TrackX < pos.x or not autostop.TrackDir and autostop.TrackX > pos.x) then
                        forws[autostop] = true
                    end
                else
                    if not (autostop.TrackDir and autostop.TrackX > pos.x or not autostop.TrackDir and autostop.TrackX < pos.x) then
                        backs[autostop] = true
                    end
                end
            end
        end
        for backautostop in pairs(backs) do
            if train.AutostopsForw and train.AutostopsForw[backautostop] then
                local isRed = true
                if IsValid(backautostop.Sig) then
                    isRed = backautostop.Sig.Red
                end

                if  (isRed and backautostop.ASType == 1) or 
                    (backautostop.ASType != 1 and (not backautostop.ASMaxSpeed or tonumber(backautostop.ASMaxSpeed) < train.Speed) or nil) 
                then
                    local nomsg = hook.Run("MetrostroiPassedAutostop", train, backautostop)
                    train.Pneumatic:TriggerInput("Autostop", nomsg and 0 or 1)
                end
            end
        end
        train.AutostopsForw = forws
        train.AutostopsBack = backs
    end
end)
function ENT:SendUpdate(ply)
    net.Start("metrostroi-autostop-msa")
        net.WriteEntity(self)
        net.WriteInt(tonumber(self.ASType) or 1, 8)
        net.WriteString(self.ASSignalLink or "")
        net.WriteInt(tonumber(self.ASMaxSpeed) or 35, 32)
    if ply then net.Send(ply) else net.Broadcast() end
end

net.Receive("metrostroi-autostop-msa", function(_, ply)
    local ent = net.ReadEntity()
    if IsValid(ent) and ent.SendUpdate then
        ent:SendUpdate(ply)
    end
end)