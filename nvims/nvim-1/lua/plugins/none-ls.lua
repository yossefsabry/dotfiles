return {
  "nvimtools/none-ls.nvim",
  lazy = true,
  keys = {
    { "<leader>ff", function() require('nvim-lsp-installer').setup({}) end, desc = "Format current buffer with LSP" }
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.biome,
        -- null_ls.builtins.diagnostics.rubocop,
        -- null_ls.builtins.formatting.rubocop,
      },
    })

    vim.keymap.set("n", "<leader>ff", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format current buffer with LSP" })
  end,
}
