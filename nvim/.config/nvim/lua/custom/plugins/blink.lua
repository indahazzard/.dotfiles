return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  opts = {
    keymap = {
      preset = 'super-tab',
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-d>'] = { function(cmp) cmp.scroll_documentation_down(4) end },
      ['<C-f>'] = { function(cmp) cmp.scroll_documentation_up(4) end },
      ['<C-Space>'] = { 'show', 'fallback' },
      ['<CR>'] = {
        function(cmp)
          if cmp.is_visible() then
            cmp.accept()
            cmp.hide()
            return true
          end
          return false
        end,
        'fallback'
    },
      ['<Tab>'] = {
        'snippet_forward',
        'select_next',
        'fallback'
      },
      ['<S-Tab>'] = {
        'snippet_backward',
        'select_prev',
        'fallback'
      }
    },

    completion = {
      documentation = {
        auto_show = true,
        window = {
            border = 'rounded'
        }
      },

      menu = {
          border = 'rounded'
      }
    },

    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'buffer'
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning"
    }
  },
  opts_extend = { "sources.default" }
}
