require("keymap")
require("option")
require("plugins.lazy")

-- adding new option for nvim --

-- Set termguicolors to enable true color support
vim.o.termguicolors = true
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

-- diable auto comment nextline 
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- adding folds for nvim and save theme and load theme when open file
vim.api.nvim_create_autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  desc = "save view (folds), when closing file",
  command = "mkview",
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})

