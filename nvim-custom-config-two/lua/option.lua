
-- netre custom
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 0
vim.g.netrw_liststyle = 0

-- Modes
vim.opt.hlsearch = false -- disable search highlight
vim.opt.incsearch = true
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

-- set highlight in cursor line
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50



