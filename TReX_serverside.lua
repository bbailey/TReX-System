--[[ MotherShip ]]

local send                          = send
local cc                            = TReX.config.cc or "##"
local humourafftable={
  "nausea", "sensitivity", "slickness", 
  "stupidity", "anorexia", "impatience",
  "clumsiness", "weariness", "asthma",
  "haemophilia", "recklessness", "paralysis",
  } 

TReX.serverside.items					= TReX.serverside.items or {}
TReX.serverside.items.room			    = TReX.serverside.items.room or {}
TReX.serverside.gingerlevel = 1

registerAnonymousEventHandler("gmcp.Char.Afflictions.Add", "t.serverside.gmcpAffAdded") -- [[internal events]]
registerAnonymousEventHandler("gmcp.Char.Afflictions.List","t.serverside.gmcpAffParse") -- [[internal events]]
registerAnonymousEventHandler("gmcp.Char.Afflictions.Remove", "t.serverside.gmcpAffRemoved") -- [[internal events]]
registerAnonymousEventHandler("gmcp.Char.Vitals", "TReX.lust.reject")
registerAnonymousEventHandler("TReX got humor", "TReX.serverside.humourGainedHandling")
registerAnonymousEventHandler("TReX lost humor", "TReX.serverside.humourcured")
registerAnonymousEventHandler("TReX got corruption", "TReX.serverside.corruptionhandling")
registerAnonymousEventHandler("TReX lost corruption", "TReX.serverside.corruptionhandling")
registerAnonymousEventHandler("got fracture", "TReX.serverside.fracturetree")
registerAnonymousEventHandler("lost fracture", "TReX.serverside.fracturetree")
registerAnonymousEventHandler("gmcp.Char.Items.List", "TReX.serverside.eh_items")
registerAnonymousEventHandler("gmcp.Char.Items.Add", "TReX.serverside.eh_items")
registerAnonymousEventHandler("gmcp.Char.Items.Remove", "TReX.serverside.eh_items")
registerAnonymousEventHandler("gmcp.Char.Vitals", "TReX.serverside.clot_my_bleeding")
registerAnonymousEventHandler("gmcp.Char.Vitals", "TReX.serverside.karma_check")
registerAnonymousEventHandler("gmcp.Char.Vitals", "TReX.serverside.sunlight_check")
registerAnonymousEventHandler("gmcp.Char.Vitals", "TReX.serverside.lock_check")
registerAnonymousEventHandler("trackable_event got", "TReX.serverside.treeAffGained")
registerAnonymousEventHandler("tree_event lost", "TReX.serverside.treeAffLost")

--save serverside file
TReX.serverside.save=function()
    if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
    end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_serverside.lua"
   table.save(savePath, TReX.serverside)
end -- func

--load serverside file
TReX.serverside.load=function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_serverside.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.serverside)
	end -- if
end -- func

t.serverside.gmcp_level_capture=function()
	for _, level in pairs(gmcp.Char.Status.level) do
		if level:starts("(\d+)") then
			return tostring(level:match("^(\d+)"))
		end
	end
end

TReX.serverside.retard_mode=function(mode)
	if mode then
		t.affs.retardation = true
		t.serverside.retard_check_count = 0
		TReX.serverside.affadd("retardation")
		t.serverside.green_echo("Retardation Combat Enabled")		
	else
		t.affs.retardation = false
		t.serverside.retard_check_count = 0	
		TReX.serverside.affremove("retardation")
		t.serverside.red_echo("Retardation Combat Disabled")
	end
end

t.sendAll=function(line)
	sendAll(line, true)
end

t.expandAlias=function(line)
	expandAlias(line)
end


TReX.serverside.transmutation_toggle=function()
if t.serverside["settings_default"].transmutation == "Yes" then
	t.send("curing transmutation off", false)
	t.serverside["settings_default"].transmutation = "No"
	TReX.pipes.epipes()
	if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>[<DarkSlateGrey>Using Concoctions<green>]", false) end
else
	t.send("curing transmutation on", false)
	t.serverside["settings_default"].transmutation = "Yes"
	TReX.pipes.epipes()
	if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<red>+<DarkSlateGrey>) <red>[<DarkSlateGrey>Using Transmutations<red>]", false) end
end
end

TReX.serverside.moss_toggle=function()
if t.serverside["settings"].moss then
	if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<red>+<DarkSlateGrey>) <red>Moss ") end
	t.send("curing mosshealth 35", false)
	t.send("curing mossmana 35", false)
	t.serverside["settings"].moss = false
else
	if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>Moss") end
	t.send("curing mosshealth 90", false)
	t.send("curing mossmana 90", false)
	t.serverside["settings"].moss = true
end
end

TReX.serverside.manathreshold=function()
  return math.ceil(TReX.stats.maxm * t.serverside["settings_default"].mana_threshold)/100
end

TReX.serverside.changemanathreshold=function(n)
    t.serverside["settings_default"].mana_threshold = tonumber(n)
	 t.serverside.green_echo("Minimum mana threshold changed to " .. t.serverside["settings_default"].mana_threshold .. "%")
end

TReX.serverside.prone_check=function()

if t.affs.prone and t.bals.bal and not t.affs.stun 
	and not t.affs.damagedleftleg and not t.affs.damagedrightleg 
	and not t.affs.brokenleftleg and not t.affs.brokenrightleg 
then
	if t.serverside["settings"].recovery then
		if TReX.s.class_spec() == "Two Handed" then 
			if not t.affs.stun then
				t.send("recover footing", false)
			end				
		end
	else
		if t.affs.prone and not t.affs.stun and t.bals.bal then
			--t.send("stand", false)
		end
	end
end
	
--writhe check
if TReX.serverside.am_bound() then
	TReX.serverside.writhe()
end
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( t.serverside.prone_check ) ") end	
end

TReX.serverside.writhe=function()

if TReX.serverside.am_bound() then
	if not (t.serverside.writhing) then
		if t.bals.bal and t.bals.eq then
			if TReX.s.class == "Dragon" then
				if TReX.serverside.am_functional() then
					t.send("queue prepend eqbal dragonflex", false)
				end
			else
				if TReX.serverside.am_functional() then
					t.send("queue prepend eqbal writhe", false)
				end
			end
				t.serverside.writhing = true
				tempTimer(.5, [[t.serverside.writhing = false]])
				if t.serverside["settings"].echos then t.serverside.myecho("You are writhing!") end
		end
	end
end

    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( t.serverside.writhe ) ") end


end

TReX.serverside.full_balance=function()
	if t.bals.bal and t.bals.eq and not t.affs.stun then
		return true
	else
		return false
	end
end

TReX.serverside.balance=function()
	if t.bals.bal then
		return true
	else
		return false
	end
end

TReX.serverside.equilibrium=function()
	if t.bals.eq then
		return true
	else
		return false
	end
end

TReX.serverside.voice=function()
	if t.bals.voice and not t.affs.stun then
		return true
	else
		return false
	end
end

TReX.serverside.amProneAndConcussion=function()
	for _,v in pairs({"damagedhead","mangledhead","concussion"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) and t.affs.prone then
			return true
		else
			return false
		end

        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.amProneAndConcussion ) ") end
	end
end

TReX.serverside.amProneAndtorsoBroke=function()
    for _,v in pairs({"mildtrauma","serioustrauma"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) and t.affs.prone then 
			return true
		else
			return false
		end
	end

        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.amProneAndTorsoBroke ) ") end

end

TReX.serverside.amProneAndBroke=function()
    for _,v in pairs({"damagedrightleg","damagedleftleg","mangledrightleg","mangledleftleg"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) and t.affs.prone then
			return true
		else
			return false
		end

	end
	
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.amProneAndBroke ) ") end
	
end

TReX.serverside.amProneAndMending=function()
	for _,v in pairs({"brokenleftleg","brokenrightleg"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) and t.affs.prone and not TReX.serverside.amProneAndBroke() then
			return true
		else
			return false
		end
	end
	
	 if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.amProneAndMending ) ") end
	
end

TReX.serverside.enemy_check=function()
	for k,v in pairs({"paralysis","stun","sleeping","prone"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) then
			return false
		else
			return true
		end
	end

 if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.am_functional ) ") end


end

TReX.serverside.am_functional=function()
	for k,v in pairs({"paralysis","stun","sleeping","prone"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) then
			return false
		else
			return true
		end
	end

 if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.am_functional ) ") end


end

TReX.serverside.am_capable=function()
	for _,v in pairs({"brokenleftleg","brokenrightleg","damagedleftleg","damagedrightleg","mangledleftleg","mangledrightleg"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) then	
			return false
		else
			return true
		end
	end

 if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.am_capable ) ") end

end

TReX.serverside.attack_check=function()
	if TReX.serverside.am_capable() and TReX.serverside.am_functional() then
		return true
	else
		return false
	end
end

TReX.serverside.am_free=function()
	for _,v in pairs({"impaled","webbed","transfixed","daeggerimpale","bound","roped"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) or TReX.serverside.amProneAndBroke() then	
			return false
		else
			return true
		end
	end
 

 if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.am_free ) ") end

end

TReX.serverside.am_hindered=function()
	for _,v in pairs({"stupidity","frozen","shivering","lethargy"}, t.affs) do
		if t.affs[v] then
			return true
		else
			return false
		end
	end

		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.am_hindered ) ") end

end

TReX.serverside.am_bound=function()
 if t.affs.impaled or t.affs.webbed or t.affs.transfixed or t.affs.daegger_impaled or t.affs.bound then
  return true
 else
  return false
 end

 if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.am_bound ) ") end

end

TReX.lust.lost=function (who)

TReX.lust.rejectlist = TReX.lust.rejectlist or {}

    if table.contains(TReX.lust.rejectlist, who) then
        table.remove(TReX.lust.rejectlist, table.index_of(TReX.lust.rejectlist, who))
    end

     if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.lust.lost ) ") end


end

TReX.lust.got=function (who)

TReX.lust.rejectlist = TReX.lust.rejectlist or {}

    --if not on whitelist and not already on reject list, add
    if not (table.contains(t.lust.whitelist, who)) then
        if not (table.contains(TReX.lust.rejectlist, who)) then
            TReX.lust.rejectlist[#TReX.lust.rejectlist+1] = who
        end
    end

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.lust.got ) ") end

end

TReX.lust.reject=function()
--new addition
if (t.serverside["settings"].installed) then
TReX.lust.rejectlist = TReX.lust.rejectlist or {}

    if #TReX.lust.rejectlist > 0 then
        for k,v in pairs(TReX.lust.rejectlist) do
			if TReX.serverside.am_functional() then
				t.send("queue prepend eqbal reject " ..v)
			end
		end
    end

        --if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.lust.reject ) ") end
end-- if installed
end

TReX.lust.whitelist=function(who, add, remove)
--new addition
if (t.serverside["settings"].installed) then

t.lust.whitelist = t.lust.whitelist or {}

    if add then
        if not (table.contains({t.lust.whitelist}, who)) then
            table.insert(t.lust.whitelist, who)
            table.save(getMudletHomeDir().."/TReX_whitelist.lua", t.lust.whitelist)
        end
    end

    if remove then
        if table.contains({t.lust.whitelist}, who) then
            table.remove(t.lust.whitelist, table.index_of(t.lust.whitelist, who))
           --table.removekey(t.lust.whitelist, who)
 
        end
    end

    if not (table.is_empty(t.lust.whitelist)) then
        
		 cecho("\n\t<white>White list:")
        
            for k,v in pairs(t.lust.whitelist) do
                cecho("\n<dim_grey>"..v:title())
            end

            echo("\n")

    else
		cecho("<white>\nWhite List Empty\n")
    end
	
end-- if installed
	
    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.lust.whitelist ) ") end

end -- func

TReX.serverside.endArenaSpar=function()
	
	if not (table.is_empty(t.serverside.gmcp_aff_table)) then

		t.serverside.gmcp_aff_table = {}
		TReX.serverside.unknown_count_reset()
		TReX.lock.clear()
				
		TReX.serverside.affs_reset()
			

		
		if TReX.serverside.am_free() then t.send("inr all", false) end
			
				TReX.serverside.affStacks()
		
	end

    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.endArenaSpar ) ") end
	
end

TReX.serverside.unknowndenizneblockcheck=function(cure)
	for _,i in pairs(misc_cure_table[cure].blocks) do   -- check affliction blocks before using.
		if t.affs[i] then t.serverside.red_echo(cure.." blocked by "..i) return true end
	end
			return false
end

TReX.serverside.unknowndenizen=function()

if t.affs.unknownany >= unknown_cures_table.unknowndenizen.try_at then
	for k,v in ipairs(unknown_cures_table.unknowndenizen.cures_to_try) do

		if v~="valerian" then
			if t.bals[v] then
				if not TReX.serverside.unknowndenizneblockcheck(v) then
					t.send(misc_cure_table[v].command)
				end
			end
		else 
			if t.bals.smoke then
				t.send(smoke_table[v].command)
			end
		end -- if valerian

	end -- for
end	-- if

end

TReX.serverside.unknown_count_reset=function()

	t.affs.unknownany = 0
	
	if table.contains({t.serverside.gmcp_aff_table}, "unknownany") then
		TReX.serverside.affremove("unknownany")
		t.send("clear curing queue") -- to prevent waste.
	end

end

TReX.serverside.unknown_count=function()

if not (t.affs.unknownany) then 
	t.affs.unknownany = 0
end

t.affs.unknownany = t.affs.unknownany + 1

if not (table.index_of(t.serverside.gmcp_aff_table, "unknownany")) then
	TReX.serverside.affadd("unknownany")
end

	if t.affs.unknownany >= tonumber(t.config["settings_system"].diag_at) then 
		TReX.serverside.diagnose()
	end		

        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.unknown_count ) ") end
	
end

TReX.serverside.diagnose=function()

send("diagnose")

   if not (t.affs.aeon) and TReX.serverside.am_free() and TReX.serverside.am_functional() then
   
		t.serverside.gmcp_aff_table = {}
		TReX.lock.clear()
				
		TReX.serverside.affs_reset()

	end
		
		t.serverside.gmcpAffShow()
		echo"\n\n"
		deletep = false
		showprompt()
		
    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.diagnose ) ") end
    
end -- func

TReX.serverside.sit=function(item)
t.serverside["settings"].override = true
	if TReX.serverside.am_functional() then 
		if item then 
			t.send("queue prepend eqbal sit "..item) 
		else
			t.send("queue prepend eqbal sit", false) 
		end
	end
