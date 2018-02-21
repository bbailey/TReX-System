-- TReX.db
-- Database
-- NO NEED TO LOAD / SAVE ANYTHING HERE
-- WORK IN PROGRESS


debugEnabled						= false 				-- hard debugs -- programmer echos
local send							= send

TReX								= TReX or {}
TReX.db								= TReX.db or {}
--TReX.db.ppl							= TReX.db.ppl or {}
-- this is my database I am starting

--registerAnonymousEventHandler("sysLoadEvent",		    "TReX.db.download")
--registerAnonymousEventHandler("sysLoadEvent",		    "TReX.db.Load_Tracking")
--registerAnonymousEventHandler("sysDownloadError",		"TReX.db.download_error")
--registerAnonymousEventHandler("sysDownloadDone",		"TReX.db.download_done")
registerAnonymousEventHandler("gmcp.Room.AddPlayer",	"TReX.db.ppl.eventhandler")
registerAnonymousEventHandler("gmcp.Room.RemovePlayer", "TReX.db.ppl.eventhandler")
registerAnonymousEventHandler("gmcp.Room.Players",		"TReX.db.ppl.eventhandler")



--save db file
TReX.db.save = function()
  if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
  	else
		_sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_db.lua"
   table.save(savePath, TReX.db)
end -- func

--load db file
TReX.db.load = function()
if (string.char(getMudletHomeDir():byte()) == "/") then
		_sep = "/"
    else 
		_sep = "\\"
end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_db.lua"
	if (io.exists(savePath)) then
		table.load(savePath, TReX.db)
	end -- if
end -- func


-- -- create database if it doesn't already exist
-- local trexppldb						= db:create("trexppl",
  -- {
    -- people = {
	  -- name = "",
	  -- city = "",
      -- order = "",
	  -- house = "",
	  -- race = "",
      -- dragon = 0,
      -- enemy = 0,
      -- ally = 0,
      -- cityenemy = 0,
      -- orderenemy = 0,
      -- updated = db:Timestamp("CURRENT_TIMESTAMP"),
      -- _index = { {"name"} },
	  -- _unique = { {"name"} },
	  -- _violations = "IGNORE",
    -- },
  -- }
-- )


-- -- work with the database
-- local ppldb							= db:get_database("trexppl")
-- local ppl							= ppl or {}

-- TReX.db.ppl.eventhandler = function(event, arg)
-- -- so far just gets the names and adds them to the database
-- -- need to build functions to update information as it becomes available

	-- local arg = arg or {}
	-- if event == "gmcp.Room.Players" then
		-- -- add person to db if not already included
		-- for _, v in ipairs(gmcp.Room.Players) do
			-- if #db:fetch(ppldb.people, db:eq(ppldb.people.name, v.name)) == 0 then
				-- db:add(ppldb.people, {name = v.name})
				-- --cecho("\n<orange>[<white>+<orange>]<reset> Adding "..v.name.."\n")
				
			-- end
		-- end
	
	-- elseif event:find("Player") then
		-- if #db:fetch(ppldb.people, db:eq(ppldb.people.name, event.name)) == 0 then
			-- db:add(ppldb.people, {name = event.name})
			-- --cecho("\n<orange>[<white>+<orange>]<reset> Adding "..event.name.."\n")

		-- end

	-- end	

-- end


-- TReX.db.ppl.show = function()
-- -- to be updated in the future, here for debugging purposes

	-- ppl = db:fetch(ppldb.people)
	-- cecho("\n<orange>[<white>+<orange>]<reset> People in db:\n")
	-- for k, v in pairs(ppl) do
		-- cecho("<orange>- <reset>"..v.name.."\n")
	-- end
-- end




if debugEnabled then TReX.debugMessage(" (TReX.db loaded successfully) ") end

for _, file in ipairs(TReX.db) do
	dofile(file)
end -- for