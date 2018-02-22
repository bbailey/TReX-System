-- TReX.defs
-- Defence tracking

local send							= send
local cc							= TReX.config.cc or "##" --change to be the character used for concatenation

registerAnonymousEventHandler("gmcp.Char.Defences.List", "TReX.defs.gmcp_def_event_list")
registerAnonymousEventHandler("gmcp.Char.Defences.Add", "TReX.defs.gmcp_def_event_add")
registerAnonymousEventHandler("gmcp.Char.Defences.Remove", "TReX.defs.gmcp_def_event_remove")
registerAnonymousEventHandler("gmcp.Char.Defences.Remove", "TReX.defs.keepup")
registerAnonymousEventHandler("gmcp.Char.Vitals", "TReX.defs.keepup")

--load offense file
TReX.defs.save = function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_defs_main.lua"
   table.save(savePath, TReX.defs)
end -- func

--load defsense file
TReX.defs.load = function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_defs_main.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.defs)
	end -- if
end -- func

TReX.defs.login=function()
def_list = {}
TReX.defs.list()

--raiseEvent("gmcp.Char.Skills.Info")
--TReX.defs.skillcheck()
	if TReX.s.class == "Dragon" then
		t.file["dragon"] = t.file["dragon"] or def_list	 -- adding in to test
		def_list = t.file["dragon"] 	
		TReX.defs.keepup()
	else
		def_list = t.file[TReX.s.class:lower()] or def_list
		TReX.defs.keepup()
	end
end



-- parses incoming defs from gmcp
TReX.defs.gmcp_def_event_list=function()

if t.serverside["settings"].installed then
	for k, v in pairs(gmcp.Char.Defences.List) do
		if v["name"] ~= "morph" then
			if not table.contains({"parrying (head)","parrying (torso)","parrying (left leg)","parrying (right leg)","parrying (left arm)","parrying (right arm)"}, v["name"]) then
					TReX.defs.sort(v["name"])	
				if not (table.index_of(t.defs, v["name"])) then  
					table.insert(t.defs,#t.defs+1,v["name"])

							
				end
			end
		end
	end -- for
		TReX.defs.keepup()
end -- if installed
end -- func

---NEW UPDATES---
TReX.defs.gmcp_def_event_add=function(defs) -- motherboard gmcp def add 

local ignore={"boartattoo","megalithtattoo","fireflytattoo","mosstattoo","feathertattoo","shieldtattoo","mindseyetattoo","hammertattoo","cloaktattoo","belltattoo"
,"crystaltattoo","moontattoo","starbursttattoo","boartattoo","webtattoo","tentacletattoo","hourglasstattoo","braziertattoo","prismtattoo","treetattoo","oxtattoo"
,"chameleontattoo"}

	local defs,count = string.match( gmcp.Char.Defences.Add.name, "(%w+) %((%d+)%)" )
	local defs = defs or defences or gmcp.Char.Defences.Add.name
    
		-- important to add the def to the table.
		-- this table adds gmcp afflictions to the t.serverside.gmcp_aff_table table, all but the ignored. 
		-- The ignored affs still go to t.affs and the t.serverside.gmcp_aff_table tables
		if defs ~= "morph" then
			if not table.index_of(t.defs, defs) then -- secondary def add, (but also the event handler table)
				if not table.index_of(ignore, k) then
					table.insert(t.defs, #t.defs+1, defs)
					TReX.defs.sort(defs)

				end
			end
			
			
				--if not table.index_of(ignore, k) then
					--TReX.defs.sort(defs)
				--end
		end

	for k,v in pairs(def_list.free) do
		if k == defs then
			if not v.keepup then
				if not table.contains({ignore}, k) then
						--table.remove(t.defs, table.index_of(t.defs, k))
						send("curing prio def "..k.." reset")
						--print(k)
				end
			end
		end
		
	end	

		
	for k,v in pairs(def_list.needs_full_bal) do
		if k == defs then
			if not v.keepup then
				if not table.contains({ignore}, k) then
					send("curing prio def "..k.." reset")
				end
			end
		end
		
	end
	
	for k,v in pairs(def_list.class) do
		if k == defs then
			if not v.keepup then
				if not table.contains({ignore}, k) then
						--table.remove(t.defs, table.index_of(t.defs, k))
						send("curing prio def "..k.." reset")
						--print(k)
				end
			end
		end
		
	end	
		
		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.gmcp_def_event_add ) ") end
				
end -- func

--calling highest affliction k,v function to set prio list.
--removes from gmcp affliction table via gmcp
TReX.defs.gmcp_def_event_remove=function() -- motherboard gmcpaff remove
    for _, defs in ipairs( gmcp.Char.Defences.Remove ) do
		defs2,count = string.match( defs, "(%w+) %((%d+)%)" )
		defs = defs

		--if defs ~= "morph" then
			--t.send("curing priority defence " .. defs .. " reset")		
		--end	
		
		-- remove defs from table t.defs
		local x = -1
		local defs = gmcp.Char.Defences.Remove[1]
			
			if (table.index_of(t.defs,defs)) then
				for k, v in pairs(t.defs) do
					if defs == v then x = k end
				end -- if
			end -- if

			if x > -1 then table.remove(t.defs, table.index_of(t.defs, defs))  end
			if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.gmcp_def_event_remove ) ") end	
			
	end -- for
end -- func


