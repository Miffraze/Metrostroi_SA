include("shared.lua")

function ENT:Initialize()
    self:SetSolid(SOLID_BBOX)
    self:SetTrigger(true)
    self:SetCollisionBoundsWS(self:GetPos(), self:GetPos() + Vector(0, 0, 40))
end

function ENT:TriggerAutostop( train, cooldown )
    cooldown = tonumber(cooldown) or (train.FrontBogey.Reversed and 2 or 0.2)
    timer.Simple(cooldown, function()
        if IsValid(self) and IsValid(self:GetParent()) and IsValid(train) then
            if math.floor(train.Speed) > 0 then
                local nomsg = hook.Run("MetrostroiPassedAutostop", train, self:GetParent())
                train.Pneumatic:TriggerInput("Autostop", nomsg and 0 or 1)
                if timer.Exists("msa.autostop_trigger_" .. train:EntIndex()) then timer.Remove("msa.autostop_trigger_" .. train:EntIndex()) end
            else
                local entIndex = train:EntIndex()
                timer.Create("msa.autostop_trigger_" .. entIndex, 0.1, 0, function()
                    if not IsValid(train) then timer.Remove("msa.autostop_trigger_" .. entIndex) end
                    if math.floor(train.Speed) > 0 then
                        local nomsg = hook.Run("MetrostroiPassedAutostop", train, self:GetParent())
                        train.Pneumatic:TriggerInput("Autostop", nomsg and 0 or 1)
                        timer.Remove("msa.autostop_trigger_" .. entIndex)
                    end
                end)
            end
        end
    end)
end

function ENT:StartTouch( ent )
    if ent:GetClass("gmod_train_bogey") then
        local train = ent:GetNW2Entity("TrainEntity")
        if IsValid(train) and train.SubwayTrain and train.SubwayTrain.ALS and train.SubwayTrain.ALS.HaveAutostop and train.FrontBogey == ent and Metrostroi.TrainDirections[train] ~= nil and istable(Metrostroi.AutostopsForNode) then
            if self:GetParent().AutoType == 1 or self:GetParent().AutoType == 5 then
                if self:GetParent().TrackDir == Metrostroi.TrainDirections[train] and self:GetParent():GetNW2Bool("Autostop") then
                    self:TriggerAutostop(train)
                end
            elseif self:GetParent().AutoType == 2 then
                local maxSpeed = tonumber(self:GetParent().MaxSpeed) or 0
                maxSpeed = maxSpeed - math.random(0, 2)

                if self:GetParent().TrackDir == Metrostroi.TrainDirections[train] and train.Speed >= maxSpeed then
                    self:TriggerAutostop(train)
                end
            elseif self:GetParent().AutoType == 3 then
                if self:GetParent().TrackDir == Metrostroi.TrainDirections[train] then
                    self:TriggerAutostop(train)
                end
            elseif self:GetParent().AutoType == 4 then
                if self:GetParent().TrackDir == ent.Reversed then
                    if train.RearWagon ~= nil then
                        if train.RearWagon == ent.Reversed then
                            local maxSpeed = tonumber(self:GetParent().MaxSpeed) or 0
                            maxSpeed = maxSpeed - math.random(0, 2)

                            if train.Speed >= maxSpeed then self:TriggerAutostop(train) end
                            train.RearWagon = nil
                        else
                            self:TriggerAutostop(train)
                        end
                    else
                        self:TriggerAutostop(train)
                    end
                else
                    if train.RearWagon == nil and Metrostroi.TrainDirections[train] == self:GetParent().TrackDir then
                        train.WagonList[#train.WagonList].RearWagon = train.WagonList[#train.WagonList].FrontBogey.Reversed
                    else
                        self:TriggerAutostop(train)
                    end
                end
            elseif self:GetParent().AutoType == 6 then
                if self:GetParent().TrackDir ~= Metrostroi.TrainDirections[train] then return end
                if self:GetParent():GetNW2Bool("Autostop") then
                    self:TriggerAutostop(train)
                else
                    local maxSpeed = tonumber(self:GetParent().MaxSpeed) or 0
                    maxSpeed = maxSpeed - math.random(0, 2)
                    if train.Speed >= maxSpeed then self:TriggerAutostop(train) end
                end
            end
        end
    end
end