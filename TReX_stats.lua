-- This is the prompt
-- Originally written by Jhui
-- Updated for TReX


local send							= send
local cc							= TReX.config.cc or "##"

--registerAnonymousEventHandler("gmcp.Char.Vitals", "TReX.stats.custom_prompt")
registerAnonymousEventHandler("gmcp.Char.Vitals", "TReX.stats.stat")
registerAnonymousEventHandler("You Died", "TReX.stats.you_died")
registerAnonymousEventHandler("You Alive", "TReX.stats.you_alive")

TReX.stats.prompt_options={
	health = function () return TReX.stats.health_color_percentage(math.floor(TReX.stats.h*100/TReX.stats.maxh))..tostring(TReX.stats.h) end,
	mana = function () return TReX.stats.mana_color_percentage(math.floor(TReX.stats.m*100/TReX.stats.maxm))..tostring(TReX.stats.m) end,
	willpower = function () return TReX.stats.willpower_color_percentage(math.floor(TReX.stats.w*100/TReX.stats.maxw))..tostring(TReX.stats.w) end,
	endurance = function () return TReX.stats.endurance_color_percentage(math.floor(TReX.stats.e*100/TReX.stats.maxe))..tostring(TReX.stats.e) end,
	timestamp = function () timestamp = tostring(getTime(true,"hh:mm:ss:zzz")) return("<dim_grey>"..timestamp) end,
	rage = function () if not TReX.hunting.rage then TReX.hunting.rage = 0 end return("<dim_grey>(<red>R<white>: "..TReX.hunting.rage.."<dim_grey>)<white>") end,
	karma = function () if TReX.s.class=="Occultist" then return "<white>("..TReX.serverside.karma_check()..")%<green> " else return "" end end,
	sunlight = function () if table.index_of({"Druid","Sylvan"}, TReX.s.class)then return "<white>("..TReX.serverside.sunlight_check()..")%<green> " else return "" end end,
	afftracker = function ()
		if not promptset then
			promptset={}
			--opromptscoreup()
		end
			if not target then 
				return "" 
			elseif #promptset > 0 then
				return "\n<red>[<white>"..table.concat(promptset, ", ").."<red>]<white>".." "
			else
				return ""
			end
	end,
	
	stacks = function () 
		if table.is_empty(t.stacks) then
			for k, v in pairs(t.serverside.cures) do -- this sets aff count by cure type to 0.
				t.stacks[k] = 0
			end
		end
		stack_option=""
		for _, stack in ipairs({"stand","focus","tree","kelp","ginseng","valerian","bloodroot","goldenseal"}) do
			if t.stacks[stack] > 0 then
				stack_option=stack_option.."<DarkSlateGrey>[<green>"..stack.."<white>: "..(t.stacks[stack]).."<DarkSlateGrey>]".." "
   			end 
   				
   		end
			if stack_option ~= "" then
				stack_option = "<DarkSlateGrey>[<green>cure<DarkSlateGrey>]:"..stack_option 
				return( stack_option )
	   		else
	   			return ""
	   		end
   	end,

	target = function () 
		
		if not target or target == "None" then
			target = ""
		end

		return "<tomato>"..target.." <white>"		

	end,


	--roomexits = function () if gmcp then if gmcp.Room then exitStr = "" for k, v in pairs(gmcp.Room.Info.exits) do exitStr = exitStr.." "..k--[[:upper()]]..")" end if gmcp.Room.Info.details == "wilderness" then return "" else return ("<grey>"..exitStr) end else return "" end else return "" end end,
	phealth = function () return "<dim_grey>("..TReX.stats.health_color_percentage(math.floor(TReX.stats.h*100/TReX.stats.maxh))..""..tostring(math.floor(TReX.stats.h*100/TReX.stats.maxh)).."<dim_grey>)%" end,
	pmana = function () return "<dim_grey>("..TReX.stats.mana_color_percentage(math.floor(TReX.stats.m*100/TReX.stats.maxm))..""..tostring(math.floor(TReX.stats.m*100/TReX.stats.maxm)).."<dim_grey>)%" end,
	pwillpower = function () return "<dim_grey>("..TReX.stats.willpower_color_percentage(math.floor(TReX.stats.w*100/TReX.stats.maxw))..""..tostring(math.floor(TReX.stats.w*100/TReX.stats.maxw)).."<dim_grey>)%" end,
	pendurance = function () return "<dim_grey>("..TReX.stats.endurance_color_percentage(math.floor(TReX.stats.e*100/TReX.stats.maxe))..""..tostring(math.floor(TReX.stats.e*100/TReX.stats.maxe)).."<dim_grey>)%" end,
	eq = function () if t.bals.eq then return "e" else return "" end end,
	bal = function () if t.bals.bal then return "x" else return "" end end, 
	diffhealth = function () if TReX.stats.h ~= TReX.stats.oh then return "<green>("..tostring(TReX.stats.h - TReX.stats.oh).."h) "  else return "" end end,
	diffmana = function () if TReX.stats.m ~= TReX.stats.om then return "<green>("..tostring(TReX.stats.m - TReX.stats.om).."m) " else return "" end end,
	mono = function () if table.contains({TReX.serverside.itms.room}, "a monolith sigil") then return "<brown>-MONO- " else return "" end end,
	retardation = function () if t.affs.retardation then return " <red>(r) " else return "" end end,
	aeon = function () if t.affs.aeon then return " <red>(a)<grey>" else return "" end end,
	level = function () return "<grey>lvl <green>"..gmcp.Char.Status.level.." " end,
	lightwall = function () if table.contains({TReX.serverside.itms.room}, "a lightwall") then return "<white>{<red>[<white>LW<red>]<white>}" else return "" end end,
	heldbreath = function () if t.def.heldbreath then return "<sky_blue>[<white>B<sky_blue>]" else return "" end end,
	--ferocity = function () if tgz.snb.ferocity >= 1 then return "("..tgz.snb.ferocity..")" else return "" end end,	
	limbdisplay = function () return SLC_shortdisplay() end, 
	kai = function () if not TReX.s.class=="Monk" then return "" end if gmcp.Char.Vitals.charstats[3] then return "<sky_blue>("..tostring(tonumber(string.sub(gmcp.Char.Vitals.charstats[3],5,string.len(gmcp.Char.Vitals.charstats[3])- 1))).."%)" else return "" end end,
	--affs = function () return t.serverside.gmcp_aff_table else return "" end end,
	--uni = function () if uniroom() then return "<yellow>-UNI-" else return "" end end,
	--afflictions = function () return t.serverside.cmd_prompt end,

	
	
	
	prone = function () 
		if t.affs.prone then 
			--if TReX.serverside.getProneLength() > 0 then 
			--	return "<white> ( <red>PR <white>[<red>"..TReX.serverside.getProneLength().."<white>] ) <grey>" 
			--else 
				return "<white> ( <red>PR <white>) "  
			--end 
		else 
			return ""
		end
	end,


	defs = function () 
		local s = ""
		if table.contains({t.defs}, "cloak") then s = s.."c" end
		if table.contains({t.defs}, "kola") then s = s.."k" end
		if table.contains({t.defs}, "thirdeye") then s = s.."e" end
		if table.contains({t.defs}, "insomnia") then s = s .. "i" end
		if not (t.affs.deafness) then s = s.."d" end
		if not (t.affs.blindness) then s = s.."b" end
		return s
	end,

	paused = function ()  

		if not t.serverside["settings"].paused then 
			return "" 
		else 		
			return " <red>[<white>Paused<red>] " 
		end 

	end, --<red>(p)
	


	
}

