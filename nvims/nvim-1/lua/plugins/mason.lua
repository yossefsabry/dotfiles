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
                -- THERE IS BIG FIX
                -- "ast_grep", -- some lsps
                "clangd", -- for c and c++
                "lua_ls", -- lua
                "gopls", -- go
                "bashls", -- bash
                "pyright", -- python
                "phpactor", -- php
                -- "tailwindcss", -- tailwindcss
                -- for javascript and typescript check down
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })

        -- for install for typescript and javascript server check this  url
        -- https://arc.net/l/quote/gnfnumen
        -- automatically install ensure_installed servers     
        --  (✓ typescript-language-server ts_ls, ts_ls)
        require("mason-lspconfig").setup_handlers({
            -- Will be called for each installed server that doesn't have
            -- a dedicated handler.
            --
            function(server_name) -- default handler (optional)
                if server_name == "tsserver" then
                    server_name = "ts_ls"
                end
                local capabilities = require("cmp_nvim_lsp").default_capabilities()
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                })
            end,
        })

        -- code formatter
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
