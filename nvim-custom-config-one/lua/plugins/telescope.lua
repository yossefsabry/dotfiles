return {
   'nvim-telescope/telescope.nvim',
   tag = '0.1.5',
   -- or                              , branch = '0.1.x',
   dependencies = { 'nvim-lua/plenary.nvim' },
   config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fs', builtin.find_files, {})

      require('telescope').setup {
         defaults = {
            file_ignore_patterns = {
               "node_modules",
                "lib",
                "lib64",
                ".git",
                "include/site"
            }
         }
      }
   end

}
