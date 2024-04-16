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
    -- for auto close html tags
    "windwp/nvim-ts-autotag",
  },
}
