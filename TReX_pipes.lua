-- TReX.pipes
-- Pipe Handling

local send              = send
local cc              = TReX.config.cc or "##"

TReX.pipes.save=function()
  if string.char(getMudletHomeDir():byte()) == "/" then
    _sep = "/"
    else
    _sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_pipes.lua"
   table.save(savePath, TReX.pipes)
end -- func

TReX.pipes.load=function()
  if string.char(getMudletHomeDir():byte()) == "/"
   then _sep = "/"
    else _sep = "\\"
     end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_pipes.lua"
   if (io.exists(savePath)) then
   table.load(savePath, TReX.pipes)
  end -- if
end -- func

TReX.pipes.settings=function()

-- this is the pipes filelook
TReX.pipes.names           = {"valerian", "skullcap", "elm"}
TReX.pipes.empties         = {}
t.pipes.refill             = t.pipes.refill or 3

  TReX.pipes.valerian = {lit = false, id = 0,  arty = false, puffs = 0, filledwith = "valerian", maxpuffs = 10}
  TReX.pipes.valerian = TReX.pipes.valerian

  TReX.pipes.elm = {lit = false, id = 0,  arty = false, puffs = 0, filledwith = "elm", maxpuffs = 10}
  TReX.pipes.elm = TReX.pipes.elm

  TReX.pipes.skullcap = {lit = false, id = 0, arty = false, puffs = 0, filledwith = "skullcap", maxpuffs = 10}
  TReX.pipes.skullcap = TReX.pipes.skullcap
    
    if not (t.serverside["settings"].paused) or (t.affs.stun) or (t.affs.aeon) then
        t.send("queue add eqbal pipelist", false)
    elseif t.serverside.settings.paused then
       TReX.config.display("Can't set pipes\t-\tSystem PAUSED ")
    elseif t.affs.aeon then
       TReX.config.display("Can't set pipes\t-\tYou are in AEON ")
    elseif t.faffs.stun then
       TReX.config.display("Can't set pipes\t-\tYou are STUNNED ")	  
    end -- if
    
        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.pipes.settings ) ") end
      
end -- func

-- parses any pipes on my person into a list in a table.
TReX.pipes.parseplist=function()

  local pipenames = {
    ["slippery elm"]                = "elm",
    ["a valerian leaf"]             = "valerian",
    ["a skullcap flower"]           = "skullcap",
    ["a pinch of ground malachite"] = "skullcap",
    ["a pinch of realgar crystals"] = "valerian",   
    ["a pinch of ground cinnabar"]  = "elm",

  }

  local short_names = {
    ["slippery elm"]                = "elm",
    ["a valerian leaf"]             = "valerian",
    ["a skullcap flower"]           = "skullcap",
    ["a pinch of ground malachite"] = "malachite",
    ["a pinch of realgar crystals"] = "realgar",
    ["a pinch of ground cinnabar"]  = "cinnabar",
  }

  local id     = tonumber(matches[3])
  local herb   = pipenames[matches[4]]
  local puffs  = tonumber(matches[5])
  local status = matches[2]

  if not (id and herb and puffs and status) then return end

  local filled,lit,arty,puffskey, maxpuffs
  
    TReX.pipes[herb].id = id
    TReX.pipes[herb].herb = herb
    TReX.pipes[herb].puffs = puffs
    TReX.pipes[herb].status = status

    filled = "filledwith"
    lit = "lit"
    arty = "arty"
    puffskey = "puffs"
    maxpuffs = "maxpuffs"

  TReX.pipes[herb][arty] = false
  TReX.pipes[herb][filled] = short_names[matches[4]]
  
if status == "out" then
  TReX.pipes[herb][lit] = false
elseif status == "lit" then
  TReX.pipes[herb][lit] = true
elseif status == "artf" then
  TReX.pipes[herb][arty] = true
