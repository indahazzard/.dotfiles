return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")


		lint.linters.phpmd.args = {
			'-',
			'json',
			vim.loop.cwd() .. '/phpmd.xml'
		}

		lint.linters.phpcs.args = {
			"-",
			"--standard=" .. vim.loop.cwd() .. "/phpcs.xml",
			"--report=json",
			"-v"
		}
		local severities = {
			['ERROR'] = vim.diagnostic.severity.ERROR,
			['WARNING'] = vim.diagnostic.severity.WARN,
			['INFORMATION'] = vim.diagnostic.severity.INFO,
			['HINT'] = vim.diagnostic.severity.HINT,
		}
		local bin = 'phpcs'
		lint.linters.phpcs.parser = function(output, _)
			if vim.trim(output) == '' or output == nil then
				return {}
			end

			local json_start = output:find("{")
			local json_end = output:find("}%s")

			if not json_start or not json_end then
				vim.notify("No complete JSON found in output")
				return {}
			end

			local json_part = output:sub(json_start, json_end)

			local success, decoded = pcall(vim.json.decode, json_part)
			if not success then
				vim.notify("Failed to decode JSON")
				return {}
			end

			local diagnostics = {}

			for file_path, file_data in pairs(decoded['files']) do
				local messages = file_data['messages']

				for _, msg in ipairs(messages or {}) do
					table.insert(diagnostics, {
						lnum = msg.line - 1,
						end_lnum = msg.line - 1,
						col = msg.column - 1,
						end_col = msg.column - 1,
						message = msg.message,
						code = msg.source,
						source = bin,
						severity = assert(severities[msg.type],
							'missing mapping for severity ' .. msg.type),
					})
				end
			end

			return diagnostics
		end

		lint.linters_by_ft = {
			php = { "phpmd", "phpcs" }
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end
		})
	end

}
