-- Taken from: https://gist.github.com/garoto/e0eb539b210ee077c980e01fb2daef4a

local HISTFILE = os.getenv("HOME") .. "/Documents/org/mpv-history.org";

mp.register_event("file-loaded", function()  
  local file = io.open(HISTFILE, "a+") 
  if not file then return false end
  
  local filename = mp.get_property("path")


  local title = mp.get_property("media-title");
  title = (title == mp.get_property("filename") and ":" or (":%s"):format(title));
  local uploader = mp.get_property("metadata/by-key/uploader") or mp.get_property("metadata/by-key/channel_url") or "";
  
  local duration = mp.get_property("duration") or "0";
  local playtime = mp.get_property("playback-time") or "0";
  local speed = mp.get_property("speed") or "1.0";

  if filename:sub(1, string.len("http://desktop:8096")) == "http://desktop:8096" then
    filename = "Jellyfin"
  end

  -- Format seconds to %H:%M:%S
  local function formatTime(seconds)
    return os.date("%H:%M:%S", seconds - 3600)
  end


  file:seek("end");
  file:write(("*** %s %s:<%s>:<%s>:<%s>:%s:%s:\n"):format(filename, title, os.date("%Y-%m-%d %a %H:%M"), formatTime(playtime), formatTime(duration), speed, uploader));    
  file:close();
end)