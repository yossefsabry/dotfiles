return {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    cmd = { 'Telescope' }, -- This will load the plugin when any Telescope command is used
    keys = {
        { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = "Live Grep with Telescope" },
        { '<leader>fs', function() require('telescope.builtin').find_files() end, desc = "Find Files with Telescope" },
        { '<leader>r', function() require('telescope.builtin').oldfiles() end, desc = "Recent Files with Telescope" },
    },
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup {
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    "lib",
                    "lib64",
                    ".git",
                    "include/site",
                    "vendor"
                }
            }
        }
    end,
}

