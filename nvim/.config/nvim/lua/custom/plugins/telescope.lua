return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    config = function()
        local custom_pick = require "custom.plugins.config.telescope.multigrep"
        local ok, local_pickers = pcall(require, 'custom.plugins.config.telescope.local_telescope_config')
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                    },
                },
            },
            pickers = ok and local_pickers or {},
        }

        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'rg')
        pcall(require('telescope').load_extension, 'neoclip')

        -- See `:help telescope.builtin`
        vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
            { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
            { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
        vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>sg', custom_pick.live_multigrep, { desc = '[S]earch by [G]rep (Custom Multi Grep)' })

        local nnoremap = require("custom.functions.keymap_utils").nnoremap

        nnoremap('gd', function() require('telescope.builtin').lsp_definitions() end, { desc = '[G]oto [D]efinition' })
        nnoremap('gr', function() require('telescope.builtin').lsp_references() end, { desc = '[G]oto [R]eferences' })
        nnoremap('gI', function() require('telescope.builtin').lsp_implementations() end,
            { desc = '[G]oto [I]mplementation' })
        nnoremap('<leader>D', function() require('telescope.builtin').lsp_type_definitions() end,
            { desc = 'Type [D]efinition' })
        nnoremap('<leader>ly', "<cmd>Telescope neoclip<cr>", { silent = false, desc = "Show all Yanks" })
    end
}
