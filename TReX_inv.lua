-- TReX.inv
-- Inventory tracking - personal and room

local send							= send
local cc							= TReX.config.cc or "##" --change to be the character used for concatenation

registerAnonymousEventHandler("gmcp.Char.Items.List",			"TReX.inv.eventhandler")
registerAnonymousEventHandler("gmcp.Char.Items.Add",			"TReX.inv.eventhandler")
registerAnonymousEventHandler("gmcp.Char.Items.Remove",			"TReX.inv.eventhandler")
registerAnonymousEventHandler("gmcp.Char.Items.Update",			"TReX.inv.eventhandler")

--save inv file
TReX.inv.save=function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_inv.lua"
   table.save(savePath, TReX.inv)
end -- func

--load inv file
TReX.inv.load=function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_inv.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.inv)
	end -- if
end -- func

TReX.inv.toggle=function(variable, toggle, toggle2)

	if type(t.inv[variable].enabled) == "boolean" then
		if toggle ~= nil then
			t.inv[variable].enabled = verify(toggle)
		else
			t.inv[variable].enabled = not t.inv[variable].enabled
		end

		if t.inv[variable].enabled then -- if toggling to true

			--if variable == "satchel" then
				t.inv[variable].enabled = true
				--print"true"
			--end

			--if variable == "kitbag" then
				--t.inv[variable].enabled = true
			--end

				TReX.config.show("inventory")
				TReX.config.display(variable:title().. " Enabled")

		else

			--if variable == "satchel" then
				t.inv[variable].enabled = false
			--end		

			--if variable == "kitbag" then
				--t.inv[variable].enabled = false
				--print"false"
			--end	


				TReX.config.show("inventory")
				TReX.config.display(variable:title().. " Disabled")


		end	

	end		

	TReX.config.save()

end

TReX.inv.display=function()

	if table.is_empty(t.inv) then
		TReX.inv.set_id_table()
	end

cecho("\n\t<white>Inventory\n")	
  		
 -- local sortInv = {}
  
  -- -- sort defs
  -- for k,v in pairs(t.inv) do
		-- --if v.enabled then -- if I want it to show on my list.
			-- sortInv[#sortInv+1] = k
			-- table.sort(sortInv)
		-- --end
		-- --print(sortInv)
  -- end

  	-- local x = 0
 			 
	-- for i, n in ipairs(sortInv) do
		-- x = x + 1
	
     		-- local d = "<dark_slate_gray>[<white>"

		-- --if table.index_of(t.inv, n) then
			-- if t.inv[n].enabled then
				-- d = d .. " <green>+ "
			-- else
				-- d = d .. " <red>- "
			-- end

	 			-- d = d .. "<dark_slate_gray>]<white> " 


				-- if (x-1)%3 == 0 then
					-- echo("\n")
				-- end  
		
		   	-- local nWithSpace = n:title()

				-- if nWithSpace:len() < 25 and (x-1) %3~=2 then
					-- local pad = 25 - nWithSpace:len()
					-- nWithSpace = nWithSpace .. string.rep(" ", pad)
				-- elseif nWithSpace:len() > 25 then
					-- nWithSpace = nWithSpace:cut(25)
		     	-- end
	 
			-- local command
				-- fg("white")
				-- cecho(d)
			
			-- local command = [[TReX.inv.toggle("]]..n..[[")]]
			-- echoLink(nWithSpace, command, "Toggle " .. n, true)

		-- end
		

end

TReX.inv.eventhandler=function(event, arg)
--if t.serverside["settings"].installed then
	if event:find(".List") then
		--print("gmcp.Char.Items.List event")

		-- ROOM ITEMS
		if gmcp.Char.Items.List.location == "room" then
			TReX.inv.room = {}
			for key,value in pairs(gmcp.Char.Items.List.items) do
				--local highlight = TReX.inv.highlight(value) or ""
				if value.name then TReX.inv.room[value.id] = {name = value.name, highlight = highlight, attrib = value.attrib} end

			end
			--gui.updateRoomInv()
			--raiseEvent("TReX room inv", {r = gmcp.Room.Info.num})
			raiseEvent("TReX room inv")

		elseif gmcp.Char.Items.List.location == "inv" then
			TReX.inv.inv = {}
			for key,value in pairs(gmcp.Char.Items.List.items) do
				--local highlight = TReX.inv.highlight(value) or ""
				if value.name then TReX.inv.inv[value.id] = {name = value.name, highlight = highlight, attrib = value.attrib} end

			end
			raiseEvent("TReX personal inv")
			
		end

	elseif event:find(".Add") then
		--print("gmcp.Char.Items.Add event")

		-- ROOM ITEMS
		if gmcp.Char.Items.Add.location == "room" then
			local value = gmcp.Char.Items.Add.item
			--local highlight = TReX.inv.highlight(value) or ""
			TReX.inv.room[value.id] = {name = value.name, highlight = highlight, attrib = value.attrib}
			--gui.updateRoomInv()
			--raiseEvent("TReX room inv", {r = gmcp.Room.Info.num})

		elseif gmcp.Char.Items.Add.location == "inv" then
			local value = gmcp.Char.Items.Add.item
			--local highlight = TReX.inv.highlight(value) or ""
			TReX.inv.inv[value.id] = {name = value.name, highlight = highlight, attrib = value.attrib}
			raiseEvent("TReX personal inv")
		end

	elseif event:find(".Update") then
		-- Only INV Items
		local value = gmcp.Char.Items.Update.item
		TReX.inv.inv[value.id] = {name = value.name, highlight = highlight, attrib = value.attrib}
		if value.attrib then TReX.inv.inv[value.id].attrib = value.attrib end
		raiseEvent("TReX personal inv")

	elseif event:find(".Remove") then
		--print("gmcp.Char.Items.Remove event")

		-- ROOM ITEMS
		if gmcp.Char.Items.Remove.location == "room" then
			itemKey = gmcp.Char.Items.Remove.item.id
			TReX.inv.room["" .. itemKey] = nil
			--gui.updateRoomInv()
			--raiseEvent("TReX room inv",{r = gmcp.Room.Info.num})
		elseif gmcp.Char.Items.Remove.location == "inv" then
			itemKey = gmcp.Char.Items.Remove.item.id
			TReX.inv.inv["" .. itemKey] = nil
			raiseEvent("TReX personal inv")
		end

	end

--end -- if installed
end

TReX.checkWield=function(itm, hnd)

	if not (hnd) then hnd = "x" else hnd = hnd:cut(1):lower() end

		if TReX.inv.inv[tostring(itm)] then if TReX.inv.inv[tostring(itm)].attrib then
			if (hnd == "l" and TReX.inv.inv[tostring(itm)].attrib:find("l"))
			  or (hnd == "r" and TReX.inv.inv[tostring(itm)].attrib:find("L"))
			  or (hnd == "x" and TReX.inv.inv[tostring(itm)].attrib:lower():find("lL")) then
				return true
			end
		end 

	end

	return false
	
end

TReX.rewield=function(itm,hnd)
	if not (TReX.checkWield(itm, hnd or "x")) then
		
		if (hnd == "x") then hand = "right" end
		if (hnd == "r") then hand = "right" end
		if (hnd == "l") then hand = "left" end
		
		t.send("QUEUE PREPEND EQBAL wield "..hand.." "..itm, false)
		
	end
end

getInv = tempTimer(20, [[sendGMCP("Char.Items.Inv")]]) -- do this so personal inventory data is captured
if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.inv loaded successfully) ") end

TReX.inv.save()

for _, file in ipairs(TReX.inv) do
	dofile(file)
end -- for