if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.sit ) ") end
end -- [[func]]

t.serverside.kneel=function(person)
t.serverside["settings"].override=true
TReX.serverside.affadd("prone")
	if TReX.serverside.am_functional() then 
		if person then 
			t.send("kneel "..person)
		else
			t.send("kneel")
		end
	end
end

TReX.serverside.kneel=function()
	if not t.affs.prone then 
		TReX.serverside.affadd("prone")
	end
end -- [[func]]

-- kelp stack check
TReX.serverside.kelp_stack_check=function()
	if t.stacks["kelp"] >= 2 then
		return true
	else
		return false
	end
end


TReX.serverside.class_check=function(aff)
	
	local aff = aff or nil
	
	t.class.list = {
	"alchemist",
	"apostate",
	"bard",
	"blademaster",
	"depthswalker",
	"dragon",
	"druid",
	--"infernal",
	"jester",
	"magi",
	"monk",
	"occultist",
	--"paladin",
	"priest",
	--"runewarden",
	"sentinel",
	"serpent",
	"shaman",
	"sylvan",
	"snb",
	"twoh",
	"dualb",
	"dualc",
	"shikudo",
}
	for _,v in pairs(t.class.list) do
		if t.class[v].enabled then
			TReX.class[v](aff)
		end
	end
	
end

	
TReX.lock.clear=function()

TReX.lock.list = {

	"dead",
	"rift",
	"pipe",
	"hard",
	"venom",
	"soft"
	
}
	for k,v in pairs(TReX.lock.list) do
		t.lock[v] = false -- sets t.lock ie. t.lock.soft to false
	end
    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.lock.clear ) ") end
end -- [[func]]


TReX.serverside.affs_reset=function()

		for k, v in pairs(t.serverside.gmcp_aff_table) do -- this needs a list I think.
			if table.contains({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, k) then
				t.affs[k] = 0
			else
				t.affs[k] = false
			end
		end
		
		for k, v in pairs(t.serverside.cures) do -- this sets aff count by cure type to 0.
			t.stacks[k] = 0
		end

end

TReX.serverside.lock_check=function()

t.serverside.cures = {
bloodroot = {type = "herb", alternatives = {concoctions = "bloodroot", alchemy = "magnesium"}},
lobelia = {type = "herb", alternatives = {concoctions = "lobelia", alchemy = "argentum"}},
kelp = {type = "herb", alternatives = {concoctions = "kelp", alchemy = "aurum"}},
ginseng = {type = "herb", alternatives = {concoctions = "ginseng", alchemy = "ferrum"}},
bellwort = {type = "herb", alternatives = {concoctions = "bellwort", alchemy = "cuprum"}},
ash = {type = "herb", alternatives = {concoctions = "ash", alchemy = "stannum"}},
goldenseal = {type = "herb", alternatives = {concoctions = "goldenseal", alchemy = "plumbum",}},
elm = {type = "smoke", alternatives = {concoctions = "elm", alchemy = "cinnabar"}},
valerian = {type = "smoke", alternatives = {concoctions = "valerian", alchemy = "realgar"}},
ginger = {type = "herb", alternatives = {concoctions = "ginger", alchemy = "antimony"}},
pear = {type = "herb", alternatives = {concoctions = "pear", alchemy = "calcite"}},
focus = {type = "focus"},
mendinglegs = { type = "salve" },
mendingarms = { type = "salve" },
mendingskin = { type = "salve" },
epidermalbody = { type = "salve" },
epidermalhead = { type = "salve"},
mendinghead = { type = "salve" },
mendingbody = { type = "salve" },
mendingtorso = { type = "salve" },
epidermalhead = { type = "salve" },
caloric = { type = "salve" },
restorationarms = { type = "salve" },
restorationlegs = { type = "salve" },
restorationhead = { type = "salve" },
restorationtorso = { type = "salve" },
restorationbody = { type = "salve" },
generosity = { type = "generosity" },
tree = { type = "tree" },
accelerate = { type = "balance" },
alleviate = { type = "balance" },
salt = { type = "balance" },
bloodboil = { type = "balance" },
daina = { type = "balance" },
shrugging = { type = "balance" },
might = { type = "balance" },
restore = { type = "balance" },
dheal = { type = "balance"}, -- TODO
flex = { type = "balance" }, -- TODO
writhe = { type = "balance" }, -- TODO
fool = { type = "balance" }, -- TODO
concentrate = { type = "concentrate" },
compose = { type = "compose" },
clot = { type = "clot" },
immunity = { type = "immunity" },
fitness = { type = "balance" },
rage = { type = "rage" },
healthhead = { type = "elixir" },
healthtorso = { type = "elixir" },
healtharms = { type = "elixir" },
healthlegs = { type = "elixir" },
stand = { type = "stand" },
stun = { type = "time" },
time = { type = "time" },
mental = { type = "type" },
physical = { type = "type" },
diagnose = { type = "type" },
instant = { type = "type" },
wake = { type = "wake" },
toggle = { type = "toggle" },
herb = { type = "herb" },
misc = { type = "misc" },
rage = { type = "balance" },
eruption = { type = "balance"},
purify = { type = "balance"},
slough = { type = "balance"},

}

TReX.lock.clear() 

	for k, v in pairs(t.serverside.cures) do -- this sets aff count by cure type to 0.
		t.stacks[k] = t.stacks[k] or 0
	end

    -- kelp stack check
    if t.stacks["kelp"] >= 3 then
		if isPrompt() then 
			if t.serverside["settings"].echos then 
				t.serverside.red_echo(" <white>---<red>[<white>KELP IS STACKED ON YOU<red>]<white>---", false) 
			end 	
		end
    end
	
	    -- kelp stack check
    if t.stacks["ginseng"] >= 3 then
		if isPrompt() then 
			if t.serverside["settings"].echos then 
				t.serverside.red_echo(" <white>---<red>[<white>GINSENG IS STACKED ON YOU<red>]<white>---", false) 
			end 	
		end
    end
	
	--slickness
	if t.stacks["valerian"] >= 1 and t.affs.asthma then
		if isPrompt() then 
			if t.serverside["settings"].echos then 
				t.serverside.red_echo(" <white>---<red>[<white>WATCH OUT FOR LOCK<red>]<white>---", false) 
			end 	
		end
    end
	
	
    --asthma weariness slickness check
   -- if t.affs.slickness and ((t.affs.asthma and t.affs.weariness) or (t.affs.asthma and not (t.affs.sensitivity or t.affs.clumsiness or t.affs.hypochondria))) then --1 scenario
       -- TReX.prios.switchPrios("asthma", 3)
       -- TReX.prios.switchPrios("paralysis", 4)
   -- elseif t.affs.asthma and t.affs.hellsight then
       -- TReX.prios.switchPrios("hellsight", 3, 1)
       -- TReX.prios.switchPrios("asthma", 4)
       -- TReX.prios.switchPrios("paralysis", 5)
   -- end
    -- --confusion and disrupt
   -- if t.affs.confusion and t.affs.disrupted and (t.bals.focus or t.affs.impatience) and not t.affs.whisperingmadness then --2 scenario
       -- TReX.prios.switchPrios("confusion", 2, 1)
       -- TReX.prios.switchPrios("paralysis", 3, 1)
   -- end
   
--[[TRUE LOCK]]	
	if (t.affs.impatience) and (t.affs.asthma) and (t.affs.slickness) and (t.affs.anorexia) and (t.affs.paralysis) and (t.affs.confusion) and (t.affs.disruption) then 
		t.lock["dead"] = true
		TReX.serverside.lock_class_skill_check()
			return
	end
--[[HARD LOCK]]		
	if (t.affs.impatience) and (t.affs.asthma) and (t.affs.slickness) and (t.affs.anorexia) and (t.affs.paralysis) then 
		t.lock["hard"] = true
		--if not table.is_empty(trx.bard.harmonics.table) and trx.bard.harmonics.table_check then
		--	if t.bals.eq and t.bals.bal then
		--		t.send("call harmonics")
			--	TReX.serverside.lock_class_skill_check()
			--	trx.bard.harmonics.table_check = false
		--	end
		--end
		--TReX.serverside.lock_class_skill_check()
			return
	end
--[[VENOM LOCK]]	
    if (t.affs.paralysis) and (t.affs.asthma) and (t.affs.slickness) and (t.affs.anorexia) then 
		TReX.serverside.lock_class_skill_check()
		t.lock["venom"] = true
			return
	end
--[[RIFT LOCK]]	
    if (t.affs.brokenleftarm) and (t.affs.brokenrightarm) and (t.affs.slickness) then
		t.lock["rift"] = true
		TReX.serverside.lock_class_skill_check()
			return
	end	
--[[SOFT LOCK]]
	if (t.affs.asthma) and (t.affs.slickness) and (t.affs.anorexia) then 
		TReX.serverside.lock_class_skill_check()
		t.lock["soft"] = true
			return
	end
        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.lock_check ) ") end
				
end--[[func]]

TReX.serverside.lock_class_skill_check=function()
local queue_kelp = false

	--if t.bals["tree"] then
		if t.serverside["settings_default"].tree ~= "Yes" then
			t.serverside["settings_default"].tree = "Yes"
			t.send("curing tree on", false) 
		end
	--else
	--	if t.serverside["settings_default"].tree ~= "No" then
	--		t.serverside["settings_default"].tree = "No"
	--		t.send("curing tree off", false) 
	--	end
	--end

	for _,v in pairs({"Runewarden","Infernal","Paladin","Blademaster","Monk","Sentinel","Druid"}) do
		if TReX.s.class == v then
			t.fitness()
		end
	end
	
	for _,v in pairs({"Sentinel","Druid"}) do if TReX.s.class == v then t.might() end end
	for _,v in pairs({"Occultist","Jester"}) do if TReX.s.class == v then t.fool() end end
 	for _,v in pairs({"Magi"}) do if TReX.s.class == v then t.bloodboil() end end
	for _,v in pairs({"Dragon"}) do if TReX.s.class == v then t.dragonheal() end end
	for _,v in pairs({"Serpent"}) do if TReX.s.class == v then t.shrugging() end end
	for _,v in pairs({"Depthswalker"}) do if TReX.s.class == v then t.accelerate() end end
	for _,v in pairs({"Blademaster"}) do if TReX.s.class == v then t.alleviate() end end
	for _,v in pairs({"Shaman"}) do if TReX.s.class == v then t.daina() end end
	for _,v in pairs({"Alchemist"}) do if TReX.s.class == v then t.salt() end end
	for _,v in pairs({"water Elemental Lord"}) do if TReX.s.class == v then t.purify() end end -- 'purify'
	for _,v in pairs({"earth Elemental Lord"}) do if TReX.s.class == v then t.eruption() end end -- 'terran eruption'
	for _,v in pairs({"fire Elemental Lord"}) do if TReX.s.class == v then t.slough() end end -- SLOUGH IMPURITIES
	-- phoenix=blademaster.
end
	
TReX.serverside.humourUp=function(h)

  local humour = "tempered" .. h
  
  
  --local humour = h
  if not (t.affs[humour]) then
    t.affs[humour] = 1
  elseif t.affs[humour] < 6 then
    --math min ensures it caps at 8
    t.affs[humour] = math.min(t.affs[humour] + 1, 8)
  elseif t.affs[humour] >= 6 then
    for k,v in pairs(humourafftable) do
      if t.affs[v] then
        t.affs[humour] = math.min(t.affs[humour] + 2, 8)
        --return
      end
    end
    t.affs[humour] = math.min(t.affs[humour] + 1, 8)
  end

  if not table.index_of(t.serverside.gmcp_aff_table, tostring(humour)) then
	table.insert(t.serverside.gmcp_aff_table, tostring(humour))
  end
  
  
if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.humourUp ) ") end


end

TReX.serverside.humourDown=function(h)
  local humour = "tempered" .. h
  --local humour = h

  if t.affs[humour] then
    --math.max ensures that its capped at 1 (cause it dropped one, didn't cure)
    t.affs[humour] = math.max(t.affs[humour] - TReX.serverside.gingerlevel, 0)
  end
 
  if t.affs[humour] < 1 then
	
		if table.contains({t.serverside.gmcp_aff_table}, humour) then
			table.remove(t.serverside.gmcp_aff_table, table.index_of(t.serverside.gmcp_aff_table, humour))
		end

  end
  
if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.humourDown ) ") end
 

end

TReX.serverside.humourReset=function(h)
  local humour = "tempered" .. h
  --local humour = h
  t.affs[humour] = 0  
  
  --enable system prompt echo
  table.remove(t.serverside.gmcp_aff_table, table.index_of(t.serverside.gmcp_aff_table, humour)) 
  
  
        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.humourReset ) ") end

end 

TReX.serverside.temperscount=function(aff)
	if aff == "temperedphlegmatic" or aff == "temperedsanguine" or aff == "temperedcholeric" or aff == "temperedmelancholic" then
		if t.affs[aff] == 0 then
			table.remove(t.serverside.gmcp_aff_table, table.index_of(t.serverside.gmcp_aff_table, aff)) 
		end
	end

	t.serverside.gmcpAffShow()
		
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.temperscount ) ") end

end
 
TReX.serverside.humourGainedHandling=function(event, affliction)
--new addition
if (t.serverside["settings"].installed) then

	if event:find("got humor") then

		if t.affs.temperedcholeric and t.affs.temperedcholeric >= 3 then
		  
			if TReX.prios.current["sensitivity"] ~= 2 then
				TReX.prios.switchPrios("sensitivity", 2, 2)
			end	
		  
			if TReX.prios.current["temperedcholeric"] ~= 2 then
				TReX.prios.switchPrios("temperedcholeric", 2, 1)
			end	
				
		elseif t.affs.temperedsanguine and t.affs.temperedsanguine >= 3 then
		  
			if TReX.prios.current["temperedsanguine"] ~= 2 then
				TReX.prios.switchPrios("temperedsanguine", 2, 1)
			end	
				
		elseif t.affs.temperedphlegmatic and t.affs.temperedphlegmatic >= 3 then
				
			if TReX.prios.current["temperedphlegmatic"] ~= 2 then
				TReX.prios.switchPrios("temperedphlegmatic", 2, 1)
			end	
				
		elseif t.affs.temperedmelancholic and t.affs.temperedmelancholic >= 3 then
			
			if TReX.prios.current["temperedmelancholic"] ~= 2 then
				TReX.prios.switchPrios("temperedmelancholic", 2, 1)
			end	

		end
	end

