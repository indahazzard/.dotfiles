local wezterm = require 'wezterm'

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local dynamic_font_size = nil

if is_linux() then
	dynamic_font_size = 16.0
end

if is_darwin() then
	dynamic_font_size = 18.0
end

-- font
return {
	font = wezterm.font('Fira Code'),
	font_size = dynamic_font_size
}
