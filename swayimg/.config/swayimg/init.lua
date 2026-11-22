local function shell_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- do not include video files (fix lags)
swayimg.format_conf = {
	video = {
		enable = false,
	},
}

-- set original image scale, when pressing 0
swayimg.viewer.on_key("0", function()
	swayimg.viewer.set_abs_scale(1.0)
end)

-- Opens swayimg in gallery mode by default
swayimg.mode = "gallery"
swayimg.imagelist.adjacent = true

-- Use right arrow key for moving to next image
swayimg.viewer.on_key("right", function()
	swayimg.viewer.open("next")
end)

-- Use left arrow key for moving to previous image
swayimg.viewer.on_key("left", function()
	swayimg.viewer.open("prev")
end)

-- Copy current image to Wayland clipboard (requires wl-clipboard)
swayimg.viewer.on_key("Ctrl+c", function()
	local img = swayimg.viewer.get_image()
	if img then
		os.execute(string.format('wl-copy < "%s"', img.path))
		swayimg.text.set_status("Copied image to clipboard")
	end
end)

-- Copy file path to clipboard
swayimg.viewer.on_key("p", function()
	local img = swayimg.viewer.get_image()
	if img then
		os.execute(string.format('printf "%%s" "%s" | wl-copy', img.path))
		swayimg.text.set_status("Copied path: " .. img.path)
	end
end)

-- Annotate image using noctalia's screenshot-annotate tool by pressing 'e'
swayimg.viewer.on_key("e", function()
	local image = swayimg.viewer.get_image()
	if not image then
		return
	end

	local folder = image.path:match("^(.*)/") or "."
	os.execute(
		"noctalia msg annotate --directory "
			.. shell_quote(folder)
			.. " "
			.. shell_quote(image.path)
			.. " >/dev/null 2>&1 &"
	)
end)

local function find_index(list, target_path)
	if not list then
		return nil
	end
	for i, entry in ipairs(list) do
		local p = type(entry) == "table" and entry.path or entry
		if p == target_path then
			return i
		end
	end
	return nil
end

local function trash_file(path)
	local cmd = string.format("gio trash %s", path)
	local ok = os.execute(cmd)
	if ok == true or ok == 0 then
		swayimg.imagelist.remove(path)
		return true
	end
	return false
end

swayimg.viewer.on_key("Delete", function()
	local img = swayimg.viewer.get_image()
	if not img then
		return
	end

	local path = img.path
	local list = swayimg.imagelist.get()
	local count = list and #list or 0
	local idx = find_index(list, path)

	if count > 1 then
		if idx and idx < count then
			swayimg.viewer.open("next")
		else
			swayimg.viewer.open("first")
		end
	end

	trash_file(path)
end)

swayimg.gallery.on_key("Delete", function()
	local img = swayimg.gallery.get_image()
	if not img then
		return
	end

	local path = img.path
	local list = swayimg.imagelist.get()
	local count = list and #list or 0
	local idx = find_index(list, path)

	if count > 1 then
		if idx and idx < count then
			swayimg.gallery.select("right")
		else
			swayimg.gallery.select("first")
		end
	end

	trash_file(path)
end)
