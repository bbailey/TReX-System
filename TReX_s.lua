-- TReX.s
-- Status tracking

local send							= send
local cc							= TReX.config.cc or "##"

registerAnonymousEventHandler("TReX.s.class_change_event", "TReX.s.classChanged")
registerAnonymousEventHandler("gmcp.Char.Status", "TReX.s.newtargethandler")
registerAnonymousEventHandler("gmcp.Char.Status", "TReX.s.class_check")
registerAnonymousEventHandler("race update", "TReX.s.race_update") 	

--save s file
TReX.s.save=function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_s.lua"
   table.save(savePath, TReX.s)
end -- func

--load s file
TReX.s.load=function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_s.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.s)
	end -- if
end -- func

TReX.s.newtargethandler=function()
	local newtarget = gmcp.Char.Status.target
	if TReX.s.gametarget ~= newtarget then -- target changed
		--raiseEvent("TReX gametarget changed", TReX.s.gametarget, gmcp.Char.Status.target)
		TReX.s.gametarget = tonumber(gmcp.Char.Status.target)
	end
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.s.newtargethandler )") end
end

TReX.s.class_switch=function(class)
	if hl.raid then
		hl.raid = false
		--TReX.defs.defs2relax()
		t.serverside.red_echo("Disabled raid mode.")
	end
		t.send("class switch "..class)
end

TReX.s.class_check=function() -- this is called on gmcp after the switch

	local old_class = TReX.s.class or ""
		--if gmcp.Char.Status.race:find("Dragon") then
		if string.find(gmcp.Char.Status.class, "Dragon") then
			TReX.s.class = "Dragon"
			TReX.s.dragon_color = ""
				if old_class ~= TReX.s.class then
					raiseEvent("TReX.s.class_change_event", TReX.s.class, TReX.s.dragon_color)
				end
			TReX.s.dragon_color = string.split(gmcp.Char.Status.class, " ")[1] or ""
				if TReX.s.dragon_color == "Golden" then
					TReX.s.dragon_color = "Gold"
				end
		else
			TReX.s.class = gmcp.Char.Status.class:title() or ""
			TReX.s.dragon_color = ""
				if old_class ~= TReX.s.class then
					raiseEvent("TReX.s.class_change_event", TReX.s.class, TReX.s.dragon_color)
				end
				
		end

		
		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.s.class_check )") end
end -- func

TReX.s.classChanged=function(event, class, color)

if t.serverside.settings.paused then
	TReX.config.pause()
