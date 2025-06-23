return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("cyberdream").setup({
            borderless_telescope = false,
            transparent = true,
            saturation = 0.75
        })
        vim.cmd("colorscheme cyberdream")
    end
}
