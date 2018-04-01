-- TReX.precache
-- precache Handling

local send              = send
local cc              	= TReX.config.cc or "##"

registerAnonymousEventHandler("TReX precache reset", "TReX.precache.update")

TReX.precache.save=function()
  if string.char(getMudletHomeDir():byte()) == "/" then
    _sep = "/"
    else
    _sep = "\\"
   end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_precache.lua"
   table.save(savePath, TReX.precache)
end -- func

TReX.precache.load=function()
  if string.char(getMudletHomeDir():byte()) == "/"
   then _sep = "/"
    else _sep = "\\"
     end -- if
   local savePath = getMudletHomeDir() .. _sep .. "TReX_precache.lua"
   if (io.exists(savePath)) then
   table.load(savePath, TReX.precache)
  end -- if
end -- func

TReX.precache.manage=function()

cecho("\n\t<white>Precache Settings\n\n")

--raiseEvent("TReX.precache.update")

  if t.serverside["settings"].transmutation then
    TReX.precache.update()
      for item,num in TReX.config.spairs(TReX.precache._minerals, function(t,a,b) return t[b] < t[a] end) do
        echo(" ")
        cechoLink("<dim_grey>[<light_blue> + <dim_grey>]", [[TReX.precache.countUp("]]..item..[[",]]..num..[[)]], "count " .. item .. " up.", true)
        echo(" ")
        cechoLink("<dim_grey>[<red> -<dim_grey> ]", [[TReX.precache.countDown("]]..item..[[",]]..num..[[)]], "count " .. item .. " down.", true)
        --cechoLink("<antique_white>(<gold>DD<antique_white>)", [[kTReX.prios.delete("]]..aff..[[", ]] .. num .. [[)]], "Delete " .. item .. " from list.", true)
        resetFormat()
        cecho(" <dim_grey>[ <white>"..num.." <dim_grey>] <gray>" .. item:title() .. " \n")  --dark_orchid
      end
  else
    TReX.precache.update()
      for item,num in TReX.config.spairs(TReX.precache._herbs, function(t,a,b) return t[b] < t[a] end) do
        echo(" ")
        cechoLink("<dim_grey>[ <light_blue>+ <dim_grey>]", [[TReX.precache.countUp("]]..item..[[",]]..num..[[)]], "count " .. item .. " up.", true)
        echo(" ")
        cechoLink("<dim_grey>[<red> - <dim_grey>]", [[TReX.precache.countDown("]]..item..[[",]]..num..[[)]], "count " .. item .. " down.", true)
        --cechoLink("<antique_white>(<gold>DD<antique_white>)", [[kTReX.prios.delete("]]..aff..[[", ]] .. num .. [[)]], "Delete " .. item .. " from list.", true)
        resetFormat()
        cecho(" <dim_grey>[ <white>"..num.." <dim_grey>] <gray>" .. item:title() .. " \n")  --dark_orchid
      end
  end
  
		echo"\n\n"
		deletep = false
		showprompt()
  
 		
end 
 
TReX.precache.countDown=function(item, num)
  if t.serverside["settings"].transmutation then
      TReX.precache.minerals[item].default=tonumber(num-1)
        if TReX.precache.minerals[item].default < 0 then
          TReX.precache.minerals[item].default=0
        end          
      TReX.precache._minerals[item]=tonumber(num-1)
        if TReX.precache._minerals[item] < 0 then
          TReX.precache._minerals[item]=0
        end
  else
      TReX.precache.herbs[item].default=tonumber(num-1)
        if TReX.precache.herbs[item].default < 0 then
          TReX.precache.herbs[item].default=0
        end          
      TReX.precache._herbs[item]=tonumber(num-1)
        if TReX.precache._herbs[item] < 0 then
          TReX.precache._herbs[item]=0
        end
  end
     -- TReX.config.saveSettings()
      TReX.precache.manage()
end

