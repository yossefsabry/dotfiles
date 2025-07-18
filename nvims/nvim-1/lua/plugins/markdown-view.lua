return {
    {
        "OXY2DEV/markview.nvim",
        lazy = true,      -- Recommended
        ft = "markdown", -- If you decide to lazy-load anyway

        dependencies = {
            -- You will not need this if you installed the
            -- parsers manually
            -- Or if the parsers are in your $RUNTIMEPATH
            "nvim-treesitter/nvim-treesitter",

            "nvim-tree/nvim-web-devicons"
        }
    },
    {
        "lervag/vimtex",
        lazy = true,     -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
        end
    }
}

-- return{
--     "iamcco/markdown-preview.nvim",
--     ft = "markdown",
--     run = "cd app && npm install",  -- Installs dependencies
--     setup = function()
--         vim.g.mkdp_auto_start = 1     -- Automatically start preview
--         vim.g.mkdp_auto_close = 1     -- Automatically close preview when buffer is closed
--         vim.g.mkdp_refresh_slow = 1   -- Slow refresh for large files
--         vim.g.mkdp_markdown_css = ""  -- Customize CSS (optional)
--         vim.g.mkdp_theme = "dark"     -- Theme for preview window
--         vim.g.mkdp_preview_options = {
--             disable_sync_scroll = 0, 
--             hide_yaml_meta = 1,
--             sequence_diagrams = 1,
--             flowchart_diagrams = 1,
--             mermaid = 1,
--             mathjax = {
--                 enable = 1,
--                 inline = "$",
--                 block = "$$"
--             }
--         }
--     end,
--     dependencies = {
--         "nvim-treesitter/nvim-treesitter",
--         "nvim-tree/nvim-web-devicons"
--     }
-- }
--
