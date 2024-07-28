return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  Cmd = { "TSInstall", "TSUpdate" }, -- Load the plugin when the TSInstall command is used
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,   -- for auto install the highlight for the languaga
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
