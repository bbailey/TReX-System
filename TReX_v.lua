-- TReX.v
-- Vitals tracking

local send							= send
local cc							= TReX.config.cc or "##"

local sipMaxHealth					= 1  --// 0 		= use average, 1 		= use max
local sipMaxMana					= 1  --// 0 		= use average, 1 		= use max
local mossHealthDiff				= 15 --// set to percentage below sipHeath threshold to use moss/potash, recommended 10 to 15
local mossManaDiff					= 15 --// set to percentage below sipMana threshold to use moss/potash, recommended 10 to 15

TReX.pingList=TReX.pingList or {}

registerAnonymousEventHandler("DataSendRequest",     	"TReX.addPing")
registerAnonymousEventHandler("gmcp.Char.Vitals",		"TReX.v.eventhandler")
registerAnonymousEventHandler("TReX lost bal",			"TReX.bals.update")
registerAnonymousEventHandler("TReX gained bal",		"TReX.bals.update")

--save v file
TReX.v.save=function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_v.lua"
   table.save(savePath, TReX.v)
end -- func

--load v file
TReX.v.load=function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_v.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.v)
	end -- if
end -- func

TReX.v.sip_full_health=function()
	if TReX.stats.h < TReX.stats.maxh then
		if t.bals.sip then
			t.send("queue prepend eqbal sip health",false)
		end
			tempTimer(.2, [[
				if TReX.stats.h >= TReX.stats.maxh then
					t.serverside.green_echo("full health")
				--else
					--TReX.v.sip_full_health()
				end
				]])
	end

	if TReX.stats.m < TReX.stats.maxm then
		if t.bals.sip then
			t.send("queue prepend eqbal sip mana",false)
		end
			tempTimer(.2, [[
				if TReX.stats.m >= TReX.stats.maxm then
					t.serverside.green_echo("full mana")
				--else
					--TReX.v.sip_full_health()
				end
				]])
	end
end

TReX.v.eventhandler=function()

if t.serverside["settings"].installed then


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


	-------------------------------------------------------------------------
	-- BALANCE TRACKING -----------------------------------------------------
	-------------------------------------------------------------------------

		if not (TReX.u.toBoolean(gmcp.Char.Vitals.bal)) then
			raiseEvent("TReX lost bal", "bal")
		end

		if TReX.u.toBoolean(gmcp.Char.Vitals.bal) then
			raiseEvent("TReX gained bal", "bal")
		end

	----------------------------------------------------------------------------
	-- EQUILIBRIUM TRACKING-----------------------------------------------------
	----------------------------------------------------------------------------

		if not (TReX.u.toBoolean(gmcp.Char.Vitals.eq)) then
			raiseEvent("TReX lost bal", "eq")
		end

		if TReX.u.toBoolean(gmcp.Char.Vitals.eq) then
			raiseEvent("TReX gained bal", "eq")
		end

	-------------------------------------------------------------------------
	-- VOICE TRACKING -------------------------------------------------------
	-------------------------------------------------------------------------

	if TReX.s.class == "Bard" then
	 	if not (table.contains(gmcp.Char.Vitals.charstats, "Voice: Yes")) then
	 		raiseEvent("TReX lost bal", "voice")
		end
	
		if TReX.u.toBoolean(gmcp.Char.Vitals.voice) then
			raiseEvent("TReX gained bal", "voice")
		end	
	end
	
	
end

end

TReX.bals.entity_bal_check=function()
	for _, stat in ipairs(gmcp.Char.Vitals.charstats) do 
		if stat:starts("Entity:") then 
			t.bals["entity"] = tostring(stat:match("^Entity: (%w+)"))
			
			if t.bals.entity == "Yes" then
				return true
			else 
				return false
			end
			
		end 
			
	end
end

TReX.bals.update=function(event, arg)
	if event:find("gained bal") then
		t.bals[arg] = true  	
	else
		t.bals[arg] = false     

	end
end

--return my ping
TReX.myPing=function()
  return TReX.averageListResult(TReX.pingList)
end

TReX.addPing=function ()
  table.insert(TReX.pingList, 1, getNetworkLatency())
  if #TReX.pingList > 10 then
    table.remove(TReX.pingList, 11)
  end
end

TReX.averageListResult=function (l)
  local i = #l
  local acc = 0
  for k,v in pairs(l) do
    acc = acc + v
  end --for
  return acc / i
end

if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.v loaded successfully) ") end

TReX.v.save()

for _, file in ipairs(TReX.v) do
	dofile(file)
end -- for