return {
	{

		"hrsh7th/nvim-cmp", -- Autocompletion plugin
		"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
		"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
		"L3MON4D3/LuaSnip",
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
			local servers = { "clangd", "rust_analyzer", "pyright", "tsserver", "html", "lua_ls", "ast_grep" }
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
					vim.keymap.set("n", "<leader>vws", function()
						vim.lsp.buf.workspace_symbol()
					end, opts)
					vim.keymap.set("n", "<leader>vd", function()
						vim.diagnostic.open_float()
					end, opts)
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.goto_next()
					end, opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.goto_prev()
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
				end,
				vim.diagnostic.config({
					virtual_text = {
						prefix = "⋄⋄", -- Could be '●', '▎', 'x'
					},
				}),
			})

			-- luasnip setup
			local luasnip = require("luasnip")

			-- nvim-cmp setup
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
					["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
					-- C-b (back) C-f (forward) for snippet placeholder navigation.
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			})
		end,
	},
}
