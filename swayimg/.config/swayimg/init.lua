local function shell_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

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

-- Allow deleting image by pressing Delete key in gallery mode
swayimg.gallery.on_key("Delete", function()
	local image = swayimg.gallery.get_image()
	if image then
		os.remove(image.path)
	end
end)

-- Allow deleting image by pressing Delete key in viewer mode
swayimg.viewer.on_key("Delete", function()
	local image = swayimg.viewer.get_image()
	if image then
		os.remove(image.path)
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