TReX.stats.settings=function()

t.stats								= { -- so anything you change in this table , gets saved to home directory and is overrights this main table d on login, else it uses this table settings as defalut?? got it?

 	["p_health"] 				= {["name"] = "health %", ["enabled"] = false},
	["health_prompt"]	   		= {["name"] = "health #", ["enabled"] = false},
	["diff_health_prompt"]	   	= {["name"] = "health +-", ["enabled"] = false},
	["p_mana"]				   	= {["name"] = "mana %", ["enabled"] = false},
	["mana_prompt"] 		   	= {["name"] = "mana #", ["enabled"] = false},
	["diff_mana_prompt"]	   	= {["name"] = "mana +-", ["enabled"] = false},
	["p_willpower"] 		   	= {["name"] = "willpower %", ["enabled"] = false},
	["karma_prompt"]			= {["name"] = "karma %", ["enabled"] = false},
	["sunlight_prompt"] 		= {["name"] = "sunlight %", ["enabled"] = false},
	["willpower_prompt"] 	   	= {["name"] = "willpower #", ["enabled"] = false},
	["p_endurance"] 		   	= {["name"] = "endurance %", ["enabled"] = false},
	["endurance_prompt"]	   	= {["name"] = "endurance #", ["enabled"] = false},
	["time_stamp_prompt"]	   	= {["name"] = "timestamp", ["enabled"] = false},
	--["limb_display_prompt"]	   	= {["name"] = "slc", ["enabled"] = false},
	["battle_rage"]				= {["name"] = "battle rage", ["enabled"] = false},
	--["dragon_breath"]		   	= {["name"] = "dragon breath", ["enabled"] = false},
	["level_prompt"] 		   	= {["name"] = "dragon %", ["enabled"] = false},
	["prone_prompt"]		   	= {["name"] = "prone", ["enabled"] = false},
	["mono_prompt"]			   	= {["name"] = "monolith", ["enabled"] = false},
	--["denizen_health_prompt"]  	= {["name"] = "denizen health %", ["enabled"] = false},
	["held_breath"]  			= {["name"] = "held breath", ["enabled"] = false},
	["target_prompt"]  		   	= {["name"] = "target", ["enabled"] = false},
	["eq_bal_prompt"]			= {["name"] = "eq & bal", ["enabled"] = false},
	["defs_prompt"]				= {["name"] = "defences", ["enabled"] = false},
	["stacks"]					= {["name"] = "stacks", ["enabled"] = false},
	["afftracker"]				= {["name"] = "[ak] affs", ["enabled"] = false},
	
	--["room_exits"]				= {["name"] = "room exits", ["enabled"] = false},
	["light_wall"]				= {["name"] = "light wall", ["enabled"] = false},
	["kai"]						= {["name"] = "kai", ["enabled"] = false},

}  