end	-- if installed
	
        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.humourGainedHandling ) ") end

end --func

TReX.serverside.humourLevelLost=function()
    if t.affs.temperedcholeric < 1 then
			if TReX.prios.current["sensitivity"] ~= 2 then
				TReX.prios.switchPrios("sensitivity", 2, 2)
			end	
  		TReX.prios.affPrioRestore("temperedcholeric")
    elseif t.affs.temperedsanguine < 1 then
		TReX.prios.affPrioRestore("temperedsanguine")
    elseif t.affs.temperedphlegmatic < 1  then
		TReX.prios.affPrioRestore("temperedphlegmatic")
    elseif t.affs.temperedmelancholic < 1 then
		TReX.prios.affPrioRestore("temperedmelancholic")
    end
       if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.humourLevelLost ) ") end
end --func

TReX.serverside.humourcured=function(event, affliction)
--new addition
if (t.serverside["settings"].installed) then
  if event:find("lost humor") then
	if TReX.prios.current[affliction] ~= TReX.prios.default[affliction] then
		TReX.prios.switchPrios(affliction, TReX.prios.default[affliction])
	end
  end

end    
    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.humourcured ) ") end

end



TReX.serverside.parryCheck=function()

    if (n=="Your shield completely absorbs the damage.") then
        return true
     elseif (n=="You dodge nimbly out of the way.") then
         return true
     elseif (n=="You twist your body out of harm's way.") then
         return true
     elseif (n=="You quickly jump back, avoiding the attack.") then
         return true
     elseif string.starts(n,"The attack rebounds back onto") then
         return true
     elseif string.starts(n,"You frantically attempt to parry the attack of") then
         return true
    else
        return false
    end

    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.parryCheck ) ") end


end

TReX.serverside.dodgeCheck=function(n)

	if (n=="You parry the attack with a deft manoeuvre.") then
        return true
    elseif (n=="You dodge nimbly out of the way.") then
        return true
    elseif (n=="You twist your body out of harm's way.") then
        return true
    elseif (n=="You quickly jump back, avoiding the attack.") then
        return true
    elseif string.starts(n,"The attack rebounds back onto") then 
		return true
    elseif string.starts(n,"You frantically attempt to parry the attack of") then
        return true
	end
	
        return false
  
end

TReX.serverside.fractureup=function(li, n)

  if t.affs[li] == 0 then
    t.affs[li] = n
  elseif t.affs[li] >= 1 then
    t.affs[li] = math.min(t.affs[li] + n, 8)
  end
  	-- an added bonus for static health application thresholds
	TReX.serverside.healthaffscheck(li)
	--- this gets added in the event file.
	TReX.serverside.affadd(li)  
	   
end

TReX.serverside.fracturedown=function(li, n)
  if t.affs[li] then
	t.affs[li] = math.max(t.affs[li] - n, 0)
  end
	
	if t.affs[li] == 0 then
		TReX.serverside.affremove(li)
	end
	
	-- an added bonus for static health application thresholds
	TReX.serverside.healthaffscheck(li)	
	
end

TReX.serverside.fracturereset=function(li)
    t.affs[li] = 0
end

TReX.serverside.fracturecount=function()
  local c = 0
  if t.affs["skullfractures"] then
    c = c + t.affs["skullfractures"]
  elseif t.affs["crackedribs"] then
    c = c + t.affs["crackedribs"]
  elseif t.affs["torntendons"] then
    c = c + t.affs["torntendons"]
  elseif t.affs["wristfractures"] then
    c = c + t.affs["wristfractures"]
  end

  return c
end

TReX.serverside.twohanddoubled=function(p)
  if not table.contains({TReX.serverside.twohanddouble}, p) then
		TReX.serverside.twohanddouble[#TReX.serverside.twohanddouble+1] = p
		if TReX.timer["twohanddouble"..p] then 
			killTimer(TReX.timer["twohanddouble"..p]) 
			TReX.timer["twohanddouble"..p]=nil 
		end

			TReX.timer["twohanddouble"..p] = tempTimer(1.9, function() 
				TReX.timer["twohanddouble"..p] = nil 
				TReX.serverside.twohandsingled(p)
			end)
		
  end
end

TReX.serverside.twohandsingled=function(p)
  if table.contains(TReX.serverside.twohanddouble, p) then
    table.remove(TReX.serverside.twohanddouble, table.index_of(TReX.serverside.twohanddouble, p))
  end

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.twohandsingled ) ") end

end

TReX.serverside.is_twohanddoubled=function(p)
local ans = table.contains(TReX.serverside.twohanddouble, p)
	TReX.serverside.twohandsingled(p)
        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.is_twohanddoubled ) ") end
            return ans
end
      
TReX.serverside.fracturetree=function(event, affliction)
	if TReX.serverside.fracturecount() >= 1 and not (t.affs.paralysis)  then
		raiseEvent("tree_event got")
	end

    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.fracturetree ) ") end

end

-- TReX.serverside.conditional_report=function()
	-- if table.is_empty(t.serverside.gmcp_aff_table) then
		-- if t.serverside.empty_report then
			-- if isPrompt() then t.serverside.gmcpAffShow() end
		-- end
	-- else
		-- if #t.serverside.gmcp_aff_table==1 and table.contains({t.serverside.gmcp_aff_table}, "bleeding") then
			-- return
		-- else
			-- if isPrompt() then t.serverside.gmcpAffShow() end
			-- t.serverside.empty_report = true
		-- end
	-- end

-- end

function TReX.serverside.myShin()
 if gmcp.Char.Vitals then
	for k, v in pairs(gmcp.Char.Vitals.charstats) do
		if string.starts(v, "Shin") then
			shin = tonumber(string.match(v,"Shin: (%d+)"))
			return  shin
		end
	end
 end
end

-- affliction table list echo
t.serverside.gmcpAffShow=function()  -- this is your aff display

local a,b,c,d

t.affs["pres"] = t.affs["pres"] or 0
t.affs["bleed"] = TReX.serverside.bleed_check()

t.affs["unknownany"] = t.affs["unknownany"] or 0
t.affs["crackedribs"] = t.affs["crackedribs"] or 0
t.affs["torntendons"] = t.affs["torntendons"] or 0
t.affs["wristfractures"] = t.affs["wristfractures"] or 0
t.affs["skullfractures"] = t.affs["skullfractures"] or 0
t.affs["temperedmelancholic"] = t.affs["temperedmelancholic"] or 0
t.affs["temperedcholeric"] = t.affs["temperedcholeric"] or 0
t.affs["temperedphlegmatic"] = t.affs["temperedphlegmatic"] or 0
t.affs["temperedsanguine"] = t.affs["temperedsanguine"] or 0

                   
	if tonumber(t.affs.bleed) < 150 then
		c = "<white>"
	elseif tonumber(t.affs.bleed) > 149 and tonumber(t.affs.bleed) < 300 then
		c = "<yellow>"
	elseif tonumber(t.affs.bleed) > 299 then
		c = "<red>"
	end

	if tonumber(t.affs.burn) <= 1 then
		d = "<white>"
	elseif tonumber(t.affs.burn) > 1 and tonumber(t.affs.burn) < 3 then
		d = "<yellow>"
	else
		d = "<red>"
	end
				
				
local aff_abbrev = {
  ablaze                 = "<orange_red>ablaze",
  addiction              = "<blue>add",
  aeon                   = "<white>[<magenta>AEON<white>]",
  agoraphobia            = "<DarkSlateGrey>agor",
  airdisrupt             = "<DarkSlateGrey>adsr",
  airfisted              = "<violet>airfisted",
  anorexia               = "<violet>ano",
  asphyxiating           = "<violet>asphyx",
  sleeping               = "<white>[<firebrick>ASLEEP<white>]",
  asthma                 = "<orange>ast",
  blackout               = "<red>[<DarkKhaki>blackout<red>]",
  bleeding               = "<red>bleed <white>("..c.. "" ..t.affs["bleed"].."<white>)",
  blindness              = "<DarkSlateGrey>blind",
  blistered              = "<red>blstrd",
  bound                  = "<DarkSlateGrey>bound",
  burning                = "<orange_red>burning <white>("..d.. "" ..t.affs["burn"].."<white>)",
  charredburn            = "<orange_red>:charredburn: <white>(<firebrick>4<white>)",
  cadmuscurse		     = "<white>(<red>CADMUS<white>)",
  temperedcholeric       = "<DarkKhaki>chol <white>("..c.. ""..t.affs["temperedcholeric"].."<white>)",
  claustrophobia         = "<lemon_chiffon>clau:",
  calcifiedskull		 = "<dark_orange>calcskull",	
  calcifiedtorso		 = "<dark_orange>calctorso"	,
  clumsiness             = "<dark_orange>clum",
  concussion		     = "<red>[<DarkSlateGrey>concussion<red>]",
  confusion              = "<MediumSpringGreen>conf",
  corruption             = "<DarkKhaki>corrupt",
  conflagration          = "<white>[[<DarkKhaki>conflag<white>]]",
  crackedribs            = "<DarkKhaki>ribs <white>("..c.. ""..t.affs["crackedribs"].."<white>)",
  crushedthroat          = "<DarkSlateGrey>crushedthroat",
  brokenleftarm   	     = "<white>{<firebrick>LA<white>(1)}",
  brokenleftleg   	     = "<white>{<firebrick>LL<white>(1)}",
  brokenrightarm  	     = "<white>{<firebrick>RA<white>(1)}",
  brokenrightleg   	     = "<white>{<firebrick>RL<white>(1)}",
  bruisedribs            = "<DarkSlateGrey>bruisedribs",
  darkshade              = "<blue>dark",
  dazed                  = "<DarkSlateGrey>dazed",
  dazzled                = "<DarkSlateGrey>dazzled",
  deadening              = "<light_gray>dea",
  deafness               = "<DarkSlateGrey>deaf",
  deepsleep              = "<red>[<white>deepsleep<red>]",
  degenerate             = "<DarkKhaki>degenerate", 
  dehydrated             = "<DarkKhaki>dehydrate",
  demonstain             = "<red>[<white>STAIN<red>]",
  dementia               = "<MediumSpringGreen>dem",
  depression             = "<LightGoldenrod>dep", 
  deteriorate            = "<DarkKhaki>deteriorate", 
  disloyalty             = "<light_gray>disl",
  disrupt                = "<DarkKhaki>disrupt",
  dissonance             = "<LightGoldenrod>disso",
  dizziness              = "<LightGoldenrod>diz",
  earthdisrupt           = "<green>edsr",
  enlightenment		     = "<firebrick>>>>><white>enlighten<firebrick><<<<<",
  epilepsy               = "<LightGoldenrod>epi",
  extremeburn            = "<orange_red>burn (<firebrick>3<white>)",
  enmesh                 = "<DarkSlateGrey>enmesh",
  fear                   = "<DarkSlateGrey>fear",
  firedisrupt            = "<firebrick>firedisrupt",
  frozen                 = "<cyan>frozen",
  flamefisted            = "flamefisted",
  generosity             = "<lemon_chiffon>generosity",
  haemophilia            = "<white>{<blue>haem<white>}",
  hallucinations         = "<MediumSpringGreen>hall",
  hamstrung              = "<red>[[<white>HMS<red>]]",
  hatred                 = "<DarkSlateGrey>hatred", 
  healthleech            = "<white>[<green>H<white>] leech",
  heartseed              = "<red>(<white>HEARTSEED<red>)]]",
  hecatecurse		     = "<orange>{{{<white>hecate<orange>}}}",
  hellsight              = "<red>hell",
  homunculusmercury      = "<white>{<DarkKhaki>mercury<white>}",
  hypersomnia            = "<MediumSpringGreen>hypers",
  hypochondria           = "<dark_orange>hypoch",
  hindered               = "<firebrick>hindered",
  icing                  = "<DarkSlateGrey>ice",
  indifference           = "<DarkSlateGrey>indifference",
  illness                = "<DarkSlateGrey>ill",
  impaled                = "<white>(<firebrick>IMPALED<white>)",
  impatience             = "<white>[<yellow>IMP<white>]",
  inquisition            = "<orange_red>[[<white>inquisition<orange_red>]]",
  icefisted              = "<DodgerBlue>icefisted",
  itching                = "<DarkSlateGrey>itching",
  internalbleeding	     = "<red>intbld",
  kkractlebrand		 	 = "<dark_orange>kkbrand",
  latched		         = "<dark_orange>latched",	
  justice                = "<lemon_chiffon>((<white>JUSTICE<lemon_chiffon>))",
  retribution            = "<lemon_chiffon>retr",
  laceratedthroat        = "lac<white>(<orange>2<white>)",
  lapsingconsciousness   = "lapsingconsciousness",
  lethargy               = "<blue>let",
  loneliness             = "<lemon_chiffon>lon",
  shadowmadness          = "<white>[<LightGoldenrod>SMAD<white>]",
  lovers                 = "<lemon_chiffon>lovers",
  madness                = "<DarkSlateGrey>madness",
  damagedleftarm         = "<yellow>{<firebrick>LA<white>(<yellow>2<white>)<yellow>}",
  damagedleftleg         = "<yellow>{<firebrick>LL<white>(<yellow>2<white>)<yellow>}",
  damagedrightarm        = "<yellow>{<firebrick>RA<white>(<yellow>2<white>)<yellow>}",
  damagedrightleg        = "<yellow>{<firebrick>RL<white>(<yellow>2<white>)<yellow>}",
  masochism              = "<lemon_chiffon>maso",
  entangled              = "<DarkKhaki>entangled",
  entropy                = "<DarkKhaki>entropy",
  kaisurge               = "<DarkKhaki>kaisurge",
  temperedmelancholic    = "<DarkKhaki>melan <white>("..c.. ""..t.affs["temperedmelancholic"].."<white>)",
  trueblind              = "<DarkSlateGrey>trueblind",
  manaleech              = "<white>[<blue>M<white>] leech",
  mindclamp              = "<red>[<white>mindclamp<red>]",
  meltingburn            = "meltingburn(<firebrick>5<white>)",
  mangledhead        	 = "<white>{<firebrick> HEAD <white>(1) }",
  mildtrauma             = "<white>{<firebrick> TORSO <white>(1) }",
  mangledleftarm         = "<red>{<firebrick>LA<white>(<red>3<white>)<red>}",
  mangledleftleg  	     = "<red>{<firebrick>LL<white>(<red>3<white>)<red>}",
  mangledrightarm 	     = "<red>{<firebrick>RA<white>(<red>3<white>)<red>}",
  mangledrightleg 	     = "<red>{<firebrick>RL<white>(<red>3<white>)<red>}",
  nausea                 = "<blue>nau",
  ninkharsag             = "<DarkSlateGrey>nkh",
  numbedleftarm          = "<DarkSlateGrey>nbla",
  numbedrightarm         = "<DarkSlateGrey>nbra",
  pacifism               = "<lemon_chiffon>pac",
  paralysis              = "<firebrick>par",
  paranoia               = "<MediumSpringGreen>prn",
  parasite               = "<dark_orange>pars", 
  peace                  = "<lemon_chiffon>pea",
  temperedphlegmatic     = "<DarkKhaki>phleg <white>("..c.. ""..t.affs["temperedphlegmatic"].."<white>)",
  phlogistication        = "<DarkKhaki>phlog",
  pinshot                = "<red>{{<white>psh<red>}}",
  prone                  = "<white>[<firebrick>PR<white>]",
  retardation			 = "<white><red>r<white>",
  recklessness           = "<DarkKhaki>reck",
  scytherus              = "<red>{<white>scy<red>}",
  timeloop               = "<white>(<lemon_chiffon>timeloop<white>)", --DW UPDATE
  roped                  = "<red>roped",
  temperedsanguine       = "<DarkKhaki>sang <white>("..c.. ""..t.affs["temperedsanguine"].."<white>)",
  selarnia               = "<DarkSlateGrey>sel",
  stun 					 = "<red>[<DarkKhaki>stun<red>]",
  sensitivity            = "<dark_orange>sen",
  seriousconcussion      = "<yellow>{<firebrick>HEAD<white>(<yellow>2<white>)<yellow>}",
  serioustrauma          = "<yellow>{<firebrick>TORSO<white>(<yellow>2<white>)<yellow>}",
  severeburn             = "<orange_red>severeburn (<yellow>2<white>)",
  shivering              = "<DodgerBlue>shiv",
  shyness                = "<DarkSlateGrey>shy",
  skullfractures         = "<DarkKhaki>skull <white>("..c.. ""..t.affs["skullfractures"].."<white>)",
  slashedthroat          = "<red>lacerate <white>(1)",
  slickness              = "<deep_pink>sli",
  slimeobscure		     = "<yellow_green>slimed",
  spiritdisrupt          = "<light_grey>sdsr",
  stain                  = "<yellow_green>stain",
  stupidity              = "<LightGoldenrod>st",
  stuttering             = "<DarkSlateGrey>stut",
  swellskin              = "<DarkSlateGrey>swsk",
  timeflux               = "<red>{<white>TFX<red>}",
  vinewreathed           = "<DarkSlateGrey>vinewreathe",
  vitiated               = "<DarkKhaki>vitiated",
  voidfisted             = "<DarkKhaki>voidfisted",
  tension				 = "<dark_orange>tension",
  pressure				 = "<orange_red>pressure <white>("..d.. "" ..t.affs["pres"].."<white>)",
  coldfate				 = "<dark_orange>coldfate",
  torntendons            = "<DarkKhaki>ttendons <white>("..c.. ""..t.affs["torntendons"].."<white>)",
  transfixation          = "<DarkKhaki>transf",
  unconsciousness        = "<white>[<blue>unconc<white>]", 
  unknownany             = "<firebrick> ? <white>("..c.. ""..t.affs["unknownany"].."<white>)",
  unknowncrippledarm     = "<DarkSlateGrey>uwna",
  unknowncrippledleg     = "<DarkSlateGrey>uwnl",
  unknowncrippledlimb    = "<DarkSlateGrey>uwcrip",
  unknowncure            = "<DarkSlateGrey>uc",
  unknownmental          = "<DarkSlateGrey>um",
  vertigo                = "<lemon_chiffon>vert",
  vitrification          = "<DarkKhaki>vitri",
  voided                 = "<red>{<white>VOID<red>}",
  voyria                 = "<DarkKhaki>VOYRIA",
  waterdisrupt           = "<cyan>wdsr",
  weakenedmind           = "<DarkKhaki>weakmind",
  weariness			     = "<dark_orange>weary",
  webbed                 = "<DarkKhaki>webbed",
  whisperingmadness      = "<yellow>>>><white>madness<yellow><<<",
  wristfractures         = "<DarkKhaki>wrist <white>("..c.. ""..t.affs["wristfractures"].."<white>)",
  scalded				 = "<firebrick>>>><white>scalded<firebrick><<<",
 
}

