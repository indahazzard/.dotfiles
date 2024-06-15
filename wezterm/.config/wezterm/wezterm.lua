local wezterm = require 'wezterm'

-- Import configs
local keybindings = require 'configs.keybindings'
local font = require 'configs.font'
local settings = require 'configs.settings'

-- Create config builder
local config = wezterm.config_builder()

-- Function to setup configs
local function setup(dest, src)
  for k, v in pairs(src) do
    dest[k] = v
  end
end

-- Setup font configs
setup(config, font)

-- Setup terminal settings
setup(config, settings)

-- Setup keybindings
setup(config, keybindings)

return config
