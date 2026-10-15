-- yazi init.lua
-- Set up bookmarks (Thunar Places) using yamb

local sep = package.config:sub(1, 1)
local home = os.getenv("HOME")

local function bm(tag, path, key)
  return { tag = tag, path = home .. sep .. path .. sep, key = key }
end

local bookmarks = {
  bm("Home", "", "h"),
  bm("Desktop", "Desktop", "D"),
  bm("Documents", "Documents", "c"),
  bm("Downloads", "Downloads", "d"),
  bm("Music", "Music", "m"),
  bm("Pictures", "Pictures", "p"),
  bm("Videos", "Videos", "v"),
}

require("yamb"):setup {
  bookmarks = bookmarks,
  jump_notify = true,
  cli = "fzf",
}

require("zoxide"):setup({
  update_db = true,
})
