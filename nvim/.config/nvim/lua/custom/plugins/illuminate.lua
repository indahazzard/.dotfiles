return {
    "RRethy/vim-illuminate",
    config = function ()
    	require("illuminate").configure({
	    under_cursor = false,
	    filetypes_denylist = {
		"TelescopePrompt",
		"neo-tree",
		"Outline",
		"alpha"
	    }
	})
    end
}
