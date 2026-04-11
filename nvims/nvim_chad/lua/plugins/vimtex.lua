local function has_latex_parser()
  local data = vim.fn.stdpath("data")
  local parser_paths = {
    data .. "/site/parser/latex.so",
    data .. "/parser/latex.so",
  }

  for _, path in ipairs(parser_paths) do
    if vim.loop.fs_stat(path) then
      return true
    end
  end

  return false
end

return {
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>mv", "<cmd>Markview toggle<cr>", desc = "Toggle Markdown preview" },
      { "<leader>mh", "<cmd>Markview HybridToggle<cr>", desc = "Toggle Markdown hybrid" },
    },
    config = function()
      require("markview").setup({
        latex = {
          enable = false,
        },
        preview = {
          enable = true,
          enable_hybrid_mode = true,
          filetypes = { "markdown" },
          ignore_buftypes = { "nofile" },
          condition = nil,
          debounce = 120,
          max_buf_lines = 500,
          modes = { "n", "no", "c" },
          hybrid_modes = { "n" },
          raw_previews = {},
          linewise_hybrid_mode = false,
          edit_range = { 0, 0 },
          map_gx = false,
        },
      })

      local group = vim.api.nvim_create_augroup("UserMarkdownMathPreview", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "markdown",
        callback = function()
          if has_latex_parser() or vim.g.markview_latex_warned then
            return
          end

          vim.g.markview_latex_warned = true

          vim.schedule(function()
            vim.notify(
              "markview.nvim needs the Treesitter latex parser for Markdown math rendering. Run :TSInstall latex",
              vim.log.levels.WARN
            )
          end)
        end,
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

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    event = "InsertEnter",
    dependencies = {
      "iurimateus/luasnip-latex-snippets.nvim",
    },
    config = function()
      local ls = require("luasnip")

      ls.config.set_config({
        enable_autosnippets = true,
        updateevents = "TextChanged,TextChangedI",
      })

      require("luasnip-latex-snippets").setup()
      ls.filetype_extend("markdown", { "tex" })

      vim.keymap.set("i", "<C-k>", function()
        if ls.expandable() then
          ls.expand()
        end
      end, { silent = true, desc = "LuaSnip expand" })

      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.jumpable(1) then
          ls.jump(1)
        end
      end, { silent = true, desc = "LuaSnip jump forward" })

      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = "LuaSnip jump backward" })

      vim.keymap.set({ "i", "s" }, "<C-e>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = "LuaSnip next choice" })
    end,
  },
}
