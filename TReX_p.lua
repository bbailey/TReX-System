local send						= send
local cc							= TReX.config.cc or "##"

registerAnonymousEventHandler("room player check","TReX.p.track")
registerAnonymousEventHandler("gmcp.Room.Info",	"TReX.p.room_num_check")
registerAnonymousEventHandler("gmcp.Room.AddPlayer","TReX.p.track")
registerAnonymousEventHandler("gmcp.Room.RemovePlayer","TReX.p.track")
registerAnonymousEventHandler("gmcp.Room.Players","TReX.p.track")

TReX.p.wrong_dir=function()
	t.serverside.flee_started=false -- resets hard pause on movement keys
	t.serverside.tumble_started=false -- resets hard pause on movement keys
	gmcp.Room.WrongDir = "" -- resets wrong direction room check
end

TReX.p.tumble_dir_end=function()
	gmcp.Room.WrongDir = "" -- resets wrong direction room check
	t.send("clearqueue eqbal")
	disableTimer("tumble started")
	t.serverside.tumble_started=false -- resets hard pause on movement keys
end

TReX.p.tumble_dir_start=function()
	t.serverside.tumble_started=true
	enableTimer("tumble started")
end


TReX.p.room_num_check=function()
local room_num = gmcp.Room.Info.num
	if room_num ~= current_room_num then
		current_room_num = room_num -- resets the new current room name
		gmcp.Room.WrongDir = "" -- resets wrong direction room check
		
		t.affs.retardation = false
		

		requestchase = false
	    
		def_list.needs_full_bal["shield"].keepup=false
		

			if table.contains({t.serverside.gmcp_aff_table}, "retardation") then	
				table.remove(t.serverside.gmcp_aff_table, table.index_of(t.serverside.gmcp_aff_table), "retardation")
			end
				
		t.serverside.flee_started=false -- resets hard pause on movement keys
		raiseEvent("room player check")
		
			tempTimer(.05, [[
			  --cecho("\n<red>test 1!")
				if table.is_empty(TReX.p.here) then
					TReX.config.display("<white>Room Clear", false)
				else
					local what = "<ForestGreen>[<white>ROOM<ForestGreen>] <green>[<white>"..table.concat(TReX.p.here, "<green>]<DarkSlateGrey>-<green>[<white>").."<green>] "
					moveCursorEnd("main")
					if getCurrentLine() ~= "" then what = "\n"..what end
					if t.serverside["settings"].echos then cecho(what) end
				end
				]])
	
		
	end	
end

TReX.p.room_num_reset=function()

	t.serverside.flee_started=false -- resets hard pause on movement keys
	gmcp.Room.WrongDir = "" -- resets wrong direction room check
	t.send("cq all")
	
	if t.serverside.backflip_started then
		t.serverside.backflip_started = false
		t.serverside.myecho("BACKFLIP CANCELLED")
	elseif t.serverside.somersault_started then
		t.serverside.somersault_started = false
		t.serverside.myecho("SOMERSAULT CANCELLED")	
	elseif t.serverside.evade_started then
		t.serverside.evade_started = false
		t.serverside.myecho("EVADING CANCELLED")
	elseif t.serverside.tumble_started then
		t.serverside.tumble_started = false
		t.serverside.myecho("TUMBLE CANCELLED")
	else
		t.serverside.flee_started = false
		t.serverside.myecho("FLEE CANCELLED")
	end
	
end


TReX.p.track = function(event)
if not gmcp.Room then
	gmcp.Room.Players = {}
	sendGMCP("Core.Supports.Add [ \"Room 1\", \"Room.Players 1\" ]")
	return
end
   
	if event == "gmcp.Room.Players" or event == "room player check" then
		TReX.p.here = {}
		if gmcp.Room.Players and t.serverside.settings.sys_loaded then
				for k,v in pairs(gmcp.Room.Players) do
					if gmcp.Room.Players[k].name ~= gmcp.Char.Status.name then
						table.insert(TReX.p.here, gmcp.Room.Players[k].name)
							if hl.raid then
								if trx or jcl then
									if table.contains({trx.ally_table}, gmcp.Room.Players[k].name) and not table.contains({trx.raid.ally_table}, gmcp.Room.Players[k].name) then
										t.send("ally "..gmcp.Room.Players[k].name)
									end	
									if not table.contains({trx.ally_table}, gmcp.Room.Players[k].name) and not table.contains({trx.enemy_table}, gmcp.Room.Players[k].name) then
										if TReX.serverside.enemy_check() then
											t.send("enemy " .. gmcp.Room.Players[k].name)
										end
									end
									if table.contains({jcl.ally_table}, gmcp.Room.Players[k].name) and not table.contains({jcl.raid.ally_table}, gmcp.Room.Players[k].name) then
										t.send("ally "..gmcp.Room.Players[k].name)
									end
									 
									if not table.contains({jcl.ally_table}, gmcp.Room.Players[k].name) and not table.contains({jcl.enemy_table}, gmcp.Room.Players[k].name) then
										if TReX.serverside.enemy_check() then
											t.send("enemy " .. gmcp.Room.Players[k].name)
										end
									end
								 
								else	
									return 
								end
							end
		
					end
				end
		end
		
		
	elseif event == "gmcp.Room.RemovePlayer" then
		listRemove(TReX.p.here, gmcp.Room.RemovePlayer)
			if (table.is_empty(TReX.p.here)) then
				TReX.config.display("<white>Room Clear", false)
			else
				--cecho("\n<ForestGreen>[<DarkSlateGrey>†<ForestGreen>] <green>[<white>"..table.concat(TReX.p.here, "<green>]<DarkSlateGrey>-<green>[<white>").."<green>]")
				t.serverside.cmd_prompt = getLineCount()
				local what = "<ForestGreen>[<white>†<ForestGreen>] <green>[<white>"..table.concat(TReX.p.here, "<green>]<DarkSlateGrey>-<green>[<white>").."<green>] "
				moveCursorEnd("main")
				if getCurrentLine() ~= "" then what = "\n"..what end
					if t.serverside["settings"].echos then cecho(what) end
	  	end
	else -- gmcp.Room.AddPlayer
		table.insert(TReX.p.here, gmcp.Room.AddPlayer.name)
		local s, type = {}, type
			if next (TReX.p.here) then
				for k, v in pairs(TReX.p.here) do
				   s[#s+1] = v
				   
				end
				
				--playeradded()
				
					--echo(table.concat(TReX.p.here))
					t.serverside.cmd_prompt = getLineCount()
					local what = "<ForestGreen>[<white>†<ForestGreen>] <green>[<white>"..table.concat(TReX.p.here, "<green>]<DarkSlateGrey>-<green>[<white>").."<green>] "
					moveCursorEnd("main")
					if getCurrentLine() ~= "" then what = "\n"..what end
					if t.serverside["settings"].echos then cecho(what) end
			end
	end

	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.p.track ) ") end
	--raiseEvent("TReX changed people")

end

