return {
  {
    "ThePrimeagen/vim-be-good",
  },
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>nn", vim.cmd.UndotreeToggle)
    end,
  },
  {
    -- install markdown Preview auto work
    "instant-markdown/vim-instant-markdown",
  },
  {
    -- auto session
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({})
    end,
  },
  {
    -- for auto close html tags
    "windwp/nvim-ts-autotag",
  },
}
