return {
    'freddiehaddad/feline.nvim',
    opts = {},
    config = function(_)
        local feline = require('feline')
        local defaults = require('feline.default_components')

        local full_path_component = {
            provider = function()
                return vim.fn.expand('%:.')
            end,
            left_sep = ' ',
            right_sep = ' ',
        }

        local project = {
            provider = function()
                return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end,
            hl = {
                style = 'bold',
            },
            left_sep = {
                str = ' | ',
                hl = { fg = 'white', },
            },
            right_sep = {
                str = ' | ',
                hl = { fg = 'white', },
            },
        }

        defaults.statusline.icons.active[1][3] = project

        table.insert(defaults.statusline.icons.active[1], 6, full_path_component)

        feline.setup({
            components = defaults.statusline.icons,
        })
    end,
}
