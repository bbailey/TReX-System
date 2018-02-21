-- TReX.u
-- Utilities

local send                          = send
local cc                            = TReX.config.cc or "##"

--save u file
TReX.u.save=function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_u.lua"
   table.save(savePath, TReX.u)
end -- func

--load u file
TReX.u.load=function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_u.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.u)
	end -- if
end -- func

TReX.u.toBoolean=function(x)

--if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.u.toBoolean  )") end

	local isTrue = {"yes","y","1","-1","true","Yes"}

	x = tostring(x)
	if table.contains(isTrue,x) then
		return true
	else
		return false
	end

end

TReX.u.value2key=function(tbl)

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.u.value2key  )") end


-- invert key / value

   local tmp = {}

   for k,v in pairs(tbl) do
     tmp[v] = k
   end

   return tmp

end
   
TReX.u.runLuaCode=function(arg)

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.u.runLuaCode  )") end

	local f,e = loadstring("return "..arg)
	if not (f) then
		f,e = assert(loadstring(arg))
	end

	local r = {f()}

	if r then
		if type(r[1]) == 'nil' then
			local m = "Lua ran successfully, but no results returned with argument '"..arg.."'"
			if arg:reverse():cut(1) == ")" then m = m.." <LightSlateGrey>(might be a function)" end
			--TReX.config.echo(m)
		elseif #r == 1 then
			if type(r) == 'string' or type(r) == 'number' then
				if t.serverside["settings"].reporting then TReX.config.echo("Results returned from argument '"..arg.."':\n  "..r[1]) end
			else
				display(r[1])
			end
		else
			display(r)
		end
	end

end

TReX.u.isDragon=function()

if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.u.isDragon  )") end

	if TReX.v.class:find("Dragon") or TReX.v.class:find("dragon") then
		return true
	else
		return false
	end

end

TReX.u.save()

for _, file in ipairs(TReX.u) do
	dofile(file)
end -- for


if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.u loaded successfully) ") end