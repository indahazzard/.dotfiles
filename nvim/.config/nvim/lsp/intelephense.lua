-- Base config
local intelephense = {
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
        exclude = {}
    }
}

local function deepMerge(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" and type(t1[k]) == "table" then
            deepMerge(t1[k], v)
        elseif type(v) == "table" and type(t1[k]) ~= "table" then
            t1[k] = vim.deepcopy(v)
        elseif type(v) ~= "table" then
            t1[k] = v
        end
    end
end

local ok, localSettings = pcall(require, 'local_lsp_config')
if ok and localSettings.intelephense then
    deepMerge(intelephense, localSettings.intelephense)

    if intelephense.environment and intelephense.environment.includePaths then
        local seen = {}
        local uniquePaths = {}
        for _, path in ipairs(intelephense.environment.includePaths) do
            if not seen[path] then
                table.insert(uniquePaths, path)
                seen[path] = true
            end
        end
        intelephense.environment.includePaths = uniquePaths
    end
end

return {
    intelephense = {
        settings = {
            intelephense = intelephense
        }
    }
}
