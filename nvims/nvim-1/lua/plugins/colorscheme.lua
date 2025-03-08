return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		  config = function()
		      vim.cmd.colorscheme("tokyonight")
		      vim.g.enfocado_style = 'nature'
		      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		  end
	},
	{
		  -- adding color scheme for user
		"rose-pine/neovim",
		as = "rose-pine",
		config = function()
			vim.cmd.colorscheme("rose-pine")
		          -- vim.cmd.colorscheme("zaibatsu")
			vim.g.enfocado_style = "nature"
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},
	{
		-- transparnet background color for nvim
		"tribela/vim-transparent",
	},
}
