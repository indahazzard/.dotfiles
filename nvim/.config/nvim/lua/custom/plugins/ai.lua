return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
        provider = "gemini_vertexai",
        vendors = {
            ---@type AvanteProvider
            gemini_vertexai = {
                endpoint = "https://us-central1-aiplatform.googleapis.com/v1/projects/danads-bit/locations/us-central1/publishers/google/models",
                model = "gemini-1.5-flash-002",
                api_key_name = 'Gemini key',

                parse_curl_args = function(opts, code_opts)
                    local body_opts = vim.tbl_deep_extend("force", {}, {
                        generationConfig = {
                            temperature = 0,
                            maxOutputTokens = 4096,
                        },
                    })
                    return {
                        url = opts.endpoint .. "/" .. opts.model .. ":streamGenerateContent?alt=sse",
                        headers = {
                            ["Authorization"] = "Bearer " .. opts.parse_api_key(opts.api_key_name),
                            ["Content-Type"] = "application/json; charset=utf-8",
                        },
                        body = vim.tbl_deep_extend(
                            "force",
                            {},
                            require("avante.providers.gemini").parse_messages(opts, code_opts),
                            body_opts
                        ),
                    }
                end,
                parse_response = function(data_stream, event_state, opts)
                    require("avante.providers.gemini").parse_response(data_stream, event_state, opts)
                end,
            }
        },
    },
    build = "make",
    dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- Optional dependencies
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
