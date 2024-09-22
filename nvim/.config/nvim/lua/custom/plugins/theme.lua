-- File: lua/custom/plugins/theme.lua

return {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("nightfox").setup({
            options = {
                transparent = false
            },
            specs = {
                -- Set NeoTree background color to match Normal background
                NeoTreeNormal = {
                    fg = "fg1",
                    bg = "bg0" -- Uses the same background as 'Normal'
                },
            }
        })

        -- Apply the colorscheme
        vim.cmd("colorscheme carbonfox")

        -- Sync NeoTree with Normal background using the new API
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = normal_bg })

        -- Remove color from NeoTree border
vim.api.nvim_set_hl(0, "NormalFloat", {bg="NONE"})
    end,
}
