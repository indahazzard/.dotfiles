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

            lint.linters_by_ft = {
                php = { "phpmd" }
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