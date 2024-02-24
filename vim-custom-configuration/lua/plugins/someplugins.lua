return {
  {
    "ThePrimeagen/vim-be-good",
  },
  {
    -- github 
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>nn", vim.cmd.UndotreeToggle)
    end,
  },
}
