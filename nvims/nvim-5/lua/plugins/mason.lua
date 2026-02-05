return {
	"williamboman/mason.nvim",
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
            -- ensure these language parsers are installed
            ensure_installed = {
                --"tsserver", -- typescript and javascript (not valild)
                "tailwindcss", -- tailwindcss
                "clangd", -- for c and c++
                "lua_ls", -- lua
                "gopls", -- go
                "bashls", -- bash
                "phpactor", -- php
            },

        })

		mason_tool_installer.setup({
		})
	end,
}
