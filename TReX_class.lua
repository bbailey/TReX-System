-- TReX.prios
-- TReX Class Tracking
-- Priority tracking

local send							= send
local cc							= TReX.config.cc or "##"

--- notes to remember tomorrow.. fix dissapearing class enabled value
--- check on t.stacks not loading right.. again.. 

--save offense file
TReX.class.save=function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_class.lua"
   table.save(savePath, TReX.class)
end -- func

--load offense file
TReX.class.load=function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_class.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.class)
	end -- if
end -- func

TReX.class.set=function(a, b, aff) -- this is the function throwing an error

t.target = ""

local a = tostring(a)
local b = b or t.target
local aff = tostring(aff)

	-- enable class im fighting
	if not (t.class[a].enabled) then
		TReX.class.reset()
		t.class[a].enabled = true
			tempTimer(15, [[TReX.class.reset() t.serverside.green_echo("Reset Enemy Class")]])
	end

		--soft target
		if t.target~=b then
			TReX.tgt.soft(b)
		end
	
		--class check
		TReX.class[a](aff) 

end

TReX.class.reset=function()

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
	"air",
	"water", -- purify, active skill
	"fire",
	"earth", -- extrusion syn. 'terran extrustion'
}

-- configure t.class = {}
for k,v in ipairs(t.class.list) do
	t.class[v] = {check = TReX.class[v], enabled = false}
end

for k,v in ipairs(t.class.list) do
	t.class[v].enabled = false 
	if TReX.prios.current[k] ~= TReX.prios.default[k] then
		TReX.prios.switchPrios(k,TReX.prios.default[k])
	end
end

end -- [[func]]

--for install
TReX.class.skill_set=function()

class_skill = {

["alchemist"] = {["salt"]=false,},
["dragon"] = {["dragonform"]=false,},
["monk"] = {["fitness"]=false,},
["occultist"] = {["tarot"]=false,},
["sentinel"] = {["might"]=false, ["fitness"]=false,},
["depthswalker"] = {["accelerate"]=false,},
["serpent"] = {["shrugging"]=false,},
["runewarden"] = {["fitness"]=false,},
["infernal"] = {["fitness"]=false,},
["paladin"] = {["fitness"]=false,},
["blademaster"] = {["fitness"]=false, ["alleviate"]=false,},
["druid"] = {["might"]=false, ["fitness"]=false,},
["magi"] = {["bloodboil"]=false,},
["shaman"] = {["daina"]=false,},
["jester"] = {["tarot"]=false,},
["water"] = {["purify"]=false,},
["earth"] = {["extrusion"]=false,},
["fire"] = {[""]=false,},
["air"] = {[""]=false,},


}

end


-- for login and class switch
TReX.class.skill_check=function()

if t.serverside.settings.sys_loaded then

class_skill = {

["alchemist"] = {["salt"]=class_skill.alchemist.salt or false},
["dragon"] = {["dragonheal"]=class_skill.dragon.dragonheal or false,},
["monk"] = {["fitness"]=class_skill.monk.fitness or false,},
["occultist"] = {["tarot"]=class_skill.occultist.tarot or false,},
["sentinel"] = {["might"]=class_skill.sentinel.might or false, ["fitness"]=class_skill.sentinel.fitness or false,},
["druid"] = {["might"]=class_skill.druid.might or false, ["fitness"]=class_skill.druid.fitness or false,},
["depthswalker"] = {["accelerate"]=class_skill.depthswalker.accelerate or false,},
["serpent"] = {["shrugging"]=class_skill.serpent.shrugging or false,},
["runewarden"] = {["fitness"]=class_skill.runewarden.fitness or false,},
["infernal"] = {["fitness"]=class_skill.infernal.fitness or false,},
["paladin"] = {["fitness"]=class_skill.paladin.fitness or false,},
["blademaster"] = {["fitness"]=class_skill.blademaster.fitness or false, ["alleviate"]=class_skill.blademaster.alleviate or false,},
["druid"] = {["might"]=class_skill.sentinel.might or false, ["fitness"]=class_skill.sentinel.fitness or false,},
["magi"] = {["bloodboil"]=class_skill.magi.bloodboil or false,},
["shaman"] = {["daina"]=class_skill.shaman.daina or false,},
["jester"] = {["tarot"]=class_skill.jester.tarot or false,},
["water"] = {["purify"]=class_skill.water.tarot or false,},
["air"] = {[""]=class_skill.water.tarot or false,},
["earth"] = {["extrusion"]=class_skill.water.tarot or false,},
["fire"] = {[""]=class_skill.water.tarot or false,},

}


	for k,v in pairs(class_skill) do 
		for p,j in pairs(class_skill[k]) do 
			if TReX.s.class:lower()==k then
				t.serverside.settings[p]=j
			else
				t.serverside.settings[p]=nil
			end				
		end
	end


