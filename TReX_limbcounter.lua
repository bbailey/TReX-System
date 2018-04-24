-- my limbcounter

debugEnabled						= false 					-- hard debugs -- programmer echos
local send							= send
local cc							= TReX.config.cc or "`" --change to be the character used for concatenation


TReX								= TReX or {}
TReX.lc								= TReX.lc or {}
TReX.math							= TReX.math or {}


TReX.lc.reset = function()
TReX.lc.targettinglimbs = false
TReX.lc.damageRightLeg = 0
TReX.lc.rightLegPrepped = false
TReX.lc.damageLeftLeg = 0
TReX.lc.leftLegPrepped = false
TReX.lc.damageRightArm =  0
TReX.lc.rightArmPrepped = false
TReX.lc.damageLeftArm =  0
TReX.lc.leftArmPrepped = false
TReX.lc.damageTorso =  0
TReX.lc.torsoPrepped = false
TReX.lc.damageHead =  0
TReX.lc.headPrepped = false
TReX.lc.breakpoint =  6
TReX.lc.damageSlice = TReX.lc.damageSlice or 1
TReX.lc.damagePrep = TReX.lc.damagePreP or 1
TReX.lc.limbdam = "none"
target = target or "none"
TReX.lc.targetMaxHealth = TReX.lc.targetMaxHealth or 3300
t.serverside.green_echo("Limb Damage Reset")
end


TReX.lc.limb_reset = function(limb)

local limb = limb

if limb == "hh" then
		TReX.lc.damageHead = 0
		TReX.lc.headPrepped = false
		t.serverside.green_echo("Head damage reset")
		TReX.lc.displayLC()
		
elseif limb == "tt" then
		TReX.lc.damageTorso = 0
		t.serverside.green_echo("Torso damage reset")
		TReX.lc.torsoPrepped = false
		
elseif limb == "ll" then
		TReX.lc.damageLeftLeg = 0
		TReX.lc.leftLegPrepped = false
		t.serverside.green_echo("Left Leg damage reset")
		
elseif limb == "rl" then
		TReX.lc.damageRightLeg = 0
		TReX.lc.rightLegPrepped = false
		t.serverside.green_echo("Right Leg damage reset")
		
elseif limb == "la" then
		TReX.lc.damageLeftArm = 0
		t.serverside.green_echo("Left Arm damage reset")
		TReX.lc.leftArmPrepped = false
		
elseif limb == "ra" then
		TReX.lc.damageRightArm = 0
		t.serverside.green_echo("Right Arm damage reset")
		TReX.lc.rightArmPrepped = false
		
end
end

TReX.lc.adjust_bkp = function(bkp)

TReX.lc.breakpoint = tonumber(bkp)
t.serverside.green_echo("Break threshold set to " .. TReX.lc.breakpoint)


end

