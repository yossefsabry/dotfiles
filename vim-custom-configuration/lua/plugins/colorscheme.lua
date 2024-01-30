return {
  {

    "ellisonleao/gruvbox.nvim",
    lazy = false,
    name = "gruvbox",
    config = function()
      vim.cmd.colorscheme("gruvbox")
      vim.g.enfocado_style = 'nature'
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  --   config = function()
  --     vim.cmd.colorscheme("tokyonight")
  --     vim.g.enfocado_style = 'nature'
  --   end
  },
  {
    -- transparnet background color for nvim
    'tribela/vim-transparent',
  },
}