end

TReX.stats.stat=function()

	if not t.class then
		TReX.class.reset()
	end

		
	t.affs["burn"] = t.affs["burn"] or 0
	t.affs["bleed"] = t.affs["bleed"] or 0

	TReX.stats.oh = TReX.stats.h or 5000
	TReX.stats.om = TReX.stats.m or 5000
	TReX.stats.ow = TReX.stats.w or 20000
	TReX.stats.oe = TReX.stats.e or 20000
	--TReX.stats.oxp = TReX.stats.xp or 0

	-- if t.affs.recklessness then
		-- TReX.stats.h = tonumber(gmcp.Char.Vitals.maxhp)*.33
		-- TReX.stats.m = tonumber(gmcp.Char.Vitals.maxmp)*.33
		-- TReX.stats.e = tonumber(gmcp.Char.Vitals.maxep)*.33
		-- TReX.stats.w = tonumber(gmcp.Char.Vitals.maxwp)*.33
	-- else
		 TReX.stats.h = tonumber(gmcp.Char.Vitals.hp)
		 TReX.stats.m = tonumber(gmcp.Char.Vitals.mp)
		 TReX.stats.e = tonumber(gmcp.Char.Vitals.ep)
		 TReX.stats.w = tonumber(gmcp.Char.Vitals.wp)	
	-- end

	TReX.stats.maxh = tonumber(gmcp.Char.Vitals.maxhp)
	TReX.stats.maxm = tonumber(gmcp.Char.Vitals.maxmp)
	TReX.stats.maxe = tonumber(gmcp.Char.Vitals.maxep)
	TReX.stats.maxw = tonumber(gmcp.Char.Vitals.maxwp)

	if t.affs["burn"] > 0 then
			--
	end
	
	if #t.serverside.gmcp_aff_table>=2 then
		if TReX.serverside.am_free() and TReX.serverside.am_functional() then
			if t.serverside["settings"].override then
				t.send("curing queue add stand", false)
			end
		end
	end
	
	if TReX.stats.h < TReX.stats.oh then
		if t.affs.blackout then
			--if t.bals.sip then
				t.send("sip health")
			--end
		end
		if TReX.serverside.am_free() and TReX.serverside.am_functional() then
			if t.serverside["settings"].override then
				t.send("curing queue add stand", false)
			end
		end
	end
	
	if TReX.stats.m ~= TReX.stats.om then
		--
	end
	
	if TReX.stats.w ~= TReX.stats.ow then
		--
	end
	
	if TReX.stats.e ~= TReX.stats.oe then
		--
	end

	if TReX.stats.h == 0 then
		
		expandAlias("mstop") 
		TReX.config.display("Dead?")
		
			if TReX.stats.oh > 0 then

				if TReX.s.class =="Apostate" then
					t.send("blackwind")
				else				
					if TReX.u.toBoolean(t.serverside["settings_default"].defences) then
						t.serverside["settings_default"].defences = "No"
						send("curing defences off")
					end
				end
				

				raiseEvent("TReX.stats.You Died")
			end

	else

		if TReX.stats.oh == 0 and TReX.stats.h > 0 then
			raiseEvent("TReX.stats.You Alive")
		end

	end
	
	--full sipper
	if TReX.stats.h > TReX.stats.maxh * .95 and TReX.stats.m > TReX.stats.maxm * .95 and t.serverside.fullsip then
		t.serverside.fullsip = false
		t.serverside["settings_default"].sip_health_at = t.serverside.temp_sip_health_full 
		t.serverside["settings_default"].sip_mana_at = t.serverside.temp_sip_mana_full
		t.send("curing siphealth " .. t.serverside["settings_default"].sip_health_at)
		t.send("curing sipmana " .. t.serverside["settings_default"].sip_mana_at)
	end
	
	--failsafe
	if not t.affs.bleed then 
		t.affs.bleed = 0
	end
	
	
	--HEALTH CHECK SWAP
	if t.affs.impaled then
		if not t.affs.stun and not t.affs.aeon and not t.affs.retardation then
			if t.class["blademaster"].enabled then	
				if TReX.stats.m < TReX.stats.maxh * .90 then
					if t.serverside.settings_default.sip ~= "Mana" then
						t.serverside["settings_default"].sip = tostring("Mana")
						t.send("curing priority mana", false)
					end		
				else
					if t.serverside.settings_default.sip ~= "Health" then
						t.serverside["settings_default"].sip = tostring("Health")
						t.send("curing priority health", false)
					end
				end
			else
			
					if t.class["twoh"].enabled then
						t.send("CURING HEALTHAFFSABOVE 100")
					end
		
				if t.serverside.settings_default.sip ~= "Health" then
					t.serverside["settings_default"].sip = tostring("Health")
					t.send("curing priority health", false)
				end			
			end
		end	
	end
	
	 if t.affs.blackout then
		 if t.serverside.settings_default.sip ~= "Health" then
			 t.serverside["settings_default"].sip = tostring("Health")
			 t.send("curing priority health", false)
		 end
	 end
		
		
		