end -- if
  
  TReX.pipes[herb][puffskey] = puffs

  if TReX.pipes[herb].filled == "empty" then
		if herb == "elm" then
			send("queue prepend eqbal outr " ..TReX.pipes[herb].herb..cc.."put " ..TReX.pipes[herb].herb.." in " ..TReX.pipes[herb].id)
		else	
			t.send("queue prepend eqbal outr " ..TReX.pipes[herb].herb..cc.."put " ..TReX.pipes[herb].herb.." in " ..TReX.pipes[herb].id)
		end
  elseif TReX.pipes[herb].puffs < tonumber(t.pipes.refill) then
    
    if not (table.index_of(TReX.toggle, "paused")) then
    
      send("curing priority defence selfishness reset", false)  
      send("queue prepend eqbal empty " ..TReX.pipes[herb].id)
      send("queue prepend eqbal outr " ..TReX.pipes[herb].herb)
      send("queue prepend eqbal put " ..TReX.pipes[herb].herb.." in " ..TReX.pipes[herb].id)
    
    else  
  
      TReX.config.display(" cant relight pipes - system paused.")
    
    end

  end -- if
  
  -- assume it's a 20 puff pipe if the puffs we have atm is over 10 (bigger than normal)
  if TReX.pipes[herb].puffs > 10 then
    TReX.pipes[herb][maxpuffs] = 20
    if t.serverside["settings"].echos then TReX.serverside.echo(" ") end
    if t.serverside["settings"].echos then TReX.serverside.echo("(a 20-puff pipe)") end
  end  -- if
 
  if not (TReX.pipes[herb][arty]) and not (TReX.pipes[herb][lit]) then    
		send("queue prepend eq light " ..TReX.pipes[herb].id)
		TReX.pipes[herb][lit] = true
  
    if t.serverside["settings"].debugEnabled then debugMessage("( TReX.pipes.parseplist )") end  -- if
  
  end  -- if
     
      if (t.serverside["settings"].debugEnabled) then TReX.debugMessage(" ( TReX.pipes.settings ) ") end

end   -- func

