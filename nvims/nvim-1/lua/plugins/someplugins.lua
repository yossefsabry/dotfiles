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
    -- some denpeneds is ( pandoc, npm install -g @compodoc/live-server)
    "davidgranstrom/nvim-markdown-preview", -- make some problem when see info about any thing shift+k  file
  },
  {
    -- for auto close html tags
    "windwp/nvim-ts-autotag",
  },
}
