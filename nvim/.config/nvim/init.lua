-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    -- Useful plugin to show you pending keybinds.
    {
        'folke/which-key.nvim',
        opts = {
            icons = {
                mappings = false,
            }
        }
    },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = 'Preview git hunk' })

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({ 'n', 'v' }, ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
                vim.keymap.set({ 'n', 'v' }, '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
            end,
        },
    },
    -- Fuzzy Finder (files, lsp, etc)

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
    {
        'jwalton512/vim-blade'
    },

    require 'kickstart.plugins.debug',

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
    --    up-to-date with whatever is in the kickstart repo.
    --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    { import = 'custom.plugins' },
}, {
    ui = { border = "rounded" }
})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Enable autodidenting
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

-- Enable relative line numbers
vim.opt.nu = true
vim.opt.rnu = true

vim.opt.cursorline = false

vim.opt.scrolloff = 8

vim.opt.fillchars = { eob = '~', horiz = '─', horizup = '─', horizdown = '─' }


-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
    require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim',
            'bash', 'php', 'html', 'css', 'markdown', 'svelte', 'vue' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,
        sync_install = false,
        ignore_install = {},
        modules = {},

        highlight = { enable = true, additional_vim_regex_highlighting = { "php" } },
        indent = { enable = false },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<M-space>',
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                },
            },
        },
    }
end, 0)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>p', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')


    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = "rounded",
            title = "Documentation"
        }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "rounded"
        }
    )
end

-- document existing key chains
require('which-key').add({
    { '<leader>c', desc = '[C]ode', },
    { '<leader>d', name = '[D]ocument', },
    { '<leader>g', name = '[G]it', },
    { '<leader>h', name = 'More git', },
    { '<leader>r', name = '[R]ename', },
    { '<leader>s', name = '[S]earch', },
})


-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup({
    ui = {
        border = 'rounded'
    }
})
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local localServerSettingsLoaded, local_serverSettings = pcall(require, 'local_lsp_config')

-- Recursive table merge function
local function mergeTables(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" and type(t1[k]) == "table" then
            mergeTables(t1[k], v)
        else
            t1[k] = v
        end
    end
end

local servers = {
    rust_analyzer = {
        assist = {
            importEnforceGranularity = true,
            importPrefix = "crate"
        },
        cargo = {
            allFeatures = true
        },
        checkOnSave = {
            -- default: `cargo check`
            command = "clippy"
        },
        inlayHints = {
            lifetimeElisionHints = {
                enable = true,
                useParameterNames = true
            },
        },
        filetypes = { "rust" },
    },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
    intelephense = {
        stubs = {
            "bcmath",
            "bz2",
            "calendar",
            "Core",
            "curl",
            "zip",
            "zlib",
            "acf-pro",
            "genesis",
            "polylang"
        },
        filetypes = { "php" },
        environment = {
            includePaths = {
                ".",
            },
        },
        files = {
            exclude = {
                "*/*.blade.php",
            }
        },
        exclude = { "blade" },
        references = {
            exclude = {
            }
        }
    },
    html = {
        filetypes = { 'html', 'blade', 'svelte', 'vue' },
        files = {
            associations = {
                [".blade.php"] = "html",
                ["*.html"] = "html",
            }
        },
    },
    ts_ls = {
        init_options = {
            embeddedLanguages = {
                html = true,
            },
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = "~/.nvm/versions/node/v18.20.4/bin/typescript-language-server",
                    languages = { "javascript", "typescript", "vue" },
                },
            },
        },
        filetypes = {
            "javascript",
            "typescript",
            "vue",
        },
    },
}

if localServerSettingsLoaded then
    mergeTables(servers, local_serverSettings)
end

-- Setup neovim lua configuration
require('neodev').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 etc

local nnoremap = require("custom.functions.keymap_utils").nnoremap
local formatBuffer = require('custom.functions.format').format

-- Center buffer while navigating
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("{", "{zz")
nnoremap("}", "}zz")
nnoremap("N", "Nzz")
nnoremap("n", "nzz")
nnoremap("G", "Gzz")
nnoremap("gg", "ggzz")
nnoremap("<C-i>", "<C-i>zz")
nnoremap("<C-o>", "<C-o>zz")
nnoremap("%", "%zz")
nnoremap("*", "*zz")
nnoremap("#", "#zz")

-- Save with leader key
nnoremap("<leader>w", "<cmd>w<cr>", { silent = false, desc = "Save current buffer" })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q<cr>", { silent = false, desc = "Quit current buffer" })

-- Save and Quit with leader key
nnoremap("<leader>z", "<cmd>wq<cr>", { silent = false, desc = "Save and quit current buffer" })

vim.cmd([[nnoremap <leader>cf :Neotree reveal<cr>]])
nnoremap("<leader>y", "<cmd>%y<cr>", { silent = false, desc = "Copy buffer content" })

nnoremap("<leader>gg", "<cmd>:LazyGit<cr>", { silent = false, desc = "Show LazyGit" })

-- move between buffers
nnoremap("[b", "<cmd>:bnext<cr>", { silent = false, desc = "Next buffer" })
nnoremap("]b", "<cmd>:bprevious<cr>", { silent = false, desc = "Previous buffer" })
nnoremap('<leader>gb', "<cmd>:BlameToggle window<cr>", { silent = false, desc = "Show Git blame" })

nnoremap('<leader>xd', "<cmd>:Trouble diagnostics toggle focus=false filter.buf=0<CR>",
    { silent = false, desc = "Show document diagnostics" })
nnoremap('<leader>xq', function() require("trouble").toggle("quickfix") end,
    { silent = false, desc = 'Show document quickfix' })
nnoremap('<leader>xl', function() require("trouble").toggle("loclist") end, { silent = false, desc = 'Show loclist' })


nnoremap('<C-k>', "<cmd>:wincmd k<CR>", { silent = true, desc = 'To top window' })
nnoremap('<C-j>', "<cmd>:wincmd j<CR>", { silent = true, desc = 'To bottom window' })
nnoremap('<C-h>', "<cmd>:wincmd h<CR>", { silent = true, desc = 'To left window' })
nnoremap('<C-l>', "<cmd>:wincmd l<CR>", { silent = true, desc = 'To right window' })

nnoremap('<leader>cl', formatBuffer, { silent = true, desc = 'Format code' })
