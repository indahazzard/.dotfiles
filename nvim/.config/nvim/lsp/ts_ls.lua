return {
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
    }
