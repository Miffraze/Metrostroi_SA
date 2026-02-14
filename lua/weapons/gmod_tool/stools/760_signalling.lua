TOOL.Category   = "Metro"
TOOL.Name       = "Signalling Tool 81-760 Fix"
TOOL.Command    = nil
TOOL.ConfigName = ""
TOOL.ClientConVar["signaldata"] = ""
TOOL.ClientConVar["signdata"] = ""
TOOL.ClientConVar["autodata"] = ""
TOOL.ClientConVar["type"] = 1
TOOL.ClientConVar["routetype"] = 1

if SERVER then util.AddNetworkString "metrostroi-stool-760_signalling" end
CreateClientConVar( "760_optimization", "0", false, false )

local langtbl = {
	["en"] = {
		["Types"] = {"Autodrive",[0] = "Choose Type"},
		["TypesOfAuto"] = {"PrOst Sensor",[0] = "Choose Type"},
		["Auto1"] = {
			{"AutoSpawn","AutoSpawn"},
			{"Two Markers","AutoSpawn 2 markers instead of 4"},
			{"Reverse spawn","Spawn in another direction of track"},
			{"Marker №","Marker 1","Marker 2","Marker 3","Marker 4"},
			{"Right Doors","Right Doors"}
		},
		["Optimization"] = {"Optimization 760 trains","Optimization 760 trains"},		
	},
	["ru"] = {
		["Types"] = {"Автоведение",[0] = "Выберите тип"},
		["TypesOfAuto"] = {"ПрОст (Прицельная остановка)",[0] = "Выберите тип"},
		["Auto1"] = {	
			{"Автоспавн","Автоспавн"},
			{"Две метки","Автоспавн 2 меток вместо 4"},
			{"Инвертировать спавн","Спавн в другом направлении"},
			{"Метка №","Метка 1","Метка 2","Метка 3","Метка 4"},
			{"Правые двери","Правые двери"}
		},
		["Optimization"] = {"Оптимизация 760х составов","Оптимизация 760х составов"},
	}
}
TOOL.Type = 0
TOOL.Auto = {}
TOOL.Auto.Type = 0

if CLIENT then
    language.Add("Tool.760_signalling.name", "Signalling Tool 81-760")
    language.Add("Tool.760_signalling.desc", "Adds and modifies signalling equipment (ARS/ALS) or signs")
    language.Add("Tool.760_signalling.0", "Primary: Spawn/update selected signalling entity (point at the inner side of rail)\nReload: Copy ARS/light settings\nSecondary: Remove")
    language.Add("Undone_760_signalling", "Undone ARS/signalling equipment")
end

