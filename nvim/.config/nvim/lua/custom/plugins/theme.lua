-- File: lua/custom/plugins/theme.lua

return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("cyberdream").setup({
            borderless_telescope = false,
        })
        -- Apply the colorscheme
        vim.cmd("colorscheme cyberdream")
    end
}
