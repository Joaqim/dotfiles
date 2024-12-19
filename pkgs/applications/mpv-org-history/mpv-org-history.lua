-- Not my code: originally from https://redd.it/3t6s7k (author deleted; failed to ask for permission).
-- Only tested on Windows. Date is set to dd/mmm/yy and time to machine-wide format.
-- Save as "mpvhistory.lua" in your mpv scripts dir. Log will be saved to mpv default config directory.
-- Make sure to leave a comment if you make any improvements/changes to the script!
-- https://gist.github.com/garoto/e0eb539b210ee077c980e01fb2daef4a

-- 2022-03-14 Joaqim Planstedt <mail@joaqim.xyz>
-- Personal additions and changes, mainly output mpv history as org mode compatible list with timestamps
-- Additionally, checks for existing entry of filename/url before appending entry to mpv history

local HISTFILE = os.getenv("HOME").."/Documents/org/mpv-history.org";

local function read_last_line(filename)
  local file = io.open(filename, "rb") 
  if not file then return nil end

  local eof  = file:seek("end")
  
  for i = 1, eof do
      file:seek("set", eof - i)
      if i == eof then break end
      if file:read(1) == '\n' then break end
  end
  
  return file:read("*a")
end


local function has_entry(filename)
  local last_line = read_last_line(HISTFILE)
  if not last_line then return false end
  local entry_filename = last_line:match("%*%*%* (.*)%s:.*:<.*>:") or ""

  return last_line_filename == filename;
end

mp.register_event("file-loaded", function()  
  local filename = mp.get_property("path")

  if has_entry(filename) then
    return nil;
  end
  local file = io.open(HISTFILE, "a+") 
  if not file then return false end

  local title = mp.get_property("media-title");  
  title = (title == mp.get_property("filename") and ":" or (":%s"):format(title));

  file:seek("end");
  file:write(("\n*** %s %s:<%s>:"):format(filename, title, os.date("%Y-%d-%m %a %H:%M")));    
  file:close();
end)