TReX.lc.slice = function(p)

	if TReX.lc.limbdam == "head" then
		TReX.lc.damageHead = TReX.lc.damageHead + TReX.lc.damageSlice
		if TReX.lc.damageHead<TReX.lc.breakpoint-1 then headcolor="<green>" end
		if TReX.lc.damageHead >= TReX.lc.breakpoint-1 then TReX.lc.headPrepped=true headcolor="<red>" end
		cecho("\n<white>Head Count: ["..headcolor..""..TReX.lc.damageHead .."<white>]")

	elseif TReX.lc.limbdam == "torso" then
		TReX.lc.damageTorso = TReX.lc.damageTorso + TReX.lc.damageSlice
		if TReX.lc.damageTorso<TReX.lc.breakpoint-1 then torsocolor="<green>" end
		if TReX.lc.damageTorso >= TReX.lc.breakpoint then TReX.lc.torsoPrepped=true torsocolor="<red>" end
		cecho("\n<white>Torso Count: ["..torsocolor..""..TReX.lc.damageTorso .."<white>]")	
	
	elseif TReX.lc.limbdam == "leftleg" then
		TReX.lc.damageLeftLeg = TReX.lc.damageLeftLeg + TReX.lc.damageSlice
		if TReX.lc.damageLeftLeg<TReX.lc.breakpoint-1 then leftlegcolor="<green>" end
		if TReX.lc.damageLeftLeg >= TReX.lc.breakpoint then TReX.lc.leftLegPrepped=true leftlegcolor="<red>" end
		cecho("\n<white>Left Leg Count: ["..leftlegcolor..""..TReX.lc.damageLeftLeg .."<white>]")	
	
	elseif TReX.lc.limbdam == "rightleg" then
		TReX.lc.damageRightLeg = TReX.lc.damageRightLeg + TReX.lc.damageSlice
		if TReX.lc.damageRightLeg<TReX.lc.breakpoint-1 then rightlegcolor="<green>" end
		if TReX.lc.damageRightLeg >= TReX.lc.breakpoint then TReX.lc.rightLegPrepped=true rightlegcolor="<red>" end
		cecho("\n\n<white>Right Leg Count: ["..rightlegcolor..""..TReX.lc.damageRightLeg .."<white>]")	
		
	elseif TReX.lc.limbdam == "leftarm" then
		TReX.lc.damageLeftArm = TReX.lc.damageLeftArm + TReX.lc.damageSlice
		if TReX.lc.damageLeftArm<TReX.lc.breakpoint-1 then leftarmcolor="<green>" end
		if TReX.lc.damageLeftArm >= TReX.lc.breakpoint then TReX.lc.leftArmPrepped=true leftarmcolor="<red>" end
		cecho("\n\n<white>Left Arm Count: ["..leftarmcolor..""..TReX.lc.damageLeftArm .."<white>]")

		
	elseif TReX.lc.limbdam == "rightarm" then
		TReX.lc.damageRightArm = TReX.lc.damageRightArm + TReX.lc.damageSlice
		if TReX.lc.damageRightArm<TReX.lc.breakpoint-1 then rightarmcolor="<green>" end
		if TReX.lc.damageRightArm >= TReX.lc.breakpoint then TReX.lc.rightArmPrepped=true rightarmcolor="<red>" end
		cecho("\n\n<white>Right Arm Count: ["..rightarmcolor..""..TReX.lc.damageRightArm .."<white>]")				
	else end

end


TReX.lc.missed = function(p)
	if TReX.lc.limbdam == "head" then
		TReX.lc.damageHead = TReX.lc.damageHead - TReX.lc.damageSlice
	elseif TReX.lc.limbdam == "torso" then
		TReX.lc.damageTorso = TReX.lc.damageTorso - TReX.lc.damageSlice
	elseif TReX.lc.limbdam == "leftleg" then
		TReX.lc.damageLeftLeg = TReX.lc.damageLeftLeg - TReX.lc.damageSlice
	elseif TReX.lc.limbdam == "rightleg" then
		TReX.lc.damageRightLeg = TReX.lc.damageRightLeg - TReX.lc.damageSlice
	elseif TReX.lc.limbdam == "leftarm" then
		TReX.lc.damageLeftArm = TReX.lc.damageLeftArm - TReX.lc.damageSlice
	elseif TReX.lc.limbdam == "rightarm" then
		TReX.lc.damageRightArm = TReX.lc.damageRightArm - TReX.lc.damageSlice
	else end
end


TReX.lc.hit_landed_check=function(n, p)

	if (n=="The attack rebounds back onto you!") then
		t.serverside.green_echo(target:title() .. " !! REBOUNDING !!")
			return
	elseif string.starts(n,"Using a heavy tremolo you brutally punish") then	
			return
	elseif string.starts(n,"The reflective barrier surrounding ") then	
			return
	elseif string.starts(n,"A bell-like tone rings out from your songblessed rapier,") then	
			return
	elseif string.starts(n,"A reflection of") then
			return
	elseif string.starts(n,"A chaos orb intercepts the attack") then
			return
	elseif string.ends(n,"dodges nimbly out of the way.") then
			return
	elseif string.ends(n,"parries the attack with a deft manoeuvre.") then
			return
	elseif string.ends(n,"steps into the attack, grabs your arm, and throws you violently to the ground.") then
			return
	elseif string.ends(n,"knocking your blow aside before viciously countering with a strike to your head.") then
			return
	elseif string.ends(n,"quickly jumps back, avoiding the attack.") then
			return
	elseif string.ends(n,"body out of harm's way.") then
			return
	elseif string.ends(n,"rebounds back onto you!") then
			return
	elseif string.ends(n,"blinks out of existence.") then
			return
	elseif string.starts(n,"As your attack falls") then
			return

	else

		TReX.lc.slice(p)
	
	end
