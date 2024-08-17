---@type LazySpec
return {
  {
    "andrewferrier/debugprint.nvim",
    keys = {
      { "g?", mode = "n", desc = "Debug Print" },
      { "g?", mode = "x", desc = "Debug Print" },
    },
    opts = {
      keymaps = {
        normal = {
          plain_below = "g?p",
          plain_above = "g?P",
          variable_below = "g?v",
          variable_above = "g?V",
          variable_below_alwaysprompt = nil,
          variable_above_alwaysprompt = nil,
          textobj_below = "g?o",
          textobj_above = "g?O",
          toggle_comment_debug_prints = nil,
          delete_debug_prints = nil,
        },
        visual = {
          variable_below = "g?v",
          variable_above = "g?V",
        },
      },
    },
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = "Neogen",
    keys = {
      { "gD", function() require("neogen").generate {} end, desc = "Neogen" },
    },
    config = true,
  },
  {
    "smjonas/live-command.nvim",
    cmd = { "Norm" },
    config = function()
      require("live-command").setup {
        commands = {
          Norm = { cmd = "norm" },
        },
      }
    end,
  },
  {
    "jxnblk/vim-mdx-js",
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>lgc", "<cmd>LazyGitConfig<cr>", desc = "LazyGitConfig" },
      { "<leader>lgf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGitFilterCurrentFile" },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    opts = {
      handlers = {
        cursor = false,
      },
    },
  },
  {
    "xlboy/swap-ternary.nvim",
    opts = {},
    config = function() end,
  },
  {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
  },
  {
    "gsuuon/tshjkl.nvim",
    opts = {
      keymaps = {
        toggle = "<S>gv",
      },
    },
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "xlboy/node-edge-toggler.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "%", function() require("node-edge-toggler").toggle() end, desc = "Node start/end toggle" },
    },
  },
  {
    "soulis-1256/eagle.nvim",
    opts = {},
  },
  {
    "mcauley-penney/visual-whitespace.nvim",
    config = true,
  },
  {
    "rasulomaroff/reactive.nvim",
    opts = {
      builtin = {
        cursorline = true,
        cursor = true,
        modemsg = true,
      },
    },
  },
  {
    "folke/drop.nvim",
    enabled = false,
    opts = {
      ---@type DropTheme|string
      theme = "auto", -- when auto, it will choose a theme based on the date
    },
  },
  {
    "olrtg/nvim-emmet",
    config = function() vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation) end,
  },
  {
    "sontungexpt/better-diagnostic-virtual-text",
    event = "LspAttach",
    config = function()
      require("better-diagnostic-virtual-text").setup {
        ui = {
          wrap_line_after = false, -- Wrap the line after this length to avoid the virtual text is too long
          left_kept_space = 3, --- The number of spaces kept on the left side of the virtual text, make sure it enough to custom for each line
          right_kept_space = 3, --- The number of spaces kept on the right side of the virtual text, make sure it enough to custom for each line
          arrow = "  ",
          up_arrow = "  ",
          down_arrow = "  ",
          above = false, -- The virtual text will be displayed above the line
        },
        inline = true,
      }
    end,
  },
}
