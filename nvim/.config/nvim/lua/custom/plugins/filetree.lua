vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require('neo-tree').setup {
			filesystem = {
				filtered_items = {
					visible = true,
				}
			},
			popup_border_style = "rounded",
			enable_diagnostics = true,
			window = {
				position = "float"
			},
			default_component_configs = {
				modified = {
					symbol = "",
					highlight = "",
				},
				git_status = {
					symbols = {
						-- Change type
						added     = "A", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified  = "M", -- or "", but this is redundant info if you use git_status_colors on the name
						deleted   = "D", -- this can only be used in the git_status source
						renamed   = "R", -- this can only be used in the git_status source
						-- Status type
						untracked = "",
						ignored   = "",
						unstaged  = "",
						staged    = "",
						conflict  = "",
					}
				},
				indent = {
					indent_size = 2,
					padding = 1, -- extra padding on left hand side
					-- indent guides
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "",
					-- expander config, needed for nesting files
					with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "",
				},
			}
		}

		vim.cmd([[nnoremap <leader>f :Neotree toggle <cr>]])
	end,
}
