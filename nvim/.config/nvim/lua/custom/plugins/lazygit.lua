return {
        "kdheepak/lazygit.nvim",
        config = function()
            require("telescope").load_extension("lazygit")
        end,
    }
