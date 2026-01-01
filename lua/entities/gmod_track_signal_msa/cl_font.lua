if game.GetMap() ~= "gm_metro_minsk_1984" then 
	if game.GetMap() ~= "gm_metro_u1" then
		if game.GetMap() ~= "gm_metro_u5" then
			if game.GetMap() ~= "gm_metro_u6" then
				if game.GetMap() ~= "gm_berlin_u55" then
					if game.GetMap() ~= "gm_metro_ndr_val_v2r1" then
						timer.Simple(1, function()  
							scripted_ents.Alias ("gmod_track_signal", "gmod_track_signal_msa")
						end)
						timer.Simple(1, function()  
							scripted_ents.Alias ("gmod_track_signs", "gmod_track_signs_msa")
						end)

					else return end
				else return end
			else return end
		else return end
	else return end
else return end
Metrostroi = Metrostroi or {}
Metrostroi.RoutePointerFont = {
	[""] = {
	false,false,false,false,false,
	false,false,false,false,false,
	false,false,false,false,false,
	false,false,false,false,false,
	false,false,false,false,false,
	false,false,false,false,false,
	false,false,false,false,false,
	},
	["1"] = {
	false,false,true ,false,false,
	false,true ,true ,false,false,
	true ,false,true ,false,false,
	false,false,true ,false,false,
	false,false,true ,false,false,
	false,false,true ,false,false,
	true ,true ,true ,true ,true ,
	},
	["2"] = {
	false,true ,true ,true ,false,
	true ,false,false,false,true ,
	false,false,false,false,true ,
	false,false,false,true,false,
	false,false,true ,false,false,
	false,true ,false,false,false,
	true ,true ,true ,true ,true ,
	},
	["3"] = {
	false,true ,true ,true ,false,
	true ,false,false,false,true ,
	false,false,false,false,true ,
	false,false,true ,true ,false,
	false,false,false,false,true ,
	true ,false,false,false,true ,
	false,true ,true ,true ,false,
	},
	["4"] = {
	false,false,false,true ,false,
	false,false,true ,true ,false,
	false,true ,false,true ,false,
	true ,false,false,true ,false,
	true ,true ,true ,true ,true ,
	false,false,false,true ,false,
	false,false,false,true ,false,
	},
	["5"] = {
	true ,true ,true ,true ,true ,
	true ,false,false,false,false,
	true ,true ,true ,true ,false,
	false,false,false,false,true ,
	false,false,false,false,true ,
	true ,false,false,false,true ,
	false,true ,true ,true ,false,
	},
	["6"] = {
	false,true ,true ,true ,false,
	true ,false,false,false,true ,
	true ,false,false,false,false,
	true ,true ,true ,true ,false,
	true ,false,false,false,true ,
	true ,false,false,false,true ,
	false,true ,true ,true ,false,
	},
	["7"] = {
	true ,true ,true ,true ,true ,
	false,false,false,false,true ,
	false,false,false,true ,false,
	false,false,true ,false,false,
	false,true ,false,false,false,
	false,true ,false,false,false,
	false,true ,false,false,false,
	},
	["8"] = {
	false,true ,true ,true ,false,
	true ,false,false,false,true ,
	true ,false,false,false,true ,
	false,true ,true ,true ,false,
	true ,false,false,false,true ,
	true ,false,false,false,true ,
	false,true ,true ,true ,false,
	},
	["9"] = {
	false,true ,true ,true ,false,
	true ,false,false,false,true ,
	true ,false,false,false,true ,
	false,true ,true ,true ,true ,
	false,false,false,false,true ,
	true ,false,false,false,true ,
	false,true ,true ,true ,false,
	},
	["0"] = {
	false,true ,true ,true ,false,
	true ,false,false,false,true ,
	true ,false,false,true ,true ,
	true ,false,true ,false,true ,
	true ,true ,false,false,true ,
	true ,false,false,false,true ,
	false,true ,true ,true ,false,
	},
	["D"] = {
	false,true ,true ,true ,false,
	false,true ,false,true ,false,
	false,true ,false,true ,false,
	false,true ,false,true ,false,
	false,true ,false,true ,false,
	true ,true ,true ,true ,true ,
	true ,false,false,false,true ,
	},
	["V"] = {
	true,true ,true ,true ,false,
	true,false ,false,false ,true,
	true,false ,false,false ,true,
	true,true ,true,true ,false,
	true,false ,false,false ,true,
	true ,false ,false ,false ,true ,
	true ,true,true,true,false ,
	},
	["M"] = {
	true,false ,false ,false ,true,
	true,true ,false,true ,true,
	true,false ,true,false ,true,
	true,false ,true,false ,true,
	true,false ,false,false ,true,
	true ,false ,false ,false ,true ,
	true ,false,false,false,true ,
	},
}
