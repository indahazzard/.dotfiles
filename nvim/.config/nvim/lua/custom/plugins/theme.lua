-- File: lua/custom/plugins/theme.lua

return {
    "aliqyan-21/darkvoid.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("darkvoid").setup({
            transparent = true,
            glow = false,
            colors = {
                search_highlight = '#22bd7a',
                operator = '#22bd7a',

                pmenu_sel_bg = '#22bd7a',
                bufferline_selection = '#22bd7a',
            }
        })
        -- Apply the colorscheme
        vim.cmd("colorscheme darkvoid")
    end
}
