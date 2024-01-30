return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem reveal left<CR>", {})
    -- Assuming you have this line in your config for nvim-tree
    vim.g.nvim_tree_highlight_opened_files = 1

    -- Set the background color to transparent
    vim.cmd [[
      highlight NvimTreeNormal guibg=NONE ctermbg=NONE
      highlight NvimTreeVertSplit guibg=NONE ctermbg=NONE
      highlight NvimTreeCursorLine guibg=NONE ctermbg=NONE
      highlight NvimTreeStatusline guibg=NONE ctermbg=NONE
      highlight NvimTreeWindowPicker guibg=NONE ctermbg=NONE
      highlight NvimTreeVertSplit guibg=NONE ctermbg=NONE
      highlight NvimTreeVertSplit guibg=NONE ctermbg=NONE
      highlight NvimTreeRootFolder guibg=NONE ctermbg=NONE
      highlight NvimTreeIndentMarker guibg=NONE ctermbg=NONE
      highlight NvimTreeImageFile guibg=NONE ctermbg=NONE
      highlight NvimTreeSymlink guibg=NONE ctermbg=NONE
      highlight NvimTreeSpecialFile guibg=NONE ctermbg=NONE
      highlight NvimTreeFolderName guibg=NONE ctermbg=NONE
      highlight NvimTreeEmptyFolderName guibg=NONE ctermbg=NONE
      highlight NvimTreeOpenedFile guibg=NONE ctermbg=NONE
      highlight NvimTreeExecFile guibg=NONE ctermbg=NONE
      highlight NvimTreeRootFolder guibg=NONE ctermbg=NONE
      highlight NvimTreeFolderIcon guibg=NONE ctermbg=NONE
      highlight NvimTreeEmptyFolderIcon guibg=NONE ctermbg=NONE
      highlight NvimTreeOpenedFolderIcon guibg=NONE ctermbg=NONE
      highlight NvimTreeClosedFolderIcon guibg=NONE ctermbg=NONE
      highlight NvimTreeOpenedFile guibg=NONE ctermbg=NONE
      highlight NvimTreeSpecialFile guibg=NONE ctermbg=NONE
  ]]
  end,
}
