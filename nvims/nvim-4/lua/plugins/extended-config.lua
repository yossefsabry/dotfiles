---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
    },
    opts = function(_, opts)
      local actions = require "telescope.actions"
      opts.pickers = {
        buffers = {
          theme = "dropdown",
        },
        find_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
        },
        git_files = {
          show_untracked = true,
          theme = "ivy",
        },
        live_grep = {
          theme = "ivy",
        },
        lsp_definitions = {
          theme = "cursor",
        },
        lsp_references = {
          theme = "cursor",
        },
      }
      opts.defaults = {
        hidden = true,
        prompt_prefix = "   ",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",

        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          width = 0.87,
          height = 0.80,
        },
        path_display = {
          filename_first = {
            reverse_directories = true,
          },
        },
        mappings = {
          i = {
            ["<esc>"] = "close",
            ["<c-g>"] = "close",
            ["<c-t>"] = require("trouble.sources.telescope").open,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
          },
          n = {
            ["<c-t>"] = require("trouble.sources.telescope").open,
          },
        },
        file_ignore_patterns = {
          "%.git/.*",
          "%.vim/.*",
          "node_modules/.*",
          "%.idea/.*",
          "%.vscode/.*",
          "%.history/.*",
        },
      }
    end,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup {}
      require("telescope").load_extension "textcase"
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function() require("telescope").load_extension "fzf" end,
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    keys = {
      { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Find undo" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    opts = {
      hint = "floating-big-letter",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.completion = {
        completeopt = "menu,menuone,noinsert",
      }
      opts.sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
        { name = "emoji", priority = 700 },
      }
      return opts
    end,
  },
}
