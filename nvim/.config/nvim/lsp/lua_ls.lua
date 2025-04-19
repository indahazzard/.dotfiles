return {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            runtime = {
                -- Tell the language server you're using LuaJIT in Neovim
                version = "LuaJIT",
            },
            diagnostics = {
                -- Recognize the `vim` global
                globals = { "vim" },
            },
        },
    }