TReX.precache.countUp=function(item, num)
  if t.serverside["settings"].transmutation then
      TReX.precache.minerals[item].default=tonumber(num+1)
        if TReX.precache.minerals[item].default < 0 then
          TReX.precache.minerals[item].default=0
        end          
      TReX.precache._minerals[item]=tonumber(num+1)
        if TReX.precache._minerals[item] < 0 then
          TReX.precache._minerals[item]=0
        end
  else
      TReX.precache.herbs[item].default=tonumber(num+1)
        if TReX.precache.herbs[item].default < 0 then
          TReX.precache.herbs[item].default=0
        end          
      TReX.precache._herbs[item]=tonumber(num+1)
        if TReX.precache._herbs[item] < 0 then
          TReX.precache._herbs[item]=0
        end
  end
     -- TReX.config.saveSettings()
      TReX.precache.manage()
  end

TReX.precache.settings=function()
  TReX.precache.minerals = {

    ["antimony"] = {["default"] = 0, ["current"] = 0},
    ["argentum"] = {["default"] = 0, ["current"] = 0},  
    ["arsenic"] = {["default"] = 0, ["current"] = 0},  
    ["aurum"] = {["default"] = 0, ["current"] = 0},  
    ["azurite"] = {["default"] = 0, ["current"] = 0},  
    ["bisemutum"] = {["default"] = 0, ["current"] = 0},  
    ["calamine"] = {["default"] = 0, ["current"] = 0},  
    ["calcite"] = {["default"] = 0, ["current"] = 0},  
    ["cinnabar"] = {["default"] = 0, ["current"] = 0}, 
    ["cuprum"] = {["default"] = 0, ["current"] = 0}, 
    ["dolomite"] = {["default"] = 0, ["current"] = 0}, 
    ["ferrum"] = {["default"] = 0, ["current"] = 0}, 
    ["gypsum"] = {["default"] = 0, ["current"] = 0}, 
    ["magnesium"] = {["default"] = 0, ["current"] = 0}, 
    ["malachite"] = {["default"] = 0, ["current"] = 0}, 
    ["potash"] = {["default"] = 0, ["current"] = 0}, 
    ["quartz"] = {["default"] = 0, ["current"] = 0}, 
    ["quicksilver"] = {["default"] = 0, ["current"] = 0}, 
    ["realgar"] = {["default"] = 0, ["current"] = 0}, 
    ["stannum"] = {["default"] = 0, ["current"] = 0},
	["plumbum"] = {["default"] = 0, ["current"] = 0},	

  }

  TReX.precache.herbs = {

    ["ash"] = {["default"] = 0, ["current"] = 0},
    ["bayberry"] = {["default"] = 0, ["current"] = 0},  
    ["bellwort"] = {["default"] = 0, ["current"] = 0},  
    ["bloodroot"] = {["default"] = 0, ["current"] = 0},  
    ["cohosh"] = {["default"] = 0, ["current"] = 0},  
    ["elm"] = {["default"] = 0, ["current"] = 0},  
    ["ginger"] = {["default"] = 0, ["current"] = 0},  
    ["ginseng"] = {["default"] = 0, ["current"] = 0},  
    ["goldenseal"] = {["default"] = 0, ["current"] = 0}, 
    ["hawthorn"] = {["default"] = 0, ["current"] = 0}, 
    ["kelp"] = {["default"] = 0, ["current"] = 0}, 
    ["kola"] = {["default"] = 0, ["current"] = 0}, 
    ["lobelia"] = {["default"] = 0, ["current"] = 0}, 
    ["skullcap"] = {["default"] = 0, ["current"] = 0}, 
    ["valerian"] = {["default"] = 0, ["current"] = 0}, 
    ["sileris"] = {["default"] = 0, ["current"] = 0}, 
    ["irid"] = {["default"] = 0, ["current"] = 0}, 
    ["pear"] = {["default"] = 0, ["current"] = 0}, 

  }
end

