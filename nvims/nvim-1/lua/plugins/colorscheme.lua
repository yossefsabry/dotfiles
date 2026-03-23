
-- TOKYONIGHT COLOR SCHEME
-- return {
-- 	-- {
-- 	-- 	"folke/tokyonight.nvim",
-- 	-- 	lazy = false,
-- 	-- 	priority = 1000,
-- 	-- 	opts = {},
-- 	-- 	  config = function()
-- 	-- 	      vim.cmd.colorscheme("tokyonight")
-- 	-- 	      vim.g.enfocado_style = 'nature'
-- 	-- 	      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- 	-- 	      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- 	-- 	  end
-- 	-- },
-- 	{
-- 		  -- adding color scheme for user
--         "rose-pine/neovim",
--         priority = 1000,
-- 		as = "rose-pine",
--         opts = {
--             dark_variant = "moon",
--             styles = {italic = false},
--             palette = {
--                 dawn = {
--                     no_bg = "#faf4ed",
--                     cursor_bg = "#000000",
--                     cursor_fg = "#ffffff",
--                 },
--                 moon = {
--                     gold = "#f6d5a7",
--                     foam = "#a1d1da",
--                     iris = "#d9c7ef",
--                     rose = "#ebbcba",
--                     pine = "#437e91",
--                     no_bg = "#000000",
--                     cursor_bg = "#ffffff",
--                     cursor_fg = "#000000",
--                 },
--             },
--             highlight_groups = {
--                 Normal = {bg = "no_bg"},
--                 Cursor = {bg = "cursor_bg", fg = "cursor_fg"},
--                 Directory = {fg = "foam", bold = false},
--                 StatusLine = {bg = "surface", fg = "subtle"},
--                 StatusLineTerm = {link = "StatusLine"},
--                 StatusLineNC = {link = "StatusLine"},
--                 --- gitsigns
--                 StatusLineGitSignsAdd = {bg = "surface", fg = "pine"},
--                 StatusLineGitSignsChange = {bg = "surface", fg = "gold"},
--                 StatusLineGitSignsDelete = {bg = "surface", fg = "rose"},
--                 --- diagnostics
--                 StatusLineDiagnosticSignError = {bg = "surface", fg = "love"},
--                 StatusLineDiagnosticSignWarn = {bg = "surface", fg = "gold"},
--                 StatusLineDiagnosticSignInfo = {bg = "surface", fg = "foam"},
--                 StatusLineDiagnosticSignHint = {bg = "surface", fg = "iris"},
--                 StatusLineDiagnosticSignOk = {bg = "surface", fg = "pine"},
--             },
--         },
-- 		config = function()
-- 			vim.cmd.colorscheme("rose-pine")
--             -- vim.cmd.colorscheme("zaibatsu")
--             -- vim.g.enfocado_style = "nature"
--             -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--             -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- 		end,
-- 	},
-- 	{
-- 		-- transparnet background color for nvim
-- 		-- "tribela/vim-transparent",
-- 	},
-- }


-- ROSE-PINE COLOR SCHEME
return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        opts = {
            dark_variant = "moon",
            styles = { italic = false },
            palette = {
                dawn = {
                    no_bg = "#faf4ed",
                    cursor_bg = "#000000",
                    cursor_fg = "#ffffff",
                },
                moon = {
                    gold = "#f6d5a7",
                    foam = "#a1d1da",
                    iris = "#d9c7ef",
                    rose = "#ebbcba",
                    pine = "#437e91",
                    no_bg = "#000000",
                    cursor_bg = "#ffffff",
                    cursor_fg = "#000000",
                },
            },
            highlight_groups = {
                Normal = { bg = "no_bg" },
                Cursor = { bg = "cursor_bg", fg = "cursor_fg" },
                Directory = { fg = "foam", bold = false },
                StatusLine = { bg = "surface", fg = "subtle" },
                StatusLineTerm = { link = "StatusLine" },
                StatusLineNC = { link = "StatusLine" },
                --- gitsigns
                StatusLineGitSignsAdd = { bg = "surface", fg = "pine" },
                StatusLineGitSignsChange = { bg = "surface", fg = "gold" },
                StatusLineGitSignsDelete = { bg = "surface", fg = "rose" },
                --- diagnostics
                StatusLineDiagnosticSignError = { bg = "surface", fg = "love" },
                StatusLineDiagnosticSignWarn = { bg = "surface", fg = "gold" },
                StatusLineDiagnosticSignInfo = { bg = "surface", fg = "foam" },
                StatusLineDiagnosticSignHint = { bg = "surface", fg = "iris" },
                StatusLineDiagnosticSignOk = { bg = "surface", fg = "pine" },
            },
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd.colorscheme("rose-pine")
        end,
    },
    {
        -- transparnet background color for nvim
        "tribela/vim-transparent",
    },
}


-- JELLYBEANS COLOR SCHEME
-- return {
--     {
--         "metalelf0/jellybeans-nvim",
--         dependencies = { "rktjmp/lush.nvim" },
--         priority = 1000,
--         config = function()
--             vim.opt.termguicolors = true
--             vim.cmd.colorscheme("jellybeans-nvim")
--
--             -- custom highlights, like you did with rose-pine
--             vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
--             vim.api.nvim_set_hl(0, "Cursor", { bg = "#ffffff", fg = "#000000" })
--             vim.api.nvim_set_hl(0, "Directory", { fg = "#a1d1da", bold = false })
--
--             vim.api.nvim_set_hl(0, "StatusLine", { bg = "#1c1c1c", fg = "#808080" })
--             vim.api.nvim_set_hl(0, "StatusLineTerm", { link = "StatusLine" })
--             vim.api.nvim_set_hl(0, "StatusLineNC", { link = "StatusLine" })
--
--             -- gitsigns
--             vim.api.nvim_set_hl(0, "StatusLineGitSignsAdd", { bg = "#1c1c1c", fg = "#437e91" })
--             vim.api.nvim_set_hl(0, "StatusLineGitSignsChange", { bg = "#1c1c1c", fg = "#f6d5a7" })
--             vim.api.nvim_set_hl(0, "StatusLineGitSignsDelete", { bg = "#1c1c1c", fg = "#ebbcba" })
--
--             -- diagnostics
--             vim.api.nvim_set_hl(0, "StatusLineDiagnosticSignError", { bg = "#1c1c1c", fg = "#ff5f5f" })
--             vim.api.nvim_set_hl(0, "StatusLineDiagnosticSignWarn", { bg = "#1c1c1c", fg = "#f6d5a7" })
--             vim.api.nvim_set_hl(0, "StatusLineDiagnosticSignInfo", { bg = "#1c1c1c", fg = "#a1d1da" })
--             vim.api.nvim_set_hl(0, "StatusLineDiagnosticSignHint", { bg = "#1c1c1c", fg = "#d9c7ef" })
--             vim.api.nvim_set_hl(0, "StatusLineDiagnosticSignOk", { bg = "#1c1c1c", fg = "#437e91" })
--         end,
--     },
--     {
--         "tribela/vim-transparent",
--     },
-- }
