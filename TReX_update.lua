registerAnonymousEventHandler("sysLoadEvent", "TReX.checkForUpdates")
registerAnonymousEventHandler("sysDownloadDone", "TReX.downloadedVersionFile")
registerAnonymousEventHandler("sysDownloadError", "TReX.downloadedFileError")

-- download latest version number file
TReX.checkForUpdates=function()
  if string.char(getMudletHomeDir():byte()) == "/" then -- this is the git update file
    _sep = "/" 
  else 
    _sep = "\\" 
  end -- if
  local current_version = getMudletHomeDir().._sep.."TReX_version"
	downloadFile(current_version, "https://raw.githubusercontent.com/shanesrasmussen/TReX-System/master/TReX-Update")
  end

TReX.downloadedVersionFile=function(_, filename)
  -- is the file that downloaded ours?
  if not filename:match("TReX_version", 1, true) then return end
  -- parse downloaded file for current version
  local ver = io.open(filename):read("*all")
  TReX.currentVersion = string.trim(ver)

  if TReX.myVersion >= TReX.currentVersion then
    t.serverside.green_echo("Running the latest TReX version: "..TReX.myVersion)
    TReX.updateAvailable = false
  else
    t.serverside.green_echo("Update available ("..TReX.currentVersion..")")
    TReX.updateAvailable = true
    TReX.updatePopup()
  end
  
  --io.open():close()
  --os.remove(filename)
end

TReX.downloadedFileError=function(_, reason)
  display(reason)
  t.serverside.red_echo(" Could not check for updates ")
  cechoLink( "<blue> "..TReX.downloadsURL, [[TReX.downloadNow()]], TReX.downloadsURL, true )
end

TReX.updatePopup=function()
TReXDownloadContainer = Geyser.Container:new({
  name = "TReXDownloadContainer",
  x = "35%", y = "88%",
  width = 200, height = 90,
  })

TReXDownloadBackground = Geyser.Label:new({
  name = "TReXDownloadBackground",
  x = 0, y = 0,
  height = "100%", width = "100%",
  fgColor = "white",
  color = "dim_grey",
  message = [[<center>TReX ]]..TReX.currentVersion..[[ Available!</center>]]
  },TReXDownloadContainer)

TReXDownloadBackground:setStyleSheet([[
  qproperty-alignment: 'AlignTop';
  background-color: rgba(105,105,105,90%);
  border 2px solid;
  border-width: 5px;
  border-style: solid;
  border-color: white;
  border-radius: 10px;
]])

TReXDownloadNowButton = Geyser.Label:new({
  name = "TReXDownloadNowButton",
  x = 10, y = 25,
  height = 25, width = "90%",
  fgColor = "white",
  color = "LawnGreen",
  message = [[<center>Download Now!</center>]]
  }, TReXDownloadContainer)

TReXDownloadNowButton:setClickCallback("TReX.downloadNow")

TReXDownloadNowButton:setStyleSheet([[
  qproperty-alignment: 'AlignTop';
  background-color: green;
  border 2px solid;
  border-width: 2px;
  border-style: solid;
  border-color: white;
  border-radius: 10px;
]])

TReXDownloadLaterButton = Geyser.Label:new({
  name = "TReXDownloadLaterButton",
  x = 10, y = 55,
  height = 25, width = "90%",
  fgColor = "white",
  color = "red",
  message = [[<center>Later!</center>]]
  }, TReXDownloadContainer)

TReXDownloadLaterButton:setClickCallback("TReX.downloadLater")


TReXDownloadLaterButton:setStyleSheet([[
  qproperty-alignment: 'AlignTop';
  background-color: red;
  border 2px solid;
  border-width: 2px;
  border-style: solid;
  border-color: white;
  border-radius: 10px;
]])

end

TReX.downloadNow=function()
  openUrl(TReX.downloadsURL)
  TReXDownloadContainer:hide()
end

TReX.downloadLater=function()
  TReXDownloadContainer:hide()
end