end -- func


TReX.stats.mana_color_percentage=function(perc)  
	if perc < 1 then
		return "<brown>"
	elseif perc <= 25 then
		return "<red>"
	elseif perc <= 50 then
		return "<light_blue>"
	elseif perc <= 80 then
		return "<dodger_blue>"
	else
		return "<royal_blue>"
	end
end

TReX.stats.health_color_percentage=function(perc)  
	if perc < 1 then
		return "<brown>"
	elseif perc <= 25 then
		return "<red>"
	elseif perc <= 50 then
		return "<dark_orange>"
	elseif perc <= 80 then
		return "<yellow>"
	else
		return "<dark_green>"
	end
end

TReX.stats.willpower_color_percentage=function(perc)  
	if perc < 1 then
		return "<brown>"
	elseif perc <= 25 then
		return "<red>"
	elseif perc <= 50 then
		return "<VioletRed>"
	elseif perc <= 80 then
		return "<MediumPurple>"
	else
		return "<DarkViolet>"
	end
end

TReX.stats.endurance_color_percentage=function(perc)  
	if perc < 1 then
		return "<brown>"
	elseif perc <= 25 then
		return "<red>"
	elseif perc <= 50 then
		return "<LightGoldenrod>"
	elseif perc <= 80 then
		return "<goldenrod>"
	else
		return "<orange>"
	end
end



function TReX.stats.requestdelete()

 deleteLine()
 deletep = true
 deletelines = 2 

end


