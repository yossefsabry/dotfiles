return {
    {
        -- "ThePrimeagen/vim-be-good",
    },
    {
        "mbbill/undotree",
        Cmd = { "UndotreeToggle" },
        keys = {
            { "<leader>nn", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" }
        },
    },
    {
        -- install markdown Preview auto work
        -- some denpeneds is ( pandoc, npm install -g @compodoc/live-server)
        -- "davidgranstrom/nvim-markdown-preview", -- make some problem when see info about any thing shift+k  file
    },
    {
        -- for auto close html tags
        -- "windwp/nvim-ts-autotag",
        -- lazy = true,
        -- config = function()
        -- require("nvim-ts-autotag").setup()
        -- end,
    },
    {
        "Shobhit-Nagpal/nvim-rafce",
        lazy = true,
        cmd = { "Rafce" },
        config = function()
            require("rafce")
        end,
    },
    {
		-- transparnet background color for nvim
		"tribela/vim-transparent",
    },
}
