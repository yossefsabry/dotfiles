return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		name = "kanagawa",
		config = function()
		    vim.cmd.colorscheme("kanagawa-wave")
		    vim.g.enfocado_style = 'nature'
		    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		name = "gruvbox",
		-- config = function()
		--     vim.cmd.colorscheme("gruvbox")
		--     vim.g.enfocado_style = 'nature'
		--     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		--     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		-- end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		--   config = function()
		--       vim.cmd.colorscheme("tokyonight")
		--       vim.g.enfocado_style = 'nature'
		--       vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		--       vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		--   end
	},
	{
		"rose-pine/neovim",
		lazy = false,
		as = "rose-pine",
		-- config = function()
		-- 	vim.cmd("colorscheme rose-pine-main")
		-- 	vim.g.enfocado_style = "nature"
		-- 	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		-- 	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		-- end,
	},
	{
		-- transparnet background color for nvim
		"tribela/vim-transparent",
	},
}
