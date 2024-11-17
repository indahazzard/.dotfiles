-- File: lua/custom/plugins/theme.lua

return {
    "aliqyan-21/darkvoid.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("darkvoid").setup({
            transparent = false,
            glow = false
        })

        vim.cmd("colorscheme darkvoid")
    end
}