TReX.stats.custom_prompt=function()
	-- if deletep then return end -- if true then return

	-- prompt_sent=prompt_sent or {}
	-- if table.contains({prompt_sent}, "sent") or gmcp.Char.Name.name == "Nehmrah" then
		-- table.remove(prompt_sent, table.index_of(prompt_sent, "sent"))
	
			local prompt_string = ""
			if not (t.affs.blackout) then
				if t.serverside["settings"].Prompt then
					if t.stats["stacks"].enabled then 
						if TReX.stats.prompt_options.stacks() ~= "" then 
							moveCursorEnd("main")
							--if selectString(line, 1) ~= "" then prompt_string = "\n"..prompt_string end						
								prompt_string = prompt_string..TReX.stats.prompt_options.stacks() .. "\n" 		
						end
					end
					if t.serverside["settings"].timestamp and t.stats["time_stamp_prompt"].enabled then
						prompt_string = prompt_string..TReX.stats.prompt_options.timestamp() .. " |<white>" 
					end
					
					prompt_string = prompt_string..TReX.stats.prompt_options.paused() .. "<white>"
					prompt_string = prompt_string..TReX.stats.prompt_options.aeon() .. "<white>"
					prompt_string = prompt_string..TReX.stats.prompt_options.retardation() .. "<white>"
					prompt_string = prompt_string..TReX.stats.prompt_options.lightwall() .. "<white> "

			
					-- prompt_string = prompt_string..TReX.stats.prompt_options.health().. TReX.stats.prompt_options.phealth()..", "
					-- prompt_string = prompt_string..TReX.stats.prompt_options.mana() .. TReX.stats.prompt_options.pmana()..", "
					-- prompt_string = prompt_string..TReX.stats.prompt_options.willpower() .. ", "
					-- prompt_string = prompt_string..TReX.stats.prompt_options.endurance() .. " "
					
					if t.stats["health_prompt"].enabled then
						if t.stats["p_health"].enabled then 
							prompt_string = prompt_string..TReX.stats.prompt_options.health()..""..TReX.stats.prompt_options.phealth()..",<white> "
						else
							prompt_string = prompt_string..TReX.stats.prompt_options.health()..",".."<white> " 
						end
					else
						if t.stats["p_health"].enabled then 
							prompt_string = prompt_string..TReX.stats.prompt_options.phealth()..",<white> "
						end
					end
					
					if t.stats["mana_prompt"].enabled then
						if t.stats["p_mana"].enabled then 
							prompt_string = prompt_string..TReX.stats.prompt_options.mana()..""..TReX.stats.prompt_options.pmana()..",<white> "
						else
							prompt_string = prompt_string..TReX.stats.prompt_options.mana()..",".."<white> " 
						end
					else
						if t.stats["p_mana"].enabled then 
							prompt_string = prompt_string..TReX.stats.prompt_options.pmana()..",<white> "
						end
					end
					
					if t.stats["kai"].enabled  then prompt_string = prompt_string..TReX.stats.prompt_options.kai()..",<white>" else end

					if t.stats["willpower_prompt"].enabled  then
						if t.stats["p_willpower"].enabled then 
							prompt_string = prompt_string..TReX.stats.prompt_options.willpower()..""..TReX.stats.prompt_options.pwillpower()..",<white> "
						else
							prompt_string = prompt_string..TReX.stats.prompt_options.willpower()..",".."<white> " 
						end
					else
						if t.stats["p_willpower"].enabled then 
							prompt_string = prompt_string..TReX.stats.prompt_options.pwillpower()..",<white> "
						end
					end

					
					if t.stats["endurance_prompt"].enabled then
						if t.stats["p_endurance"].enabled then 
							prompt_string = prompt_string..TReX.stats.prompt_options.endurance()..""..TReX.stats.prompt_options.pendurance()..",<white> "
						else
							prompt_string = prompt_string..TReX.stats.prompt_options.endurance()..",".."<white> "
						end
					else
						if t.stats["p_endurance"].enabled then 
							prompt_string = prompt_string..TReX.stats.prompt_options.pendurance()..",<white> "
						end
					end
					
					if t.stats["battle_rage"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.rage() .. " <white>" else end
					if t.stats["level_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.level() .. "<white>" else end
					if t.stats["eq_bal_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.eq() .. TReX.stats.prompt_options.bal() .. "<dim_grey>|<white>" --[[else prompt_string = prompt_string.."<dark_green>|"]] end
					if t.stats["defs_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.defs() .. " <white>" else end
					if t.stats["prone_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.prone() .. " <white>" else end
					if t.stats["held_breath"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.heldbreath() .. " <white>" else end
					if t.stats["karma_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.karma() .. " <white>" else end
					if t.stats["sunlight_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.sunlight() .. " <white>" else end
					if t.stats["target_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.target() .. " <white>" else end
					--if t.stats["denizen_health_prompt"].enabled  then prompt_string = prompt_string..TReX.stats.prompt_options.denizenhealth() .. " <white>" else end
					--prompt_string = prompt_string..prompt_options.trance()
					--prompt_string = prompt_string..prompt_options.vital()
					--prompt_string = prompt_string..prompt_options.stance()
					--prompt_string = prompt_string..prompt_options.shin()
					--prompt_string = prompt_string..prompt_options.shintrance()
					--prompt_string = prompt_string..prompt_options.bmstance()
					--prompt_string = prompt_string..prompt_options.sulphur()
					--prompt_string = prompt_string..prompt_options.ent_bal()
					--prompt_string = prompt_string..prompt_options.dmark()
					--prompt_string = prompt_string..prompt_options.uni() .. " "
					--if t.stats["limb_display_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.limbdisplay() .. " " else end
					if t.stats["mono_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.mono() .. "<white>" else end
					if t.stats["diff_health_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.diffhealth() .. "<white>" else end
					if t.stats["diff_mana_prompt"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.diffmana() .. "<white>" else end
					--if t.stats["room_exits"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.roomexits() .. " <white>" else end
					--prompt_string = prompt_string.. TReX.stats.prompt_options.ferocity() .. " "
				
								
					if t.stats["afftracker"].enabled then prompt_string = prompt_string..TReX.stats.prompt_options.afftracker() .. ""  else end


					--selectString(line, 1)
					moveCursorEnd("main")
					if getCurrentLine() ~= "" then prompt_string = "\n"..prompt_string end
						--if isPrompt() then cecho(prompt_string) end
						cecho(prompt_string)
					if gmcp.Char.Name.name ~= "Nehmrah" then
						if table.is_empty(t.serverside.gmcp_aff_table) then 
							if not table.contains({t.serverside.prompt}, "empty") then
								table.insert(t.serverside.prompt, "empty")
								t.serverside.gmcpAffShow()
							end
					    else
							if table.contains({t.serverside.prompt}, "empty") then
								table.remove(t.serverside.prompt,table.index_of(t.serverside.prompt,"empty"))
							end
								t.serverside.gmcpAffShow()
						end
					elseif gmcp.Char.Name.name == "Nehmrah" then
						t.serverside.gmcpAffShow()
					end
					

					-- if t.serverside["settings"].Prompt then
						-- if t.serverside["settings"].timestamp and not t.stats["time_stamp_prompt"].enabled then
							-- timestamp = tostring(getTime(true,"hh:mm:ss:zzz"))
							-- cecho("<dim_grey>| "..timestamp)
						-- end
					-- end
				
				end
			end
		--end -- if installed
	--end
		

	--end 

		--deletep = true
		
end -- func


	--if t.stats["dragon_breath"].enabled and TReX.s.dragon_color ~= "" then
	--	if TReX.s.dragon_color == "Black" then
		--	cecho("<ivory>[Black DB<ivory>] <white>", false)
		---elseif TReX.s.dragon_color == "Silver" then
		--	cecho("<ivory>[Silver DB<ivory>] <white>", false)
		-- else
		--	cecho("<ivory>[<"..TReX.s.dragon_color:lower()..">DB<ivory>] <white>", false)
		--end
	--end
	

TReX.stats.health_on_prompt=function()

	if t.stats["health_prompt"].enabled then
	 t.stats["health_prompt"].enabled = false
	 cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Health # OFF Prompt.")
	 --t.serverside.red_echo("Health OFF Prompt.") -- red echo
	else
	 t.stats["health_prompt"].enabled = true
	 cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Health # ON Prompt.")
	-- t.serverside.green_echo("Health ON Prompt.") -- green echo
	end
	
end

 -- make a new alias and call this func
TReX.stats.p_health_on_prompt=function()

	if t.stats["p_health"].enabled then
	  t.stats["p_health"].enabled = false
	 cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Health % OFF Prompt.")
	 --t.serverside.red_echo("Health OFF Prompt.") -- red echo
	else
	  t.stats["p_health"].enabled = true
	 cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Health % ON Prompt.")
	-- t.serverside.green_echo("Health ON Prompt.") -- green echo
	end
	
end

TReX.stats.p_n_health_on_prompt=function()
	if t.stats["prompt"].enabled == "both" then
	  t.stats["health_prompt"].enabled = true
	  t.stats["p_health"].enabled = true
	  cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Health num & % ON Prompt.")
	else
	  t.stats["health_prompt"].enabled = false
	  t.stats["p_health"].enabled = false
	  cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Health num & % OFF Prompt.")
	end
end

TReX.stats.mana_on_prompt=function()
	if t.stats["mana_prompt"].enabled then
		t.stats["mana_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Mana # OFF Prompt.")
	else
		t.stats["mana_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Mana # ON Prompt.")
	end
end

 -- make a new alias and call this func
TReX.stats.p_mana_on_prompt=function()
	if t.stats["p_mana"].enabled then
		t.stats["p_mana"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Mana % OFF Prompt.")
	else
		t.stats["p_mana"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Mana % ON Prompt.")
	end
end

TReX.stats.p_n_mana_on_prompt=function()
	if t.stats.prompt == "both" then
		t.stats["mana_prompt"].enabled = true
		t.stats["p_mana"].enabled = true
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Mana num & % ON Prompt.")
	else
		t.stats["mana_prompt"].enabled = false
		t.stats["p_mana"].enabled = false
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Mana num & % OFF Prompt.")
	end
end

TReX.stats.endurance_on_prompt=function()
	if t.stats["endurance_prompt"].enabled then
		t.stats["endurance_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Endurance # OFF Prompt.")
	else
		t.stats["endurance_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Endurance # ON Prompt.")
	end
end

 -- make a new alias and call this func
TReX.stats.p_endurance_on_prompt=function()
	if t.stats["p_endurance"].enabled then
		t.stats["p_endurance"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Endurance % OFF Prompt.")
	else
		t.stats["p_endurance"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Endurance % ON Prompt.")
	end
end

TReX.stats.p_n_endurance_on_prompt=function()
	if t.stats.prompt == "both" then
	  t.stats["endurance_prompt"].enabled = true
	  t.stats["p_endurance"].enabled = true
	  cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Endurance num & % ON Prompt.")
	else
	  t.stats["endurance_prompt"].enabled = false
	  t.stats["p_endurance"].enabled = false
	  cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Endurance num & % OFF Prompt.")
	end
end
-----------------------------------------------------------
TReX.stats.willpower_on_prompt=function()
	if t.stats["willpower_prompt"].enabled then
		t.stats["willpower_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> willpower # OFF Prompt.")
	else
		t.stats["willpower_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> willpower # ON Prompt.")
	end
end

 -- make a new alias and call this func
TReX.stats.p_willpower_on_prompt=function()
	if t.stats["p_willpower"].enabled then
		t.stats["p_willpower"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> willpower % OFF Prompt.")
	else
		t.stats["p_willpower"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> willpower % ON Prompt.")
	end
end

TReX.stats.p_n_willpower_on_prompt=function()
	if t.stats.prompt == "both" then
		t.stats["willpower_prompt"].enabled = true
		t.stats["p_willpower"].enabled = true
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> willpower num & % ON Prompt.")
	else
		t.stats["willpower_prompt"].enabled = false
		t.stats["p_willpower"].enabled = false
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> willpower num & % OFF Prompt.")
	end
end
-----------------------------------------------------------
TReX.stats.eq_bal_on_prompt=function()
	if t.stats["eq_bal_prompt"].enabled then
		t.stats["eq_bal_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Eq/Bal OFF Prompt.")
	else
		t.stats["eq_bal_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Eq/Bal ON Prompt.")
	end
end

TReX.stats.level_on_prompt=function()
	if t.stats["level_prompt"].enabled then
		t.stats["level_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Level OFF Prompt.")
	else
		t.stats["level_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Level ON Prompt.")
	end
end

TReX.stats.defs_on_prompt=function()
	if t.stats["defs_prompt"].enabled then
		t.stats["defs_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Defs OFF Prompt.")
	else
		t.stats["defs_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Defs ON Prompt.")
	end
end

TReX.stats.time_stamp_on_prompt=function()
	if t.stats["time_stamp_prompt"].enabled then
		t.stats["time_stamp_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Timestamp After Prompt.")
	elseif not t.stats["time_stamp_prompt"].enabled then
		t.stats["time_stamp_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Timestamp Before Prompt.")
	end
end

TReX.stats.mono_on_prompt=function()
	if t.stats["mono_prompt"].enabled then
		t.stats["mono_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Mono OFF Prompt.")
	else
		t.stats["mono_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Mono ON Prompt.")
	end
end

TReX.stats.target_on_prompt=function()
	if t.stats["target_prompt"].enabled then
		t.stats["target_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Target OFF Prompt.")
	else
		t.stats["target_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Target ON Prompt.")
	end
end

TReX.stats.karma_on_prompt=function()
	if t.stats["karma_prompt"].enabled then
		t.stats["karma_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Karma OFF Prompt.")
	else
		t.stats["karma_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Karma ON Prompt.")
	end
end

TReX.stats.sunlight_on_prompt=function()
	if t.stats["sunlight_prompt"].enabled then
		t.stats["sunlight_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Sunlight OFF Prompt.")
	else
		t.stats["sunlight_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Sunlight ON Prompt.")
	end
end

-- TReX.stats.denizen_health_on_prompt=function()
	-- if t.stats["denizen_health_prompt"].enabled then
		-- t.stats["denizen_health_prompt"].enabled = false
		-- cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Denizen health OFF Prompt.")
	-- else
		-- t.stats["denizen_health_prompt"].enabled = true
		-- cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Denizen health ON Prompt.")
	-- end
-- end

TReX.stats.prone_on_prompt=function()
	if t.stats["prone_prompt"].enabled then
		t.stats["prone_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Prone OFF Prompt.")
	else
		t.stats["prone_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Prone ON Prompt.")
	end
end

TReX.stats.room_exits=function()
	if t.stats["room_exits"].enabled then
		t.stats["room_exits"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Room Exits OFF Prompt.")
	else
		t.stats["room_exits"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Room Exits ON Prompt.")
	end
end

TReX.stats.diff_health_on_prompt=function()
	if t.stats["diff_health_prompt"].enabled then -- thats just calling the enabled and testing if its true or false.
		t.stats["diff_health_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Diffhealth OFF Prompt.")
	else
		t.stats["diff_health_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Diffhealth ON Prompt.")
	end
end

TReX.stats.diff_mana_on_prompt=function()
	if t.stats["diff_mana_prompt"].enabled then
		t.stats["diff_mana_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Diffmana OFF Prompt.")
	else
		t.stats["diff_mana_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Diffmana ON Prompt.")
	end
end

TReX.stats.limb_display_on_prompt=function()
	if t.stats["limb_display_prompt"].enabled then
		t.stats["limb_display_prompt"].enabled = false
		cecho("\n<red>[<DarkSlateGrey>†<red>]<DarkSlateGrey> Limbdisplay OFF Prompt.")
	else
		t.stats["limb_display_prompt"].enabled = true
		cecho("\n<green>[<DarkSlateGrey>†<green>]<DarkSlateGrey> Limbdisplay ON Prompt.")
	end
end
----------------------------------------------------------------------
TReX.stats.you_died=function()
-- new update
if t.serverside["settings"].installed then
	
	TReX.defs.reset()
	TReX.prios.reset()
	
	if not t.serverside["settings"].paused then
		TReX.config.pause()
	end
	
end -- if installed
end -- func you_died

TReX.stats.you_alive=function()
-- new update
if t.serverside["settings"].installed then
	
		t.def={}
		t.defs={}

	if t.serverside["settings_default"].defences == "No" then
		TReX.defs.defence()
	end	
	
	if t.serverside["settings"].paused then
		TReX.config.pause()
	end
end -- if installed
end
------------------------------------------------------------------------------------------

TReX.stats.showSettings=function()

echo("\n") 
cecho("\n\t<white>Prompt Settings") 
echo("\n")

local sortPrompt = {}

  for k,v in pairs(t.stats) do
	sortPrompt[#sortPrompt+1] = k
	table.sort(sortPrompt)
  end

  	local x = 0
 			 
	for i, n in ipairs(sortPrompt) do
		x = x + 1

     	local d = "<dim_grey>[<white>"


	 		if t.stats[n].enabled then
	 			d = d .. " <light_blue>+ "
	 		else
	 			d = d .. " <red>- "
	 		end


     		d = d .. "<dim_grey>]<white> " 

			if (x-1)%3 == 0 then
				echo("\n")
			end  
		

	   	local nWithSpace = t.stats[n].name

			if nWithSpace:len() < 25 and (x-1) %3~=2 then
				local pad = 25 - nWithSpace:len()
				nWithSpace = nWithSpace .. string.rep(" ", pad)
			elseif nWithSpace:len() > 25 then
				nWithSpace = nWithSpace:cut(25)
	     	end
 
		local command
			fg("white")
			cecho(d)

		local command = [[TReX.stats.on_click("]]..n..[[")]]
		echoLink(nWithSpace, command, "Toggle " .. n, true)
		
	end
		echo"\n\n"
		deletep = false
		showprompt()
end

TReX.stats.on_click=function(variable, toggle, toggle2)

	if type(t.stats[variable].enabled) == "boolean" then
		if toggle ~= nil then
			t.stats[variable].enabled = verify(toggle)
		else
			t.stats[variable].enabled = not t.stats[variable].enabled
		end

		if t.stats[variable].enabled then
			t.stats[variable].enabled = true
		else 
			t.stats[variable].enabled = false
		end

		

	end

	TReX.stats.showSettings()

		deletep=false
			--if not table.contains({prompt_sent}, "sent") then
			--	table.insert(prompt_sent, "sent")
			--end
		TReX.stats.custom_prompt()
	
end		

--save stats file
TReX.stats.save=function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_stats.lua"
   table.save(savePath, TReX.stats)
end -- func

--load stats file
TReX.stats.load=function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_stats.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.stats)
	end -- if
end -- func

if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.stats loaded successfully) ") end

TReX.stats.save()

for _, file in ipairs(TReX.stats) do
	dofile(file)
end -- for