end

end



TReX.prios.managePrios=function()

  	cecho("\n\t<white>[<MediumSpringGreen>TReX<white>]: Priority list\n\n", false)

  for item,num in TReX.config.spairs(TReX.prios.current, function(t,a,b) return t[b] < t[a] end) do

   		echo(" ")
        cechoLink("<dim_grey>[ <light_blue>+<dim_grey> ]", [[TReX.prios.shuffleUp("]]..item..[[",]]..num..[[)]], "shuffle " .. item .. " up.", true)
        echo(" ")
        cechoLink("<dim_grey>[ <red>-<dim_grey> ]", [[TReX.prios.shuffleDown("]]..item..[[",]]..num..[[)]], "shuffle " .. item .. " down.", true)
        resetFormat()
        cecho(" <dim_grey>[ <white>"..num.."<dim_grey> ] <gray>" .. item .. " \n")  --dark_orchid

  end


end

TReX.prios.shuffleDown=function(item, num)

	TReX.prios.default[item]=tonumber(num-1)
	send("curing priority "..item.." "..tonumber(num-1))
	--TReX.config.saveSettings()
	TReX.prios.managePrios()

end

TReX.prios.shuffleUp=function(item, num)

	TReX.prios.default[item]=tonumber(num+1)
	t.send("curing priority "..item.." "..tonumber(num+1))
	--TReX.config.saveSettings()
	TReX.prios.managePrios()

end

TReX.prios.login_reset=function()
	if not TReX.prios.default then
		TReX.prios.default_settings()
	end

	for k,v in pairs(TReX.prios.default) do
		send("curing priority " .. k .. " " .. tostring(v), false)
		TReX.prios.current[k] = TReX.prios.default[k]
	end
end
	
TReX.prios.affPrioRestore=function(aff)
	if TReX.prios.current[aff] ~= TReX.prios.default[aff] then
		TReX.prios.switchPrios(aff, TReX.prios.default[aff])
	end
end
	
TReX.prios.reset=function()
	for k,v in pairs(TReX.prios.default) do
		if TReX.prios.current[k] ~= TReX.prios.default[k] then
			send("curing priority " .. k .. " " .. tostring(v), false)
		end
		TReX.prios.current[k] = TReX.prios.default[k]
	end
end
  
TReX.prios.switchPrios=function(aff, pos, x)


	if TReX.prios.current[aff] ~= pos then
		send("curing priority "..aff.." "..pos)
		TReX.prios.current[aff] = pos
			if x == 1 and TReX.prios.current[aff] ~= tonumber(pos) then 
				
				if t.serverside["settings"].echos then t.serverside.red_echo(""..aff:upper().." <red>[<white>"..tonumber(pos).."<red>]") end
			end

	end
		
		if t.serverside["settings"].debugEnabled then 
			--if isPrompt() then 
				t.serverside.red_echo(" "..aff:upper().." <white>( <red>prio swap <white>)") 
			--end 
		end
	
	
end
 
TReX.prios.affPrioChanged=function( aff, pos )
	if pos == 1 or pos == 2 or pos == 8 then
		TReX.prios.current[aff] = tonumber(pos)
	else
		TReX.prios.switchPrios( aff, pos )
	
	end
end

TReX.prios.affPrioRestore=function( aff )

if not TReX.prios.default then -- fail safe
	TReX.prios.default_settings()
end

for k,v in pairs(t.class.list) do 
	if t.class[v].enabled then
		if TReX.prios.current[aff] ~= TReX.prios[v][aff] then 
			t.send("curing priority "..aff.." "..TReX.prios.default[aff])
			TReX.prios.current[aff] = TReX.prios.default[aff]
		end
	end
end	

	if TReX.prios.current[aff] ~= TReX.prios.default[aff] then 
		t.send("curing priority "..aff.." "..TReX.prios.default[aff])
		TReX.prios.current[aff] = TReX.prios.default[aff]
	end
	
end

if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.class loaded successfully) ") end

TReX.class.save()

for _, file in ipairs(TReX.class) do
	dofile(file)
end -- for