-- parses any empty pipes on my person into a list in a table.
TReX.pipes.parseplistempty=function()
  local id = tonumber(matches[3])
  local status = matches[2]
  if not (id and status) then return end

  -- save the data, to later assign the pipes to herbs
  TReX.pipes.empties[#TReX.pipes.empties+1] = {id = id, arty = (status == "artf" and true or false), status = status, filledwith = "empty"}
end -- func

--parselist parses, this is the end of parselist
TReX.pipes.parseplistend=function()
  -- fill up at least one of each first
  for id = 1, #TReX.pipes.names do
    local i = TReX.pipes.names[id]
  
    if TReX.pipes[i] and TReX.pipes[i].id == 0 and next(TReX.pipes.empties) then
      TReX.pipes[i].id = TReX.pipes.empties[#TReX.pipes.empties].id
      if TReX.pipes.empties[#TReX.pipes.empties].status == "Lit" then
        TReX.pipes[i].lit = true
      else
        TReX.pipes[i].lit = false
      end -- if

      if TReX.pipes.empties[#TReX.pipes.empties].arty then
        TReX.pipes[i].arty = true
      end -- if

      TReX.pipes.empties[#TReX.pipes.empties] = nil
    end -- if
  end -- for

  -- debug echos
  if t.serverside["settings"].debugEnabled then TReX.debugMessage("( TReX.pipes.parseplist )")  end
  
end -- func

-- checks the number of uses left in the pipe and if the count is less that three then it will auto refill the pipes
-- enables my pipes to be full at all times and not run out, enabling an easy lock from an affliction based class.
TReX.pipes.refill=function(herb)
if not TReX.pipes then
	TReX.pipes.settings()
end

local herb = herb

TReX.pipes.skullcap.puffs = TReX.pipes.skullcap.puffs or 0
TReX.pipes.elm.puffs = TReX.pipes.elm.puffs or 0
TReX.pipes.valerian.puffs = TReX.pipes.valerian.puffs or 0

if herb == tostring("realgar") or herb == tostring("valerian") then
	TReX.pipes.valerian.puffs = TReX.pipes.valerian.puffs - 1
		if t.serverside["settings"].echos then t.serverside.green_echo(" "..herb:title().." (" ..TReX.pipes.valerian.puffs..") puffs left") end
elseif herb == tostring("slippery elm") or herb == tostring("cinnabar") then
	if herb == tostring("slippery elm") then herb = tostring("elm") end
	TReX.pipes.elm.puffs = TReX.pipes.elm.puffs - 1
		if t.serverside["settings"].echos then t.serverside.green_echo(" "..herb:title().." (" ..TReX.pipes.elm.puffs.. ") puffs left") end
elseif herb == tostring("skullcap") or herb == tostring("malachite") then
	TReX.pipes.skullcap.puffs = TReX.pipes.skullcap.puffs - 1
		if t.serverside["settings"].echos then t.serverside.green_echo(" "..herb:title().." (" ..TReX.pipes.skullcap.puffs..") puffs left") end
end 
     if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( skullcap refill )") end
end -- func

-- empty out pipes
TReX.pipes.epipes=function()
		
        send("queue add eqbal generosity", false)
		send("curing priority defence selfishness reset", false)  
        send("queue add eqbal empty " ..TReX.pipes.valerian.id)
        send("queue add eqbal empty " ..TReX.pipes.elm.id)
        send("queue add eqbal empty " ..TReX.pipes.skullcap.id)
   
    -- debug echos
  if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.pipes.epipes )")  end
  
end

-- checks status of the pipes
TReX.pipes.pipefull=function()

  if multimatches[2][2] == tostring("a pinch of realgar crystals") or multimatches[2][2] == tostring("a valerian leaf") then
    TReX.pipes.valerian.puffs = 10
  end -- if
  
  if multimatches[2][2] == tostring("slippery elm") or multimatches[2][2] == tostring("a pinch of ground cinnabar") then
    TReX.pipes.elm.puffs = 10
  end -- if
  
  if multimatches[2][2] == tostring("a skullcap flower") or multimatches[2][2] == tostring("a pinch of ground malachite") then
    TReX.pipes.skullcap.puffs = 10
  end -- if

  -- debug echos
  if t.serverside["settings"].debugEnabled then TReX.debugMessage("( TReX.pipes.pipefull )")  end
  
end -- func

TReX.pipes.relight=function(herbout)

  local pipenames = {
    ["slippery elm"]                = "elm",
    ["a valerian leaf"]             = "valerian",
    ["a skullcap flower"]           = "skullcap",
    ["a pinch of ground cinnabar"]  = "cinnabar",
    ["a pinch of realgar crystals"] = "realgar",
    ["a pinch of ground malachite"] = "malachite"
  }
  
--TReX.pipes.herb = tostring(pipenames[herbout])

local herb  = tostring(pipenames[herbout])
--print(herbout)
  if herb == tostring("realgar") or herb == tostring("valerian") then
    puffs = TReX.pipes.valerian.puffs
  end -- if
  
  if herb == tostring("elm") or herb == tostring("cinnabar") then
    puffs = TReX.pipes.elm.puffs
  end -- if
  
  if herb == tostring("skullcap") or herb == tostring("malachite") then
    puffs = TReX.pipes.skullcap.puffs
  end -- if
  
if table.contains({pipenames}, herbout) then
  if (t.bals.bal) then
    if not (t.serverside["settings"].paused) or (t.affs.stun) or (t.affs.aeon) then 
      if herb == tostring("malachite") or herb == tostring("skullcap") then
        t.send("queue prepend eqbal light " .. TReX.pipes.skullcap.id)
      else
       t.send("queue prepend eqbal light " .. herb)
      end
    else
      TReX.config.display("Cant relight pipes\t-\tSystem Paused.")
    end  -- if
  end -- if
  
  if t.serverside["settings"].echos then t.serverside.green_echo(herb.." ("..puffs..") puffs left", false) end
  
  -- debug echos
  if t.serverside["settings"].debugEnabled then TReX.debugMessage("( TReX.pipes )") end
  
end 

end -- func

TReX.pipes.save()
TReX.pipes.load()

for _, file in ipairs(TReX.pipes) do
  dofile(file)
end -- for