TReX.serverside.prompt_options = {
	softlock = function () if t.lock.soft then return "<red>[[ <white>SOFT LOCK'D <red>]] " else return "" end end,
	venmlock = function () if t.lock.venom then return "<red>[[ <white>VENM LOCK'D <red>]] " else return "" end end,
	hardlock = function () if t.lock.hard then return "<red>[[ <white>HARD LOCK'D <red>]] " else return "" end end,
	truelock = function () if t.lock.dead then return "<red>[[ <white>TRUE LOCK'D <red>]] " else return "" end end,		
	riftlock = function () if t.lock.rift then return "<red>[[ <white>RIFT LOCK'D <red>]] " else return "" end end,	
	pipelock = function () if t.lock.rift then return "<red>[[ <white>PIPE LOCK'D <red>]] " else return "" end end,	
}


	if not (table.is_empty(t.serverside.gmcp_aff_table)) then
		local a, type = {}, type
			if next (t.serverside.gmcp_aff_table) then
				for k, v in pairs(t.serverside.gmcp_aff_table) do
				  a[#a+1] = (aff_abbrev[v] or v)
                    if #a < 4 then  
                        b = "<DarkSlateGrey>"
                    elseif #a < 7 then
                        b = "<white>"
                    elseif #a >= 7 then
                        b = "<red>"
                    end
				end
				
				local aff = ""
							   
                --if not t.affs.recklessness then
					local aff = aff.."<white>"..c.."[<red>affs<white>"..c.."]<white>:".."" --firebrick
				--else
				--	local aff = aff.."<red>{{affs<white>"..c.."}}<white>:".."" --firebrick
				--end
				  
				local aff = aff..TReX.serverside.prompt_options.softlock() .. ""
				local aff = aff..TReX.serverside.prompt_options.venmlock() .. ""
				local aff = aff..TReX.serverside.prompt_options.hardlock() .. ""
				local aff = aff..TReX.serverside.prompt_options.truelock() .. ""
				local aff = aff..TReX.serverside.prompt_options.riftlock() .. ""
				local aff = aff..TReX.serverside.prompt_options.pipelock() .. ""
 
				if not t.affs.recklessness then
					--clearWindow("TReX.serverside.middle")
					aff = aff..""..c.."["..b..""..#a..""..c.."]<white>:"..c.."[<DarkSlateGrey>"..table.concat(a, ": ")..""..c.."]" .. ""
				else
					--clearWindow("TReX.serverside.middle")
					aff = aff.."<red>{{"..b..""..#a.."<red>}}<white>:<red>{{<DarkSlateGrey>"..table.concat(a, ": ").."<red>}}" .. ""
				end
					selectString(line, 1)			
					moveCursorEnd("main")
					if getCurrentLine() ~= "" then aff = "\n"..aff end
					if t.serverside.settings.affbar then
						clearWindow("TReX.serverside.middle")
						TReX.serverside.middle:cecho(aff)
					else

							cecho(aff)

			   end
			end	

	else

		TReX.serverside.unknown_count_reset()
	
 		local aff = ""
		local aff = aff.."<white>[<DarkSlateGrey>affs<white>]<white>:[<DarkSlateGrey>0<white>]" --firebrick

			selectString(line, 1)
			moveCursorEnd("main")
			if getCurrentLine() ~= "" then aff = "\n"..aff end
			if t.serverside.settings.affbar then
				clearWindow("TReX.serverside.middle")
				TReX.serverside.middle:cecho(aff)
			else

					cecho(aff)

			end
		
		--failsafe for resetting stack count on empty.
		for k, v in pairs(t.serverside.cures) do -- this sets aff count by cure type to 0.
			t.stacks[k] = 0
		end
		   

			   
    end -- if
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( t.serverside.gmcpAffShow ) ") end
 end -- func

TReX.serverside.affbar=function(mode)
	if mode == "on" then
		t.serverside.settings.affbar = true
		setMiniConsoleFontSize("TReX.serverside.middle", 12)
		TReX.serverside.container:show()
		t.serverside.gmcpAffShow()
		setBorderBottom(27)
		t.serverside.green_echo("AffBar On\n")
		
	else
		t.serverside.settings.affbar = false
		TReX.serverside.container:hide()
		setBorderBottom(0)
		t.serverside.red_echo("AffBar Off\n")
	end
end

TReX.serverside.eh_items=function(event, arg)

	if event:find(".List") then
		--print("gmcp.Char.Items.List event")

		-- ROOM ITEMS
		if gmcp.Char.Items.List.location == "room" then
			TReX.serverside.items.room = {}
			for key,value in pairs(gmcp.Char.Items.List.items) do
				if value.name then TReX.serverside.items.room[value.id] = value.name end

			end
			--gui.updateRoomInv()
		end

	elseif event:find(".Add") then
		-- ROOM ITEMS
		if gmcp.Char.Items.Add.location == "room" then
			local value = gmcp.Char.Items.Add.item
			TReX.serverside.items.room[value.id] = value.name

		end

	elseif event:find(".Remove") then
		-- ROOM ITEMS
		if gmcp.Char.Items.Remove.location == "room" then
			itemKey = gmcp.Char.Items.Remove.item.id
			TReX.serverside.items.room["" .. itemKey] = nil
		end
	end
	
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.eh_items ) ") end
		 

end

-- Counts the afflictions per curative type stacked/added to my person.
TReX.serverside.affStacks=function()
--I think I need to add this to a function for counting ease..
    for affs, cures in pairs(t.serverside.afflictions) do 
        for _, cure in ipairs(cures) do
		
            if not (t.serverside.cures[cure]) then
			    if t.serverside["settings"].echos then t.serverside.green_echo("Got an unknown cure " .. cure) end
		    elseif not (t.serverside.cures[cure].affs) then 
			    t.serverside.cures[cure].affs = {} 
		    end  -- if

			if not table.index_of(t.serverside.gmcp_aff_table, aff) and not table.contains({t.serverside.exclude}, aff) then
				t.serverside.cures[cure].affs[#t.serverside.cures[cure].affs + 1] = aff 
			end

		end
	end  -- for

        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.affStacks ) ") end

end  -- for

TReX.serverside.getProneLength=function()
-- --handle cancelling of delayvenom in case of this being a DSL:
-- --apply the cripples right away, so the cure of a potential mangled limb in the
-- --dsl, the venoms and the limb break get computed for cure at once on the 

	-- t.serverside.prTime = t.serverside.prTime or 0

	-- if (t.affs.prone) then
		-- --if not (t.bals.salve) then  -- needs to be on broken legs
		-- for _,v in pairs({"brokenleftleg","damagedleftleg","mangledleftleg","brokenrightleg","damagedrightleg","mangledrightleg"}) do
			-- if table.contains({t.serverside.gmcp_aff_table}, v) then
		
				-- if t.affs.mangledleftleg then
					-- t.serverside.prTime = t.serverside.prTime+8
				-- end

				-- if t.affs.mangledrightleg then
					-- t.serverside.prTime = t.serverside.prTime+8
				-- end

				-- if t.affs.damagedleftleg then
					-- t.serverside.prTime = t.serverside.prTime+4
				-- end

				-- if t.affs.damagedrightleg then
					-- t.serverside.prTime = t.serverside.prTime+4
				-- end

				-- -- mending cures instantly so only add 1 if 2 legs are broken
				-- if (t.affs.brokenleftleg or t.affs.damagedleftleg or t.affs.mangledleftleg) and (t.affs.brokenrightleg or t.affs.damagedrightleg or t.affs.mangledrightleg) then
					-- t.serverside.prTime = t.serverside.prTime+1
				-- end

				-- --get the time elapsed off the salve timer
				-- --local salveTime = (stopStopWatch( salveStopWatch )-(getNetworkLatency()*.1))  
				-- local salveTime = stopStopWatch( salveStopWatch )+1 or 0
				-- t.serverside.prTime = t.serverside.prTime-(salveTime)
			
				-- if t.serverside.prTime < .25 then
					-- t.serverside.prTime=0
				-- end
			
			-- end -- if t.affs[v]
		-- end -- for k,v	
		-- return t.serverside.prTime
    -- else
        -- return t.serverside.prTime
	-- end

end

--Returns highest curative count variable for use.
TReX.serverside.getHighestStack = function(type) 
     local maxStack, maxNum = nil, 0 
     for stack, count in pairs(t.stacks) do 
         if type then 
             if (t.serverside.cures[stack].type == type) then 
                 if (count > maxNum) then 
                     maxStack, maxNum = stack, count 
                 end  -- if
				 
             end  -- if
         else 
             if (count > maxNum) then 
                 maxStack, maxNum = stack, count 
             end  -- if
         end  -- if
     end  -- for

        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.getHighestStack ) ") end

     return maxStack 
end  -- func

TReX.serverside.BlackoutDetection=function()
		if line == "-" or line:find("^%-%d+%-$") or line == "Vote-" or line == "note-" then -- testing 
        --if "^s:find '%s(%S-)%'" then -- like this function.. proud of myself for this one.. :)
            if not (t.affs.blackout) then
               -- TReX.serverside.affadd("blackout")
				TReX.serverside.autoTreeOn()
            end
        else 
            if t.affs.blackout then
                --stupidityTReX.serverside.affremove("blackout")
				TReX.serverside.autoTreeOff()
            end
		end

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.BlackoutDetection ) ") end

end

TReX.serverside.inslowcuringmode = function()
	if t.affs.retardation then
		return true
	else
		return false
	end
end

TReX.serverside.bleed_check=function()
	for _, stat in ipairs(gmcp.Char.Vitals.charstats) do 
		if stat:starts("Bleed:") then 
			return tonumber((stat:match("^Bleed: (%d+)"))) 
		end 
	end

		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.bleed_check ) ") end

end
			
