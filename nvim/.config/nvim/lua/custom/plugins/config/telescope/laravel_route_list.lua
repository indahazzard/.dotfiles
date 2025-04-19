local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local json_decode = vim.fn.json_decode
local Path = require "plenary.path"

local M = {}
local get_client = function(server_name)
    local clients = vim.lsp.get_clients { name = server_name }
    local client = clients[1] or nil
    local new_instance = false

    if not client then
        local server = lspconfig[server_name]

        if not server then
            error("LSP server not found: " .. server_name)
        end

        local client_id = vim.lsp.start(server.setup { root_dir = vim.loop.cwd() })

        if not client_id then
            error "Could not start lsp client"
        end

        client = vim.lsp.get_client_by_id(client_id)

        new_instance = true
    end

    return client, new_instance
end

local function custom_lsp_workspace_symbols(opts)
  opts = opts or {}
  local query = opts.query or ""

  local clients = vim.lsp.get_active_clients({
    name = "intelephense",
  })

  if vim.tbl_isempty(clients) then
    vim.notify("[LSP] intelephense is not attached", vim.log.levels.WARN)
    return
  end

  local client = clients[1]
  client.request("workspace/symbol", { query = query }, function(err, result)
    if err then
      vim.notify("[LSP] " .. err.message, vim.log.levels.ERROR)
      return
    end

    if not result or #result == 0 then
      vim.notify("[LSP] No symbols found for query", vim.log.levels.INFO)
      return
    end

    for _, symbol in ipairs(result) do
      if vim.lsp.protocol.SymbolKind[symbol.kind] == "Class" then
        local uri = symbol.location.uri
        local filename = vim.uri_to_fname(uri)

        if vim.api.nvim_buf_get_name(0) ~= filename then
          pcall(vim.cmd.edit, vim.fn.fnameescape(filename))
        end
        return
      end
    end

    vim.notify("[LSP] Class not found", vim.log.levels.INFO)
  end)
end

M.laravel_route = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()

    local finder = finders.new_async_job {
        command_generator = function(prompt)
            if not prompt or prompt == "" or prompt == " " then
                return nil
            end

            return {
                "sh", "-c",
                string.format(
                    'php artisan r:l --json | jq -c \'.[] | select((.name and (.name | type == "string") and (.name | contains("%s"))) or (.uri and (.uri | type == "string") and (.uri | contains("%s"))))\'',
                    prompt, prompt
                )
            }
        end,

        entry_maker = function(line)
            local route = json_decode(line)
            if route then
                return {
                    value = route.uri,
                    display = (route.method or "[no method]") ..
                        " " .. (route.uri or "[no uri]") .. " " .. (route.name or "[no name]"),
                    ordinal = route.name or route.uri,
                    route = route,
                }
            end
            return nil
        end,
    }

    pickers.new(opts, {
        prompt_title = "Laravel Routes",
        finder = finder,
        previewer = nil,
        sorter = require "telescope.sorters".empty(),
        attach_mappings = function(prompt_bufnr, map)
            local action_state = require "telescope.actions.state"
            local actions = require "telescope.actions"

            map("n", "<CR>", function()
                local entry = action_state.get_selected_entry()

                if entry and entry.route and entry.route.action then
                    actions.close(prompt_bufnr)

                    custom_lsp_workspace_symbols({ query = entry.route.action })
                else
                    print("Invalid entry or route")
                end
            end)

            return true
        end,
    }):find()
end

return M
