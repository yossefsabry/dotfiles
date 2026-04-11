return {
    {
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("markview").setup({
                latex = {
                    enable = false, -- latex-nvim handles math rendering
                },
                preview = {
                    enable = true,
                    enable_hybrid_mode = true,
                    filetypes = { "markdown" },
                    ignore_buftypes = { "nofile" },
                    debounce = 120,
                    modes = { "n", "no", "c" },
                    hybrid_modes = { "n" },
                },
            })
        end,
    },

    {
        "yossefsabry/latex_nvim",
        main = "latex_nvim",
        ft = { "markdown" },
        cmd = {
            "LatexNvimTogglePreview",
            "LatexNvimToggleConceal",
            "LatexNvimRefresh",
            "LatexNvimPreviewStatus",
        },
        opts = {
            compat = {
                respect_markview = true,
                reduce_presentation_with_markview = false,
                disable_when_vimtex_tex = true,
            },
            preview = {
                enabled = true,
                backend = "auto",
                fallback = "text",
                position = "above",
                debounce_ms = 120,
            },
            presentation = {
                conceal = {
                    enabled = true,
                    reveal_on_cursor = true,
                    reveal_delay_ms = 40,
                },
            },
        },
    },
}
