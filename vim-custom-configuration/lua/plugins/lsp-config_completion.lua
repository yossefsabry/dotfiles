return {
	{
		"hrsh7th/nvim-cmp", -- Autocompletion plugin
		"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
		cnofig = true,
		lazy = false,
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local signs = { Error = "", Warn = "", Hint = "", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
			-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
			local lspconfig = require("lspconfig")
			local servers =
				{ "clangd", "rust_analyzer", "pyright", "tsserver", "html", "lua_ls", "ast_grep", "cssls", "gopls"}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					-- on_attach = my_custom_on_attach,
					capabilities = capabilities,
				})
			end
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", function()
						vim.lsp.buf.definition()
					end, opts)
					vim.keymap.set("n", "K", function()
						vim.lsp.buf.hover()
					end, opts)
					vim.keymap.set("n", "<leader>vca", function()
						vim.lsp.buf.code_action()
					end, opts)
					vim.keymap.set("n", "<leader>vrr", function()
						vim.lsp.buf.references()
					end, opts)
					vim.keymap.set("n", "<leader>vrn", function()
						vim.lsp.buf.rename()
					end, opts)
					vim.keymap.set("i", "<C-h>", function()
						vim.lsp.buf.signature_help()
					end, opts)
					vim.keymap.set("n", "<space>vd", vim.diagnostic.open_float)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
					vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
				end,
			})

			vim.diagnostic.config({
				virtual_text = {
					prefix = "--", -- Could be '■', '▎', 'x'
				},
			})
			vim.diagnostic.config({
				signs = false,
			})

			-- luasnip setup
			local luasnip = require("luasnip")

			-- nvim-cmp setup
			local cmp = require("cmp")
			cmp.setup({
				window = {
					documentation = cmp.config.window.bordered(),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
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
				sources = cmp.config.sources({
					{ name = "copilot" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
