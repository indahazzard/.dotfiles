-- File: lua/custom/plugins/theme.lua

return {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("nightfox").setup({
	  options = {
	    transparent = true
	  }
        })
        vim.cmd("colorscheme carbonfox") -- set the colorscheme
    end,
}
