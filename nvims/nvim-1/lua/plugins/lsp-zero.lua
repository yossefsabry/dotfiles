---@diagnostic disable: undefined-global
return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        event = "BufReadPre",
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
            "mlaursen/vim-react-snippets",
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_cmp()

            local cmp = require("cmp")
            local cmp_action = lsp_zero.cmp_action()

            -- for vscode snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                formatting = lsp_zero.cmp_format({ details = true }),
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                }),
                performance = {
                    max_view_entries = 7,
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path", group_index = 2 },
                }, {
                    { name = "buffer" },
                }),
            })

            vim.diagnostic.config({
                virtual_text = {
                    prefix = "--", -- Could be '■', '▎', 'x'
                },
            })

            lsp_zero.set_sign_icons({
                error = "",
                warn = "",
                hint = "",
                info = "",
            })
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        cmd = "LspInfo",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            local lspconfig = require("lspconfig")
            -- lspconfig.pyright.setup{} -- for python
            local util = lspconfig.util

            -- Set a global root_dir for all servers
            lsp_zero.set_server_config({
                root_dir = function(fname)
                    return util.root_pattern( "vendor/", ".git",
                        "package.json", "Makefile", "requirements.txt",
                        "README.md")(fname)
                        or util.path.dirname(fname)
                end,
            })

            lsp_zero.on_attach(function(_, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require("mason").setup({})
            require("mason-lspconfig").setup({
                handlers = {
                    lsp_zero.default_setup,
                },
            })

            vim.diagnostic.config({
                virtual_text = {
                    prefix = "--", -- Could be '■', '▎', 'x'
                },
            })

            lsp_zero.set_sign_icons({
                error = "",
                warn = "",
                hint = "",
                info = "",
            })

            -- (Optional) Configure lua language server for Neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
        end,
    },
}