TReX.serverside.karma_check=function()
	if table.index_of({"Occultist"}, TReX.s.class) then
		if gmcp.Char.Vitals then
			for _, stat in ipairs(gmcp.Char.Vitals.charstats) do 
				if stat:starts("Karma:") then 
					_, TReX.stats["karma"] = tonumber(stat:match("^Karma: (%d+)"))
					return tonumber(stat:match("^Karma: (%d+)"))
				end 
			end
		else
			TReX.stats["karma"] = 0
			return 0
		end

			if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.karma_check ) ") end
	end
end

TReX.serverside.sunlight_check=function()
if table.index_of({"Druid","Sylvan"}, TReX.s.class) then
	if gmcp.Char.Vitals then
		for k, v in pairs(gmcp.Char.Vitals.charstats) do
			if string.starts(v, "Sunlight") then
				_, TReX.stats["sunlight"] = tonumber(string.match(v,"(%d+)"))
				return tonumber(string.match(v,"%d+"))
			end
		end
	else
		TReX.stats["sunlight"] = 0
		return 0
	end
end
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.sunlight_check ) ") end
end

TReX.serverside.morph_check=function()
if table.index_of({"Druid","Sentinel"}, TReX.s.class) then
	if gmcp.Char.Vitals then
		for _, stat in ipairs(gmcp.Char.Vitals.charstats) do 
				if stat:starts("Morph:") then 
					_, TReX.stats["morph"] = tostring(stat:match("^Morph: (%w+)"))
					return tostring(stat:match("^Morph: (%w+)"))
				end 
			end
	else
		TReX.stats["morph"] = "Human"
		return "Human"
	end
end
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.sunlight_check ) ") end
end

	
TReX.serverside.affadd=function(aff)

if table.contains({t.serverside.gmcp_aff_table}, aff) then return end

	if t.serverside["settings"].installed then

		local affInfo = t.serverside.afflictions[aff]
		local stacks = t.stacks

		-- this function sets override to false so if we are sitting and get a random afflictin we will stand up..
		if aff == tostring("prone") and t.serverside["settings"].override then
			t.serverside["settings"].override = true  
		else
			t.serverside["settings"].override = false
		end

		
		if table.index_of({"burning (1)","burning (2)","burning (3)","burning (4)","burning (5)"}, aff) then 
		
			if aff=="burning (1)" then
				t.affs.burn=1
			elseif aff=="burning (2)" then
				t.affs.burn=2
			elseif aff=="burning (3)" then
				t.affs.burn=3
			elseif aff=="burning (4)" then
				t.affs.burn=4
			elseif aff=="burning (5)" then
				t.affs.burn=5
			end
		
				return
		
		end
	   		
		
		
		-- important to add the aff to the table.
		-- this table adds gmcp afflictions to the t.serverside.gmcp_aff_table table, all but the ignored. 
		-- The ignored affs still go to t.affs and the t.serverside.gmcp_aff_table tables
		if not table.index_of(t.serverside.gmcp_aff_table, aff) and not table.contains({t.serverside.exclude}, aff) then -- secondary aff add, (but also the event handler table)
			table.insert(t.serverside.gmcp_aff_table, #t.serverside.gmcp_aff_table+1, aff)
			
				if not table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, aff) then
					t.affs[aff] = true
				end
				
		end	
			
  					   
		--  echos an error if the affliction or cure type is not listed in the table
		--  it is my echo to tell me t.serverside.afflictions needs updated.
		if (affInfo) and not table.contains({t.serverside.exclude}, aff) then
			-- iterates through the cure types and adds the values
				for _, cure in ipairs(affInfo) do
					stacks[cure] = (stacks[cure] or 0) + 1  
					
					-- counts the aff types by type
					-- [[dont move from this spot]]
					TReX.serverside.affStacks() 
					
					--[[gui affliction by type counter console]]
					-- [[dont move from this spot]]
					--if gmcp.Char.Status.name == "Nehmrah" then TReX.gui.stacks() end
					
				end  
			else		
				if not (table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, aff)) and not table.contains({t.serverside.exclude}, aff) then
					if t.serverside["settings"].echos then t.serverside.red_echo(" Got Unknown Affliction '" .. aff .. "'.") end
				end
			end

											
				for _,v in pairs({"snb","bard","magi","monk", "shikudo", "druid","jester","priest","sylvan"
									,"serpent","shaman","sentinel","occultist","apostate","alchemist"
									,"dualb","dualc","blademaster","dragon","depthswalker","earth","air","water","fire"}) 
				do
					if t.class[v].enabled then
						TReX.class[v](aff) 
					end
				end		
				
				raiseEvent("TReX gained aff", aff)
			

		--[[for debbuging purposes]]
		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.affadd ) ") end
				
	end
end 
			
t.serverside.gmcpAffAdded=function(aff) -- motherboard gmcp aff add 

if table.contains({t.serverside.gmcp_aff_table}, aff) then return end

	if t.serverside["settings"].installed then

	   --[[collect current affliction data from gmcp]]
		--local aff,count = affliction or string.match( gmcp.Char.Afflictions.Add.name, "(%w+) %((%d+)%)" )
		local aff = gmcp.Char.Afflictions.Add.name
		
		  
		if table.index_of({"burning (1)","burning (2)","burning (3)","burning (4)","burning (5)"}, aff) then 
		
			if aff=="burning (1)" then
				t.affs.burn=1
			elseif aff=="burning (2)" then
				t.affs.burn=2
			elseif aff=="burning (3)" then
				t.affs.burn=3
			elseif aff=="burning (4)" then
				t.affs.burn=4
			elseif aff=="burning (5)" then
				t.affs.burn=5
			end
		
				return
		
		end
	
		local affInfo = t.serverside.afflictions[aff]
		local stacks = t.stacks
		

		-- this function sets override to false so if we are sitting and get a random afflictin we will stand up..
	   if aff == tostring("prone") and t.serverside["settings"].override then
			t.serverside["settings"].override = true  
	   else
			t.serverside["settings"].override = false
	   end

	   
	-- important to add the aff to the table.
	-- this table adds gmcp afflictions to the t.serverside.gmcp_aff_table table, all but the ignored. 
	-- The ignored affs still go to t.affs and the t.serverside.gmcp_aff_table tables
	if not table.index_of(t.serverside.gmcp_aff_table, aff) and not table.contains({t.serverside.exclude}, aff) then -- secondary aff add, (but also the event handler table)
		table.insert(t.serverside.gmcp_aff_table, #t.serverside.gmcp_aff_table+1, aff)
		
			if not (table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, aff)) then
				t.affs[aff] = true
			end

		
	end	
	 
		--  echos an error if the affliction or cure type is not listed in the table
		--  it is my echo to tell me t.serverside.afflictions needs updated.
		if (affInfo) and not table.contains({t.serverside.exclude}, aff) then
		-- iterates through the cure types and adds the values
			for _, cure in ipairs(affInfo) do
				stacks[cure] = (stacks[cure] or 0) + 1  
				
				-- counts the aff types by type
				-- [[dont move from this spot]]
				TReX.serverside.affStacks() 
				
				--[[gui affliction by type counter console]]
				-- [[dont move from this spot]]
				--if gmcp.Char.Status.name == "Nehmrah" then TReX.gui.stacks() end
				
			end  
		else		
			if not (table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, aff)) and not table.contains({t.serverside.exclude}, aff) then
				if t.serverside["settings"].echos then t.serverside.red_echo(" Got Unknown Affliction '" .. aff .. "'.") end
			end
		end
		
				for _,v in pairs({"snb","bard","magi","monk","shikudo","druid","jester","priest","sylvan"
									,"serpent","shaman","sentinel","occultist","apostate","alchemist"
									,"dualb","dualc","blademaster","dragon","depthswalker","earth","air","water","fire"}) 
				do
					if t.class[v].enabled then
						TReX.class[v](aff) 
					end
				end
			
						
					raiseEvent("TReX gained aff", aff)

		--[[for debbuging purposes]]
		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( t.serverside.gmcpAffAdded ) ") end

	end			
					
end -- func

TReX.serverside.affremove=function(aff)

	if t.serverside["settings"].installed then

		
		local affInfo = t.serverside.afflictions[aff]
		local stacks = t.stacks
		local x = -1
	
	 --[[manual table variable instatiation]]
	if (table.contains({t.serverside.gmcp_aff_table},aff)) then
		for k, v in pairs(t.serverside.gmcp_aff_table) do
			if aff == v then x = k end
		end -- if
	else	-- count and echo unknowns on ghost cures
	
			--failsafe
			if not t.affs.unknownany then
				t.affs.unknownany = 0
			end
	
				if aff=="pressure" then
					t.affs.press = 0
				end
	
 				if aff=="burning" then
					t.affs.burn = 0
				end
	
			--t.serverside.red_echo("Unknown Affliction Cured <white>[<LawnGreen>"..aff.."<white>]")
			
			t.affs.unknownany = t.affs.unknownany - 1
				if t.affs.unknownany < 1 then
					TReX.serverside.unknown_count_reset()
				end
				
			
			if table.index_of({"deafness","blindness"}, aff) then	
				if table.contains({t.defs}, aff) then
					table.remove(t.defs, table.index_of(t.defs, aff))
				end
			end
					
					
	end		
					
	--gmcpaff show goes here its final removal
	--if x > -1 then table.remove(t.serverside.gmcpAff,x) t.serverside.gmcpAffShow() end
	if x > -1 then 
		table.remove(t.serverside.gmcp_aff_table, table.index_of(t.serverside.gmcp_aff_table, aff)) 

			if not (table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, aff)) then
				t.affs[aff] = false
			else
				t.affs[aff] = 0
			end
			
				TReX.prios.affPrioRestore(aff)

	
	end
			--reset unknowns on ghost cures -- failsafe		
		if #t.serverside.gmcp_aff_table < 2 and table.contains({t.serverside.gmcp_aff_table}, "unknownany") then
			TReX.serverside.unknown_count_reset()
		end
					
	-- [[this i put in, because I dont have all the afflictions yet]]
	-- [[and it will throw an echo if t.serverside.afflictions needs updated.]]
	if (affInfo) and not table.contains({t.serverside.exclude}, aff) then
		--[[dont move this]]
		--[[iterates through the affliction by type table]]
		for _, cure in ipairs(affInfo) do
		
		--[[dont move this]]
		--[[subtracts the affliction by type]]
			if stacks[cure] and stacks[cure] > 0 then
				stacks[cure] = stacks[cure] - 1
				--[[dont move this]]
				--[[affliction by type counter]]
				TReX.serverside.affStacks()
				
			end -- if
		end -- for
	else
		if not (table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, aff)) and not table.contains({t.serverside.exclude}, aff) then
			if t.serverside["settings"].echos then t.serverside.red_echo(" Cured Unknown Affliction '" .. aff .. "'.") end
		end
	end -- if

	
		raiseEvent("TReX lost aff", aff)
	

	--[[if gmcp table is empty then hard reset tables for good measure]]
	if table.is_empty(t.serverside.gmcp_aff_table) then
		if prioResetTimer then killTimer(tostring(prioResetTimer)) prioResetTimer=nil end
		prioResetTimer = tempTimer(15, [[ TReX.class.reset() TReX.prios.reset() ]])
	end
		
		--[[tell the system they can echo afflictions to the prompt]]

		--[[for debbuging purposes]]
		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.affremove ) ") end	

	end					
					
end

--removes from gmcp affliction table via gmcp
t.serverside.gmcpAffRemoved=function(aff) -- motherboard gmcpaff remove
		
	if t.serverside["settings"].installed then
	  
		local aff = gmcp.Char.Afflictions.Remove[1] -- testing
		local affInfo = t.serverside.afflictions[aff]
		local stacks = t.stacks
		local x = -1
 
 				if aff=="burning" then
					t.affs.burn = 0
				end
				
				if aff=="pressure" then
					t.affs.pres = 0
				end
 
			 --[[manual table variable instatiation]]
		if (table.contains({t.serverside.gmcp_aff_table},aff)) then
			for k, v in pairs(t.serverside.gmcp_aff_table) do
				if aff == v then x = k end
			end -- if
		else	-- count and echo unknowns on ghost cures
			
			--failsafe
			if not t.affs.unknownany then
				t.affs.unknownany = 0
			end
			
			--t.serverside.red_echo("Unknown Affliction Cured <white>[<LawnGreen>"..aff.."<white>]")
			
				t.affs.unknownany = t.affs.unknownany - 1
					if t.affs.unknownany < 1 then
						TReX.serverside.unknown_count_reset()
					end
				
					if table.index_of({"deafness","blindness"}, aff) then	
						if table.contains({t.defs}, aff) then
							table.remove(t.defs, table.index_of(t.defs, aff))
						end
					end
				
		end	
					
		--gmcpaff show goes here its final removal
		--if x > -1 then table.remove(t.serverside.gmcp_aff_table,x) t.serverside.gmcpAffShow() end
		if x > -1 then 
			table.remove(t.serverside.gmcp_aff_table, table.index_of(t.serverside.gmcp_aff_table, aff)) 
			
				if not table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, aff) then
					t.affs[aff] = false
				else
					t.affs[aff] = 0
				end
		
				TReX.prios.affPrioRestore(aff)
				
		end
		
		--reset unknowns on ghost cures -- failsafe
		if #t.serverside.gmcp_aff_table < 2 and table.contains({t.serverside.gmcp_aff_table}, "unknownany") then
			TReX.serverside.unknown_count_reset()
		end

		
	-- [[this i put in, because I dont have all the afflictions yet]]
	-- [[and it will throw an echo if t.serverside.afflictions needs updated.]]
	if (affInfo) and not table.contains({t.serverside.exclude}, aff) then
		--[[dont move this]]
		--[[iterates through the affliction by type table]]
		for _, cure in ipairs(affInfo) do
		
		--[[dont move this]]
		--[[subtracts the affliction by type]]
			if stacks[cure] and stacks[cure] > 0 then
				stacks[cure] = stacks[cure] - 1
				--[[dont move this]]
				--[[affliction by type counter]]
				TReX.serverside.affStacks()
				
			end -- if
		end -- for
	else
		if not (table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, aff)) and not table.contains({t.serverside.exclude}, aff) then
			if t.serverside["settings"].echos then t.serverside.red_echo(" Cured Unknown Affliction '" .. aff .. "'.") end
		end
	end -- if
	
			raiseEvent("TReX lost aff", aff)
	
	
	--[[if gmcp table is empty then hard reset tables for good measure]]
	if table.is_empty(t.serverside.gmcp_aff_table) then
		if prioResetTimer then killTimer(tostring(prioResetTimer)) prioResetTimer=nil end
		prioResetTimer = tempTimer(9.5, [[ TReX.class.reset() TReX.prios.reset() ]]) 
	end
		--[[for debbuging purposes]]
		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( t.serverside.gmcpAffRemoved ) ") end	
	end -- for
		
