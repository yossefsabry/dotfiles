return {
  "ThePrimeagen/harpoon",
  lazy = true,
  keys = {
    { "<leader>a", "<cmd>HarpoonAddFile<CR>", desc = "Mark file with harpoon" },
    { "<C-n>", "<cmd>HarpoonNavNext<CR>", desc = "Go to next harpoon mark" },
    { "<C-p>", "<cmd>HarpoonNavPrev<CR>", desc = "Go to previous harpoon mark" },
    { "<leader>hu", "<cmd>HarpoonToggleQuickMenu<CR>", desc = "Toggle harpoon quick menu" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- Define custom commands
    vim.api.nvim_create_user_command("HarpoonAddFile", function()
      require("harpoon.mark").add_file()
    end, {})
    vim.api.nvim_create_user_command("HarpoonNavNext", function()
      require("harpoon.ui").nav_next()
    end, {})
    vim.api.nvim_create_user_command("HarpoonNavPrev", function()
      require("harpoon.ui").nav_prev()
    end, {})
    vim.api.nvim_create_user_command("HarpoonToggleQuickMenu", function()
      require("harpoon.ui").toggle_quick_menu()
    end, {})
  end,
}

