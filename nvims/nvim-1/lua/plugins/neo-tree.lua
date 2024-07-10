return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    require("neo-tree").setup({
      window = {
        position = "left",
        width = 28,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
    })
  end
}