end -- func

t.serverside.gmcpAffParse=function()
	
	if t.serverside["settings"].installed then

		for k, v in pairs(gmcp.Char.Afflictions.List) do
			if table.contains({t.serverside.exclude}, v["name"]) then
				return
			else
				if not table.contains({t.serverside.gmcp_aff_table}, v["name"]) then                   -- does not add exclude items to gmcpAff table for visual and other purposes.
					table.insert(t.serverside.gmcp_aff_table,#t.serverside.gmcp_aff_table+1,v["name"])

						for _,v in pairs({"snb","bard","magi","monk","shikudo","druid","jester","priest","sylvan"
											,"serpent","shaman","sentinel","occultist","apostate","alchemist"
											,"dualb","dualc","blademaster","dragon","depthswalker",}) 
						do
							if t.class[v].enabled then
								TReX.class[v](aff) 
							end
						end

					raiseEvent("TReX gained aff", aff)
					
				end
	   
			end -- if 
			
		end -- for
			-- debugging echos.
			if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( t.serverside.gmcpAffParse ) ") end
	end
end -- func

--[[ OK DO NOT MAKE EDITS ABOVE THIS LINE UNLESS YOUR 100% your sure 
	DO NOT EDIT OR TOUCH WITHOUT SPEAKING TO ME FIRST. THIS SECTION IS VERY VERY FINICKY.
	IF THIS SECTION BREAKS EVERYTHING BREAKS]]
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- this function is an alert in game and also a variable set, it allows me to have less spam when in the heat
-- of combat on my screen, only sending other functions when instunned, and the variable is set to false.
TReX.serverside.stun = function()

	if not (t.affs.stun) then
		TReX.serverside.affadd("stun")
	else
		TReX.serverside.affremove("stun")
	end -- if

	-- debugging echos.
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.stun ) ") end
	
end -- func

-----------------------------
---------SERVERSIDE----------
-----------CURING------------
-----------------------------

TReX.serverside.not_slowed=function()
 if t.affs.aeon then
  return false
 else
  return true
 end
end

TReX.serverside.arm_check=function()

local leftarm = {"brokenleftarm" , "damagedleftarm", "mangledleftarm"}
local rightarm = {"brokenrightarm", "damagedrightarm", "mangledrightarm"}
local armcheck = 0

    for k,v in pairs(leftarm) do
		if t.affs[v] then
			armcheck = armcheck + 1 break
		end
    end
	
	for k,v in pairs(rightarm) do
        if t.affs[v] then
            armcheck = armcheck + 1 break
		end
    end

if armcheck > 1 then
    return true
else
	return false
end

        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.arm_check ) ") end


end



TReX.serverside.settings=function()


t.serverside.settings = {

    --parry = false,
	paused = false,
    reporting = false,
    transmutation = false,
    vault = false, 
    clot = false,
    focus = false,
    afflictions = false,
    sipping = false,
    tree = false,
    Prompt = false,
    restore = false,
    debugEnabled = false,
    override = false,
    timestamp = false,   
    echos = false,
    moss = false,
    sipRingMana = false,
    sipRingHealth = false,
    --meditate = false,
    installed = false,
	sys_loaded = false,
    insomnia = false,
	deathsight = false,
	gag_pipes = "off",
	affbar = false,
	tells = "off",
	roar = "off",
	asbb=27,
	sbb=0,
	sbt=0,
	sbl=0,
	sbr=0,
    
}

t.serverside.settings_default = {
        -- serverside settings
		enabled = "Yes",
        reporting = "No",
        afflictions = "No",
        defences = "No",
        sipping = "No",
        transmutation = "No",
        sip = "Health",
        sip_health_at = 93,--math.ceil(TReX.v.sipHealth),
        sip_mana_at = 83,--math.ceil(TReX.v.sipMana),
        moss_health_at = 73,--math.ceil(TReX.v.mossHealth),
        moss_mana_at = 63,--math.ceil(TReX.v.mossMana),
        focus = "No",
        focus_over_herbs = "Yes", -- make an settings option later <<<<<<
        tree = "No",
        clot = "No",
        clot_at = 70,--math.ceil(TReX.stats.h * .0010),
        vault = "No",
        mount = "No", 
        insomnia = "No",
        fractures = 66 ,  -- setting it low, with less fractures, the system will actually raise this internally, and lower it with more fracs; on a scale.
		mana_threshold = t.serverside["settings_default"].sip_mana_at or 60,  -- setting the mana_threshold to the lowest cure point.
        batch = "Yes", -- make an settings option later <<<<<<
		cmd  = "cmdsep",

}
    
t.serverside.settings_dict = {

    Yes = "on",
    No = "off",
	cmdsep  = "##",
    enabled = "on",
    sip = "priority",
    clot = "useclot",
    vault = "usevault",
    clot_at = "clotat",
    sip_mana_at = "sipmana",
    moss_mana_at = "mossmana",
    focus_over_herbs = "focus",
    sip_health_at = "siphealth",
    moss_health_at = "mosshealth",
    fractures = "healthaffsabove",
    mana_threshold = "manathreshold",
	command_separator = "commandseparator",
    mount = "mount",
	
    
}

    for k,v in pairs(t.serverside.settings_default) do
        if k == "focus_over_herbs" then
            if v == "Yes" then
                v = "first"
            else
                v = "second"
            end
        end
			if not t.serverside.settings_dict[k] == "on" or not t.serverside.settings_dict[k] == "cmd" then
				t.send("curing " ..(t.serverside.settings_dict[k] or k).. " " ..(t.serverside.settings_dict[v] or v))
			end
    end

	    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.settings ) ") end

		
	t.config.settings_system = { 
		pipes_refill = 3,
		diag_at = 1, 
	}
		
		
	
 
end

TReX.reset_taffs=function()
t.affs.stun = false
t.affs.addiction = false
t.affs.aeon = false
t.affs.agoraphobia = false
t.affs.airdisrupt = false
t.affs.airfisted = false
t.affs.amnesia = false
t.affs.anorexia = false
t.affs.asphyxiating = false
t.affs.asthma = false
t.affs.blackout = false
t.affs.blindness = false
t.affs.bound = false
t.affs.brokenleftarm = false
t.affs.brokenleftleg = false
t.affs.brokenrightarm = false
t.affs.brokenrightleg = false
t.affs.bruisedribs = false
t.affs.burning = false
t.affs.burn=0
t.affs.cadmuscurse = false
t.affs.claustrophobia = false
t.affs.clumsiness = false
t.affs.concussion = false
t.affs.conflagration = false
t.affs.confusion = false
t.affs.corruption  = false
t.affs.crackedribs = false
t.affs.crushedthroat = false
t.affs.daeggerimpale = false
t.affs.damagedhead = false
t.affs.damagedleftarm = false
t.affs.damagedleftleg = false
t.affs.damagedrightarm = false
t.affs.damagedrightleg = false
t.affs.darkshade = false
t.affs.dazed = false
t.affs.dazzled = false
t.affs.deadening = false
t.affs.deafness = false
t.affs.deepsleep = false
t.affs.degenerate = false
t.affs.dehydrated = false
t.affs.dementia = false
t.affs.demonstain  = false
t.affs.depression = false
t.affs.deteriorate = false
t.affs.disloyalty = false
t.affs.disrupted = false
t.affs.dissonance = false
t.affs.dizziness = false
t.affs.earthdisrupt = false
t.affs.enlightenment = false
t.affs.enmesh = false
t.affs.entangled = false
t.affs.entropy = false
t.affs.epilepsy = false
t.affs.fear = false
t.affs.firedisrupt = false
t.affs.flamefisted = false
t.affs.frozen = false
t.affs.generosity = false
t.affs.haemophilia = false
t.affs.hallucinations = false
t.affs.hamstrung = false
t.affs.hatred = false
t.affs.healthleech = false
t.affs.heartseed = false
t.affs.hecatecurse = false
t.affs.hellsight = false
t.affs.hindered = false
t.affs.homunculusmercury = false
t.affs.hypersomnia = false
t.affs.hypochondria = false
t.affs.hypothermia = false
t.affs.icefisted = false
t.affs.impaled = false
t.affs.impatience = false
t.affs.indifference = false
t.affs.inquisition = false
t.affs.insomnia = false
t.affs.internalbleeding = false
t.affs.isolation = false
t.affs.itching = false
t.affs.justice = false
t.affs.kaisurge = false
t.affs.laceratedthroat = false
t.affs.lapsingconsciousness = false
t.affs.lethargy = false
t.affs.loneliness = false
t.affs.lovers = false
t.affs.manaleech = false 
t.affs.mangledhead = false
t.affs.mangledleftarm = false
t.affs.mangledleftleg = false
t.affs.mangledrightarm = false
t.affs.mangledrightleg = false
t.affs.masochism = false
t.affs.mildtrauma = false
t.affs.mindclamp = false
t.affs.nausea = false
t.affs.numbedleftarm = false
t.affs.numbedrightarm = false
t.affs.pacified = false
t.affs.palpatarfeed = false
t.affs.paralysis = false
t.affs.paranoia = false
t.affs.parasite = false
t.affs.peace = false
t.affs.penitence = false
t.affs.petrified = false
t.affs.phlogisticated = false
t.affs.pinshot = false
t.affs.prone = false
t.affs.recklessness = false
t.affs.retribution = false
t.affs.revealed = false
t.affs.scalded = false
t.affs.scrambledbrains = false
t.affs.scytherus = false
t.affs.selarnia = false
t.affs.sensitivity = false
t.affs.serioustrauma = false
t.affs.shadowmadness = false
t.affs.shivering = false
t.affs.shyness = false
t.affs.silver = false
t.affs.skullfractures = 0
t.affs.slashedthroat = false
t.affs.sleeping = false
t.affs.slickness = false
t.affs.slimeobscure = false
t.affs.spiritdisrupt = false
t.affs.stupidity = false 
t.affs.stuttering = false
t.affs.temperedcholeric = 0
t.affs.temperedmelancholic = 0
t.affs.temperedphlegmatic = 0
t.affs.temperedsanguine = 0
t.affs.timeflux = false
t.affs.timeloop = false
t.affs.torntendons = 0
t.affs.transfixation = false
t.affs.trueblind = false
t.affs.unconsciousness = false
t.affs.vertigo = false
t.affs.vinewreathed = false
t.affs.vitiated = false
t.affs.vitrified = false
t.affs.voidfisted = false
t.affs.voyria = false
t.affs.waterdisrupt = false
t.affs.weakenedmind = false
t.affs.weariness = false
t.affs.webbed = false
t.affs.whisperingmadness = false
t.affs.wristfractures = 0

t.affs.retardation = false

t.affs.tension = false
t.affs.pres=0
t.affs.pressure = false
t.affs.coldfate = false
t.affs.calcifiedskull = false
t.affs.calcifiedtorso = false
t.affs.latched = false
t.affs.kkractlebrand = false

darkshadecount=0

end

TReX.reset_tbals=function()
t.bals.bal = true
t.bals.eq = true
t.bals.voice = true
t.bals.sip = true
t.bals.immunity = true
t.bals.tree = true
t.bals.focus = true
t.bals.fitness = true
t.bals.bloodboil = true
t.bals.rage = true
t.bals.salve = true
t.bals.herb = true
t.bals.smoke = true
t.bals.alleviate = true
t.bals.accelerate = true
t.bals.purify = true
t.bals.extrusion = true
end

TReX.serverside.login_settings=function()


TReX.reset_tbals()
TReX.reset_taffs()

--check for mount to avoid issues
local default_mount = "No"
if mount_list then
	for k,v in pairs(mount_list) do
		if v.enabled then
			default_mount = mount_list[k].number	
		end
	end
end

	t.affs["bleed"] = 0
	t.affs["burn"] = 0	
	
    t.bals["sip"] = true
    t.bals["herb"] = true
    t.bals["smoke"] = true
    t.bals["salve"] = true
    t.bals["tree"] = true
    t.bals["focus"] = true

	t.serverside.vivimode = t.serverside.vivimode or false
	-- t.serverside.heartseedmode = t.serverside.heartseedmode or false
	-- temporary hard code until I work on a better fix.
    -- t.send("curing priority blindness reset", false)
    -- t.send("curing priority deafness reset", false)

	
--t.class.reset_heals=function()
	local heals = {

	["rage"] = {"Runewarden","Infernal","Paladin"},
	["might"] = {"Sentinel","Druid"},
	["bloodboil"] = {"Magi"},
	["fitness"] = {"Runewarden","Infernal","Paladin","Druid","Blademaster","Monk","Sentinel"},
	["shrugging"] = {"Serpent"},
	["fool"] = {"Occultist","Jester"},
	["dragonheal"] = {"Dragon"},
	["daina"] = {"Shaman"},
	["accelerate"] = {"Depthswalker"},
	["alleviate"] = {"Blademaster"},
	["salt"] = {"Alchemist"},
	["purify"] = {"water Elemental Lord"}, -- 'purify'
	["eruption"] = {"earth Elemental Lord"}, -- 'terran eruption'
	["slough"] = {"fire Elemental Lord"}, -- 'slough impurities'

	}

	for k,v in pairs(heals) do
		if table.contains(v, TReX.s.class) then		
			t.serverside.settings[k] = false
		end
	end
--end	

-- gmcp afflictions to ignore
t.serverside.exclude = {
   
   "insomnia",
   "blindness",
   "deafness",
   "selfishness",
  -- "numbedrightarm",
  -- "numbedleftarm",

   "temperedmelancholic",
   "temperedsanguine",
   "temperedphlegmatic",
   "temperedcholeric",
   
   --"burning (1)",
   --"burning (2)",
   --"burning (3)",
   --"burning (4)",
   --"burning (5)",
   --"burning (6)",
   --"burning (7)",
   
   "crackedribs (1)",
   "crackedribs (2)",
   "crackedribs (3)",
   "crackedribs (4)",
   "crackedribs (5)",
   "crackedribs (6)",
   "crackedribs (7)",
   
   "torntendons (1)",
   "torntendons (2)",
   "torntendons (3)",
   "torntendons (4)",
   "torntendons (5)",
   "torntendons (6)",
   "torntendons (7)",
   
   "skullfractures (1)",
   "skullfractures (2)",
   "skullfractures (3)",
   "skullfractures (4)",
   "skullfractures (5)",
   "skullfractures (6)",
   "skullfractures (7)",
      
   "wristfractures (1)",
   "wristfractures (2)",
   "wristfractures (3)",
   "wristfractures (4)",
   "wristfractures (5)",
   "wristfractures (6)",
   "wristfractures (7)",
   
   --"%a+ %((%d+)%)",
   
   --"crackedribs %((%d+)%)",
   --"skullfractures %((%d+)%)",
   --"torntendons %((%d+)%)",
   --"wristfractures %((%d+)%)", 
   
   "bleeding",  -- your next on the list next.
   
   }



