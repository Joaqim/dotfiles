-- mpv-org-history.lua
-- Version: 1.0.2
-- Description: Logs file load, exit, and key press events to an Org history file. Initial version taken from: https://gist.github.com/garoto/e0eb539b210ee077c980e01fb2daef4a
-- Author: Joaqim Planstedt <mail@joaqim.xyz>
-- License: MIT

local HISTFILE = os.getenv("HOME") .. "/Documents/org/mpv-history.org";


local log_entry
function log_entry()
  local file = io.open(HISTFILE, "a+") 
  if not file then return false end
  
  local filename = mp.get_property("path")

  local function match(str)
    return filename:sub(1, string.len(str)) == str
  end

  local title = mp.get_property("media-title");
  title = (title == mp.get_property("filename") and ":" or (":%s"):format(title));
  local uploader = mp.get_property("metadata/by-key/uploader") or mp.get_property("metadata/by-key/channel_url") or "";
  
  local duration = mp.get_property("duration") or "0";
  local playtime = mp.get_property("playback-time") or "0";
  local speed = mp.get_property("speed") or "1.0";

  if match("http://desktop:8096") then
    filename = "Jellyfin"
  end

  local mpv_skipsilence_enabled = mp.get_property_bool("user-data/skipsilence/enabled")
  
  if mpv_skipsilence_enabled then
    speed = mp.get_property("user-data/skipsilence/base_speed")
  end

  -- Format seconds to %H:%M:%S
  local function formatTime(seconds)
    -- TODO: Why do we subtract one hour here? Probably because of timezone . . .
    return os.date("%H:%M:%S", seconds - 3600)
  end

  file:seek("end");
  file:write(("*** %s %s:<%s>:<%s>:<%s>:%s:%s:\n"):format(filename, title, os.date("%Y-%m-%d %a %H:%M"), formatTime(playtime), formatTime(duration), speed, uploader));    
  file:close();
end

mp.register_event("file-loaded", log_entry)
mp.register_event("file-exited", log_entry)

-- Register key press event handler
mp.add_key_binding(nil, "log_entry", log_entry)
