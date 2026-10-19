# Fish aliases
# macOS brew installs `hx`; on Linux it's often `helix` — alias only if `hx` is missing
if not command -v hx > /dev/null; and command -v helix > /dev/null
    alias hx helix
end