t.serverside.afflictions = {
 
  homunculusmercury = {"time","ginger"}, -- techinally herb eat will remove it, but slows herb balance
  isolation = {"instant"},
  cadmuscurse = {"misc"},
  hypersomnia = {"daina", "ash", "dheal",  "might", "slough", "purify", "eruption", "salt",  "bloodboil", "shrugging", "accelerate", "tree", "fool"},
  airdisrupt = {"focus", "mental"},
  airfisted = {"time"},
  enmesh = {"time"},
  conflagration = {"misc"},
  generosity = {"daina", "rage", "bellwort", "dheal", "salt", "slough", "purify", "eruption", "accelerate", "might",  "bloodboil",  "shrugging", "tree", "fool"},
  mangledhead = {"mendinghead","restorationhead"},
  transfixation = {"writhe"},
  whisperingmadness = {"daina", "dheal", "accelerate", "salt", "slough", "purify", "eruption", "might",  "bloodboil", "shrugging", "tree", "elm", "fool"},
  pinshot = {"time"},
  hecatecurse = {"time"},
  kkractlebrand = {"time"},
  blistered = {"time"},
  asphyxiating = {"time"},
  epilepsy = {"goldenseal", "daina","dheal", "focus",  "salt", "slough", "purify", "eruption", "accelerate",  "might",  "bloodboil", "shrugging", "tree", "fool", "mental"},
  damagedleftarm = {"restorationarms", "physical"},
  amnesia = {"time", --[["mental"]]},
  slickness = {"bloodroot", "daina","dheal",  "might",  "salt",  "slough", "purify", "eruption", "bloodboil",  "accelerate", "shrugging", "tree", "valerian", "fool", "physical"},
  vertigo = {"dheal", "daina", "lobelia", "focus",  "might",  "salt", "slough", "purify", "eruption", "bloodboil",  "shrugging", "tree", "fool", "mental"},
  inquisition = {"time"},
  icefisted = {"time"}, -- 15secs
  temperedmelancholic = {"ginger"},  --  melancholic does mana damage
  recklessness = {"dheal", "daina","lobelia", "focus",  "might",  "salt", "slough", "purify", "eruption", "bloodboil", "shrugging", "tree", "fool", "mental"},
  weariness = {"dheal", --[["focus",]] "kelp", "daina", "accelerate", "slough", "purify", "eruption",  "salt", "might", "bloodboil",  "shrugging", "tree", "fool", "mental"}, -- does bloodboil cure weariness?
  loneliness = {"dheal", "lobelia", "focus", "daina",  "salt", "accelerate", "slough", "purify", "eruption", "might", "bloodboil",  "shrugging", "tree", "fool", "mental"},
  --brokenarm = {"mendingskin", "physical"},
  impatience = {"goldenseal", "dheal",  "daina", "might",  "salt",  "bloodboil", "slough", "purify", "eruption", "accelerate", "shrugging", "tree", "fool", "mental"},
  paralysis = {"bloodroot", "dheal",  "daina", "might", "salt",  "bloodboil", "slough", "purify", "eruption",  "accelerate", "shrugging", "fool", "physical"},
  dizziness = {"goldenseal", "dheal", "daina", "focus", "salt",   "accelerate", "slough", "purify", "eruption", "might",  "bloodboil", "shrugging", "tree", "fool", "mental"},
  serioustrauma = {"restorationtorso","physical"},
  speared = {"writhe"},
  brokenrightleg = {"restore", "dheal", "accelerate",  "salt", "daina", "might", "slough", "purify", "eruption", "bloodboil", "shrugging", "fool", "tree", "mendinglegs", "mendingskin","physical"},
  webbed = {"flex", "writhe"},
  mangledrightarm = { "restorationarms","physical"},
  stuttering = {"dheal", "might",  "bloodboil",  "salt", "daina", "shrugging", "slough", "purify", "eruption", "accelerate", "tree", "epidermalhead", "fool", "physical"},
  crackedribs = {"healthtorso"},
  damagedrightleg = {"restorationlegs","physical"},
  damagedhead = {"restorationhead","physical"},
  haemophilia = {"dheal", "ginseng",  "might", "salt",  "daina", "accelerate", "slough", "purify", "eruption","shrugging", "tree", "fool", "physical"},
  shivering = {"caloric", "physical"},
  sensitivity = {"dheal", "kelp",  "might",  "salt",  "bloodboil", "daina", "slough", "purify", "eruption","accelerate", "shrugging", "tree", "fool", "physical"},
  entangled = {"flex", "writhe"},
  earthdisrupt = {"focus", "mental"},
  dissonance = {"goldenseal", "dheal", "daina", "salt",  "might",  "bloodboil", "slough", "purify", "eruption","daina", "accelerate", "shrugging", "tree", "fool"},
  dehydrated = {"time"},
  demonstain = {"time"},
  deepsleep = {"wake"},
  indifference = {"bellwort"},
  corruption = {"time"},
  laceratedthroat = {"restorationhead"},
  firedisrupt = {"lobelia", "mental"},
  flamefisted = {"time"},
  skullfractures = {"healthhead","physical"},
  addiction = {"dheal", "ginseng",  "might",  "salt", "bloodboil",  "daina", "slough", "purify", "eruption","accelerate", "shrugging", "tree", "fool", "physical"},
  frozen = {"caloric", "physical"},
  kaisurge = {"time"},
  selarnia = {"mendingtorso", "mendingbody"},
 -- climb = {"mendingskin"},
  slashedthroat = {"epidermalhead"},
  selfishness = {"generosity"},
  hellsight = {"dheal",  "might",  "salt", "bloodboil", "shrugging", "daina", "slough", "purify", "eruption","accelerate", "tree", "valerian", "fool", "mental"},
  --cleg = {"restore", "dheal",  "might", "shrugging", "tree", "mendinglegs", "mendingskin", "fool"},
  brokenrightarm = {"restore", "mendingarms", "dheal", "accelerate", "daina","slough", "purify", "eruption", "might",  "salt",  "shrugging", "fool", "tree", "mendingskin","physical"},
  disloyalty = {"dheal",  "might", "bloodboil",  "salt",  "shrugging",  "slough", "purify", "eruption","accelerate",  "tree", "valerian", "fool"},
  manaleech = {"valerian"},
  unconciousness = {"time"},
  confusion = {"ash", "dheal", "focus",  "might", "daina",  "salt",  "bloodboil","slough", "purify", "eruption", "accelerate", "shrugging", "tree", "fool", "mental"},
  damagedleftleg = {"restorationlegs","physical"},
  clumsiness = {"dheal", "kelp",  "might", "shrugging", "salt",  "daina", "bloodboil", "slough", "purify", "eruption", "accelerate", "tree", "fool", "physical"},
  darkshade = {"dheal", "ginseng",  "might", "shrugging", "salt",  "daina",  "bloodboil","slough", "purify", "eruption", "accelerate", "tree", "fool", "physical"},
  pacified = {"rage", "bellwort", "dheal", "focus",   "salt", "might", "bloodboil",  "daina", "slough", "purify", "eruption","accelerate", "shrugging", "tree", "fool", "mental"},
  impaled = {"writhe"},
  daeggerimpale = {"writhe"},
  disrupted = {"concentrate", "mental"},
  lapsingconsciousness = {"time"},
  lovers = {"rage", "bellwort", "dheal", "focus",  "salt", "daina", "might",  "bloodboil", "slough", "purify", "eruption", "accelerate",  "shrugging", "tree", "fool", "mental"},
  bound = {"writhe"},
  voidfisted = {"time"},
  numbedleftarm = {"time"},
  numbedrightarm  = {"time"},
  slimeobscure = {"time"},
  damagedrightarm = {"restorationarms","physical"},
  peace = {"rage", "bellwort", "dheal",  "might",  "salt", "bloodboil", "shrugging","slough", "purify", "eruption", "daina", "accelerate", "tree", "fool", "mental"},
  stupidity = {"goldenseal", "dheal", "focus", "might", "accelerate", "slough", "purify", "eruption","shrugging", "tree", "fool", "mental"},
  mangledleftarm = {"restorationarms","physical"},
  hamstrung = {"time"},
  healthleech = {"dheal", "kelp",  "salt",  "might", "bloodboil",  "slough", "purify", "eruption", "daina", "accelerate", "shrugging", "tree", "fool", "physical"},
  fear = {"compose"},
  entropy = {"time"},
  hindered = {"time"},
  --carm = {"restore", "dheal", "mendingarms", "shrugging", "tree", "fool"},
  waterdisrupt = {"focus"},
  weakenedmind = {"focus", "mental"},
  hypothermia = {"restorationbody", "physical"},
  spiritdisrupt = {"lobelia"},
  dementia = {"focus", "ash", "dheal",  "might",  "salt",  "bloodboil", "daina","slough", "purify", "eruption", "accelerate", "shrugging", "tree", "fool", "mental"},
  paranoia = {"focus", "ash", "dheal",  "might", "salt",   "bloodboil", "slough", "purify", "eruption","accelerate", "daina", "shrugging", "tree", "fool", "mental"},
 -- bleg = {"restorationarms", "restorationlegs"},
  scytherus = {"dheal", "ginseng",  "might",  "salt",  "bloodboil", "daina","slough", "purify", "eruption", "accelerate", "shrugging", "tree", "fool", "physical"},
  mangledleftleg = {"restorationlegs","physical"},
  lethargy = {"dheal", "ginseng",  "might",  "salt",  "bloodboil", "daina", "slough", "purify", "eruption","accelerate", "shrugging", "tree", "fool", "physical"},
  bleeding = {"clot"},
  bruisedribs = {"time"},
  internalbleeding = {"clot"},
  wristfractures = {"healtharms","physical"},
  spritidisrupt = {"lobelia"},
  vitiated = {"time"},
  brokenleftarm = {"restore",  "mendingarms",  "salt",  "dheal", "accelerate", "slough", "purify", "eruption","daina", "might", "shrugging", "fool", "tree", "mendingskin", "fool","physical"},
  torntendons = {"healthlegs","physical"},
  voyria = {"dheal", "immunity",  "might",  "salt",  "bloodboil", "daina", "slough", "purify", "eruption","accelerate", "shrugging", "tree", "fool", "physical"},
  burning = {"dheal",  "might", "bloodboil",  "salt",  "shrugging", "slough", "purify", "eruption","accelerate", "daina", "tree", "fool", "mendingbody", "physical"},
  crushedthroat = {"mendinghead"},
  deadening = {"dheal",  "might", "bloodboil",   "salt", "shrugging","slough", "purify", "eruption", "daina", "accelerate", "tree", "elm", "fool", "physical"},
  dazed = {"elm"},
  dazzled = {"mendinghead"},
  tension = {"dheal",  "might",  "bloodboil", "shrugging", "salt", "slough", "purify", "eruption", "accelerate", "daina", "tree", "elm", "fool"},
  pressure = {"pear"},
  aeon = {"dheal",  "might",  "bloodboil", "shrugging", "salt", "slough", "purify", "eruption", "accelerate", "daina", "tree", "elm", "fool"},
  agoraphobia = {"dheal", "lobelia", "focus",  "might",  "salt", "slough", "purify", "eruption","bloodboil",  "daina", "accelerate", "shrugging", "tree", "fool", "mental"},
  mangledrightleg = {"restorationlegs","physical"},
  anorexia = {"epidermalbody", "dheal", "focus",  "might",  "salt", "slough", "purify", "eruption","bloodboil",  "daina", "accelerate", "shrugging", "tree", "fool", "mental"},
  temperedphlegmatic = {"ginger"},
  masochism = {"dheal", "lobelia", "focus",  "might",  "salt", "slough", "purify", "eruption", "bloodboil", "daina", "accelerate", "shrugging", "tree", "fool", "mental"},
  claustrophobia = {"dheal", "lobelia", "focus",  "salt",  "might", "slough", "purify", "eruption","bloodboil",  "daina", "accelerate", "shrugging", "tree", "fool", "mental"},
  itching = {"epidermalbody", "physical"},
  daeggerimpale = {"writhe"},
  scalded = {"epidermalbody", "physical"},
  mildtrauma = {"restorationtorso","physical"},
  webbed = {"writhe"},
  hypochondria = {"dheal", "kelp",  "might", "daina",  "salt", "slough", "purify", "eruption", "accelerate", "shrugging", "bloodboil",  "tree", "fool", "physical"},
  nausea = {"dheal", "ginseng",  "might",  "accelerate",  "salt", "slough", "purify", "eruption", "shrugging", "tree",  "bloodboil", "fool", "physical"},
  hallucinations = {"focus", "ash", "dheal", "daina",  "salt", "slough", "purify", "eruption", "accelerate",  "might", "bloodboil",  "shrugging", "tree", "fool", "mental"},
  shyness = {"goldenseal", "dheal", "focus", "daina",  "salt", "slough", "purify", "eruption", "accelerate",  "might", "bloodboil",  "shrugging", "tree", "fool", "mental"}, --DW UPDATE
  shadowmadness = {"goldenseal", "dheal", "daina", "salt",  "accelerate","slough", "purify", "eruption",  "might",  "bloodboil", "shrugging", "fool"}, --DW UPDATE
  depression = {"goldenseal", "dheal",  "daina", "salt",  "accelerate", "slough", "purify", "eruption","might", "bloodboil",  "shrugging", "tree", "fool"}, --DW UPDATE
  heartseed = {"restorationtorso", "physical"},
  temperedcholeric = {"ginger", }, -- choleric is health damage
  temperedsanguine = {"ginger", },  -- bleeding
  asthma = {"fitness", "dheal", "kelp", "accelerate", "salt", "slough", "purify", "eruption", "daina", "might", "bloodboil",  "shrugging", "tree", "fool", "physical"},
  parasite = {"fitness", "dheal", "kelp","accelerate", "salt", "slough", "purify", "eruption", "daina", "might", "bloodboil",  "shrugging", "tree", "fool", "physical"}, --DW UPDATE
  justice = {"bellwort", "dheal", "rage","accelerate", "salt", "slough", "purify", "eruption","daina", "might", "bloodboil",  "shrugging", "tree", "fool", "physical"},
  retribution = {"bellwort", "dheal", "rage", "accelerate", "salt", "slough", "purify", "eruption", "daina", "might", "bloodboil",  "shrugging", "tree", "fool", "physical"}, --DW UPDATE
  timeloop = {"bellwort", "rage", "dheal", "accelerate", "salt", "slough", "purify", "eruption","daina", "might", "bloodboil", "shrugging", "fool", "tree",  "physical"}, --DW UPDATE
  brokenleftleg = {"restore", "dheal", "accelerate", "salt", "daina","slough", "purify", "eruption", "might", "bloodboil", "shrugging", "fool", "tree", "mendinglegs", "mendingskin","physical"},
  stun = {"time"},
  prone = {"stand"},
  blindness = {"epidermalbody"},
  deafness = {"epidermalbody"},
  blackout = {"tree", "time"},
  heldualbreath = {"toggle"},
  insomnia = { --[["goldenseal"]]},
  tzantza = {"mental"},
  accentato = {"mental"},
  enlightenment = {"misc"},
  vinewreathed = {"time"},
  degenerate = {"time"}, --DW UPDATE
  deteriorate = {"time"}, --DW UPDATE
  hatred = {"time"}, --DW UPDATE
  mindclamp = {"misc"},
  --unnameable = {"diagnose"},
  sleeping = {"wake"},
  timeflux = {"time"},
  lullaby = {"wake"},
  unknownany = {"diagnose"},
}
-- configures cure types by action.
t.serverside.cures = {
bloodroot = {type = "herb", alternatives = {concoctions = "bloodroot", alchemy = "magnesium"}},
lobelia = {type = "herb", alternatives = {concoctions = "lobelia", alchemy = "argentum"}},
kelp = {type = "herb", alternatives = {concoctions = "kelp", alchemy = "aurum"}},
ginseng = {type = "herb", alternatives = {concoctions = "ginseng", alchemy = "ferrum"}},
bellwort = {type = "herb", alternatives = {concoctions = "bellwort", alchemy = "cuprum"}},
ash = {type = "herb", alternatives = {concoctions = "ash", alchemy = "stannum"}},
goldenseal = {type = "herb", alternatives = {concoctions = "goldenseal", alchemy = "plumbum",}},
elm = {type = "smoke", alternatives = {concoctions = "elm", alchemy = "cinnabar"}},
valerian = {type = "smoke", alternatives = {concoctions = "valerian", alchemy = "realgar"}},
ginger = {type = "herb", alternatives = {concoctions = "ginger", alchemy = "antimony"}},
focus = {type = "focus"},
mendinglegs = { type = "salve" },
mendingarms = { type = "salve" },
mendingskin = { type = "salve" },
epidermalbody = { type = "salve" },
epidermalhead = { type = "salve"},
mendinghead = { type = "salve" },
mendingbody = { type = "salve" },
mendingtorso = { type = "salve" },
epidermalhead = { type = "salve" },
caloric = { type = "salve" },
restorationarms = { type = "salve" },
restorationlegs = { type = "salve" },
restorationhead = { type = "salve" },
restorationtorso = { type = "salve" },
restorationbody = { type = "salve" },
generosity = { type = "generosity" },
tree = { type = "tree" },
accelerate = { type = "balance" },
slough = { type = "balance" },
purify = { type = "balance" },
eruption = { type = "balance" },
alleviate = { type = "balance" },
salt = { type = "balance" },
bloodboil = { type = "balance" },
daina = { type = "balance" },
shrugging = { type = "balance" },
might = { type = "balance" },
restore = { type = "balance" },
dheal = { type = "balance"}, -- TODO
flex = { type = "balance" }, -- TODO
writhe = { type = "balance" }, -- TODO
fool = { type = "balance" }, -- TODO
concentrate = { type = "concentrate" },
compose = { type = "compose" },
clot = { type = "clot" },
immunity = { type = "immunity" },
fitness = { type = "balance" },
rage = { type = "rage" },
healthhead = { type = "elixir" },
healthtorso = { type = "elixir" },
healtharms = { type = "elixir" },
healthlegs = { type = "elixir" },
stand = { type = "stand" },
stun = { type = "time" },
time = { type = "time" },
mental = { type = "type" },
physical = { type = "type" },
diagnose = { type = "type" },
instant = { type = "type" },
wake = { type = "wake" },
toggle = { type = "toggle" },
herb = { type = "herb" },
misc = { type = "misc" },
rage = { type = "balance" }
}

            for k, v in pairs(t.serverside.cures) do -- this sets aff count by cure type to 0.
            --for var {, var} in t.serverside.cures do  
                t.stacks[k] = 0
            end

	

