return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.biome,
				-- null_ls.builtins.diagnostics.rubocop,
				-- null_ls.builtins.formatting.rubocop,
			},
		})

		vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {})
	end,
}