TReX.precache.update=function()
  if t.serverside["settings"].transmutation then
    TReX.precache._minerals=TReX.precache._minerals or {} 
      for item,num in pairs(TReX.precache["minerals"]) do
        num = TReX.precache["minerals"][item].default
        TReX.precache._minerals[item]=num
      end
  else
    TReX.precache._herbs=TReX.precache._herbs or {} 
      for item,num in pairs(TReX.precache["herbs"]) do
        num = TReX.precache["herbs"][item].default
        TReX.precache._herbs[item]=num
      end
  end
    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.precache.update )") end
end

TReX.precache.inra_mins=function(num, arg)
  
  if t.serverside["settings"].transmutation then

   local mineral = arg
   local num = num --TReX.precache.herbs = {}


      if TReX.precache.minerals[mineral].current < 0 then
          TReX.precache.minerals[mineral].current = 0
      else
          TReX.precache.minerals[mineral].current = TReX.precache.minerals[mineral].current - num
      end

  else

   local herb = arg
   local num = num --TReX.precache.herbs = {}--TReX.precache.minerals = {}
   --print()
    if herb == "lobelia seed" then
      local herb = "lobelia"
      TReX.precache.inra_count(herb, num)
    elseif herb == "ginger root" then
      local herb = "ginger"
      TReX.precache.inra_count(herb, num)
    elseif herb == "skullcap" then
      local herb = "skullcap"
      TReX.precache.inra_count(herb, num)
    elseif herb == " bellwort flower" then
      local herb = "bellwort"
      TReX.precache.inra_count(herb, num)
    elseif herb == " black cohosh" then
      local herb = "cohosh"
      TReX.precache.inra_count(herb, num)
    elseif herb == "bayberry bark" then
      local herb = "bayberry"
      TReX.precache.inra_count(herb, num)
    elseif herb == "hawthorn berry" then
      local herb = "hawthorn"
      TReX.precache.inra_count(herb, num)
    elseif herb == "ginseng root" then
      local herb = "ginseng"
      TReX.precache.inra_count(herb, num)
    elseif herb == "goldenseal root" then
      local herb = "goldenseal"
      TReX.precache.inra_count(herb, num)
    elseif herb == "bloodroot leaf" then
      local herb = "bloodroot"
      TReX.precache.inra_count(herb, num)
    elseif herb == "slippery elm" then
      local herb = "elm"
      TReX.precache.inra_count(herb, num)
    elseif herb == "prickly ash bark" then
      local herb = "ash"
      TReX.precache.inra_count(herb, num)
    elseif herb == "irid moss" then
      local herb = "irid"
      TReX.precache.inra_count(herb, num)
    elseif herb == "kola nut" then
      local herb = "kola"
      TReX.precache.inra_count(herb, num)
    end
  
  end

  if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.precache.inra_mins )") end

end

TReX.precache.inra_count=function(herb, num)
      if TReX.precache.herbs[herb].current <= 0 then
          TReX.precache.herbs[herb].current = 0
      else
        TReX.precache.herbs[herb].current = TReX.precache.herbs[herb].current - num
      end

        if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.precache.inra_count )") end

    end

