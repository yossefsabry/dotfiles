return {
    "williamboman/mason.nvim",
    lazy = true,
    Cmd = { "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonList", "MasonSearch" },
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        -- import mason
        local mason = require("mason")
        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                -- "tsserver", -- typescript and javascript
                -- "tailwindcss", -- tailwindcss
                "clangd", -- for c and c++
                "denols", -- for js, typescript
                "lua_ls", -- lua
                "gopls", -- go
                "bashls", -- bash
                "pyright", -- python
                "phpactor", -- php
                -- "intelephense", -- php
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })

        mason_tool_installer.setup({
            ensure_installed = {
                -- "prettier", -- prettier formatter
                -- "prettierd", -- prettier formatter
                -- "stylua", -- lua formatter
                -- "eslint_d", -- js linter
                -- "biome", -- js linterk
            },
        })
    end,
}
