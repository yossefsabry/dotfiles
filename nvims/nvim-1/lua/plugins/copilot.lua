return {
   "zbirenbaum/copilot.lua",
   event = "VimEnter",
   config = function()
      vim.defer_fn(function()
         require("copilot").setup({
            suggestion = {
               auto_trigger = true,
               keymap = {
                  accept = "<C-j>", -- Change this to your preferred shortcut
               },
            },
         })
      end, 100)
   end,
}
