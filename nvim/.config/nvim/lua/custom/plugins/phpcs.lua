return {
	-- PHPCS installation.
	{
		"praem90/nvim-phpcsf",
		config = function()
			vim.g.nvim_phpcs_config_phpcs_path = 'phpcs'
			vim.g.nvim_phpcs_config_phpcs_standard = vim.loop.cwd() .. '/phpcs.xml'

			vim.api.nvim_create_augroup('PHBSCF', { clear = true })

			vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
				pattern = '*.php',
				callback = function()
					require 'phpcs'.cs()
				end,
				group = 'PHBSCF'
			})
			vim.keymap.set("n", "<leader>lp", function() require("phpcs").cbf() end, {
				silent = true,
				noremap = true,
				desc = "PHP Fix"
			})
		end
	},
}
