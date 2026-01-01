if game.GetMap() ~= "gm_metro_minsk_1984" then 
	if game.GetMap() ~= "gm_metro_u1" then
		if game.GetMap() ~= "gm_metro_u5" then
			if game.GetMap() ~= "gm_metro_u6" then
				if game.GetMap() ~= "gm_berlin_u55" then
					if game.GetMap() ~= "gm_metro_ndr_val_v2r1" then
						timer.Simple(1, function()
							scripted_ents.Alias ("gmod_track_signs", "gmod_track_signs_msa")
						end)
					else return end
				else return end
			else return end
		else return end
	else return end
else return end
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
util.AddNetworkString "metrostroi-signs"

function ENT:Initialize()
	self:DrawShadow(false)
	self:SendUpdate()
end

function ENT:OnRemove()
end

function ENT:Think()
end

function ENT:SendUpdate()
	if not self.SignType then return end
	self:SetNWInt("Type",self.SignType or 1)
	self:SetNWVector("Offset",Vector(0,self.YOffset,self.ZOffset))
	self:SetNWBool("Left",self.Left or false)
end
