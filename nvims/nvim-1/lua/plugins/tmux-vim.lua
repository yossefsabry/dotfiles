return {
  "christoomey/vim-tmux-navigator",
  lazy = true,
  -- event = "VeryLazy",
  config = function()
    vim.g.tmux_navigator_no_mappings = 1
  end,
}
