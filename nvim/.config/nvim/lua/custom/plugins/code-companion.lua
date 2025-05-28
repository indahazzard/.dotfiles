return {
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        opts = {
            strategies = {
                chat = {
                    adapter = "gemini",
                },
            },
            adapters = {
                openai = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        env = {
                            api_key = "GEMINI_API_KEY",
                        },
                    })
                end,
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