function TOOL:SpawnAutoPlate(ply,trace,param)
    local pos = trace.HitPos

    -- Use some code from rerailer --
    local tr = Metrostroi.RerailGetTrackData(pos,ply:GetAimVector())
    if not tr then return end

    local ent
    local found = false
    local entlist = ents.FindInSphere(pos,64)--64 192
    for k,v in pairs(entlist) do
        if v:GetClass() == "gmod_track_autodrive_plate" and v.PlateType == 760 then
            ent = v
            found = true
            break
        end
    end
    if param == 2 then
		if not ent or ent.PlateType ~= 760 then return end
		
		self.Auto.Mode = ent.Mode
		self.Auto.RightDoors = ent.RightDoors
		
        self.Auto.LXp = ent.LXp or self.Auto.LXp
        self.Auto.LYp = ent.LYp or self.Auto.LYp
        self.Auto.LZp = ent.LZp or self.Auto.LZp
        net.Start("metrostroi-stool-760_signalling")
            net.WriteUInt(0,8)
            net.WriteTable(self.Auto)
        net.Send(self:GetOwner())		
    else
		local entlist1 = {}	
        if self.Auto.Type == 1 then
            if not ent then ent = ents.Create("gmod_track_autodrive_plate") end
            if IsValid(ent) then
			
                local angle = (-tr.right):Angle()
                angle:RotateAroundAxis(tr.up,90)
				angle:RotateAroundAxis(tr.up,0)
				angle:RotateAroundAxis(tr.forward,0)
				
                --ent.PlateType = self.Auto.Type
				ent.PlateType = 760
                local center = (tr.centerpos - tr.up * 9.5)
                if self.Auto.Type then
                    --ent.SBPPType = 2--self.Auto.SBPPType or 1
					--ent.Prost = true
					ent.Mode = self.Auto.Mode or 1
                    ent.RightDoors = self.Auto.RightDoors					
                    --ent.Model = "models/metrostroi/signals/autodrive/rfid.mdl"
					ent.Model = "models/metrostroi_train/81-760/prost_marker.mdl"
					local dir = self.Auto.AutoSpawnR		
					if self.Auto.AutoSpawn then
						local ent2 = ents.Create("gmod_track_autodrive_plate")
						table.insert(entlist1,ent)
						table.insert(entlist1,ent2)
						if not self.Auto.AutoSpawnTwo then
							local ent3,ent4=ents.Create("gmod_track_autodrive_plate"),ents.Create("gmod_track_autodrive_plate")
							table.insert(entlist1,ent3)
							table.insert(entlist1,ent4)
						end
						local positions = {12,54,200,350}
						local pos1 = center -- + (tr.forward*((self.Auto.LXp or 0)/0.01905)+tr.right*((self.Auto.LYp or 0)/0.01905)+tr.up*((self.Auto.LZp or 0)/0.01905))
						local pos = Metrostroi.GetPositionOnTrack(pos1,angle)[1]						
						local results = Metrostroi.GetPositionOnTrack(pos1,angle)
						if not results then return end
						for i=1,#entlist1 do	
							local pos,ang = Metrostroi.GetTrackPosition(results[1].node1.path,results[1].x+positions[i]*(dir and 1 or -1))	
							local tr = Metrostroi.RerailGetTrackData(pos,ang)							
							pos = (tr.centerpos - tr.up * 9.5) + tr.up*((self.Auto.LZp or 0)/0.01905)
							entlist1[i].LXp = 0
							entlist1[i].LYp = 0
							entlist1[i].LZp = (self.Auto.LZp or 0)
							entlist1[i]:SetPos(pos)
							entlist1[i].Mode = i
							entlist1[i].RightDoors = self.Auto.RightDoors
							entlist1[i].PlateType = 760
							entlist1[i].Model = "models/metrostroi_train/81-760/prost_marker.mdl"
							entlist1[i]:SetModel(entlist1[i].Model)
							entlist1[i]:SetAngles(ang:Angle())								
						end
					else			
						local pos = center + (tr.forward*((self.Auto.LXp or 0)/0.01905)+tr.right*((self.Auto.LYp or 0)/0.01905)+tr.up*((self.Auto.LZp or 0)/0.01905))
						ent:SetPos(pos)
						ent.LXp = self.Auto.LXp
						ent.LYp = self.Auto.LYp
						ent.LZp = self.Auto.LZp
						ent.Model = "models/metrostroi_train/81-760/prost_marker.mdl"
						ent:SetModel(ent.Model)
						ent:SetAngles(angle)							
					end
                end
			end
		   if not found then
				--undo.Create("760_signalling")
				if self.Auto.AutoSpawn then
					for i=1,#entlist1 do
						entlist1[i]:Spawn()
						--entlist1[i]:Initialize()
						--undo.AddEntity(entlist1[i])
					end
				else
					ent:Spawn()
					--ent:Initialize()
				end
				-- Add to undo
				undo.Create("760_signalling")
					undo.AddEntity(ent)
					if #entlist1 > 0 then
						for i=2,#entlist1 do
							undo.AddEntity(entlist1[i])
						end
					end
					undo.SetPlayer(ply)
				undo.Finish()
			end			
        end
        return (#entlist1 > 0 and entlist1 or ent)
    end
end


function TOOL:LeftClick(trace)
    if CLIENT then
        return true
    end

    --self.Signal = util.JSONToTable(self:GetClientInfo("signaldata"):replace("''","\""))
    --if not self.Signal then return end
    local ply = self:GetOwner()
    if (ply:IsValid()) and (not ply:IsAdmin()) then return false end
    if not trace then return false end
    if trace.Entity and trace.Entity:IsPlayer() then return false end

    local ent
    if self.Type == 1 then
        ent = self:SpawnAutoPlate(ply,trace)
    end

    return true
end


function TOOL:RightClick(trace)
    if CLIENT then
        return true
    end

    local ply = self:GetOwner()
    if (ply:IsValid()) and (not ply:IsAdmin()) then return false end
    if not trace then return false end
    if trace.Entity and trace.Entity:IsPlayer() then return false end

    local entlist = ents.FindInSphere(trace.HitPos,192)
    for k,v in pairs(entlist) do
        if v:GetClass() == "gmod_track_autodrive_plate" and (v.Prost or v.PlateType == 760) then
            if IsValid(v) then SafeRemoveEntity(v) end
        end
    end
    return true
end

function TOOL:Reload(trace)
    if CLIENT then return true end
    --self.Signal = util.JSONToTable(self:GetClientInfo("signaldata"):replace("''","\""))

    local ply = self:GetOwner()
    --if not (ply:IsValid()) and (not ply:IsAdmin()) then return false end
    if not trace then return false end
    if trace.Entity and trace.Entity:IsPlayer() then return false end
    local ent
    if self.Type == 1 then
        ent = self:SpawnAutoPlate(ply,trace,2)
    end
    return true
end

function TOOL:SendSettings()
    if self.Type then
        if not self.Auto then return end
        RunConsoleCommand("signalling_autodata",util.TableToJSON(self.Auto))
        net.Start "metrostroi-stool-760_signalling"
            net.WriteUInt(0,8)
            --net.WriteEntity(self)
            net.WriteTable(self.Auto)
        net.SendToServer()
    end
end

net.Receive("metrostroi-stool-760_signalling", function(_, ply)
    local TOOL = LocalPlayer and LocalPlayer():GetTool("760_signalling") or ply:GetTool("760_signalling")
    if not TOOL then return end  -- Add this check to ensure TOOL is not nil
    local typ = net.ReadUInt(8)
    if typ then
        TOOL.Auto = net.ReadTable()
        if CLIENT then
            RunConsoleCommand("signalling_signdata", util.TableToJSON(TOOL.Auto))
            NeedUpdate = true
        end
    end

    TOOL.Type = typ + 1
end)

function TOOL:BuildCPanelCustom()
    local tool = self
    local CPanel = controlpanel.Get("760_signalling")
    if not CPanel then return end
	local lang = LocalPlayer():GetInfo("metrostroi_language") == "ru" and "ru" or "en"	
    --("signalling_signaldata",util.TableToJSON(tool.Signal))
    --tool.Type = GetConVarNumber("signalling_type") or 1
	local ltbl = langtbl[lang]	
    tool.RouteType = GetConVarNumber("signalling_routetype") or 1
    CPanel:ClearControls()
    CPanel:SetPadding(0)
    CPanel:SetSpacing(0)
    CPanel:Dock( FILL )
	
	local Optimization = vgui.Create("DCheckBoxLabel")
	Optimization:SetText(ltbl["Optimization"][1])
	Optimization:SetTooltip(ltbl["Optimization"][2])
	Optimization:SetConVar("760_optimization")
	--Optimization:SetPos(20,20)
	Optimization:SetTextColor(Color(0,0,0))
	CPanel:AddItem(Optimization)

    local VType = vgui.Create("DComboBox")
        VType:ChooseOption(ltbl["Types"][tool.Type],tool.Type)
        VType:SetColor(color_black)
        for i = 1,#ltbl["Types"] do
            VType:AddChoice(ltbl["Types"][i])
        end
        VType.OnSelect = function(_, index, name)
            VType:SetValue(name)
            tool.Type = index
            tool:SendSettings()
            tool:BuildCPanelCustom()
        end	
    CPanel:AddItem(VType)
	
    if tool.Type == 1 then
        --local VNotF = vgui.Create("DLabel") VNotF:SetText("Not Finished yet!!")
        local VAType = vgui.Create("DComboBox")
        CPanel:AddItem(VAType)		
        VAType:SetColor(color_black)
        for i = 1,#ltbl["TypesOfAuto"] do
            VAType:AddChoice(ltbl["TypesOfAuto"][i])
        end
		local toolauto = tool.Auto.Type or 1
        --VAType:ChooseOptionID(0)
        VAType:ChooseOption(ltbl["TypesOfAuto"][tool.Auto.Type],tool.Auto.Type)		
        VAType.OnSelect = function(_, index, name)
            VAType:SetValue(name)
            tool.Auto.Type = index
            tool:SendSettings()
            tool:BuildCPanelCustom()
        end
        if tool.Auto.Type == 1 then
			local ltbl = langtbl[lang]["Auto1"]
			local VLXpT = CPanel:NumSlider("X:",nil,-10,10,2)
			VLXpT:SetValue(tool.Auto.LXp or 0)
			VLXpT.OnValueChanged = function(num)
				tool.Auto.LXp = VLXpT:GetValue()
				tool:SendSettings()
			end		
			local VLYpT = CPanel:NumSlider("Y:",nil,-10,10,2)
			VLYpT:SetValue(tool.Auto.LYp or 0)
			VLYpT.OnValueChanged = function(num)
				tool.Auto.LYp = VLYpT:GetValue()
				tool:SendSettings()
			end
            local VLZpT = CPanel:NumSlider("Z:",nil,-10,10,2)
            VLZpT:SetValue(tool.Auto.LZp or 0)
            VLZpT.OnValueChanged = function(num)
                tool.Auto.LZp = VLZpT:GetValue()
                tool:SendSettings()
            end
            local VAutoSpawn = CPanel:CheckBox(ltbl[1][1])
            VAutoSpawn:SetTooltip(ltbl[1][2])
            VAutoSpawn:SetValue(tool.Auto.AutoSpawn or false)
            function VAutoSpawn:OnChange()
                tool.Auto.AutoSpawn = self:GetChecked()
                tool:SendSettings()
				tool:BuildCPanelCustom()
            end		
			if tool.Auto.AutoSpawn then
				local AutoSpawnTwo = CPanel:CheckBox(ltbl[2][1])
				AutoSpawnTwo:SetTooltip(ltbl[2][2])
				AutoSpawnTwo:SetValue(tool.Auto.AutoSpawnTwo or false)
				function AutoSpawnTwo:OnChange()
					tool.Auto.AutoSpawnTwo = self:GetChecked()
					tool:SendSettings()
				end	
				local AutoSpawnR = CPanel:CheckBox(ltbl[3][1])
				AutoSpawnR:SetTooltip(ltbl[3][2])
				AutoSpawnR:SetValue(tool.Auto.AutoSpawnR or false)
				function AutoSpawnR:OnChange()
					tool.Auto.AutoSpawnR = self:GetChecked()
					tool:SendSettings()
				end						
			else
				local VASBPPType = vgui.Create("DComboBox")
				CPanel:AddItem(VASBPPType)
				VASBPPType:SetColor(color_black)
				VASBPPType:SetTooltip(ltbl[4][1])
				VASBPPType:AddChoice(ltbl[4][2])
				VASBPPType:AddChoice(ltbl[4][3])
				VASBPPType:AddChoice(ltbl[4][4])
				VASBPPType:AddChoice(ltbl[4][5])
				VASBPPType:ChooseOptionID(tool.Auto.Mode or 1)
				VASBPPType.OnSelect = function(_, index, name)
					VASBPPType:SetValue(name)
					tool.Auto.Mode = index
					tool:SendSettings()
					tool:BuildCPanelCustom()
				end
			end
            --local SBPPType = tool.Auto.SBPPType or 1
            
			local SRDoors = CPanel:CheckBox(ltbl[5][1])
            SRDoors:SetTooltip(ltbl[5][2])
            SRDoors:SetValue(tool.Auto.RightDoors or false)
            function SRDoors:OnChange()
                tool.Auto.RightDoors = self:GetChecked()
                tool:SendSettings()
            end			
        end
    end
end

TOOL.NotBuilt = true
function TOOL:Think()
    if CLIENT and (self.NotBuilt or NeedUpdate) then
        self.Signal = self.Signal or util.JSONToTable(string.Replace(GetConVarString("signalling_signaldata"),"'","\"")) or {}
        self.Sign = self.Sign or util.JSONToTable(string.Replace(GetConVarString("signalling_signdata"),"'","\"")) or {}
        self.Auto = self.Auto or util.JSONToTable(string.Replace(GetConVarString("signalling_autodata"),"'","\"")) or {}
        self:SendSettings()
        self:BuildCPanelCustom()
        self.NotBuilt = nil
        NeedUpdate = nil
    end
end
function TOOL.BuildCPanel(panel)
    panel:AddControl("Header", { Text = "#Tool.signalling.name", Description = "#Tool.signalling.desc" })
    if not self then return end
    self:BuildCPanelCustom()
end