TReX.precache.countRemove=function(mineral)


    if t.serverside["settings"].transmutation then

      local mineral = mineral

            if mineral == tostring("a magnesium chip") then
              local mineral = "magnesium"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Magnesium" .."\n") end
            elseif mineral == tostring("a potash crystal") then
              local mineral = "potash"
              TReX.precache.mineral_count(mineral)
                --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Potash" .."\n") end

            elseif mineral == tostring("an antimony flake") then
              local mineral = "antimony"
              TReX.precache.mineral_count(mineral)
              --  if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Antimony" .."\n") end

            elseif mineral == tostring("an argentum flake") then
              local mineral = "argentum"
              TReX.precache.mineral_count(mineral)
                --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Argentum" .."\n") end

            elseif mineral == tostring("an aurum flake") then
              local mineral = "aurum"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Aurum" .."\n") end

            elseif mineral == tostring("a calamine crystal") then
              local mineral = "calamine"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Calamine" .."\n") end

            elseif mineral == tostring("a gypsum crystal") then
              local mineral = "gypsum"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Gypsum" .."\n") end

            elseif mineral == tostring("a cuprum flake") then
              local mineral = "cuprum"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Cuprum" .."\n") end

            elseif mineral == tostring("a ferrum flake") then
              local mineral = "ferrum"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Ferrum" .."\n") end

            elseif mineral == tostring("a plumbum flake") then
              local mineral = "plumbum"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Plumbum" .."\n") end

            elseif mineral == tostring("a stannum flake") then
              local mineral = "stannum"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Stannum" .."\n") end

            elseif mineral == tostring("a dolomite grain") then
              local mineral = "dolomite"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Dolomite" .."\n") end

            elseif mineral == tostring("a quartz grain") then
              local mineral = "quartz"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Quartz" .."\n") end
            elseif mineral == tostring("a pinch of ground malachite") then
              local mineral = "malachite"
              TReX.precache.mineral_count(mineral)

            elseif mineral == tostring("an azurite mote") then
              local mineral = "azurite"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Azurite" .."\n") end

            elseif mineral == tostring("an calcite mote") then
              local mineral = "calcite"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Calcite" .."\n") end

            elseif mineral == tostring("an arsenic pellet") then
              local mineral = "arsenic"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Arsenic" .."\n") end
            elseif mineral == tostring("a quicksilver droplet") then
              local mineral = "quicksilver"
              TReX.precache.mineral_count(mineral)

            elseif mineral == tostring("a bisemutum chip") then
              local mineral = "bisemutum"
              TReX.precache.mineral_count(mineral)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Bisemutum" .."\n") end
            end


    else

      local herb = mineral
 
            if herb == tostring("some prickly ash bark") then
              local herb = "ash"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Magnesium" .."\n") end
            elseif herb == tostring("some bayberry bark") then
               local herb = "bayberry"
               TReX.precache.herb_count(herb)
                --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Potash" .."\n") end

            elseif herb == tostring("a bellwort flower") then
              local herb = "bellwort"
              TReX.precache.herb_count(herb)
            --  if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Antimony" .."\n") end

            elseif herb == tostring("a bloodroot leaf") then
              local herb = "bloodroot"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Argentum" .."\n") end

            elseif herb == tostring("a black cohosh root") then
              local herb = "cohosh"
              TReX.precache.herb_count(herb)

            elseif herb == tostring("slippery elm") then
              local herb = "elm"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Aurum" .."\n") end

            elseif herb == tostring("a ginseng root") then
              local herb = "ginseng"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Calamine" .."\n") end

            elseif herb == tostring("a ginger root") then
              local herb = "ginger"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Gypsum" .."\n") end

            elseif herb == tostring("a goldenseal root") then
              local herb = "goldenseal"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Cuprum" .."\n") end

            elseif herb == tostring("a hawthorn berry") then
              local herb = "hawthorn"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Ferrum" .."\n") end

            elseif herb == tostring("a kola nut") then
              local herb = "kola"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Plumbum" .."\n") end

            elseif herb == tostring("a piece of kelp") then
              local herb = "kelp"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Stannum" .."\n") end

            elseif herb == tostring("a lobelia seed") then
              local herb = "lobelia"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Dolomite" .."\n") end

            elseif herb == tostring("a valerian leaf") then
              local herb = "valerian"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Quartz" .."\n") end
            elseif herb == tostring("a skullcap flower") then
              local herb = "skullcap"
              TReX.precache.herb_count(herb)

           elseif herb == tostring("a sileris berry") then
              local herb = "sileris"
              TReX.precache.herb_count(herb)

            elseif herb == tostring("some irid moss") then
              local herb = "irid"
              TReX.precache.herb_count(herb)
              --if gmcp.Char.Status.name == "Nehmrah" then cecho("TReX.gui.actionBox","\n<green>".."  [".."<white>".."ATE".."<green>".."] ".."<white>  Azurite" .."\n") end

            elseif herb == tostring("a prickly pear") then
              local herb = "pear" 
              TReX.precache.herb_count(herb)
            end

      end
 
      if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.precache.countRemove )") end
  
end

