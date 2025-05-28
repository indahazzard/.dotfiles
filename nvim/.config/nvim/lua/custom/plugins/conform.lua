return {
    "stevearc/conform.nvim",
    opts = {},
    config = function ()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                php = { "phpcbf", "php-cs-fixer" }
            },
        })

        vim.keymap.set(
            "n",
            "<leader>cl",
            function()
                conform.format({ async = true })
            end,
            { desc = "墨 Run phpcbf via conform.nvim" }
        )
    end
}