TReX.defs.list=function()
TReX.s.class_spec()
TReX.s.class_check()
def_list = {
	free = { 			
		--["meditate"] = {["name"] = "meditate", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},	
		["blindness"] = {["name"] = "blindness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["deafness"] = {["name"] = "deafness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["insomnia"] = {["name"] = "insomnia", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["kola"] = {["name"] = "kola", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
		["levitating"] = {["name"] = "levitating", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["mass"] = {["name"] = "mass", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true,},
		["fangbarrier"] = {["name"] = "fangbarrier", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["rebounding"] = {["name"] = "rebounding", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["poisonresist"] = {["name"] = "poisonresist", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["speed"] = {["name"] = "speed", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["thirdeye"] = {["name"] = "thirdeye", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["groundwatch"] = {["name"] = "groundwatch", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["skywatch"] = {["name"] = "skywatch", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["vigilance"] = {["name"] = "vigilance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["softfocusing"]={["name"]="softfocusing", ["keepup"]=false, ["defup"]=false, ["serverside"]=true, ["enabled"]=true},
		["temperance"] = {["name"] = "temperance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["fireresist"] = {["name"] = "fireresist", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["magicresist"] = {["name"] = "magicresist", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["coldresist"] = {["name"] = "coldresist", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["electricresist"] = {["name"] = "electricresist", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
	},
	needs_full_bal = {
		["alertness"] = {["name"] = "alertness", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
		["cloak"] = {["name"] = "cloak", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},	
		["curseward"] = {["name"] = "curseward", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["shield"] = {["name"] = "shield", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},	
		["mindseye"] = {["name"] = "mindseye", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},	
		["metawake"] = {["name"] = "metawake", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["selfishness"] = {["name"] = "selfishness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["insulation"] = {["name"] = "insulation", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["heldbreath"] = {["name"] = "heldbreath", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["hypersight"] = {["name"] = "hypersight", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["nightsight"] = {["name"] = "nightsight", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["deathsight"] = {["name"] = "deathsight", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["telesense"] = {["name"] = "telesense", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["lifevision"] = {["name"] = "lifevision", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		["shroud"] = {["name"] = "shroud", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
	},
}
	if TReX.s.class == "Alchemist" then 
		def_list.class ={			
			["astronomy"] = {["name"] = "astronomy", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["mercury"] = {["name"] = "mercury", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["sulphur"] = {["name"] = "sulphur", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["tin"] = {["name"] = "tin", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			--["compoundmask"] = {["name"] = "Compoundmask", ["keepup"] = true, ["defup"] = true, ["enabled"] = true},
			--["enhancedform"] = {["name"] = "Enhancedform", ["keepup"] = true, ["defup"] = true, ["enabled"] = true},
			--["ironform"] = {["name"] = "Ironform", ["keepup"] = true, ["defup"] = true, ["enabled"] = true},
		}
	end
	
	if TReX.s.class == "Apostate" then 
		def_list.class ={
			["demonarmour"] = {["name"] = "demonarmour", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["lifevision"] = {["name"] = "lifevision", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["shroud"] = {["name"] = "shroud", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			["deathaura"] = {["name"] = "deathaura", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			["putrefaction"] = {["name"] = "putrefaction", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["vengeance"] = {["name"] = "vengeance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},  		
			["truestare"] = {["name"] = "truestare", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true}, 			
		}
	end

	--Bard
	if TReX.s.class == "Bard" then
		def_list.class ={			
			["acrobatics"] = {["name"] = "acrobatics", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["dodging"] = {["name"] = "dodging", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["arrowcatching"] = {["name"] = "arrowcatching", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["balancing"] = {["name"] = "balancing", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["heartsfury"] = {["name"] = "heartsfury", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["drunkensailor"] = {["name"] = "drunkensailor", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["lay"] = {["name"] = "lay", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["songbird"] = {["name"] = "songbird", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["tune"] = {["name"] = "tune", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["aria"] = {["name"] = "aria", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true,},
			["gripping"] = {["name"] = "gripping", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
		}			
	end
	
	--Blademaster
	if TReX.s.class == "Blademaster" then
		def_list.class ={			
			["dodging"] = {["name"] = "dodging", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["immunity"] = {["name"] = "immunity", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["projectiles"] = {["name"] = "projectiles", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["mindnet"] = {["name"] = "mindnet", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["weathering"] = {["name"] = "weathering", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["consciousness"] = {["name"] = "consciousness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["toughness"] = {["name"] = "toughness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["waterwalking"] = {["name"] = "waterwalking", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["standingfirm"] = {["name"] = "standingfirm", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["constitution"] = {["name"] = "constitution", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			["retaliation"] = {["name"] = "retaliation", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			["gripping"] = {["name"] = "gripping", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			["shinbinding"] = {["name"] = "shinbinding", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["shintrance"] = {["name"] = "shintrance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["shinclarity"] = {["name"] = "shinclarity", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		}		
	end


	if TReX.s.class == "Depthswalker" then
		def_list.class ={			
			["disperse"] = {["name"] = "disperse", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["bodyaugment"] = {["name"] = "bodyaugment", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["precision"] = {["name"] = "precision", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["durability"] = {["name"] = "durability ", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["antiforce"] = {["name"] = "antiforce", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["shadowveil"] = {["name"] = "shadowveil", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["bloodquell"] = {["name"] = "bloodquell", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		}
	end


	--Infernal
	 if TReX.s.class == "Infernal" then
         def_list.class ={            
             ["weathering"] = {["name"] = "weathering", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
             ["gripping"] = {["name"] = "gripping", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
             ["fury"] = {["name"] = "fury", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
             ["standingfirm"] = {["name"] = "standingfirm", ["keepup"] = false, ["defup"] = true, ["serverside"]=true, ["enabled"] = true},
             ["shroud"] = {["name"] = "shroud", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
             ["deathaura"] = {["name"] = "deathaura", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
             ["lifevision"] = {["name"] = "lifevision", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
             ["resistance"] = {["name"] = "resistance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			 ["putrefaction"] = {["name"] = "putrefaction", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			 ["blademastery"] = {["name"] = "blademastery", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			 ["deflect"] = {["name"] = "deflect", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			 ["vengeance"] = {["name"] = "vengeance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},            
         }	
    end

	if TReX.s.class == "Jester" then
		def_list.class = {
			["gripping"] = {["name"] = "gripping", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["slippery"] = {["name"] = "slippery", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["balancing"] = {["name"] = "balancing", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["arrowcatching"] = {["name"] = "arrowcatching", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["deviltarot"] = {["name"] = "deviltarot", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true,},
			["acrobatics"] = {["name"] = "acrobatics", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},			
		}
	end

	-- Magi
	if TReX.s.class == "Magi" then
		def_list.needs_full_bal["simultaneity"] = {["name"] = "simultaneity", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true}
		def_list.class ={
			["binding"] = {["name"] = "bind all", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["fortify"] = {["name"] = "fortify", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["chargeshield"] = {["name"] = "chargeshield", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["diamondskin"] = {["name"] = "diamondskin", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			--["stonefist"] = {["name"] = "Stone Fist", ["keepup"] = false, ["defup"] = true, ["serverside"]=true, ["enabled"] = true},  
			["stoneskin"] = {["name"] = "stoneskin", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["efreeti"] = {["name"] = "efreeti", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["waterweird"] = {["name"] = "waterweird", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		}
	end
	
	-- Monk
	if TReX.s.class == "Monk" then
		def_list.class ={			
			["vitality"] = {["name"] = "vitality", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["immunity"] = {["name"] = "immunity", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["bodyblock"] = {["name"] = "bodyblock", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["evadeblock"] = {["name"] = "evadeblock", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["pinchblock"] = {["name"] = "pinchblock", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["numbness"] = {["name"] = "numbness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["kaiboost"] = {["name"] = "kaiboost", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true}, 
			["kaitrance"] = {["name"] = "kaitrance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["regeneration"] = {["name"] = "regeneration", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["boostedregeneration"] = {["name"] = "boostedregeneration", ["keepup"] = false, ["serverside"]=false, ["defup"] = false, ["enabled"] = true},
			["mindcloak"] = {["name"] = "mindcloak", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true}, 
			["mindnet"] = {["name"] = "mindnet", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["constitution"] = {["name"] = "constitution", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			["consciousness"] = {["name"] = "consciousness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["projectiles"] = {["name"] = "projectiles", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["resistance"] = {["name"] = "resistance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["toughness"] = {["name"] = "toughness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["weathering"] = {["name"] = "weathering", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["gripping"] = {["name"] = "gripping", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		}
	end
	
	
	if TReX.s.class == "Occultist" then	
		def_list.class = {
			["distortedaura"] = {["name"] = "distortedaura", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["shroud"] = {["name"] = "shroud", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["devilmark"] = {["name"] = "devilmark", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["tentacles"] = {["name"] = "tentacles", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["astralform"] = {["name"] = "astralform", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["astralvision"] = {["name"] = "astralvision", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["deviltarot"] = {["name"] = "deviltarot", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["lifevision"] = {["name"] = "lifevision", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["simulacrum"] = {["name"] = "simulacrum", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["heartstone"] = {["name"] = "heartstone", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
		}		
	end

	--Paladin
	  if TReX.s.class == "Paladin" then
         def_list.class ={            
            ["weathering"] = {["name"] = "weathering", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["gripping"] = {["name"] = "gripping", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["fury"] = {["name"] = "fury", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["standingfirm"] = {["name"] = "standingfirm", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["inspiration"] = {["name"] = "inspiration", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["resistance"] = {["name"] = "resistance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["blademastery"] = {["name"] = "blademastery", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["deflect"] = {["name"] = "deflect", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
        }
         
    end

	--Priest
	if TReX.s.class == "Priest" then
		def_list.needs_full_bal["simultaneity"] = {["name"] = "simultaneity", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true}
		def_list.class ={
			["inspiration"] = {["name"] = "inspiration", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["fortify"] = {["name"] = "fortify", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
		}
	end
	
	--Runewarden
	  if TReX.s.class == "Runewarden" then
         def_list.class ={
            ["weathering"] = {["name"] = "weathering", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["gripping"] = {["name"] = "gripping", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["fury"] = {["name"] = "fury", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["standingfirm"] = {["name"] = "standingfirm", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
            ["resistance"] = {["name"] = "resistance", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["blademastery"] = {["name"] = "blademastery", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["deflect"] = {["name"] = "deflect", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},			
            
         }

    end

--fitness -- defence
	
	-- Sentinel
	if TReX.s.class == "Sentinel" then
		def_list.class = {
			 ["fleetness"] = {["name"] = "fleetness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},  
			 ["barkskin"] = {["name"] = "barkskin", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			 ["firstaid"] = {["name"] = "firstaid", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			 ["hiding"] = {["name"] = "hiding", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			 ["alertness"] = {["name"] = "alertness", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true,},
			 ["nightsight"] = {["name"] = "nightsight", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true,},
			 ["stealth"] = {["name"] = "stealth", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true,},
			 ["vitality"] = {["name"] = "vitality", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true,},
			 ["resistance"] = {["name"] = "resistance", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true,},
			 ["spinspear"] = {["name"] = "spinspear", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			 ["melody"] = {["name"] = "melody", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},

			-- ["mask"]
		}
	
	end
		
	-- Serpent	 
	if TReX.s.class == "Serpent" then
		def_list.class = {
			 ["lipreading"] = {["name"] = "lipreading", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},  
			 ["shroud"] = {["name"] = "shroud", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},   
			 ["ghost"] = {["name"] = "ghost", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			 ["secondsight"] = {["name"] = "secondsight", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			 ["hiding"] = {["name"] = "hiding", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			 ["scales"] = {["name"] = "scales", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			 ["weaving"] = {["name"] = "weaving", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
			 ["phased"] = {["name"] = "phased", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true,},
		}
	
	end
	
	--Shaman
	if TReX.s.class == "Shaman" then
		def_list.class = {
			["gripping"] = {["name"] = "gripping", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["swiftcurse"] = {["name"] = "swiftcurse", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		}
	
	end

	--Sylvan
	if TReX.s.class == "Sylvan" then
		def_list.needs_full_bal["simultaneity"] = {["name"] = "simultaneity", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true}
		def_list.class = { 
			["circulate"] = {["name"] = "circulate", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["viridian"] = {["name"] = "viridian", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["wildgrowth"] = {["name"] = "wildgrowth", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["fortify"] = {["name"] = "fortify", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["binding"] = {["name"] = "bind all", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["barkskin"] = {["name"] = "barkskin", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["panacea"] = {["name"] = "panacea", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["vigour"] = {["name"] = "vigour", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			--["spinningstaff"] = {["name"] = "spinningstaff", ["keepup"] = false, ["defup"] = true, ["serverside"]=false, ["enabled"] = true},
			["flailingstaff"] = {["name"] = "flailingstaff", ["keepup"] = false, ["defup"] = true, ["serverside"]=false, ["enabled"] = true},
			["reflections"] = {["name"] = "reflections", ["keepup"] = false, ["defup"] = true, ["serverside"]=false, ["enabled"] = true},
		}
	end


	if TReX.s.class == "Dragon" then	
		def_list.class = {
			["dragonarmour"] = {["name"] = "dragonarmour", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["dragonbreath"] = {["name"] = "dragonbreath", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
		}
	end

	if TReX.s.class == "Druid" then
		def_list.class = { -- any these you want on keepup or keep it like it is?
			["affinity"] = {["name"] = "afinity", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["circulate"] = {["name"] = "circulate", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["bonding"] = {["name"] = "bonding", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["wildgrowth"] = {["name"] = "wildgrowth", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["vitality"] = {["name"] = "vitality", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["panacea"] = {["name"] = "panacea", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["elusiveness"] = {["name"] = "elusiveness", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["stealth"] = {["name"] = "stealth", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			["vigour"] = {["name"] = "vigour", ["keepup"] = false, ["defup"] = false, ["serverside"]=true, ["enabled"] = true},
			--["spinningstaff"] = {["name"] = "spinningstaff", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
			["flailingstaff"] = {["name"] = "flailingstaff", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
            ["melody"] = {["name"] = "melody", ["keepup"] = false, ["defup"] = false, ["serverside"]=false, ["enabled"] = true},
		}
	
	end -- if
	
		 if TReX.s.class == "water Elemental Lord" then
         def_list.class ={}    
         end
		 
		 if TReX.s.class == "air Elemental Lord" then
         def_list.class ={}    
         end
		 
		 if TReX.s.class == "fire Elemental Lord" then
         def_list.class ={}    
         end
		 
		 if TReX.s.class == "earth Elemental Lord" then
         def_list.class ={}    
         end

		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.list ) ") end

end -- func

TReX.defs.deathsight_add=function(defs)
	 if not table.contains({t.defs}, "deathsight") then
		 if def_list.needs_full_bal["deathsight"].serverside then
			if t.serverside["settings"].deathsight then
				t.send("curing prio def deathsight 24", false)
			else 
				if t.serverside["settings"].transmutation then
					t.send("queue add eqbal outr azurite"..(TReX.config.cc or "##").."eat azurite", false)
				else
					t.send("queue add eqbal outr skullcap"..(TReX.config.cc or "##").."eat skullcap", false)
				end
			end
		 else
			t.send("curing prio def deathsight reset", false)		 end
			table.insert(t.defs, "deathsight")
	 end				 

end
					
TReX.defs.deathsight_remove=function(defs)					
 if (variable == "deathsight") then
	 if table.contains({t.defs}, defs) then
		 table.remove(t.defs, table.index_of(t.defs, defs))
		 t.send("curing prio def deathsight reset", false)
	 end	
 end
end

TReX.defs.defup_current=function()

cecho("\n<white>"..TReX.s.class.." Defup List\n")

local table_list = {
	def_list.free,
	def_list.needs_full_bal,
	def_list.class,
}

	--for i, n in ipairs(table_list) do
	local x=0	
		
	for index, def_table in pairs(table_list) do
		for k,v in pairs(def_table) do
			x=x+1
			if v.defup then
				--cecho("\n<green>+<white>"..k)
				if (x-1)%3 == 0 then
					echo("\n")
				end  
		
				local d = "<dim_grey>[<light_blue> + <dim_grey>]<white> " 
	
				local kWithSpace = k

				if kWithSpace:len() < 25 and (x-1) %3~=2 then
					local pad = 25 - kWithSpace:len()
					kWithSpace = kWithSpace .. string.rep(" ", pad)
				elseif kWithSpace:len() > 25 then
					kWithSpace = kWithSpace:cut(25)
				end

				local command
				fg("white")
				cecho(d)
				local command = [[TReX.defs._toggle_defups("]]..k..[[")]]
				echoLink(kWithSpace, command, "Defup " .. k:title(), true)
				--cecho("<green> + <white> "..kWithSpace)
				
			else
				--cecho("\n<red>-<white>"..k)
				if (x-1)%3 == 0 then
					echo("\n")
				end  
				
				local d = "<dim_grey>[<red> - <dim_grey>]<white> " 
		
				local kWithSpace = k

				if kWithSpace:len() < 25 and (x-1) %3~=2 then
					local pad = 25 - kWithSpace:len()
					kWithSpace = kWithSpace .. string.rep(" ", pad)
				elseif kWithSpace:len() > 25 then
					kWithSpace = kWithSpace:cut(25)
				end
				local command
				fg("white")
				cecho(d)
				local command = [[TReX.defs._toggle_defups("]]..k..[[")]]
				echoLink(kWithSpace, command, "Defup "..k:title(), true)
				--cecho("<red> - <white> "..kWithSpace)
			end
		end -- for
	end  -- for

	echo"\n"
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.keepup ) ") end

end -- func

--[[===========================================================================================================

	DEFUP

==============================================================================================================]]

TReX.defs._toggle_defups=function(def)

	--FREE

		if table.contains({def_list.free}, def) then
			for k,v in pairs(def_list.free) do
				if k == def then
					if v.serverside then
						if v.defup then
							def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.free[def].keepup, ["defup"] = false, ["serverside"] = true, ["enabled"] = true,}
						else
							def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.free[def].keepup, ["defup"] = true, ["serverside"] = true, ["enabled"] = true,}
						end
					else
						if v.defup then
							def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.free[def].keepup, ["defup"] = false, ["serverside"] = false, ["enabled"] = true,}
						else
							def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.free[def].keepup, ["defup"] = true, ["serverside"] = false, ["enabled"] = true,}
						end
					end -- if
				end	-- if
			end -- for
		end -- if

	
	--FULL BALANCE
	
	
		if table.contains({def_list.needs_full_bal}, def) then
			for k,v in pairs(def_list.needs_full_bal) do
				if k == def then
					if v.serverside then
						if v.defup then
							def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.needs_full_bal[def].keepup, ["defup"] = false, ["serverside"] = true, ["enabled"] = true,}
						else
							def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.needs_full_bal[def].keepup, ["defup"] = true, ["serverside"] = true, ["enabled"] = true,}
						end
					else
						if v.defup then
							def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.needs_full_bal[def].keepup, ["defup"] = false, ["serverside"] = false, ["enabled"] = true,}
						else
							def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.needs_full_bal[def].keepup, ["defup"] = true, ["serverside"] = false, ["enabled"] = true,}
						end
					end -- if
				end	-- if
			end -- for
		end -- if

	--CLASS
	
		if table.contains({def_list.class}, def) then
			for k,v in pairs(def_list.class) do
				if k == def then
					if v.serverside then
						if v.defup then
							def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.class[def].keepup, ["defup"] = false, ["serverside"] = true, ["enabled"] = true,}
						else
							def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.class[def].keepup, ["defup"] = true, ["serverside"] = true, ["enabled"] = true,}
						end
					else
						if v.defup then
							def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.class[def].keepup, ["defup"] = false, ["serverside"] = false, ["enabled"] = true,}
						else
							def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.class[def].keepup, ["defup"] = true, ["serverside"] = false, ["enabled"] = true,}
						end
					end -- if
				end	-- if
			end -- for
		end -- if
	
		t.file[TReX.s.class:lower()] = def_list  -- very important leave, updates class file on current defence settings
		TReX.defs.defup_current() -- calls the clickable toggle menu	
	
end -- func

--[[===========================================================================================================
==============================================================================================================]]

TReX.defs.keepup_current=function()

cecho("\n<white>"..TReX.s.class.. " Keepup List\n")

local table_list = {
	def_list.free,
	def_list.needs_full_bal,
	def_list.class,
}


	--for i, n in ipairs(table_list) do
	local x=0	
		
	for index, def_table in pairs(table_list) do
		for k,v in pairs(def_table) do
			x=x+1
			if v.keepup then
				--cecho("\n<green>+<white>"..k)
				if (x-1)%3 == 0 then
					echo("\n")
				end  
		
				local d = "<dim_grey>[<light_blue> + <dim_grey>]<white> " 
	
				local kWithSpace = k

				if kWithSpace:len() < 25 and (x-1) %3~=2 then
					local pad = 25 - kWithSpace:len()
					kWithSpace = kWithSpace .. string.rep(" ", pad)
				elseif kWithSpace:len() > 25 then
					kWithSpace = kWithSpace:cut(25)
				end

				--local command
				fg("white")
				cecho(d)
				local command = [[TReX.defs._toggle_keepups("]]..k..[[")]]
				echoLink(kWithSpace, command, "Keepup " .. k:title(), true)
				--cecho("<green> + <white> "..kWithSpace)
				
			else
				--cecho("\n<red>-<white>"..k)
				if (x-1)%3 == 0 then
					echo("\n")
				end  
				
				local d = "<dim_grey>[<red> - <dim_grey>]<white> " 
		
				local kWithSpace = k

				if kWithSpace:len() < 25 and (x-1) %3~=2 then
					local pad = 25 - kWithSpace:len()
					kWithSpace = kWithSpace .. string.rep(" ", pad)
				elseif kWithSpace:len() > 25 then
					kWithSpace = kWithSpace:cut(25)
				end
				--local command
				fg("white")
				cecho(d)
				local command = [[TReX.defs._toggle_keepups("]]..k..[[")]]
				echoLink(kWithSpace, command, "Keepup " .. k:title(), true)
				--cecho("<red> - <white> "..kWithSpace)
			end
		end -- for
	end  -- for

	echo"\n"
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.keepup ) ") end

end -- func

--[[===========================================================================================================

			KEEPUP
				
==============================================================================================================]]

TReX.defs._toggle_keepups=function(def)

	--FREE

		if table.contains({def_list.free}, def) then
			for k,v in pairs(def_list.free) do
				if k == def then
					if v.serverside then
						if v.keepup then
							def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.free[def].defup, ["serverside"] = true, ["enabled"] = true,}
								if table.contains({t.defs}, def) then	
									table.remove(t.defs, table.index_of(t.defs, def))
									send("curing prio def "..def.." reset")
								end
						else
							def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.free[def].defup, ["serverside"] = true, ["enabled"] = true,}
								if not table.contains({t.defs}, def) then	
									TReX.defs.sort(def)
								end								
						end
					else
						if v.keepup then
							def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.free[def].defup, ["serverside"] = false, ["enabled"] = true,}
								if table.contains({t.defs}, def) then	
									table.remove(t.defs, table.index_of(t.defs, def))
									send("curing prio def "..def.." reset")
								end
						else
							def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.free[def].defup, ["serverside"] = false, ["enabled"] = true,}
								if not table.contains({t.defs}, def) then	
									TReX.defs.sort(def)
								end								
						end
					end -- if
				end	-- if
			end -- for
		end -- if

		--FULL BALANCE
		
		if table.contains({def_list.needs_full_bal}, def) then
			for k,v in pairs(def_list.needs_full_bal) do
				if k == def then
					if v.serverside then
						if v.keepup then
							def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.needs_full_bal[def].defup, ["serverside"] = true, ["enabled"] = true,}
								if table.contains({t.defs}, def) then	
									table.remove(t.defs, table.index_of(t.defs, def))
									send("curing prio def "..def.." reset")

								end
						else
							def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.needs_full_bal[def].defup, ["serverside"] = true, ["enabled"] = true,}
								if not table.contains({t.defs}, def) then	
									TReX.defs.sort(def)
								end	
						end
					else
						if v.keepup then
							def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.needs_full_bal[def].defup, ["serverside"] = false, ["enabled"] = true,}
								if table.contains({t.defs}, def) then	
									table.remove(t.defs, table.index_of(t.defs, def))
									send("curing prio def "..def.." reset")
								
								end
						else
							def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.needs_full_bal[def].defup, ["serverside"] = false, ["enabled"] = true,}
								if not table.contains({t.defs}, def) then	
									TReX.defs.sort(def)
								end								
						end
					end -- if
				end	-- if
			end -- for
		end -- if

		--CLASS
		
		if table.contains({def_list.class}, def) then
			for k,v in pairs(def_list.class) do
				if k == def then
					if v.serverside then
						if v.keepup then
							def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.class[def].defup, ["serverside"] = true, ["enabled"] = true,}
								if table.contains({t.defs}, def) then	
									table.remove(t.defs, table.index_of(t.defs, def))
									send("curing prio def "..def.." reset")

								end							
						else
							def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.class[def].defup, ["serverside"] = true, ["enabled"] = true,}
								if not table.contains({t.defs}, def) then	
									TReX.defs.sort(def)
								end								
						end
					else
						if v.keepup then
							def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.class[def].defup, ["serverside"] = false, ["enabled"] = true,}
								if table.contains({t.defs}, def) then	
									table.remove(t.defs, table.index_of(t.defs, def))								
									send("curing prio def "..def.." reset")
									
								end							
						else
							def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.class[def].defup, ["serverside"] = false, ["enabled"] = true,}
								if not table.contains({t.defs}, def) then	
									TReX.defs.sort(def)
								end									
						end
					end -- if
				end	-- if
			end -- for
		end -- if
		
		t.file[TReX.s.class:lower()] = def_list  -- very important leave, updates class file on current defence settings
		TReX.defs.keepup_current() -- calls the clickable toggle menu	
	
end -- func

--[[===========================================================================================================
==============================================================================================================]]

TReX.defs.keepup=function()

local table_list = {
	def_list.free,
	def_list.needs_full_bal,
	def_list.class,
}

	for index, def_table in pairs(table_list) do 
		for k,v in pairs(def_table) do 
			if v.keepup then	
				TReX.defs.sort(k)
			end -- if
		end -- for
	end  -- for
	
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.keepup ) ") end

end -- func

TReX.defs.class_changed=function()


local table_list = {

	def_list.free,
	def_list.needs_full_bal,
	def_list.class,
	
	}

	for k, v in pairs(table_list) do
		if v.enabled then 
			t.send("curing priority defence " .. k .. " reset")
		end -- if
	end -- for

	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.class_changed ) ") end

end -- func

TReX.defs.raid=function()

local table_list = {
	def_list.free,
	def_list.needs_full_bal,
	def_list.class,
}

	for index, def_table in pairs(table_list) do
		for k,v in pairs(def_table) do
			if v.defup then	
				TReX.defs.sort(k)
			end -- if
		end -- for
	end  -- for
	
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.defup ) ") end

end  -- func

TReX.defs.preempt=function(defs)

	defs_prio = defs_prio or 23
	def_list = def_list or {}

	TReX.defs.defs_sort(defs)

	if TReX.s.class=="Sylvan" then
		TReX.defs.viridian(defs)
	end

	for _,v in pairs({"Sylvan","Druid"}) do
		if TReX.s.class == v then
			TReX.defs.vigour_panacea_wildgrowth(defs)
		end
	end

	if defs == "mass" then
		TReX.defs.mass()	
	end
	
	
end  -- func
		
TReX.defs.alias_toggle=function(defs)
	if not table.contains({t.defs}, defs) then
		defs_prio = defs_prio or 23
		def_list = def_list or {}
		TReX.defs.defs_sort(defs)
						
		if TReX.s.class=="Sylvan" then
			TReX.defs.viridian(defs)
		end
					
		for _,v in pairs({"Sylvan","Druid"}) do
			if TReX.s.class == v then
				TReX.defs.vigour_panacea_wildgrowth(defs)	
			end
		end

		
			if defs == "mass" then
				TReX.defs.mass()
			end

			--if defs == "meditate" then
				--TReX.defs.meditate()
			--end	
			
			--if defs == "selfishness" then
				--if not table.contains({t.defs}, "selfishness") then
				--	t.send("selfishness")
				--end
			--end

			if table.index_of({"groundwatch","skywatch","hypersight","alertness","telesense","insomnia","softfocusing"}, defs) then
				if not t.def[defs] then
					if defs == "softfocusing" then
						t.send("softfocus on")
					else
						t.send(defs.." on")
					end
				end
			end	
			
			if table.index_of({"Bard","Jester"}, TReX.s.class) then
				if table.index_of({"acrobatics","arrowcatching","heartsfury","dodging","balancing"}, defs) then
					if not table.contains({t.defs}, defs) then
						TReX.defs.class_bard_up(defs)
					end
				end
				if table.index_of({"drunkensailor","heartsfury"}, defs) then
					if not table.contains({t.defs}, defs) then
						TReX.defs.drunkensailor_heartsfury_up(defs)
					end
				end
				
			end
			
			if table.index_of({"Bard"}, TReX.s.class) then
				if defs == "aria" then 
					if not table.contains(t.defs, "aria") then
						if t.bals.eq and t.bals.voice then
							t.send("queue prepend eq draw rapier##wield rapier left##auralbless me")
							t.send("queue add class sing aria at me")
						end
					end
				end
			end	
							
			
			
			if table.index_of({"Magi"}, TReX.s.class) then
				if defs == "binding" then 
					TReX.defs.binding_all()
				end
				if defs == "fortify" then
					TReX.defs.fortify_all()
				end
				if defs == "efreeti" then 
					TReX.defs.efreeti_up()
				end
				if defs == "waterweird" then 
					TReX.defs.waterweird_up()
				end
				if defs == "simultaneity" then
					TReX.defs.simultaneity_up()
				end
			end	
		
			if table.index_of({"Druid"}, TReX.s.class) then
				if defs == "bonding" then 
					if not table.contains({t.defs}, "bonding") then
						t.send("queue add eqbal bonding spirit")
					end
				end
			end

			if table.index_of({"Jester"}, TReX.s.class) then
				if defs == "deviltarot" then 
					t.send("queue add eqbal fling devil at ground")
				end
			end	
			
			if table.index_of({"Occultist"}, TReX.s.class) then
				if defs == "deviltarot" then 
					if not table.contains({t.defs}, "deviltarot") then
						t.send("queue add eqbal fling devil at ground")
					end
				end
				if defs == "devilmark" then 
					if not table.contains({t.defs}, "devilmark") then
						if TReX.stats.karma > 2 then				
							t.send("queue add eqbal devilmark")
						else
							if not table.contains(t.defs, defs) then
								TReX.defs.def_keepup_toggle(tostring(defs))
							end
								t.serverside.green_echo("Low Karma")
						end
					end
				end
				if defs == "astralvision" then 
					if not table.contains({t.defs}, "astralvision") then
						if TReX.stats.karma > 2 then
							t.send("queue add eqbal astralvision")
						else
							if not table.contains(t.defs, defs) then
								TReX.defs.def_keepup_toggle(tostring(defs))
							end
								t.serverside.green_echo("Low Karma")
						end
					end
				end
				if defs == "simulacrum" then
					if not table.contains({t.defs}, "simulacrum") then
						if not table.contains({TReX.inv.inv}, "a simulacrum") and TReX.stats.karma > 2 then
							t.send("queue add eqbal simulacrum")
						end
					end
				end
				if defs == "heartstone" then
					if not table.contains({t.defs}, "heartstone") then
						if not table.contains({TReX.inv.inv}, "a heartstone") and TReX.stats.karma > 2 then
							t.send("queue add eqbal heartstone")
						end
					end
				end			
			end	

			if table.index_of({"Priest"}, TReX.s.class) then
				if defs == "fortify" then 
					TReX.defs.fortify_all()
				end
				if defs == "simultaneity" then
					TReX.defs.simultaneity_up()
				end
			end

			if table.index_of({"Sylvan"}, TReX.s.class) then
				if defs == "viridian" then
					TReX.defs.viridian_staff(defs)
				end
				if defs == "simultaneity" then
					TReX.defs.simultaneity_up()
				end
				if defs == "circulate" then 
					t.send("queue add eqbal cast circulate")
				end
				if defs == "reflections" then 
					t.send("queue add eqbal cast reflection at me")
				end
			end


			if table.index_of({"Sentinel","Druid"}, TReX.s.class) then
			
			TReX.defs.metamorphosis()
			
				if table.contains({"alertness","nightsight","stealth",}, defs) then
					for k,v in pairs(def_list.metamorphosis) do
						if table.contains({v}, defs) then
							if not table.contains({t.defs}, defs) then
								if t.bals.bal and t.bals.eq then
									if TReX.defs.morph_check():lower() ~= k and TReX.serverside.am_functional() and TReX.serverside.full_balance() then
										t.send("morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check(), false) 
										t.bals.eq = false -- cheat
									end	
										table.insert(t.defs, defs)
										t.send("queue add eqbal "..defs.." on",false)
											break										
								end
							end
						end
					end
				end
				
				if defs == "vitality" then
					for k,v in pairs(def_list.metamorphosis) do
						--if table.contains({v}, defs) then
							if not table.contains({t.defs}, defs) then
								if t.bals.bal and t.bals.eq then
									t.bals.eq = false -- cheat
										t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal "..defs)
										table.insert(t.defs, defs)
								end	
							end
						--end
					end
				end
				
				if defs == "resistance" then
					for k,v in pairs(def_list.metamorphosis) do
						if table.contains({v}, defs) then
							if not table.contains({t.defs}, defs) then
								if t.bals.bal and t.bals.eq then
									t.bals.eq = false -- cheat
										t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal "..defs)
										table.insert(t.defs, defs)
								end	
							end
						end
					end
				end
				
				if defs == "melody" then
					for k,v in pairs(def_list.metamorphosis) do
						if table.contains({v}, defs) then
							if not table.contains({t.defs}, defs) then
								if t.bals.bal and t.bals.eq then
									t.bals.eq = false -- cheat
										t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal sing "..defs)
										table.insert(t.defs, defs)
								end	
							end
						end
					end
				end
				
				
						if defs == "spinspear" then
							TReX.rewield(t.inv["spear"].id, "r")
								if not t.def.spinspear then
									t.send("queue add eqbal spin spear",false)
									table.insert(t.defs, defs)
								end
							
						end	
				
			end

				if not table.index_of({"Sentinel","Druid"}, TReX.s.class) then
					if not table.contains({t.defs}, defs) then
						table.insert(t.defs, defs)
					end
				else
					if not table.contains({"alertness","nightsight","stealth","vitality","resistance"}, defs) then
						if not table.contains({t.defs}, defs) then
							table.insert(t.defs, defs)
						end
					end
				end
				
					if not t.def[defs] then
						t.def[defs]=true
					end

						t.serverside.green_echo(defs:title())
						
	else		

		--if not table.contains({"drunkensailor","heartsfury","dodging","aria","spinspear","circulate","binding","boostedregeneration","fortify", "efreeti", "deviltarot"
							  -- ,"waterweird","hiding","flailingstaff","viridian","reflections","simultaneity","astralvision","simulacrum","heartstone","meditate"
							  -- ,"balancing","gripping","acrobatics","arrowcatching","alertness","telesense","heldbreath","metawake","groundwatch","skywatch","softfocusing"}, defs) then -- important line

			send("curing priority defence " .. defs .. " reset", false)
		--end

		--if defs == "meditate" then
		--	t.serverside.red_echo("Meditate")
			--TReX.defs.reset_meditate()
		--end

		if defs=="gripping" then
			t.send("relax grip")
		end
		
		if defs == "vigilance" then 
			t.send("relax vigilance")
		end		
		
		if defs == "deathsight" then
			TReX.defs.deathsight_remove(defs)
		end
		
			if table.index_of({"groundwatch","skywatch","hypersight","alertness","telesense","insomnia","softfocusing"}, defs) then
				if t.def[defs] then
					if defs == "softfocusing" then
						t.send("softfocus off")
					else
						t.send(defs.." off")
					end
				end
			end	
			
			if defs == "metawake" then
				TReX.defs.metawake_down()
			end
			
			if defs == "selfishness" then
				if table.contains({t.defs}, "selfishness") then
					t.send("generosity")
				end
			end
			
			if defs == "heldbreath" then
				if table.contains({t.defs}, "heldbreath") then
					t.send("release")
				end
			end	
		
			if table.index_of({"Infernal"}, TReX.s.class) then
				if table.index_of({"vengeance"}, defs) then
					t.send("relax vengeance")
				end
			end			

			if table.index_of({"Bard","Jester"}, TReX.s.class) then
				if table.index_of({"acrobatics","arrowcatching","heartsfury","dodging","balancing"}, defs) then
					if table.contains({t.defs}, defs) then
						TReX.defs.class_bard_down(defs)
					end
				end
				if table.index_of({"drunkensailor","heartsfury"}, defs) then
					if table.contains({t.defs}, defs) then
						TReX.defs.drunkensailor_heartsfury_down(defs)
					end
				end
			end			
		
			
			if table.index_of({"Magi"}, TReX.s.class) then
				if defs == "binding" then 
					TReX.defs.binding_off()
				end
				if defs == "fortify" then 
					TReX.defs.fortify_down()
				end
				if defs == "waterweird" then 
					TReX.defs.waterweird_down()
				end
				if defs == "efreeti" then 
					TReX.defs.efreeti_down()
				end
				if defs == "simultaneity" then
					TReX.defs.simultaneity_down()
				end
			end	

			if table.index_of({"Monk"}, TReX.s.class) then
				if defs == "boostedregeneration" then	
					t.send("relax regeneration")
				end
				if defs == "evadeblock" then	
					t.send("unblock evb")
				end
				if defs == "pinchblock" then	
					t.send("unblock pnb")
				end
			end
		
			if table.index_of({"Occultist"}, TReX.s.class) then
				if defs == "distortedaura" then	
					t.send("normalaura")
				end
			end
			
				 if table.index_of({"Sylvan"}, TReX.s.class) then
					if defs == "flailingstaff" then 
						t.send("queue add eqbal unwield " ..t.inv["staff"].id)
						TReX.rewield(t.inv["staff"].id, "x")
					end
					if defs == "binding" then 
						TReX.defs.binding_off()
					end
 			
					if defs == "simultaneity" then
						TReX.defs.simultaneity_down()
					end

				end

			if table.index_of({"Druid"}, TReX.s.class) then
				if defs == "flailingstaff" then 
					t.send("queue add eqbal unwield " ..t.inv["staff"].id)
					TReX.rewield(t.inv["staff"].id, "x")
				end
			end
				
			if table.index_of({"Sentinel","Druid"}, TReX.s.class) then
				TReX.defs.metamorphosis()
					if table.contains({"alertness","nightsight","stealth","vitality","resistance"}, defs) then
						for k,v in pairs(def_list.metamorphosis) do
							if table.contains({v}, defs) then
								if table.contains({t.defs}, defs) then
									if TReX.defs.morph_check():lower() ~= k and TReX.serverside.am_functional() and TReX.serverside.full_balance() then
										t.send("morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check(), false) 
										t.bals.eq = false -- cheat
									end	
										table.remove(t.defs, table.index_of(t.defs, defs))
										t.send("queue add eqbal relax "..defs)
											break
								end
							end
						end
					end
				
				if defs == "melody" then
					if table.contains({t.defs}, defs) then
						table.remove(t.defs, table.index_of(t.defs, defs))
					end
				end
				
				if defs == "spinspear" then
					if t.def.spinspear then
						t.send("queue add eqbal stop spinning",false)
						table.remove(t.defs, table.index_of(t.defs, defs))
					end
					
				end					
				
			end
			
		
		if not table.index_of({"Sentinel","Druid"}, TReX.s.class) then
			if table.contains({t.defs}, defs) then
				table.remove(t.defs, table.index_of(t.defs, defs))
			end
		else
			if not table.contains({"alertness","nightsight","stealth","vitality","resistance"}, defs) then
				if table.contains({t.defs}, defs) then
					table.remove(t.defs, table.index_of(t.defs, defs))
				end
			end
		end

					if t.def[defs] then
						t.def[defs]=false
					end
					
						t.serverside.red_echo(defs:title())

	end
	
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.alias_toggle ) ") end
	
end -- func

TReX.defs.toggle=function(defs)


if not table.contains({t.defs}, defs) then

defs_prio = defs_prio or 23
def_list = def_list or {}
TReX.defs.defs_sort(defs)

if table.index_of({"Sylvan"}, TReX.s.class) then
	TReX.defs.viridian(defs)
end
				
if table.index_of({"Sylvan","Druid"}, TReX.s.class) then
	TReX.defs.vigour_panacea_wildgrowth(defs)		
end

		
		--if defs == "meditate" then
			--TReX.defs.meditate()
		--end

		if defs == "mass" then
			TReX.defs.mass()
		end
		
		--if defs == "selfishness" then
		--	if not table.contains({t.defs}, "selfishness") then
		--		t.send("selfishness")
		--	end
		--end
		
		if table.index_of({"groundwatch","skywatch","hypersight","alertness","telesense","insomnia","softfocusing"}, defs) then
			if not t.def[defs] then
				if defs == "softfocusing" then
					--t.send("softfocus on")
					cecho("<green> softfocus on")
				else
					--t.send(defs.." on") -- this line causes defenses to get sent twice. ex: typing alertness on results in it going in twice. but i'm having it echo to make sure it doesn't break anything
					cecho("<green>"..defs.." on")
				end
			end
	    end	
		
		if table.index_of({"Bard","Jester"}, TReX.s.class) then
			if table.index_of({"acrobatics","arrowcatching","heartsfury","dodging","balancing"}, defs) then
					if not table.contains(t.defs, defs) then
						TReX.defs.class_bard_up(defs)
					end
			end
			if table.index_of({"drunkensailor","heartsfury"}, defs) then
				if not table.contains({t.defs}, defs) then
					TReX.defs.drunkensailor_heartsfury_up(defs)
				end
			end
		end
		
		if table.index_of({"Druid"}, TReX.s.class) then
			if defs == "bonding" then 
				if not table.contains({t.defs}, "bonding") then
					t.send("queue add eqbal bonding spirit")
				end
			end
		end
		
		if table.index_of({"Magi"}, TReX.s.class) then
			if defs == "binding" then 
				TReX.defs.binding_all()
			end
			if defs == "fortify" then
				TReX.defs.fortify_all()
			end
			if defs == "efreeti" then 
				TReX.defs.efreeti_up()
			end
			if defs == "waterweird" then 
				TReX.defs.waterweird_up()
			end
			if defs == "simultaneity" then
				TReX.defs.simultaneity_up()
			end
		end	

		if table.index_of({"Bard"}, TReX.s.class) then
			if defs == "aria" then 
				if not table.contains(t.defs, "aria") then
					if t.bals.eq and t.bals.voice then
						t.send("queue prepend eq draw rapier##wield rapier left##auralbless me")
						t.send("queue add class sing aria at me")
					end
				end
			end
		end		
			
			

		if table.index_of({"Jester"}, TReX.s.class) then
			if defs == "deviltarot" then 
				t.send("queue add eqbal fling devil at ground")
			end
		end	
		
		if table.index_of({"Occultist"}, TReX.s.class) then
			if defs == "deviltarot" then 
				if not table.contains({t.defs}, "deviltarot") then
					t.send("queue add eqbal fling devil at ground")
				end
			end
			if defs == "devilmark" then 
				if not table.contains({t.defs}, "devilmark") then
					if TReX.stats.karma > 2 then
						t.send("queue add eqbal devilmark")
					else
						if not table.contains(t.defs, defs) then
							TReX.defs.def_keepup_toggle(tostring(defs))
						end
							t.serverside.green_echo("Low Karma")
					end
				end
			end
			if defs == "astralvision" then 
				if not table.contains({t.defs}, "astralvision") then
					if TReX.stats.karma > 2 then
						t.send("queue add eqbal astralvision")
					else
						if not table.contains(t.defs, defs) then
							TReX.defs.def_keepup_toggle(tostring(defs))
						end
							t.serverside.green_echo("Low Karma")
					end				
				end
			end
			if defs == "simulacrum" then
				if not table.contains({t.defs}, "simulacrum") then
					if not table.contains({TReX.inv.inv}, "a simulacrum") and TReX.stats.karma > 2 then
						t.send("queue add eqbal simulacrum")
					end
				end
			end
			if defs == "heartstone" then
				if not table.contains({t.defs}, "heartstone") then
					if not table.contains({TReX.inv.inv}, "a heartstone") and TReX.stats.karma > 2 then
						t.send("queue add eqbal heartstone")
					end
				end
			end			
		end	

		if table.index_of({"Priest"}, TReX.s.class) then
			if defs == "fortify" then 
				TReX.defs.fortify_all()
			end
			if defs == "simultaneity" then
				TReX.defs.simultaneity_up()
			end
		end

		if table.index_of({"Sylvan"}, TReX.s.class) then
			if defs == "viridian" then
				TReX.defs.viridian_staff(defs)
			end
			if defs == "simultaneity" then
				TReX.defs.simultaneity_up()
			end
			if defs == "circulate" then 
				t.send("queue add eqbal cast circulate")
			end
			if defs == "reflections" then 
				t.send("queue add eqbal cast reflection at me")
			end
		end


		if table.index_of({"Sentinel","Druid"}, TReX.s.class) then

		TReX.defs.metamorphosis()
			
			if table.contains({"alertness","nightsight","stealth",}, defs) then
				for k,v in pairs(def_list.metamorphosis) do
					if table.contains({v}, defs) then
						if t.bals.bal and t.bals.eq then
							if TReX.defs.morph_check():lower() ~= k and TReX.serverside.am_functional() and TReX.serverside.full_balance() then
								t.send("morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check(), false) 
								t.bals.eq = false -- cheat
							end	
								table.insert(t.defs, defs)
								t.send("queue add eqbal "..defs.." on",false)
									break
						end
					end
				end
			end
			
			if defs == "vitality" then
				for k,v in pairs(def_list.metamorphosis) do
					--if table.contains({v}, defs) then
						if t.bals.bal and t.bals.eq then
							t.bals.eq = false -- cheat
								t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal "..defs)
								if not table.contains({t.defs}, defs) then
									table.insert(t.defs, defs)
								end
						end		
					--end
				end
			end
			
			if defs == "resistance" then
				for k,v in pairs(def_list.metamorphosis) do
					if table.contains({v}, defs) then
						if t.bals.bal and t.bals.eq then
							t.bals.eq = false -- cheat
								t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal "..defs)
								if not table.contains({t.defs}, defs) then
									table.insert(t.defs, defs)
								end
						 end		
					end
				end
			end

			if defs == "melody" then
				for k,v in pairs(def_list.metamorphosis) do
					if table.contains({v}, defs) then
						if t.bals.bal and t.bals.eq then
							t.bals.eq = false -- cheat
								t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal sing "..defs)
								if not table.contains({t.defs}, defs) then
									table.insert(t.defs, defs)
								end
						 end		
					end
				end
			end			

					
			if defs == "spinspear" then
				TReX.rewield(t.inv["spear"].id, "r")
					if not t.def.spinspear then
						t.send("queue add eqbal spin spear",false)
						table.insert(t.defs, defs)
					end
				
			end
			
		end


			if not table.index_of({"Sentinel","Druid"}, TReX.s.class) then
				if not table.contains({t.defs}, defs) then
					table.insert(t.defs, defs)
				end
			else
					if not table.contains({t.defs}, defs) then
						table.insert(t.defs, defs)
					end
				
			end
	
					if not t.def[defs] then
						t.def[defs]=true
					end
											
else		


		--if not table.contains({"drunkensailor","heartsfury","dodging","aria","spinspear","circulate","binding","boostedregeneration","fortify", "efreeti", "deviltarot"
		--					   ,"waterweird","hiding","flailingstaff","viridian","reflections","simultaneity","astralvision","simulacrum","heartstone","meditate"
		--					   ,"balancing","gripping","acrobatics","arrowcatching","alertness","telesense","heldbreath","metawake","groundwatch","skywatch","softfocusing"}, defs) then -- important line

			send("curing priority defence " .. defs .. " reset", false)
		--end

		--if defs == "meditate" then
			--t.serverside.red_echo("Meditate")
			--TReX.defs.reset_meditate()
		--end

		if defs=="gripping" then
			t.send("relax grip")
		end
		
		if defs == "vigilance" then 
			t.send("relax vigilance")
		end
				
		if table.index_of({"groundwatch","skywatch","hypersight","alertness","telesense","insomnia","softfocusing"}, defs) then
			if t.def[defs] then
				if defs == "softfocusing" then
					t.send("softfocus off")
				else
					t.send(defs.." off")
				end
			end
	    end	
			
			if defs == "metawake" then
				TReX.defs.metawake_down()
			end
			
			if defs == "selfishness" then
				if table.contains({t.defs}, "selfishness") then
					t.send("generosity")
				end
			end
			
			if defs == "heldbreath" then
				if table.contains({t.defs}, "heldbreath") then
					t.send("release")
				end
			end	
			
			if table.index_of({"Infernal"}, TReX.s.class) then
				if table.index_of({"vengeance"}, defs) then
					t.send("relax vengeance")
				end
			end	
			
		if table.index_of({"Bard","Jester"}, TReX.s.class) then
			if table.index_of({"acrobatics","arrowcatching","heartsfury","dodging","balancing"}, defs) then
					if table.contains(t.defs, defs) then
						TReX.defs.class_bard_down(defs)
					end
			end
			if table.index_of({"drunkensailor","heartsfury"}, defs) then
				if table.contains({t.defs}, defs) then
					TReX.defs.drunkensailor_heartsfury_down(defs)
				end
			end
		end			
			
				
		if table.index_of({"Magi"}, TReX.s.class) then
			if defs == "binding" then 
				TReX.defs.binding_off()
			end
			if defs == "fortify" then 
			 	TReX.defs.fortify_down()
			end
			if defs == "waterweird" then 
			 	TReX.defs.waterweird_down()
			end
			if defs == "efreeti" then 
				TReX.defs.efreeti_down()
			end
			if defs == "simultaneity" then
				TReX.defs.simultaneity_down()
			end
		end	

			if table.index_of({"Monk"}, TReX.s.class) then
				if defs == "boostedregeneration" then	
					t.send("relax regeneration")
				end
				if defs == "evadeblock" then	
					t.send("unblock evb")
				end
				if defs == "pinchblock" then	
					t.send("unblock pnb")
				end
			end
			
				if table.index_of({"Occultist"}, TReX.s.class) then
					if defs == "distortedaura" then	
						t.send("normalaura")
					end
		
				end
				
				 if table.index_of({"Sylvan"}, TReX.s.class) then
					if defs == "flailingstaff" then 
						t.send("queue add eqbal unwield " ..t.inv["staff"].id)
						TReX.rewield(t.inv["staff"].id, "x")
					end
					if defs == "binding" then 
						TReX.defs.binding_off()
					end
					if defs == "simultaneity" then
						TReX.defs.simultaneity_off()
					end

				end
				
				 if table.index_of({"Druid"}, TReX.s.class) then
					if defs == "flailingstaff" then 
						t.send("queue add eqbal unwield " ..t.inv["staff"].id)
						TReX.rewield(t.inv["staff"].id, "x")
					end
				end
				
				if table.index_of({"Sentinel","Druid"}, TReX.s.class) then
				TReX.defs.metamorphosis()
					if table.contains({"alertness","nightsight","stealth"}, defs) then
						for k,v in pairs(def_list.metamorphosis) do
							if table.contains({v}, defs) then
								if table.contains({t.defs}, defs) then
								
									if TReX.defs.morph_check():lower() ~= k and TReX.serverside.am_functional() and TReX.serverside.full_balance() then
										t.send("morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()) 
										t.bals.eq = false -- cheat
									end	
										table.remove(t.defs, table.index_of(t.defs, defs))
										t.send("queue add eqbal relax "..defs)
											break
									
								end
							end
						end
					end
					
					if defs == "melody" then
						if table.contains({t.defs}, defs) then
							table.remove(t.defs, table.index_of(t.defs, defs))
						end
					end					
					
					if defs == "spinspear" then
						if t.def.spinspear then
							t.send("queue add eqbal stop spinning")
							table.remove(t.defs, table.index_of(t.defs, defs))
						end
					end	
					
				end
				
					if table.contains({t.defs}, defs) then
						table.remove(t.defs, table.index_of(t.defs, defs))
					end
					
					if t.def[defs] then
						t.def[defs]=false
					end

			
end
	
	TReX.defs.display()
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.toggle ) ") end
	
end

TReX.defs.sort=function(defs)

defs_prio = defs_prio or 23
def_list = def_list or {}

		--parry
		--if t.serverside["settings"].parry then
		--	if not TReX.parry.on then
			--	TReX.parry.toggle("on")
		--	end
		--end

	-- if gmcp.Char.Status.name == "Nehmrah" then
		-- if TReX.s.class == "Bard" then
			-- if t.serverside["settings"].sys_loaded then
				-- if TReX.stats.e > (TReX.stats.maxe*.85) then
					-- if not table.contains({t.defs}, "acrobatics") then 
						-- t.send("acrobatics on") 
					-- end
				-- else
					-- if table.contains({t.defs}, "acrobatics") then
						-- table.remove(t.defs, table.index_of(t.defs, "acrobatics")) 
						-- t.send("acrobatics off")
					-- end
					-- --TReX.defs.def_keepup_toggle("acrobatics")
					-- --t.send("meditate")
				-- end
			-- end
		-- end
	-- end
		
		
-- adding to the t.defs table from TReX.defs.list.
TReX.defs.defs_sort(defs) 

if table.index_of({"Sylvan"}, TReX.s.class) then
	TReX.defs.viridian(defs)
end
				
if table.index_of({"Sylvan","Druid"}, TReX.s.class) then
	TReX.defs.vigour_panacea_wildgrowth(defs)		
end


		
if defs == "mass" then
	TReX.defs.mass()
end

		-- if table.index_of({"groundwatch","skywatch","hypersight","alertness","telesense","insomnia","softfocusing"}, defs) then
			-- if not t.def[defs] then
				-- if defs == "softfocusing" then
					-- --t.send("softfocus on")
					-- --cecho("<pink>softfocus on")
				-- else
					-- --t.send(defs.." on") same defence bug. echoing to test. 
					-- --cecho("<pink>"..defs.." on")
				-- end
			-- end
	    -- end	

		if table.index_of({"Bard","Jester"}, TReX.s.class) then
			if table.index_of({"acrobatics","arrowcatching","heartsfury","dodging","balancing"}, defs) then
					if not table.contains(t.defs, defs) then
						TReX.defs.class_bard_up(defs)
					end
			end
			if table.index_of({"drunkensailor","heartsfury"}, defs) then
				if not table.contains({t.defs}, defs) then
					TReX.defs.drunkensailor_heartsfury_up(defs)
				end
			end
		end			
		
		if table.index_of({"Bard"}, TReX.s.class) then
			if defs == "aria" then 
				if not table.contains(t.defs, "aria") then
					if t.bals.eq and t.bals.voice then
						t.send("queue prepend eq draw rapier##wield rapier left##auralbless me")
						t.send("queue add class sing aria at me")
					end
				end
			end
		end		
		
		if table.index_of({"Druid"}, TReX.s.class) then
			if defs == "bonding" then 
				if not table.contains({t.defs}, "bonding") then
					t.send("queue add eqbal bonding spirit")
				end
			end
		end

		if table.index_of({"Magi"}, TReX.s.class) then
			if defs == "binding" then 
				TReX.defs.binding_all()
			end
			if defs == "fortify" then
				TReX.defs.fortify_all()
			end
			if defs == "efreeti" then 
				TReX.defs.efreeti_up()
			end
			if defs == "waterweird" then 
				TReX.defs.waterweird_up()
			end
			if defs == "simultaneity" then
				TReX.defs.simultaneity_up()
			end
		end	
		
		if table.index_of({"Jester"}, TReX.s.class) then
			if defs == "deviltarot" then 
				if not table.contains({t.defs}, "deviltarot") then
					t.send("queue add eqbal fling devil at ground")
				end
			end
		end	
		
		if table.index_of({"Occultist"}, TReX.s.class) then
			if defs == "deviltarot" then 
				if not table.contains({t.defs}, "deviltarot") then
					t.send("queue add eqbal fling devil at ground")
				end
			end
			if defs == "devilmark" then 
				if TReX.stats.karma > 2 then
					if not table.contains({t.defs}, "devilmark") then
						t.send("queue add eqbal devilmark")
					end
				else
					if not table.contains(t.defs, defs) then
						TReX.defs.def_keepup_toggle(tostring(defs))
					end
						t.serverside.green_echo("Low Karma")
				end					
			end
			if defs == "astralvision" then 
				if not table.contains({t.defs}, "astralvision") then
					if TReX.stats.karma > 2 then
						t.send("queue add eqbal astralvision")
					else
						if not table.contains(t.defs, defs) then
							TReX.defs.def_keepup_toggle(tostring(defs))
						end
							t.serverside.green_echo("Low Karma")
					end						
				end
			end
			if defs == "simulacrum" then
				if not table.contains({t.defs}, "simulacrum") and TReX.stats.karma > 2 then
					if not table.contains({TReX.inv.inv}, "a simulacrum shaped like " ..gmcp.Char.Status.name) then
						t.send("queue add eqbal simulacrum")
					end
				end
			end
			if defs == "heartstone" then
				if not table.contains({t.defs}, "heartstone") then
					if not table.contains({TReX.inv.inv}, "a heartstone") and TReX.stats.karma > 2 then
						t.send("queue add eqbal heartstone")
					end
				end
			end
		end	

		if table.index_of({"Priest"}, TReX.s.class) then
			if defs == "fortify" then 
				TReX.defs.fortify_all()
			end
			if defs == "simultaneity" then
				TReX.defs.simultaneity_up()
			end
		end

		if table.index_of({"Sylvan"}, TReX.s.class) then

			-- testing this here
			if defs == "viridian" then 
				TReX.defs.viridian_staff(defs)
			end
			if defs == "simultaneity" then
				TReX.defs.simultaneity_up()
			end
			if defs == "circulate" then 
				t.send("queue add eqbal cast circulate")
			end
			if defs == "reflections" then 
				t.send("queue add eqbal cast reflection at me")
			end

		end

		if table.index_of({"Sentinel","Druid"}, TReX.s.class) then
		
		TReX.defs.metamorphosis()
		
			if table.index_of({"alertness","nightsight","stealth",}, defs) then
				for k,v in pairs(def_list.metamorphosis) do
		
					if table.contains({v}, defs) then
						if not table.contains({t.defs}, defs) then
							if TReX.defs.morph_check():lower() ~= k and TReX.serverside.am_functional() and TReX.serverside.full_balance() then
								t.send("morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check(), false) 
								t.bals.eq = false -- cheat
							end	
								table.insert(t.defs, defs)
								t.send("queue add eqbal "..defs.." on",false)
									break
						end
					end
				end
			end
			
			if defs == "vitality" then
				for k,v in pairs(def_list.metamorphosis) do
					if table.contains({v}, defs) then
						if not table.contains({t.defs}, defs) then
							if t.bals.bal and t.bals.eq then
								t.bals.eq = false -- cheat
									table.insert(t.defs, defs)
								t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal "..defs)

							end	
						end
					end
				end
			end
			
			if defs == "resistance" then
				for k,v in pairs(def_list.metamorphosis) do
					if table.contains({v}, defs) then
						if not table.contains({t.defs}, defs) then
							if t.bals.bal and t.bals.eq then
								t.bals.eq = false -- cheat
									table.insert(t.defs, defs)
								t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal "..defs)

							end	
						end
					end
				end
			end
			
			if defs == "melody" then
				for k,v in pairs(def_list.metamorphosis) do
					if table.contains({v}, defs) then
						if not table.contains({t.defs}, defs) then
							if t.bals.bal and t.bals.eq then
								t.bals.eq = false -- cheat
									table.insert(t.defs, defs)
								t.send("queue add eqbal morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check()..(TReX.config.cc or "##").."queue add eqbal sing "..defs)
							end	
						end
					end
				end
			end

			if defs == "spinspear" then
				TReX.rewield(t.inv["spear"].id, "r")
					if not t.def.spinspear then
						t.send("queue add eqbal spin spear",false)
						table.insert(t.defs, defs)
					end
				
			end
			
			
		end


			if not table.index_of({"Sentinel","Druid"}, TReX.s.class) then
				if not table.contains({t.defs}, defs) then
					table.insert(t.defs, defs)
				end
			else
				if not table.contains({t.defs}, defs) then
					table.insert(t.defs, defs)
				end
			end


		--failsafe
		if not t.def[defs] then
			t.def[defs]=true
		end
			

	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.sort ) ") end

end			


TReX.defs.reset=function()
-- new update

	for k,v in pairs(def_list.free) do
		if k ~= "meditate" then
			t.send("curing prio def "..k.." reset", false)
		end
	end

	for k,v in pairs(def_list.needs_full_bal) do
		if k ~= "meditate" then
			t.send("curing prio def "..k.." reset", false)
		end
	end

	for k,v in pairs(def_list.class) do
		if k ~= "meditate" then
			t.send("curing prio def "..k.." reset", false)
		end
	end

	for _,v in pairs(t.defs) do
		if v ~= "meditate" then
			t.send("curing prio def "..v.." reset", false)
		end
	end


	
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.reset ) ") end

end -- func


TReX.defs.defs2relax=function() -- and just replace this reset function with your current one.
-- new update

local ignore={"boartattoo","megalithtattoo","fireflytattoo","mosstattoo","feathertattoo","shieldtattoo","mindseyetattoo","hammertattoo","cloaktattoo","belltattoo"
,"crystaltattoo","moontattoo","starbursttattoo","boartattoo","webtattoo","tentacletattoo","hourglasstattoo","braziertattoo","prismtattoo","treetattoo","oxtattoo"
,"chameleontattoo","blindness","deafness"}

local defs2relax={"groundwatch","skywatch","alertness","nightsight","telesense","metawake","vigilance","hypersight","softfocusing"
					, "dodging","acrobatics", "arrowcatching","balancing","gripping","heartsfury","drunkensailor"-- Bard
					, "mindnet", "projectiles", "consciousness", "regeneration", "mindcloak" -- Monk
					, "waterwalking", "shinbinding", "retaliation"-- Blademaster
					, "weaving" -- Serpent
					, "vengeance", "blademastery" -- Infernal
					, "distortedaura", "devilmark" -- Occultist
				} 

	for k,v in pairs(def_list.free) do
		if table.contains({t.defs}, k) then
		if not table.contains({ignore}, k) then
				if table.contains({defs2relax}, k) then
					if not v.keepup then
						table.remove(t.defs, table.index_of(t.defs, k))
						send("curing prio def "..k.." reset", false)
						if k=="softfocusing" then
							send"relax softfocus"
						else
							send("relax "..k)
						end
					end
				end
		end
		end
			
	end

	for k,v in pairs(def_list.needs_full_bal) do
		--if k ~= "meditate" then
			if table.contains({t.defs}, k) then
				if not table.contains({ignore}, k) then
						if table.contains({defs2relax}, k) then
							if not v.keepup then
								table.remove(t.defs, table.index_of(t.defs, k))
								send("curing prio def "..k.." reset", false)							
								if k=="heldbreath" then
									send"release"
								else
									send("relax "..k)
								end
							end
						end
				end
			end
		--end
	end

	for k,v in pairs(def_list.class) do
		--if k ~= "meditate" then
			if table.contains({t.defs}, k) then
				if not table.contains({ignore}, k) then
						if table.contains({defs2relax}, k) then
							if not v.keepup then
								table.remove(t.defs, table.index_of(t.defs, k))
								send("curing prio def "..k.." reset", false)							
								if k=="arrowcatching" then
									send("relax arrowcatch")
								elseif k=="gripping" then
									send("relax grip")
								elseif k=="heartsfury" then
									send("queue add eqbal unstance")
								elseif k=="drunkensailor" then
									send("queue add eqbal unstance")									
								elseif k=="blademastery" then
									send("relax mastery")	
								elseif k=="waterwalking" then
									send("relax waterwalk")																
								elseif k=="shinbinding" then
									send("relax binding")
								elseif k=="retaliation" then
									send("retaliation off")	
								elseif k=="mindcloak" then
									send("mindcloak off")	
								elseif k=="distortedaura" then
									send("normalaura")
								elseif k=="devilmark" then
									send("wipe devilmark")	
								else
									send("relax "..k)
								end
							end
						end
				end
			end
		--end
	end

	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.reset ) ") end

end -- func

TReX.defs.def_display=function(def_table)

 if def_table == def_list.free then
	 cecho("<white>\n\tFree: \n")
 elseif def_table ==	def_list.needs_full_bal then
	  cecho("<white>\n\n\tBalance: \n")
 elseif def_table ==	def_list.class then
	  cecho("<white>\n\n\tClass Based: \n")
 end

  local sortDefs = {}
  local manaUse = {"kaitrance","shintrance","shinbinding","projectiles","dodging","mastery","boostedregeneration"
  ,"mindnet","reflexes","groundwatch","vigilance","treewatch","telesense","evadeblock", "pinchblock"
  ,"distortedaura","softfocusing","skywatch","hypersight","alertness","weaving","metawake"
  ,"balancing","arrowcatching","heartsfury","drunkensailor"}
  local endUse = {"spinspear","acrobatics"}
  
 
  -- sort defs
  for k,v in pairs(def_table) do
		if v.enabled then -- if I want it to show on my list.
			sortDefs[#sortDefs+1] = k
			table.sort(sortDefs)
		end
  end

  	local x = 0
 			 
	for i, n in ipairs(sortDefs) do
		x = x + 1

     		local d = "<dim_grey>[<white>"

		if table.index_of(t.defs, n) then

			if table.contains(manaUse, n) then
				d = d .. "<blue> m " -- uses mana
			elseif table.contains(endUse, n) then
				d = d .. "<yellow> e " -- uses mana
			else	
				d = d .. "<light_blue> + "
			end
				
		else
			d = d .. "<red> - "
		end
     		d = d .. "<dim_grey>]<white> " 

			if (x-1)%3 == 0 then
				echo("\n")
			end  
		

	   local nWithSpace = def_table[n].name:title() 

		if nWithSpace:len() < 25 and (x-1) %3~=2 then
			local pad = 25 - nWithSpace:len()
			nWithSpace = nWithSpace .. string.rep(" ", pad)
		elseif nWithSpace:len() > 25 then
			nWithSpace = nWithSpace:cut(25)
     	end
 
		local command
			fg("white")
			cecho(d)
	local command = [[TReX.defs.toggle("]]..n..[[")]]
		echoLink(nWithSpace, command, "Toggle " .. n, true)
	end

	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.defs.def_display ) ") end


end


TReX.defs.display=function()
cecho("\n\n<white>"..TReX.s.class.." Defences") echo("\n")
table_list = {
	def_list.free,
	def_list.needs_full_bal,
	def_list.class,
	}
	
	for index, def_table in pairs(table_list) do
		TReX.defs.def_display(def_table)
	end
	
		echo"\n\n"
		deletep=false
			if not table.contains({prompt_sent}, "sent") then
				table.insert(prompt_sent, "sent")
			end
		TReX.stats.custom_prompt()

end

	
-- [[ HARD DEFENCE TOGGLE ]]
-- toggles serverside defence defup off and on
TReX.defs.defence=function()
	if TReX.u.toBoolean(t.serverside["settings_default"].defences) then
		TReX.defs.reset()
		t.send("curing defences off")
		t.serverside["settings_default"].defences = "No"
		if (t.serverside["settings"].echos) then t.serverside.green_echo("<DarkSlateGrey>(<white>-<DarkSlateGrey>) <white>[ <DarkSlateGrey>DEFENCE <white>] ") end
	else
		TReX.defs.keepup()
		t.send("curing defences on")		
		t.serverside["settings_default"].defences = "Yes"
		if (t.serverside["settings"].echos) then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>[ <DarkSlateGrey>DEFENCE <green>] ") end
	end -- if
	
				
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.defence ) ") end
		
		
end -- func

TReX.defs.defs_sort=function(defs)

-- adding to the t.defs table from TReX.defs.list.
	if not table.contains({"acrobatics","arrowcatching","balancing","drunkensailor","heartsfury","melody","spinspear","circulate","binding","boostedregeneration","fortify", "efreeti", "deviltarot", "waterweird", "viridian", "reflections","simultaneity","astralvision","simulacrum","heartstone","meditate"}, defs) then
		if table.contains(def_list.free, defs) then
			if not table.index_of({"fireresist","coldresist","magicresist","electricresist"}, defs) then
				defs_prio=23
			end
		elseif table.contains({def_list.needs_full_bal}, defs) then
			if defs == "deathsight" then 
				TReX.defs.deathsight_add(defs) 
			else
				defs_prio=24
			end
		elseif table.contains({def_list.class}, defs) then
			defs_prio=25
		end
	end

TReX.defs.priorityQueue(defs, defs_prio)

end

-- [[Blindness Logic]]
-- [[THIS USES THE AFF TABLE to track and defup]]
TReX.defs.blindness=function()
	if not table.index_of(t.defs, "blindness") and not (t.affs.blindness) then
		if not table.index_of(t.defs, "blindness") then
			table.insert(t.defs, "blindness")
				if (t.class.sentinel) or (t.class.occultist) or (t.class.apostate) then
					t.send("curing priority defence blindness 3")
				else
					t.send("curing priority defence blindness 24")
				end
		end
	else
		if table.index_of(t.defs, "blindness") then
			table.remove(t.defs, table.index_of(t.defs, "blindness"))
			t.send("curing priority defence blindness reset")
			--if (t.serverside["settings"].echos) then t.serverside.red_echo("<DarkSlateGrey>(<red>-<DarkSlateGrey>) <red>[<DarkSlateGrey>Blindness<red>] ") end
		end
	end -- if
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.blindness ) ") end
end --[[func]]

-- [[Deafness Logic]]
TReX.defs.deafness=function()
	if not table.index_of(t.defs, "deafness") and not (t.affs.deafness) then
		if not table.index_of(t.defs, "deafness") then
			table.insert(t.defs, "deafness")
				if (t.class.sentinel) or (t.class.occultist) or (t.class.apostate) then
					t.send("curing priority defence deafness 2")
				else
					t.send("curing priority defence deafness 24")
				end
		end -- if
	else
		if table.index_of(t.defs, "deafness") then
			table.remove(t.defs, table.index_of(t.defs, "deafness"))
			t.send("curing priority defence deafness reset")
			--if (t.serverside["settings"].echos) then t.serverside.red_echo("<DarkSlateGrey>(<red>-<DarkSlateGrey>) <red>[<DarkSlateGrey>Deafness<red>] ") end
		end
	end -- if
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.deafness ) ") end
end -- func

-- [[RESTORE]]
t.restore=function() -- the is the restore call.
    enableTrigger("restore")
        if TReX.timer.restorewait then
           killTimer(tostring(TReX.timer.restorewait))--yeah
           TReX.timer.restorewait=nil 	
        end
                TReX.timer.restorewait = tempTimer(2, [[ TReX.timer.restorewait = nil ]])

					t.send("restore") -- t.sends restore.

			
-- if
				
	if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.restore ) ") end
                	
end -- func

t.restored=function() 

	if TReX.timer.restorewait then
		disableTrigger("restore")

	  	if not t.affs.blackout then
	   		if TReX.timer.restorewait then
	    		killTimer(tostring(TReX.timer.restorewait))
	    		TReX.timer.restorewait=nil
	    	end
	   			
	  	end -- if

 	end -- if

        if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.restored ) ") end

end -- func

-- [[RAGE]]
t.rage=function()
	if (t.serverside["settings"].rage) and t.stats.m > 500 and t.stats.w > 100 then
		if (t.bals.rage) and TReX.serverside.full_balance() and TReX.serverside.am_free() and TReX.serverside.am_capable() then
			t.send("cq eqbal"..cc.."queue add eqbal rage")
			t.bals.rage = false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.rage ) ") end
end -- func

-- [[RAGE BALANCE]]
TReX.defs.rage=function(balance)
	local balance = balance
		if balance then
			t.bals["rage"] = true
		else
			t.bals["rage"] = false
		end -- if
			if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.rage ) ") end
end -- func

-- [[RAGE]]
t.might=function()
	if (t.serverside["settings"].might) and t.bals.bal and t.bals.eq then
		if (t.bals.might) and TReX.serverside.am_free() and TReX.serverside.am_capable() and not t.affs.prone then
			if table.index_of({"Druid","Sentinel"}, TReX.s.class) then
				for k,v in pairs(def_list.metamorphosis) do
					if table.contains({v}, "might") then
						if TReX.defs.morph_check():lower() ~= k then
							t.send("morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check(), false)
							--t.bals.eq = false -- cheat								
						end	
							t.send("cq eqbal"..cc.."queue add eqbal might ",false)
							t.bals.might=false
							break

					end
				end
			end
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.rage ) ") end
end -- func

-- [[SHRUGGING]]
t.shrugging=function()
	if (t.serverside["settings"].shrugging) then
		if (t.bals.shrugging) and not t.affs.weariness and TReX.serverside.am_free() and TReX.serverside.am_capable() then
			send("cq eqbal"..cc.."queue add eqbal shrugging",false)
			t.bals.shrugging=false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.shrugging ) ") end
end -- func

-- [[FITNESS]]					
-- [[FITNESS]]					
t.fitness=function()
	if (t.serverside.settings.fitness) and (t.bals.fitness) and not (t.affs.weariness) then 
		for _,v in pairs({"Druid","Sentinel"}) do
			if TReX.s.class == v then
				for k,v in pairs(def_list.metamorphosis) do
					if table.contains({v}, "fitness") then
						if TReX.defs.morph_check():lower() ~= k then
							t.send("morph "..k..(TReX.config.cc or "##")..TReX.defs.sip_mana_check(), false)
							t.bals.eq = false -- cheat								
						end	
							t.send("fitness")
							t.bals.fitness = false
							break
					end
				 end	
			 end	
		 end
		 for _,v in pairs({"Runewarden","Infernal","Paladin","Blademaster","Monk"}) do
			if TReX.s.class == v then
					t.send("fitness")
					t.bals.fitness = false
					break
			end
		end-- if fitness
	end -- if
	if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.fitness ) ") end
end -- func

-- [[FOOL]]
t.fool=function()
	if (t.serverside["settings"].fool) then
		if (t.bals.fool) and TReX.serverside.full_balance() and TReX.serverside.am_free() and TReX.serverside.am_capable() then
			t.send("queue prepend eqbal outd fool"..(TReX.config.cc or "##").."queue add eqbal charge fool"..(TReX.config.cc or "##").."queue add eqbal fling fool at me")
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.fool ) ") end
end -- func

t.dragonheal=function()
	if (t.serverside["settings"].dragonheal) then
		if (t.bals.dragonheal) and TReX.serverside.full_balance() and t.stats.m >= 1500 and not (t.affs.weariness and t.affs.recklessness) and TReX.serverside.am_free() and TReX.serverside.am_capable() then
				t.send("cq eqbal"..cc.."queue add eqbal dragonheal")
				t.bals.dragonheal = false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.dragonheal ) ") end
end -- func

TReX.defs.dragonheal=function(balance)
local balance = balance
	if balance then
		t.bals["dragonheal"] = true
		if (t.serverside["settings"].echos) then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>[<DarkSlateGrey>Dragonheal<green>] ") end
	else
		t.bals["dragonheal"] = false
		if (t.serverside["settings"].echos) then t.serverside.red_echo("<DarkSlateGrey>(<red>-<DarkSlateGrey>) <red>[<DarkSlateGrey>Dragonheal<red>] ") end
	end -- if
 		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.dragonheal ) ") end
end -- func

t.bloodboil=function()
	if (t.serverside["settings"].bloodboil) then
		if (t.bals.bloodboil) and TReX.serverside.full_balance() and TReX.serverside.am_capable() and TReX.serverside.am_free() and not t.affs.haemophilia then
				t.send("cq eqbal"..cc.."queue add eqbal bloodboil")
				--t.bals.bloodboil = false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.bloodboil ) ") end
end -- func

TReX.defs.bloodboil=function(balance)
local balance = balance
	if balance then
		t.bals["bloodboil"] = true
		if (t.serverside["settings"].echos) then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>[<DarkSlateGrey>Bloodboil<green>] ") end
	else
		t.bals["bloodboil"] = false
		if (t.serverside["settings"].echos) then t.serverside.red_echo("<DarkSlateGrey>(<red>-<DarkSlateGrey>) <red>[<DarkSlateGrey>Bloodboil<red>] ") end
	end -- if
 		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.bloodboil ) ") end
end -- func

t.accelerate=function()
	if (t.serverside["settings"].accelerate) then -- two broken arms also blocks -- it cures 1-2 random affs
		if (t.bals.accelerate) and not t.affs.recklessness and TReX.serverside.am_capable() and TReX.serverside.am_free() then
				t.send("cq eqbal"..cc.."queue add eqbal accelerate",false)
				--t.send("queue prepend chrono accelerate", false)
				t.bals.accelerate = false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.accelerate ) ") end
end -- func

TReX.defs.accelerate=function(balance)
local balance = balance
	if balance then
		t.bals["accelerate"] = true
		if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>[<DarkSlateGrey>Accelerate<green>] ") end
	else
		t.bals["accelerate"] = false
		if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<red>-<DarkSlateGrey>) <red>[<DarkSlateGrey>Accelerate<red>] ") end
	end -- if
 		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.accelerate ) ") end
end -- func

t.daina = function()
	if (t.serverside["settings"].daina) then
		if (t.bals.daina) and TReX.serverside.full_balance() and TReX.serverside.am_capable() and TReX.serverside.am_free() and not t.affs.disloyalty then
				t.send("cq eqbal"..cc.."queue add eqbal invoke purification",false)
				t.bals.daina=false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.daina ) ") end
end -- func

TReX.defs.daina=function(balance)
local balance = balance
	if balance then
		t.bals["daina"] = true
		if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>[<DarkSlateGrey>Daina<green>] ") end
	else
		t.bals["daina"] = false
		if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<red>-<DarkSlateGrey>) <red>[<DarkSlateGrey>Daina<red>] ") end
	end -- if
 		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.daina ) ") end
end -- func

t.alleviate=function()
	if (t.serverside["settings"].alleviate) then
		if (t.bals.alleviate) and TReX.serverside.am_functional() and TReX.serverside.am_free() then
				t.send("cq eqbal"..cc.."queue add eqbal alleviate")
				t.bals.alleviate=false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.alleviate ) ") end
end -- func

t.extrusion=function()
	if (t.serverside["settings"].extrusion) then
		if (t.bals.extrusion) and TReX.serverside.am_functional() and TReX.serverside.am_free() then
				t.send("cq eqbal"..cc.."queue add eqbal terran extrusion")
				t.bals.extrusion=false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.extrusion ) ") end
end -- func

t.purify=function()
	if (t.serverside["settings"].purify) then
		if (t.bals.purify) and TReX.serverside.am_functional() and TReX.serverside.am_free() then
				t.send("cq eqbal"..cc.."queue add eqbal purify")
				t.bals.purify=false
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.purify ) ") end
end -- func

TReX.defs.alleviate=function(balance)
local balance = balance
	if balance then
		--t.bals["alleviate"] = true
		if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>[<DarkSlateGrey>Alleviate<green>] ") end
	else
		--t.bals["alleviate"] = false
		if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<red>-<DarkSlateGrey>) <red>[<DarkSlateGrey>Alleviate<red>] ") end
	end -- if
end -- func

t.salt=function()
	if (t.serverside["settings"].salt) then
		if (t.bals.salt) and TReX.serverside.full_balance() and TReX.serverside.am_free() and not t.affs.stupidity then
			t.send("cq eqbal"..cc.."queue add eqbal educe salt",false)
		end -- if
	end
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.salt ) ") end
end -- func

TReX.defs.salt=function(balance)
local balance = balance
	if balance then
		t.bals["salt"] = true
		if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<green>+<DarkSlateGrey>) <green>[<DarkSlateGrey>Salt<green>] ") end
	else
		t.bals["salt"] = false
		if t.serverside["settings"].echos then t.serverside.green_echo("<DarkSlateGrey>(<red>-<DarkSlateGrey>) <red>[<DarkSlateGrey>Salt<red>] ") end
	end -- if
 		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( TReX.defs.salt ) ") end
end -- func

TReX.defs.focus_swap=function(swap)
local swap = swap
	if not (swap) then
		if TReX.serverside.equilibrium() then
			if t.serverside["settings_default"].focus_over_herbs ~= tostring("No") then
				t.send("curing focus second") 
				t.serverside["settings_default"].focus_over_herbs = tostring("No")	-- too keep from spamming over and over		
				if t.serverside["settings"].echos then t.serverside.red_echo("<red>[<DarkSlateGrey>Herbs\t<red>>\t<DarkSlateGrey>Focus<red>] ") end
			end
		end
	else
		if TReX.serverside.equilibrium() then
			if t.serverside["settings_default"].focus_over_herbs ~= tostring("Yes") then		
				t.send("curing focus first") 
				t.serverside["settings_default"].focus_over_herbs = tostring("Yes") -- too keep from spamming over and over
				if t.serverside["settings"].echos then t.serverside.green_echo("<green>[<DarkSlateGrey>Focus\t<green>>\t<DarkSlateGrey>Herbs<green>] ") end
			end
		end
	end -- [[if]]	
		if t.serverside["settings"].debugEnabled then TReX.debugMessage(" ( t.focus ) ") end
end -- func

TReX.serverside.focusblockcheck=function()
	for _,i in pairs(misc_cure_table["focus"].blocks) do   -- check affliction blocks before using.
		if t.affs[i] then 
			for k, v in pairs(TReX.prios.default) do	 								-- iterate through defsault table
					if TReX.prios.current[k] ~= TReX.prios.default[k] then				-- check against defsault table.
						if not table.index_of({"brokenleftleg","brokenrightleg","damagedleftleg","damagedrightleg","mangledleftleg","mangledrightleg"
							,"brokenleftarm","brokenrightarm","damagedleftarm","damagedrightarm","mangledleftarm","mangledrightarm"
							,"mildtrauma","serioustrauma"
							,"concussion","mangledhead","damagedhead"},k) then
								
								TReX.prios.switchPrios(k,TReX.prios.default[k])
								
						end

					end
			
			end
				if isPrompt() then 
					t.serverside.red_echo("focus blocked by " ..i) 
					return true 
				end
		end
			return false
	end
end

TReX.defs.def_defup_toggle=function(def)

	if table.contains({def_list.free}, def) then
		if not table.contains(t.defs, def) then
			for k,v in pairs(def_list.free) do
				if k == def then
					if v.serverside then
						def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.free[def].keepup, ["defup"] = true, ["serverside"] = true, ["enabled"] = true,}
					else
						def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.free[def].keepup, ["defup"] = true, ["serverside"] = false, ["enabled"] = true,}
					end -- if
				end	-- if
			end -- for
		else
			for k,v in pairs(def_list.free) do
				if k == def then
					if v.serverside then
						def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.free[def].keepup, ["defup"] = false, ["serverside"] = true, ["enabled"] = true}
					else
						def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.free[def].keepup, ["defup"] = false, ["serverside"] = false, ["enabled"] = true}
					end	 -- if
				end -- if
			end -- for
		end -- if
	end -- if

	if table.contains({def_list.needs_full_bal}, def) then
		if not table.contains(t.defs, def) then
			for k,v in pairs(def_list.needs_full_bal) do
				if k == def then
					if v.serverside then
						def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.needs_full_bal[def].keepup, ["defup"] = true, ["serverside"] = true, ["enabled"] = true,}
					else
						def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.needs_full_bal[def].keepup, ["defup"] = true, ["serverside"] = false, ["enabled"] = true,}
					end -- if
				end	-- if
			end -- for
		else
			for k,v in pairs(def_list.needs_full_bal) do
				if k == def then
					if v.serverside then
						def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.needs_full_bal[def].keepup, ["defup"] = false, ["serverside"] = true, ["enabled"] = true,}
					else
						def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.needs_full_bal[def].keepup, ["defup"] = false, ["serverside"] = false, ["enabled"] = true,}
					end -- if
				end -- if	
			end -- for
		end -- if
	end -- if

	if table.contains({def_list.class}, def) then
		if not table.contains(t.defs, def) then
			for k,v in pairs(def_list.class) do
				if k == def then
					if v.serverside then
						def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.class[def].keepup, ["defup"] = true, ["serverside"] = true, ["enabled"] = true,}
					else
						def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.class[def].keepup, ["defup"] = true, ["serverside"] = false, ["enabled"] = true,}
					end -- if
				end	-- if
			end -- for
		else
			for k,v in pairs(def_list.class) do
				if k == def then
					if v.serverside then
						def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.class[def].keepup, ["defup"] = false, ["serverside"] = true, ["enabled"] = true}
					else
						def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = def_list.class[def].keepup, ["defup"] = false, ["serverside"] = false, ["enabled"] = true}
					end	 -- if
				end -- if
			end -- for
		end -- if
	end -- if
	
		t.file[TReX.s.class:lower()] = def_list  -- very important leave, updates class file on current defence settings
		TReX.defs.alias_toggle(def) -- toggles the information in the menu
		TReX.defs.defup_current() -- calls the clickable toggle menu		
	
end -- func

TReX.defs.def_keepup_toggle=function(def)

	if table.contains({def_list.free}, def) then
		if not table.contains(t.defs, def) then
			for k,v in pairs(def_list.free) do
				if k == def then
					if v.serverside then
						def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.free[def].defup, ["serverside"] = true, ["enabled"] = true,}
					else
						def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.free[def].defup, ["serverside"] = false, ["enabled"] = true,}
					end -- if
				end	-- if
			end -- for
		else
			for k,v in pairs(def_list.free) do
				if k == def then
					if v.serverside then
						def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.free[def].defup, ["serverside"] = true, ["enabled"] = true}
					else
						def_list.free[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.free[def].defup, ["serverside"] = false, ["enabled"] = true}
					end -- if
				end -- if
			end -- for
		end -- if
	end -- if

	if table.contains({def_list.needs_full_bal}, def) then
		if not table.contains(t.defs, def) then
			for k,v in pairs(def_list.needs_full_bal) do
				if k == def then
					if v.serverside then
						def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.needs_full_bal[def].defup, ["serverside"] = true, ["enabled"] = true,}
					else
						def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.needs_full_bal[def].defup, ["serverside"] = false, ["enabled"] = true,}
					end -- if
				end	 -- if
			end -- for
		else
			for k,v in pairs(def_list.needs_full_bal) do
				if k == def then
					if v.serverside then
						def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.needs_full_bal[def].defup, ["serverside"] = true,  ["enabled"] = true}
					else
						def_list.needs_full_bal[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.needs_full_bal[def].defup, ["serverside"] = false, ["enabled"] = true}
					end -- if
				end	-- if
			end -- for
		end -- if
	end -- if

	if table.contains({def_list.class}, def) then
		if not table.contains(t.defs, def) then
			for k,v in pairs(def_list.class) do
				if k == def then
					if v.serverside then
						def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.class[def].defup, ["serverside"] = true, ["enabled"] = true,}
					else
						def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = true, ["defup"] = def_list.class[def].defup, ["serverside"] = false, ["enabled"] = true,}
					end	-- if
				end	-- if		
			end -- for
		else
			for k,v in pairs(def_list.class) do
				if k == def then
					if v.serverside then
						def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.class[def].defup, ["serverside"] = true, ["enabled"] = true}
					else
						def_list.class[tostring(def)] = {["name"] = tostring(def), ["keepup"] = false, ["defup"] = def_list.class[def].defup, ["serverside"] = false, ["enabled"] = true}
					end	-- if
				end -- iff
			end -- for
		end -- if
	end -- if
		
		TReX.defs.alias_toggle(def) -- toggles the information in the menu
		t.file[TReX.s.class:lower()] = def_list  -- very important leave, updates class file on current defence settings

		
			--if not table.index_of({"meditate","rebounding","selfishness","heldbreath",""}, def) then
				--TReX.defs.keepup_current() -- calls the clickable toggle menu	
			--end
				
				
end -- func

TReX.defs.priorityQueue=function(defs, defs_prio)
	local table_list = {

			def_list.free,
			def_list.needs_full_bal,
			def_list.class, 
			
			}

		
	if not table.index_of({"aria","deathsight","melody","spinspear","circulate","binding","boostedregeneration","fortify", "efreeti", "deviltarot", "waterweird", "viridian", "reflections","simultaneity","astralvision","simulacrum","heartstone","meditate"}, defs) then
		for index, def_table in pairs(table_list) do
			--if defs_prio > 23 then 
				if table.contains({def_table}, defs) then
					--fail safe
					if table.index_of({"Sentinel","Druid"}, TReX.s.class) then
						if not table.index_of({"alertness","nightsight","stealth","vitality","resistance"}, defs) then
						--	if not t.def[defs] then
							if not table.contains({t.defs}, defs) then
								t.send("curing priority defence "..defs.." "..defs_prio)
							end
						end 
					else
						--if not t.def[defs] then
						if not table.contains({t.defs}, defs) then
							t.send("curing priority defence "..defs.." "..defs_prio)
						end
					end
				end
		end
	end
end

TReX.defs.sip_mana_check=function(mode, limb, enemy)
	if TReX.stats.m < TReX.stats.maxm then
		if t.bals.sip then
			return "sip mana "
		end
	end
			return " "
end

TReX.defs.morph_check=function()
if table.index_of({"Druid","Sentinel"}, TReX.s.class) then
	if gmcp.Char.Vitals then
		for k, v in pairs(gmcp.Char.Vitals.charstats) do
				if v:starts("Morph:") then 
					_, TReX.stats["morph"] = v:match("^Morph: (%w+)")
					return v:match("^Morph: (%w+)")
				end 
		end
	else
		return nil
	end
end
	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.serverside.sunlight_check ) ") end
end

TReX.defs.metamorphosis=function()

	def_list.metamorphosis={
		["squirrel"]={["powers"]={"forage"--[[,"dig"]]}, ["enabled"]=false},
		["wildcat"]={["powers"]={--[["alertness",]]--[["nightsight",]]"scratch"},["enabled"]=false},
		["wolf"]={["powers"]={--[["bite",]]--[["fitness",]]"howl",--[["nightsight",]]--[["scent",]]}, ["enabled"]=false},
		["turtle"]={["powers"]={"fluidswim","snap"}, ["enabled"]=false},
		--["jackdaw"]={["powers"]={-[["fly"]],--[["land"]]}, ["enabled"]=false},
		--["cheetah"]={["powers"]={--[["alertness"]],--[["bite"]],--[["fitness"]],--[["leap"]],--[["nightsight"]],--[["scent"]],--[["sprint"]]}, ["enabled"]=false},
		--["owl"]={["powers"]={--[["fly",]]--[["land",]]--[["nightsight",]]--[["spy",]]--[["swoop",]]} ["enabled"]=false},
		--["cheetah"]={["powers"]={--[["alertness",]]--[["claw",]]--[["elusiveness",]]--[["fitness",]]--[["leap",]]--[["nightsight",]]--[["scent",]]"stealth"}, ["enabled"]=false},
		--["eagle"]={["powers"]={--[["fly",]]--[["land",]]--[["nightsight",]]--[["scanarea",]]--[["spy",]]--[["swoop",]]--[["traverse",]]--[["view"]]}, ["enabled"]=false},
		--["gopher"]={["powers"]={--[["burrow"]],--[["dig",]]--[["sniff"]]}, ["enabled"]=false},
		["sloth"]={["powers"]={"rest"}, ["enabled"]=false},
		["bear"]={["powers"]={--[["alertness",]]--[["block",]]--[["scent",]]"shred",--[["vitality",]]}, ["enabled"]=false},
		["nightingale"]={["powers"]={--[["fly",]]--[["land",]]"melody"}, ["enabled"]=false},
		["elephant"]={["powers"]={"block",--[["fitness",]]"stampede","trumpet","yank",--[["vitality"]]}, ["enabled"]=false},
		["wolverine"]={["powers"]={"burrow","dig","claw",--[["elusiveness",]]--[["nightsight"]]"sniff","spring"}, ["enabled"]=false},
		["jaguar"]={["powers"]={--[["alertness",]]"ambush",--[["elusiveness",]]"fitness",--[["leap",]]--[["maul",]]--[["might",]]--[["nightsight",]]"dismember",--[["resistance",]]--[["scent",]]--[["sprint",]]--[["stealth",]]--[["vitality"]]}, ["enabled"]=false},
		["icewyrm"]={["powers"]={--[["alertness",]]"icebreath","maul","might","scent","sprint","temperance","vitality"}, ["enabled"]=false},
		["eagle"]={["powers"]={"fly","hoist","land","nightsight","scanarea","spy","swoop","track","traverse","view"}, ["enabled"]=false},
		["gorilla"]={["powers"]={"alertness","pound","leap","swinging"}, ["enabled"]=false},
		["basilisk"]={["powers"]={"bite","elusiveness","flame","gaze","resistance","stealth","petrify"}, ["enabled"]=false},
		
							}
end

TReX.defs.metawake_up=function()
	if not table.contains({t.defs}, "metawake") then
		t.send("queue add eqbal metawake on")
	end
end

TReX.defs.metawake_down=function()
	if table.contains({t.defs}, "metawake") then
		t.send("metawake off")
	end
end

TReX.defs.insomnia_up=function()
	if not t.def.insomnia then
		t.send("cq eqbal"..cc.."queue add eqbal insomnia")
	end
end

TReX.defs.mass=function()
	if not t.inv["shackle"] then
		if not table.contains({t.defs}, "mass") then
			if not t.def["mass"] then -- double measure?
				t.send("curing priority defence mass 23")
			end
		end	
	end
end

TReX.defs.class_bard_up=function(defs)
	if not table.contains({t.defs},def) then
		if defs == "arrowcatching" then	
			t.send("queue add eqbal arrowcatch on")
		elseif defs == "heartsfury" then	
			t.send("queue add eqbal heartsfury")
		else
			t.send("queue add eqbal "..defs.." on")
		end
	end
end

TReX.defs.drunkensailor_heartsfury_up=function(defs)
	if not table.contains({t.defs},def) then
		t.send("queue add eqbal "..defs)
	end
end

TReX.defs.class_bard_down=function(defs)
	if table.contains({t.defs},def) then
		if defs == "arrowcatching" then	
			t.send("queue add eqbal arrowcatch off")
		elseif defs == "heartsfury" then	
			t.send("queue add eqbal unstance")
		else
			t.send("queue add eqbal "..defs.." off")
		end
	end
end

TReX.defs.drunkensailor_heartsfury_down=function(defs)
	if table.contains({t.defs},def) then
		t.send("queue add eqbal unstance "..defs)
	end
end

TReX.defs.viridian=function(defs)
	if tonumber(TReX.stats.sunlight) >= 500 then
		defs_prio=25
	else
		defs_prio="reset"
		if table.contains(t.defs, defs) then
			TReX.defs.def_keepup_toggle(tostring(defs))
		end
	end
end

TReX.defs.viridian_staff=function(defs)
	if not table.contains({t.defs}, "viridian") then
		if not t.serverside["settings"].paused then
			TReX.config.pause()
		end					
		t.send("queue add eqbal assume viridian staff")
	end
end

TReX.defs.vigour_panacea_wildgrowth=function(defs)
	if defs == "vigour" then
		if tonumber(TReX.stats.sunlight) >= 300 then
			defs_prio=25
		else
			defs_prio="reset"
			if table.contains(t.defs, defs) then
				TReX.defs.def_keepup_toggle(tostring(defs))
			end
		end
	end
	if defs == "panacea"  then
		if tonumber(TReX.stats.sunlight) >= 250 then
			defs_prio=25
		else
			defs_prio="reset"
			if table.contains(t.defs, defs) then
				TReX.defs.def_keepup_toggle(tostring(defs))
			end
		end
	end
	if defs == "wildgrowth" then
		if tonumber(TReX.stats.sunlight) >= 200 then
			defs_prio=25
		else
			defs_prio="reset"
			if table.contains(t.defs, defs) then
				TReX.defs.def_keepup_toggle(tostring(defs))
			end
		end
	end
end

-- TReX.defs.binding_on=function()
	-- if not table.contains({t.defs}, "binding") then
		-- t.send("binding on")
	-- end
-- end

TReX.defs.binding_off=function()
	if table.contains({t.defs}, "binding") then
		t.send("queue add eqbal binding off")
	end
end

TReX.defs.binding_all=function()
	if not table.contains({t.defs}, "binding") then
		t.send("queue add eqbal binding all")
	end
end

TReX.defs.fortify_all=function()
	if not table.contains({t.defs}, "fortify") then
		t.send("queue add eqbal fortify all")
	end
end
TReX.defs.efreeti_up=function()
	if not table.contains({t.defs}, "efreeti") then
		t.send("queue add eqbal cast efreeti")
	end
end
TReX.defs.waterweird_up=function()
	if not table.contains({t.defs}, "waterweird") then
		t.send("queue add eqbal cast waterweird") 
	end
end
TReX.defs.simultaneity_up=function()
	if not table.contains({t.defs}, "simultaneity") then
		t.send("queue add eqbal simultaneity")
	end
end

TReX.defs.fortify_down=function()
	if table.contains({t.defs}, "fortify") then
		t.send("queue add eqbal fortify off")
	end
end
TReX.defs.efreeti_down=function()
	if table.contains({t.defs}, "efreeti") then
		t.send("queue add eqbal dismiss efreeti")
	end
end
TReX.defs.waterweird_down=function()
	if table.contains({t.defs}, "waterweird") then
		t.send("queue add eqbal dismiss waterweird") 
	end
end
TReX.defs.simultaneity_down=function()
	if table.contains({t.defs}, "simultaneity") then
		t.send("queue add eqbal sever all")
	end
end

if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.defences loaded successfully) ") end
TReX.defs.save()

for _, file in ipairs(TReX.defs) do
	dofile(file)
end -- for
