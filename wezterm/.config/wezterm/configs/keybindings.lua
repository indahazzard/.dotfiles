local wezterm = require 'wezterm'

local act = wezterm.action

return {
	keys = {
		{
			key = 'Enter',
			mods = 'CTRL|SHIFT',
			action = act({
				SplitHorizontal = {
					cwd = '~'
				}
			})
		},
		{
			key = 'w',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.CloseCurrentPane { confirm = true },
		},
		{
			key = '%',
			mods = 'CTRL|SHIFT',
			action = act({
				SplitVertical = {
					cwd = '~'
				}
			})
		},
		{
			key = "LeftArrow",
			mods = "ALT",
			action = wezterm.action { SendString = "\x1bb" },
		},
		{
			key = "RightArrow",
			mods = "ALT",
			action = wezterm.action { SendString = "\x1bf" },
		},
	},
}
