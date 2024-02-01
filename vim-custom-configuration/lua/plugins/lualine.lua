return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
         options = {
            theme = "palenight",
            -- theme = "gruvbox_dark",
			},
		})
	end,
}
