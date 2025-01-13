local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local json_decode = vim.fn.json_decode
local Path = require "plenary.path"

local M = {}
local lspconfig = require("mason-lspconfig")
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
    local lsp, is_new_instance = get_client('intelephense')

    if not lsp then
        vim.notify("Lsp not found")
    end

    local resp = lsp.request_sync("workspace/symbol", { query = query }, nil)
    local class_location = nil

    for _, location in pairs(resp.result) do
        if
            location.location
            and vim.lsp.protocol.SymbolKind[location.kind] or '' == "Class"
        then
            class_location = location
            break
        end
    end

    local filename = vim.uri_to_fname(class_location.location.uri)

    if vim.api.nvim_buf_get_name(0) ~= filename then
        filename = Path:new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
        pcall(vim.cmd, string.format("%s %s", "edit", filename))
    end

    if is_new_instance then
        vim.lsp.stop_client(lsp.id)
    end
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
