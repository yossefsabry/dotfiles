return {
  "nvim-lualine/lualine.nvim",
  lazy = true,
  event = "BufAdd",
  config = function()
    require("lualine").setup({
        globalstatus = false,
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "男", right = "後" },
        section_separators = { left = "▓ 팣", right = " ▓" }, -- ▓
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
