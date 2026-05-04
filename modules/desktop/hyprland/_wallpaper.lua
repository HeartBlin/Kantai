local M = {}

local STATE_FILE = "/tmp/wallpaper_index"
local WALLPAPER_DIR = os.getenv("HOME") .. "/Pictures/Wallpapers"
local WALLPAPER_EXTS = { ".jpg", ".jpeg", ".png" }
local AWWW_OPTIONS = "--transition-type random --transition-step 180 --transition-fps 144"

local function read_index()
  local f = io.open(STATE_FILE, "r")
  if not f then return 1 end
  local content = f:read("*a")
  f:close()
  return tonumber(content) or 1
end

local function write_index(idx)
  local f = io.open(STATE_FILE, "w")
  if f then
    f:write(tostring(idx))
    f:close()
  end
end

local function get_wallpapers()
  local pattern = table.concat(WALLPAPER_EXTS, "|")
  local cmd = string.format(
    'find "%s" -maxdepth 1 -type f | grep -iE "(%s)$" | sort',
    WALLPAPER_DIR, pattern
  )

  local f = io.popen(cmd)
  if not f then return {} end

  local wallpapers = {}
  for line in f:lines() do
    table.insert(wallpapers, line)
  end

  f:close()
  return wallpapers
end

function M.walk(direction)
  local wallpapers = get_wallpapers()
  if #wallpapers == 0 then return end

  local next_idx = (read_index() - 1 + direction) % #wallpapers + 1
  write_index(next_idx)

  os.execute(string.format('awww img "%s" %s', wallpapers[next_idx], AWWW_OPTIONS))
end

return M
