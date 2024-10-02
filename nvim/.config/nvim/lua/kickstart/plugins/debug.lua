-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	'mfussenegger/nvim-dap',
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		'rcarriga/nvim-dap-ui',

		-- Installs the debug adapters for you
		'williamboman/mason.nvim',
		'jay-babu/mason-nvim-dap.nvim',
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require 'dap'
		local dapui = require 'dapui'

		require('mason-nvim-dap').setup {
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {
				function(config)
					require('mason-nvim-dap').default_setup(config)
				end,
				php = function(config)
					config.configurations = {
						-- to listen to php call in docker container
						{
							name = "listen for Xdebug docker",
							type = "php",
							request = "launch",
							port = 9005,
							pathMappings = {
							  ["/var/www/html"] = vim.loop.cwd(),
							}
						}
					}

					require('mason-nvim-dap').default_setup(config)
				end
			},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				'bash-debug-adapter',
				'php-debug-adapter',
			},
		}

		dap.adapters.php = {
		  type = 'executable',
		  command = 'node',
		  args = { "/Users/"..os.getenv("USER").."/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js"},
		}

		dap.adapters.bash = {
		  type = 'executable',
		  command = 'node',
		  args = { "/Users/"..os.getenv("USER").."/.local/share/nvim/mason/packages/bash-debug-adapter/extension/out/bashDebug.js"},
		}
		-- Basic debugging keymaps, feel free to change to your liking!
		vim.keymap.set('n', '<leader>ds', dap.continue, { desc = 'Debug: Start/Continue' })
		vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
		vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over' })
		vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
		vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
		vim.keymap.set('n', '<leader>B', function()
			dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
		end, { desc = 'Debug: Set Breakpoint' })

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup {
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
			controls = {
				icons = {
					pause = '⏸',
					play = '▶',
					step_into = '⏎',
					step_over = '⏭',
					step_out = '⏮',
					step_back = 'b',
					run_last = '▶▶',
					terminate = '⏹',
					disconnect = '⏏',
				},
			},
		}

		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

		dap.listeners.after.event_initialized['dapui_config'] = dapui.open
		dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		dap.listeners.before.event_exited['dapui_config'] = dapui.close

	end,
}
