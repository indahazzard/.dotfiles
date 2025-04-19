return {
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
    }
