return {
    "kdheepak/lazygit.nvim",
    require = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        -- Load Telescope and LazyGit
        local telescope = require("telescope")
        local lazygit = require("telescope").extensions.lazygit

        -- Set up LazyGit with Telescope
        telescope.setup {
            extensions = {
                lazygit = {
                    enable = true,
                    keymaps = {
                        -- Set key mapping for LazyGit
                        toggle = "<leader>gg",
                    },
                },
            },
        }

        -- Load the LazyGit extension
        telescope.load_extension("lazygit")

        -- Set key mapping for LazyGit in normal mode
        vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd> LazyGit<CR>", { noremap = true, silent = true, desc = "LazyGit UI" })
    end,
}
