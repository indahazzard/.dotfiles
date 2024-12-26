local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local json_decode = vim.fn.json_decode

local M = {}

local function custom_lsp_workspace_symbols(opts)
    opts = opts or {}
    local query = opts.query or ""

    vim.lsp.buf_request(0, "workspace/symbol", { query = query }, function(err, result, ctx)
        if err then
            vim.notify("Error fetching workspace symbols: " .. vim.inspect(err), vim.log.levels.ERROR)
            return
        end

        local client = vim.lsp.get_client_by_id(ctx.client_id)

        if not client then
            vim.notify("No valid LSP client found.", vim.log.levels.ERROR)
            return
        end
        local offset_encoding = client.offset_encoding or "utf-16"

        local first_entry = result[1]
        if first_entry and first_entry.location then
            vim.lsp.util.jump_to_location(first_entry.location, offset_encoding)
        end
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
                    display = (route.method or "[no method]") .. " " .. (route.uri or "[no uri]") .. " " .. (route.name or "[no name]"),
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

                -- actions.close(prompt_bufnr)
            end)

            return true
        end,
    }):find()
end

return M
