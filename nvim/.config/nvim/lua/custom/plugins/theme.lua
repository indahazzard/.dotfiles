-- File: lua/custom/plugins/theme.lua

return {
    "aliqyan-21/darkvoid.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("darkvoid").setup({
            transparent = true,
            glow = false
        })
        -- Apply the colorscheme
        vim.cmd("colorscheme darkvoid")
    end
}
