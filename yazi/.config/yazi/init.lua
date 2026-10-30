-- yazi init.lua

require("zoxide"):setup({
	update_db = true,
})
require("fs-usage"):setup()

-- Show recursive directory size in the middle pane (async, non-blocking).
-- Files use the built-in size; dirs are measured with fs.calc_size() in a
-- ya.async task so scrolling never stalls, then cached for the session.
-- Only a plain string crosses the sync->async boundary: render-scoped
-- File/Url userdata is destructed by the time the task runs, so the Url is
-- rebuilt inside the task. A "peek" emit re-renders once a size lands.
-- (No ya.sync/ui.render here: those require a plugin context, init.lua has none.)
-- ponytail: per-session cache, no expiry; totals can go stale if dir
-- contents change. Restart yazi to refresh.
local dir_size_cache, dir_size_pending = {}, {}

function Linemode:size()
	local size = self._file:size()
	if size then
		return ya.readable_size(size)
	end
	local cha = self._file.cha
	if not cha or not cha.is_dir then
		return ""
	end
	local key = tostring(self._file.url)
	if dir_size_cache[key] then
		return dir_size_cache[key]
	end
	if not dir_size_pending[key] then
		dir_size_pending[key] = true
		ya.async(function()
			local ok, total = pcall(function()
				local it = assert(fs.calc_size(Url(key)))
				local sum = 0
				while true do
					local n = it:recv()
					if not n then
						break
					end
					sum = sum + n
				end
				return sum
			end)
			dir_size_pending[key] = nil
			-- ponytail: "?" on error (e.g. permission denied), no retry loop
			dir_size_cache[key] = ok and ya.readable_size(total) or "?"
			ya.emit("peek", {})
		end)
	end
	return "…"
end

-- Single date/time format used by every linemode: 16-Oct-2026 03:48PM.
local function fmt_time(time)
	time = math.floor(time or 0)
	if time == 0 then
		return ""
	end
	return os.date("%d-%b-%Y %I:%M%p", time)
end

function Linemode:mtime()
	return fmt_time(self._file.cha.mtime)
end

function Linemode:btime()
	return fmt_time(self._file.cha.btime)
end

-- Default view: size + mtime (reuses Linemode:size, so dir totals still work).
function Linemode:size_mtime()
	return string.format("%s  %s", Linemode.size(self), fmt_time(self._file.cha.mtime))
end
