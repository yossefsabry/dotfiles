-- Define key mapping function
local function keymap(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {})
end

-- Define terminal key mapping options
local term_opts = { noremap = true, silent = true, nowait = true }

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
-- ...
vim.opt.hlsearch = false -- disable search highlight
vim.opt.incsearch = true

-- Normal mode mappings switch between the split window
keymap("n", "<C-h>", "<C-w>h", term_opts)
keymap("n", "<C-j>", "<C-w>j", term_opts)
keymap("n", "<C-k>", "<C-w>k", term_opts)
keymap("n", "<C-l>", "<C-w>l", term_opts)

-- Center the screen after moving with search n/N
keymap("n", "<C-d>", "<C-d>zz", term_opts)
keymap("n", "<C-u>", "<C-u>zz", term_opts)
keymap("n", "n", "nzzzv", term_opts)
keymap("n", "N", "Nzzzv", term_opts)

-- for default noe tree
-- keymap("n", "<leader>e", ":Lex 20<cr>", term_opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +4<CR>", term_opts)
keymap("n", "<C-Down>", ":resize -4<CR>", term_opts)
keymap("n", "<C-Left>", ":vertical resize -4<CR>", term_opts)
keymap("n", "<C-Right>", ":vertical resize +4<CR>", term_opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", term_opts)
keymap("n", "<S-h>", ":bprevious<CR>", term_opts)

-- Visual mode mappings
keymap("v", "<", "<gv", term_opts)
keymap("v", ">", ">gv", term_opts)

-- Move text up and down in visual mode
keymap("v", "<A-j>", ":m .+1<CR>==", term_opts)
keymap("v", "<A-k>", ":m .-2<CR>==", term_opts)
keymap("v", "p", '"_dP', term_opts)

-- Visual block mode mappings
keymap("x", "J", ":move '>+1<CR>gv-gv", term_opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", term_opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", term_opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", term_opts)

-- Terminal mode mappings
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

vim.cmd("set expandtab")
vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=3")
vim.cmd("set shiftwidth=3")

-- Navigate vim panes better

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", term_opts )
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", term_opts  )
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", term_opts )
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", term_opts)

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", term_opts )
vim.wo.relativenumber = true

-- insert mode
keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- disabkeymapys in insert mode ---
keymap("i", "<left>", "<nop>", term_opts)
keymap("i", "<right>", "<nop>", term_opts)
keymap("i", "<up>", "<nop>", term_opts)
keymap("i", "<down>", "<nop>", term_opts)

-- Key mkeymape_runner.nvim
keymap("n", "<A-r>", ":RunCode<CR>", term_opts)
keymap("n", "<A-r>f", ":RunFile<CR>", term_opts)
keymap("n", "<A-r>p", ":RunProject<CR>", term_opts)
keymap("n", "<A-r>c", ":RunClose<CR>", term_opts)
keymap("n", "<A-r>cp", ":CRProjects<CR>", term_opts)

