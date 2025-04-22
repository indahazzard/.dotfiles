return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
        provider = "gemini",
        vendor = {
            vertex = {
                parse_api_key = function ()
                      local key_path = "/Users/mykyta.v.dotsenko/.config/avante.nvim/api_keys.json"
                      local api_key = nil

                      local ok, content = pcall(vim.fn.readfile, key_path)
                      if ok and content then
                          local ok_json, data = pcall(vim.fn.json_decode, table.concat(content, "\n"))
                          if ok_json then
                              api_key = data["GEMINI_API_KEY"]
                          end
                      end

                      return api_key
                end
            }
        }
    },
    build = "make",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "echasnovski/mini.pick",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" }
            },
            ft = { "markdown", "Avante" }
        }
    }
}