t.serverside.login_settings = {
        -- serverside settings
		enabled = t.serverside["settings_default"].enabled or "Yes",
        reporting = t.serverside["settings_default"].reporting or "Yes",
        afflictions = t.serverside["settings_default"].afflictions or "No",
        defences = "Yes",
        sipping = t.serverside["settings_default"].sipping or "No",
        transmutation = t.serverside["settings_default"].transmutation or "No",
        sip = t.serverside["settings_default"].sip or "Health",
        sip_health_at = t.serverside["settings_default"].sip_health_at or 85,--math.ceil(TReX.v.sipHealth),
        sip_mana_at = t.serverside["settings_default"].sip_mana_at or 80,--math.ceil(TReX.v.sipMana),
        moss_health_at = t.serverside["settings_default"].moss_health_at or 80,--math.ceil(TReX.v.mossHealth),
        moss_mana_at = t.serverside["settings_default"].moss_mana_at or 75,--math.ceil(TReX.v.mossMana),
        focus = t.serverside["settings_default"].focus or "No",
        focus_over_herbs = t.serverside["settings_default"].focus_over_herbs or "Yes",
        tree = t.serverside["settings_default"].tree or "No",
        clot = "No",
        clot_at = t.serverside["settings_default"].clot_at or 70,--math.ceil(TReX.stats.h * .0010),
        vault = t.serverside["settings_default"].vault or "No",--t.serverside["settings"].vault,
        --mount = default_mount, -- make a select from menu for mounts.
        insomnia = t.serverside["settings_default"].insomnia or "No",
        fractures = t.serverside["settings_default"].fractures or 65 ,
        mana_threshold = t.serverside["settings_default"].moss_mana_at or 60, 
		commandseparator  = "cmdsep",

}
    
t.serverside.login_dict = {

    Yes = "on",
    No = "off",
	cmdsep  = t.serverside.settings_dict.cmdsep or "##",
    enabled = "on",
    sip = "priority",
    clot = "useclot",
    vault = "usevault",
    clot_at = "clotat",
    sip_mana_at = "sipmana",
    moss_mana_at = "mossmana",
    focus_over_herbs = "focus",
    sip_health_at = "siphealth",
    moss_health_at = "mosshealth",
    fractures = "healthaffsabove",
    mana_threshold = "manathreshold",
	--command_separator = "commandseparator",
    --mount = "mount",
	
    
}

    for k,v in pairs(t.serverside.login_settings) do
        if k == "focus_over_herbs" then
            if v == "Yes" then
                v = "first"
            else
                v = "second"
            end
        end
			--print(t.serverside.settings_dict[k] or v)
			--print(t.serverside.settings_dict[v] or v)
		if k == "commandseparator" then
			t.send("config " ..(t.serverside.login_dict[k] or k).. " " ..(t.serverside.login_dict[v] or v))
		else
	        t.send("curing " ..(t.serverside.login_dict[k] or k).. " " ..(t.serverside.login_dict[v] or v))
		end
    end
  

  
	 t.config.settings_system = { 
		-- pipes_refill = t.config["settings_system"].pipes_refill or 3,
		 diag_at = t.config["settings_system"].diag_at or 3, 
	 }

        for k, v in pairs(t.serverside.gmcp_aff_table) do -- this needs a list I think.
            if table.index_of({"skullfractures","crackedribs","torntendons","wristfractures","temperedphlegmatic","temperedsanguine","temperedcholeric","temperedmelancholic", "unknownany"}, k) then
                t.affs[k] = 0
            else
                t.affs[k] = false
            end
        end
  
		--checks things like fitness, might, shrugging..
			TReX.class.skill_check()

            if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.login_settings ) ") end
				
end	
    	
TReX.serverside.numberOfLockAffs=function()
    local i = 0
    for k,v in pairs(t.serverside.affs2tree4) do
        --if v == "blackout" then break end
        if t.affs[v] then i = i + 1 end
    end
    return i
end

TReX.serverside.treeblockcheck=function()

	for k,v in pairs({"paralysis"}) do
		if table.contains({t.serverside.gmcp_aff_table}, v) then
			return true
		else
			return false
		end
	end
	--for _,i in pairs(misc_cure_table["tree"].blocks) do   -- check affliction blocks before using.
	--	if t.affs[i] then t.serverside.echo_red("tree blocked by " ..i,false) return true end
	--		return false
	--end
end

TReX.serverside.treeAffGained=function()
	for k,v in pairs(t.class) do 
		if (v.enabled) then
			if (t.serverside["settings"].tree) then -- if enabled via menu 
				if (TReX.serverside.numberOfLockAffs() >= TReX.affs2tree["_by_class"][k]) then
					if not TReX.serverside.treeblockcheck() and not TReX.serverside.arm_check() then -- check tree blocks
						if t.bals["tree"] and t.serverside["settings_default"].tree ~= "Yes" then
							t.serverside["settings_default"].tree = "Yes"
							t.send("curing tree on", false) 
						end
					end
				else
					if t.bals["tree"] and t.serverside["settings_default"].tree ~= "No" then
						t.serverside["settings_default"].tree = "No"
						t.send("curing tree off", false) 
					end
				end
			end
		end
	end
end --func

TReX.serverside.treeAffLost=function(event, affliction)
	if t.serverside["settings"].installed then  
		if (event == "tree_event lost") then
			for k,v in pairs(t.class) do
				if (v.enabled) then
					if (t.serverside["settings"].tree) then -- if enabled via menu
						if (TReX.serverside.numberOfLockAffs() <= TReX.affs2tree["_by_class"][k]) and t.serverside["settings_default"].tree ~= "No" then
							t.serverside["settings_default"].tree = "No"
							t.send("curing tree off", false)
						end
					end
				end
			end
		end
	end-- if installed	
end --func

-- TReX.serverside.toggleAutoTree=function()
  -- if t.serverside["settings_default"].tree then
    -- TReX.serverside.autoTreeOff()
  -- else
    -- TReX.serverside.autoTreeOn()
  -- end
-- end

TReX.serverside.autoTreeOn=function()
	if not tree then
		if t.bals.tree then
			send("curing tree on", false)
			tree = true
		end
	end
end

TReX.serverside.autoTreeOff=function()
	if tree then
		send("curing tree off", false)
		tree = false
	end
end


TReX.serverside.tree_by_class=function()
  TReX.affs2tree.by_class = {
	["blackout"] = {["default"] = 0},
	["alchemist"] = {["default"] = 0},
    ["apostate"] = {["default"] = 0},  
    ["bard"] = {["default"] = 0},  
    ["blademaster"] = {["default"] = 0},  
    ["depthswalker"] = {["default"] = 0},  
    ["dragon"] = {["default"] = 0},  
    ["druid"] = {["default"] = 0},  
    ["dualc"] = {["default"] = 0},  
    ["dualb"] = {["default"] = 0}, 
    ["jester"] = {["default"] = 0}, 
    ["magi"] = {["default"] = 0}, 
    ["monk"] = {["default"] = 0}, 
	["shikudo"] = {["default"] = 0}, 
    ["occultist"] = {["default"] = 0}, 
    ["priest"] = {["default"] = 0}, 
    ["serpent"] = {["default"] = 0}, 
    ["shaman"] = {["default"] = 0}, 
    ["sylvan"] = {["default"] = 0}, 
    ["sentinel"] = {["default"] = 0}, 
    ["snb"] = {["default"] = 0}, 
    ["twoh"] = {["default"] = 0}, 
	["water"] = {["default"] = 0},
	["earth"] = {["default"] = 0},
	["air"] = {["default"] = 0},
	["fire"] = {["default"] = 0},
  }
end

TReX.serverside.tree_manage=function()
cecho("\n\t<white>Tree Settings\n\n")
TReX.serverside.update()

  for class,num in TReX.config.spairs(TReX.affs2tree._by_class, function(t,a,b) return t[b] < t[a] end) do
    echo(" ")
    cechoLink("<dim_grey>[<light_blue> + <dim_grey>]", [[TReX.serverside.treeUp("]]..class..[[",]]..num..[[)]], "tree count " .. class .. " up.", true)
    echo(" ")
    cechoLink("<dim_grey>[<red> - <dim_grey>]", [[TReX.serverside.treeDown("]]..class..[[",]]..num..[[)]], "tree count " .. class .. " down.", true)
    resetFormat()
    cecho(" <dim_grey>[ <white>"..num.." <dim_grey>] <gray>" .. class:title() .. " \n")  --dark_orchid
  end
  		echo"\n\n"
		deletep = false
		showprompt()

end

TReX.serverside.treeDown=function(class, num)
      TReX.affs2tree.by_class[class].default=tonumber(num-1)
        if TReX.affs2tree.by_class[class].default<0 then
          TReX.affs2tree.by_class[class].default=0
        end          
     TReX.serverside.tree_manage()
end

TReX.serverside.treeUp=function(class, num)
      TReX.affs2tree.by_class[class].default=tonumber(num+1)
        if TReX.affs2tree.by_class[class].default<0 then
          TReX.affs2tree.by_class[class].default=0
        end          
      TReX.serverside.tree_manage()
 end

TReX.serverside.update=function()

    TReX.affs2tree._by_class=TReX.affs2tree._by_class or {} 
      for class,num in pairs(TReX.affs2tree["by_class"]) do
        num = TReX.affs2tree["by_class"][class].default
        TReX.affs2tree._by_class[class]=num
      end
  
    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.serverside.update )") end
end

TReX.serverside.flee_started_timer=function()
	enableTimer("flee_started")
end
	
TReX.serverside.save()

if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.serverside loaded successfully) ") end

for _, file in ipairs(TReX.serverside) do
	dofile(file)
end -- for


