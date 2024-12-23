-- File: lua/custom/plugins/theme.lua

return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("cyberdream").setup({
            borderless_telescope = false,
            theme = {
                colors = {
                    bg = "#000000",
                    bgAlt = "#23272b",
                    bgHighlight = "#2e3338",
                    fg = "#e0e0e0",
                    grey = "#8a94a6",
                    blue = "#4682b4",
                    green = "#4caf50",
                    cyan = "#40c4ff",
                    red = "#e57373",
                    yellow = "#ffd54f",
                    magenta = "#ba68c8",
                    pink = "#e573a1",
                    orange = "#ffb74d",
                    purple = "#9575cd",
                },
            }
        })
        -- Apply the colorscheme
        vim.cmd("colorscheme cyberdream")
    end
}
