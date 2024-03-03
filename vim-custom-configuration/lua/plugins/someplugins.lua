return {
	{
		"ThePrimeagen/vim-be-good",
	},
	{
		-- github
		"github/copilot.vim"
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>nn", vim.cmd.UndotreeToggle)
		end,
	},
}
