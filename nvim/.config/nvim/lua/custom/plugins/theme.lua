-- File: lua/custom/plugins/theme.lua

return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("cyberdream").setup({
            saturation = 0.7,
            borderless_pickers = true,
            transparent = true,
            extensions = {
                telescope = false,
            }
        })
        -- Apply the colorscheme
        vim.cmd("colorscheme cyberdream")
    end
}