end
 
TReX.lc.assess = function(focus)
	t.send("queue add eqbal assess " .. t.target)
end


TReX.lc.assess_info = function(number) 
 
local approx = 1

breakpoints = { 
{health = 2860, breakpoint = 8},
{health = 3500, breakpoint = 9},
{health = 3740, breakpoint = 9},
{health = 4114, breakpoint = 10}, 
{health = 4269, breakpoint = 10},
{health = 4512, breakpoint = 10},
{health = 4963, breakpoint = 11}, 
{health = 5199, breakpoint = 11}, 
{health = 5992, breakpoint = 12},
{health = 6346, breakpoint = 12},
{health = 6877, breakpoint = 12},
{health = 6957, breakpoint = 12},
{health = 7652, breakpoint = 14},
{health = 7806, breakpoint = 14}, 
{health = 9410, breakpoint = 15},
{health = 10051, breakpoint = 16},
}

weaponname = "a Soulpiercer"

for i = 1, #breakpoints, 1 do
	if math.abs(breakpoints[i].health - number) <= math.abs(breakpoints[approx].health-number) then
		approx = i
	end
end

healthpoint = approx
TReX.lc.targetMaxHealth = number
TReX.lc.breakpoint =  breakpoints[healthpoint].breakpoint

tremolodamage = math.ceil( breakpoints[healthpoint].breakpoint * .60)

TReX.lc.damageSlice = 1
cecho("\n<yellow>"..target:title().." <white>Breakpoint: "..TReX.lc.breakpoint)
disableTrigger("Assess")

end

TReX.lc.salve = function(focus, limb)

local focus = focus 
local limb = limb


--print(focus)
--print(limb)

 
if focus == target then
	if limb == "legs" then
		if TReX.lc.damageLeftLeg >= TReX.lc.breakpoint then

				TReX.lc.damageLeftLeg = 0
				TReX.lc.leftLegPrepped = false
				t.serverside.green_echo(t.target:title().. " HEALED LEFT LEG.")
				return true

		elseif TReX.lc.damageRightLeg >= TReX.lc.breakpoint then

				TReX.lc.damageRightLeg = 0
				TReX.lc.rightLegPrepped = false
				t.serverside.green_echo(t.target:title().. " HEALED RIGHT LEG.")
				return true

		else end
	elseif limb == "arms" then
		if TReX.lc.damageLeftArm >= TReX.lc.breakpoint then

				TReX.lc.damageLeftArm = 0
				TReX.lc.leftArmPrepped = false
				t.serverside.green_echo(t.target:title().. " HEALED LEFT ARM.")
				return true

		elseif TReX.lc.damageRightArm >= TReX.lc.breakpoint then

				TReX.lc.damageRightArm = 0
				TReX.lc.rightArmPrepped = false			
				t.serverside.green_echo(t.target:title().. " HEALED RIGHT ARM.")
				return true

		else end
	elseif limb == "head" then
		if TReX.lc.damageHead >= TReX.lc.breakpoint then

				TReX.lc.damageHead = 0
				TReX.lc.headPrepped = false
				t.serverside.green_echo(t.target:title().. " HEALED HEAD.")
				return true

		else end
	elseif limb == "torso" then
		if TReX.lc.damageTorso >= TReX.lc.breakpoint then

				TReX.lc.damageTorso = 0
				TReX.lc.torsoPrepped = false
				t.serverside.green_echo(t.target:title().. " HEALED TORSO.")
				return true

		else end
	else
		return false
	end
else
end


end

TReX.math.round = function(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.50) / mult
end


TReX.lc.reset()

--save serverside file
TReX.save = function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_limbcounter.lua"
   table.save(savePath, TReX)
end -- func

--load serverside file
TReX.load = function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_limbcounter.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX)
	end -- if
end -- func

for _, file in ipairs(TReX) do
	dofile(file)
end -- for