end

	t.serverside.green_echo("Class Change Detected : <green>[ <white>"..class.." <green>]", false)
		
		t.def  = {}
		t.defs = {}
		
		TReX.defs.reset()
		TReX.defs.login()  
		TReX.class.reset()   
		TReX.class.skill_check()
			
	if TReX.s.class == "Alchemist" then
		t.bals["salt"] = true
		t.serverside["settings"].salt = t.serverside["settings"].salt or false 
	else
		t.bals["salt"] = nil
		t.serverside["settings"].salt = nil
	end	
	
	if TReX.s.class == "Blademaster" then
		t.bals["alleviate"] = true
		t.serverside["settings"].alleviate = t.serverside["settings"].alleviate or false 
	else
		t.bals["alleviate"] = nil
		t.serverside["settings"].alleviate = nil
	end	
	
	if TReX.s.class == "Shaman" then
		t.bals["daina"] = true
		t.serverside["settings"].daina = t.serverside["settings"].daina or false 
	else
		t.bals["daina"] = nil
		t.serverside["settings"].daina = nil
	end		
	
	if TReX.s.class == "Monk" then
		t.bals["transmute"] = true 
		t.serverside["settings"].transmute = t.serverside["settings"].transmute or false  
	else 
		t.bals["transmute"] = nil
		t.serverside["settings"].transmute = nil 
	end

	if TReX.s.class == "Depthswalker" then
		t.bals["accelerate"] = true
		t.serverside["settings"].accelerate = t.serverside["settings"].accelerate or false 
	else
		t.bals["accelerate"] = nil 
		t.serverside["settings"].accelerate = nil 
	end	

	if TReX.s.class == "Dragon" then 
		t.bals["dragonheal"] = true
		t.serverside["settings"].dragonheal = t.serverside["settings"].dragonheal or false 
	else
		t.bals["dragonheal"] = nil 
		t.serverside["settings"].dragonheal = nil 
	end
	
	if TReX.s.class == "Occultist" then
		TReX.serverside.karma_check()
	end

	if TReX.s.class == "water Elemental Lord" then
		t.bals["purify"] = true
	else
		t.bals["purify"] = nil
	end
	
	if TReX.s.class == "earth Elemental Lord" then
		t.bals["extrusion"] = true
	else
		t.bals["extrusion"] = nil
	end
	
	for _,v in pairs({"Occultist","Jester"}) do
		if TReX.s.class == v then
			t.bals["fool"] = true
			t.serverside["settings"].fool = t.serverside["settings"].fool or false
		else
			t.bals["fool"] = nil 
			t.serverside["settings"].fool = nil
		end
	end

	for _,v in pairs({"Druid","Sentinel"}) do 
		if TReX.s.class == v then
			t.bals["might"] = true
			t.serverside["settings"].might = t.serverside["settings"].might or false 
		else 
			t.bals["might"] = nil 
			t.serverside["settings"].might = nil 
		end
	end


	if TReX.s.class == "Serpent" then
		t.bals["shrugging"] = true
		t.serverside["settings"].shrugging = t.serverside["settings"].shrugging or false 
	else
		t.bals["shrugging"] = nil
		t.serverside["settings"].shrugging = nil
	end


	if TReX.s.class == "Magi" then
		t.bals["bloodboil"] = true
		t.serverside["settings"].bloodboil = t.serverside["settings"].bloodboil or false
	else
		t.bals["bloodboil"] = nil
		t.serverside["settings"].bloodboil = nil
	end

	for _,v in pairs({"Runewarden","Infernal","Paladin"}) do
		if TReX.s.class == v then
			t.bals["rage"] = true
			t.serverside["settings"].rage = t.serverside["settings"].rage or false  
				if TReX.s.class_spec() == "Two Handed" then
					t.serverside["settings"].recovery = false
				end
		else 
			t.bals["rage"] = nil
			t.serverside["settings"].rage = nil 
		end
	end

	for _,v in pairs({"Runewarden","Infernal","Paladin","Blademaster","Monk","Sylvan","Druid"}) do
		if TReX.s.class == v then
			t.bals["fitness"] = true
			t.serverside["settings"].fitness = t.serverside["settings"].fitness or false
		else 
			t.bals["fitness"] = nil
			t.serverside["settings"].fitness = nil
			t.serverside["settings"].recovery = nil
		end
	end

 	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.s.classChanged )") end

end -- func


TReX.s.class_spec=function()
-- new update
--if t.serverside["settings"].installed then
if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.s.class_spec )") end

    if table.contains({"Runewarden","Infernal", "Paladin"}, TReX.s.class) then -- only run if your a knight class
     if gmcp.Char.Vitals then
        for k, v in pairs(gmcp.Char.Vitals.charstats) do
            if string.starts(v, "Spec") then
                return string.match(v,"Spec: (.*)")
            end
        end
     end
    else
        --TReX.config.display("You are not a Knight Class", false)
        return ""
    end
    
--end -- if installed
end--func    

TReX.s.race_update=function() -- people say to make the name the same, but if you make it right i dont hink ther eis an issue

if gmcp.Char.Status.name == "Lucianus" then
	if gmcp.Char.Status.race == "Xoran" then
	send("set voice fiery, sonorous")
	elseif gmcp.Char.Status.race == "Human" then
	send("set voice strong, bright")
	elseif gmcp.Char.Status.race == "Tsol'aa" then
	send("set voice richly-soft, silvery")
	elseif gmcp.Char.Status.race == "Satyr" then
	send("set voice husky, full-toned")
	elseif gmcp.Char.Status.race == "Troll" then
	send("set voice harsh, powerful baritone")
	elseif gmcp.Char.Status.race == "Dwarf" then
	send("set voice heavy, deep-toned")
	elseif gmcp.Char.Status.race == "Atavian" then
	send("set voice warm, euphonious")
	elseif gmcp.Char.Status.race == "Rajamala" then
	send("set voice wildly fierce, growling")
	end
end
			--TReX.defs.list()
			--TReX.defs.keepup()

end

TReX.s.class_eventhandler=function()
-- might not be needed, depending on how skill grabber works. Not linking for now
-- Klen I made some small updates to this to make sure it was reading, cause it wasnt. - Nehm
-- It is now. But I am disabling it until you get to it. Had to tweak it a bit. - Nehm
if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.s.class_eventhandler )") end

	for _, skl in ipairs(gmcp.Char.Skills.Groups) do
		sendGMCP(string.format([[Char.Skills.Get {"group":"%s"}]], skl.name))
		TReX.config.echo(skl.name) -- added this in to amke sure it was successful - Nehm
		send("\n",false)
	end

end-- func

if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.s loaded successfully) ") end

TReX.s.save()

for _, file in ipairs(TReX.s) do
	dofile(file)
end -- for