include("shared.lua")
net.Receive("metrostroi-autostop-msa", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    local oldType = ent.ASType
    ent.ASType = net.ReadInt(8)
    ent.ASSignalLink = net.ReadString()
    ent.ASMaxSpeed = net.ReadInt(32)
    if oldType ~= ent.ASType then
        ent:UpdateModel()
    end
end)
function ENT:Initialize()
    self.Anims = {}
    self.ASType = self:GetNW2Int("type")
    self:UpdateModel()
end

function ENT:UpdateModel()
    local data = self.ModelsTable[self.ASType] or self.ModelsTable[1]
    self.ModelPath = data[1]
    self.Offset = data[2] or Vector(-78, 0, 1.5)

    if IsValid(self.ClientModel) then self.ClientModel:Remove() end
    
    self.ClientModel = ClientsideModel(self.ModelPath, RENDERGROUP_OPAQUE)
    if IsValid(self.ClientModel) then
        self.ClientModel:SetPos(self:LocalToWorld(self.Offset))
        self.ClientModel:SetAngles(self:GetAngles())
        self.ClientModel:SetParent(self)
    end
end
function ENT:Animate(clientProp, value, min, max, speed, damping, stickyness)
    local id = clientProp
    if not self.Anims[id] then
        self.Anims[id] = { val = value, V = 0.0 }
    end

    if damping == false then
        local dX = speed * self.DeltaTime
        if value > self.Anims[id].val then self.Anims[id].val = math.min(value, self.Anims[id].val + dX) end
        if value < self.Anims[id].val then self.Anims[id].val = math.max(value, self.Anims[id].val - dX) end
    else
        local delta = math.abs(value - self.Anims[id].val)
        local max_speed = 1.5 * delta / self.DeltaTime
        local max_accel = 0.5 / self.DeltaTime
        local dX2dT = (speed or 128) * (value - self.Anims[id].val) - self.Anims[id].V * (damping or 8.0)
        
        dX2dT = math.Clamp(dX2dT, -max_accel, max_accel)
        self.Anims[id].V = math.Clamp(self.Anims[id].V + dX2dT * self.DeltaTime, -max_speed, max_speed)
        self.Anims[id].val = math.Clamp(self.Anims[id].val + self.Anims[id].V * self.DeltaTime, 0, 1)
    end
    
    return min + (max - min) * self.Anims[id].val
end

function ENT:Think()
    local RealTime = RealTime()
    self.DeltaTime = RealTime - (self.PrevTime or RealTime)
    self.PrevTime = RealTime

    if not self:GetNoDraw() then self:SetNoDraw(true) end

    if IsValid(self.ClientModel) then
        local animVal = self:Animate("Autostop", self:GetNW2Bool("Autostop") and 1 or 0, 0, 1, 0.4, false)
        self.ClientModel:SetPoseParameter("position", animVal)
        self.ClientModel:SetPos(self:LocalToWorld(self.Offset))
        self.ClientModel:SetAngles(self:GetAngles())
    end
    
    self:SetNextClientThink(CurTime())
    return true
end

function ENT:OnRemove()
    if IsValid(self.ClientModel) then
        self.ClientModel:Remove()
    end
end