TReX.precache.herb_count=function(herb)
	if t.serverside["settings"].installed then
		if TReX.precache.herbs[herb].current <= 0 then
			TReX.precache.herbs[herb].current = 0
		end
			
		TReX.precache.herbs[herb].current = TReX.precache.herbs[herb].current - 1
		
		if TReX.precache.herbs[herb].current < TReX.precache.herbs[herb].default then
			TReX.precache.out()
		end

		if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.precache.herb_count )") end
	end
end

TReX.precache.mineral_count=function(mineral)
if t.serverside["settings"].installed then

	if TReX.precache.minerals[mineral].current <= 0 then
		TReX.precache.minerals[mineral].current = 0
	end
	
	TReX.precache.minerals[mineral].current = TReX.precache.minerals[mineral].current - 1 or 0
	
	if TReX.precache.minerals[mineral].current < TReX.precache.minerals[mineral].default then
		TReX.precache.out()
	end

	if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.precache.mineral_count )") end
end
end

TReX.precache.blocks=function(aff, leg, arm) 

local affs = {"sleeping", "entangled" ,"transfixation", "impaled", "webbed", "bound", "paralysis", "stupidity"}
local arms = {"brokenleftarm" , "damagedleftarm", "mangledleftarm", "brokenrightarm", "damagedrightarm", "mangledrightarm"}
local legs = {"brokenleftleg" , "damagedleftleg", "mangledleftleg", "brokenrightleg", "damagedrightleg", "mangledrightleg"}
local armcheck = 0
local legcheck = 0

if aff then
    for _,v in ipairs(affs) do
        if t.affs[v] then
			t.affs.block = t.affs[v]
            return true
        end
    end
end

-- put legs before arms, because generally ill check legs first, unless this is a precache check for arms
if leg then
    for _,v in pairs(legs) do
        if t.affs[v] then -- this might be better as a while loop actually... will have to test later.
            legcheck = legcheck + 1
        end

			TReX.serverside.prone_check()
			
            if legcheck > 1 then -- this is included in the while loop.
				t.affs.block = t.affs[v]
				return true
            end
    end
end

if arm then
    for _,v in pairs(arms) do
		if t.affs[v] then -- this might be better as a while loop actually... will have to test later.
			armcheck = armcheck + 1
		end
	
		if armcheck > 1 then -- this is included in the while loop.
			t.affs.block = t.affs[v]
			return true
		end

    end
end

    if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.precache.blocks )") end
	t.affs.block = false
    return false

end -- end func()

TReX.precache.out=function()

	if t.serverside["settings"].transmutation then

		for k,v in pairs(TReX.precache.minerals) do
			while v.current < v.default do
				if v.current < 0 then
					v.current = 0
				end
					--if not TReX.precache.blocks(true, true) then -- this is checking for arm breaks and hindering affs, not legs breaks
						t.send("outr "..k)
						v.current = v.current + 1 -- add these to trigger lines for more accurate counting later.
					--else
						--if t.serverside["settings"].echos then if t.affs.block then t.serverside.green_echo("precache blocked by [ "..t.affs.block.." ]", false) end end
					--end
			end
				--return nil
		end -- for

	else

		for k,v in pairs(TReX.precache.herbs) do
			while v.current < v.default do
				if v.current < 0 then
					v.current = 0
				end
					--if not TReX.precache.blocks(true, true) then -- this is checking for arm breaks and hindering affs, not legs breaks
						t.send("outr "..k)
						v.current = v.current + 1 -- add these to trigger lines for more accurate counting later.
					--else
					--	if t.serverside["settings"].echos then if t.affs.block then t.serverside.green_echo("precache blocked by [ "..t.affs.block.." ]", false) end end
					--end
			end
				--return nil
		end -- for

    end -- if transmutation

  if (t.serverside["settings"].debugEnabled) then TReX.debugMessage("( TReX.precache.out )") end

end -- func

if t.serverside["settings"].debugEnabled then TReX.debugMessage(" (TReX.precache loaded successfully) ") end

  TReX.precache.save()
  TReX.precache.load()

for _, file in ipairs(TReX.precache) do
  dofile(file)
end -- for
