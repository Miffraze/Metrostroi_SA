local CATEGORY_NAME = "Metrostroi" 

function ulx.kgu_force_false(calling_ply, link)
    local link_safe = link 

    if link_safe == "" then
        ULib.tsayError( calling_ply, "Вы не указали светофор!", true ) 
        return
    end
    if Metrostroi.ForceKGUState and Metrostroi.ForceKGUState(link_safe, false) then 
        ulx.fancyLogAdmin( calling_ply, "#A отключил КГУ #s", link_safe)
    else
        ULib.tsayError( calling_ply, "КГУ '" .. link_safe .. "' не найден.", true )
    end
end
local kgu_force_false = ulx.command( CATEGORY_NAME, "ulx kgu_off", ulx.kgu_force_false, "!kguof" )
kgu_force_false:addParam{ type=ULib.cmds.StringArg, hint="SignalLink", ULib.cmds.takeRestOfLine }
kgu_force_false:defaultAccess( ULib.ACCESS_ADMIN )
kgu_force_false:help( "Сброс КГУ. Вводите названия светофоров (OK133/134)" )

function ulx.kgu_force_true(calling_ply, link)
    local link_safe = link

    if link_safe == "" then
        ULib.tsayError( calling_ply, "Вы не указали светофор!", true ) 
        return
    end
    if Metrostroi.ForceKGUState and Metrostroi.ForceKGUState(link_safe, true) then
        ulx.fancyLogAdmin( calling_ply, "#A принудительно включил КГУ #s", link_safe)
    else
        ULib.tsayError( calling_ply, "КГУ '" .. link_safe .. "' не найден.", true )
    end
end
local kgu_force_true = ulx.command( CATEGORY_NAME, "ulx kgu_on", ulx.kgu_force_true, "!kguon" )
kgu_force_true:addParam{ type=ULib.cmds.StringArg, hint="SignalLink", ULib.cmds.takeRestOfLine }
kgu_force_true:defaultAccess( ULib.ACCESS_ADMIN )
kgu_force_true:help( "Принудительное включение КГУ. Вводите названия светофоров (OK133/134)" )