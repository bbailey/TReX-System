-- TReX.tgt
-- Targeting
local send                          = send
local cc                            = TReX.config.cc or "##"

--save tgt file
TReX.tgt.save=function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
        _sep = "/"
    else
        _sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_tgt.lua"
   table.save(savePath, TReX.tgt)
end -- func

--load tgt file
TReX.tgt.load=function()
if (string.char(getMudletHomeDir():byte()) == "/") then
        _sep = "/"
    else 
        _sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_tgt.lua"
    if (io.exists(savePath)) then
        table.load(savePath, TReX.tgt)
    end -- if
end -- func

--[[soft store variable target]]
TReX.tgt.soft=function(n)
local n = n or t.target 
  
	if huntVar.on then
		expandAlias("hsave") -- hunting save
		huntToggle("off") -- hunting off
	end
  
	
	--aggrolist = aggrolist or {}
	
	--if not(keyfind(aggrolist, n)) then
	
	--aggrolist[n] = os.clock() + 300
	
	
	
	--end
	
	
  
  
    t.target = n
    
    if target~=n then
        t.serverside.myecho(t.target:upper(),"orange","white")
    end
    
end

--[[manual target 1v1]]
TReX.tgt.target=function(n)
if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.target )") end
      
	if huntVar.on then
		expandAlias("hsave") -- hunting save
		huntToggle("off") -- hunting off
	end
	
	TReX.tgt.set("", n)
	--TReX.tgt.echo(n)
	
end

-- ex:1 
--[['if TReX.tgt.isTarget(matches[2]) then 
        t.send'swing axe' 
        end']] 

-- ex:2 
--[[TReX.pinshot=function(n)
        if n==nil then 
            n=target 
        end
        if TReX.isTarget(n) then
            TReX.a("pinshot")
        end
        
            TReX.pinshot_name=n
            TReX.pinshot_countdown=34
            enableTimer("Pinshot_Timer")
            
    end]] 

TReX.tgt.echo=function(what,command,popup)

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.tgt.echo  )") end

t.serverside.cmd_prompt = getLineCount()
    what = "<peru:dark_slate_blue>[<white>†<peru:dark_slate_blue>]<reset><white> " .. what
    -- apply newline if required
    moveCursorEnd("main")
    if getCurrentLine() ~= "" then what = "\n"..what.."\n" end
    if command then
        cechoLink(what, command, popup or "", true)
    else
        cecho("\n"..what.."\n")
    end
    
end

TReX.tgt.set=function(matches2, matches3)

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.tgt.set  )") end

    if matches2 == "follow" then
        if matches3 == "on" then
            TReX.tgt.follow = true
            TReX.tgt.echo("Target following <"..TReX.tgt.onColour..">ENABLED<white>, leader is: "..(t.raid.leader or "unknown"))
        
        elseif matches3 == "off" then
            TReX.tgt.follow = false
            TReX.tgt.echo("Target following <"..TReX.tgt.offColour..">DISABLED")
            
        else
            TReX.tgt.follow = true
            t.raid.leader = matches3:lower():title()
            TReX.tgt.echo("Target following <"..TReX.tgt.onColour..">ENABLED<white>, leader changed to: "..t.raid.leader)

        end
        
    elseif matches3 == "on" then
        TReX.tgt.ptecho = false
        TReX.tgt.echo("Target echoing to PT <"..TReX.tgt.onColour..">ENABLED")
        
    elseif matches3 == "off" then
        TReX.tgt.ptecho = true
        TReX.tgt.echo("Target echoing to PT <"..TReX.tgt.offColour..">DISABLED")
    elseif matches3 then
        if target ~= matches3:lower():title() then
			t.target = matches3:lower():title()
			target = matches3:lower():title()
			TReX.tgt.echo("TARGET: "..target)
	
        else
            TReX.tgt.echo("Target Remains: "..target)
			t.target = t.target or ""
				if t.target:lower():title()~= target then
					t.target = target
				end
        end
	
    else
        local techo = ""
        local tfollow = ""
        if TReX.tgt.ptecho then techo = "ON" else techo = "OFF" end
        if TReX.tgt.follow then tfollow = "ON" else tfollow = "OFF" end 
        TReX.tgt.echo(string.format("%-16s"," PT Echo: "..techo)..cc.."\t\t\tTarget: "..(matches3:lower()):title().." ")
        TReX.tgt.echo(string.format("%-16s","  Follow: "..tfollow)..cc.."\t\t\tLeader: "..t.raid.leader.." ")
        
    end

end

TReX.tgt.highlight=function()

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.tgt.highlight  )") end

    if TReX.tgt.low then killTrigger(TReX.tgt.low) end
    if TReX.tgt.high then killTrigger(TReX.tgt.high) end
    if TReX.tgt.plus then killTrigger(TReX.tgt.plus) end
    
    TReX.tgt.low = tempRegexTrigger("\\b"..t.target:lower().."\\b", string.format([[selectString(t.target:lower(),1) fg("MediumSpringGreen") resetFormat()]]) )
    TReX.tgt.high = tempRegexTrigger("\\b"..t.target:lower():title().."\\b", string.format([[selectString(t.target:lower():title(),1) fg("MediumSpringGreen") resetFormat()]]) )

end

if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.tgt loaded successfully) ") end

TReX.tgt.save()

for _, file in ipairs(TReX.tgt) do
    dofile(file)
end -- for