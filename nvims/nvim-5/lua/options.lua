require "nvchad.options"

local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true


-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = false

-- stuff
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- splitting windows
opt.splitright = true
opt.splitbelow = true

-- hide ~ on empty line
opt.fillchars = { eob = " " }

opt.wrap = true
opt.swapfile = false

opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.scrolloff = 8
opt.isfname:append("@-@")

opt.updatetime = 50

opt.path:append('**')
