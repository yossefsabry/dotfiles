return {
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
          config = function()
            vim.cmd.colorscheme("tokyonight")
            vim.g.enfocado_style = 'nature'
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
          end
    },
}
