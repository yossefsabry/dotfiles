-- Define key mapping function
local function keymap(mode, lhs, rhs, opts)
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {})
end

-- Define terminal key mapping options
local term_opts = { noremap = true, silent = true, nowait = true }

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netre custom
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3

-- Modes
vim.opt.hlsearch = false -- disable search highlight
vim.opt.incsearch = true
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50


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
keymap("n","G", "Gzz", term_opts)

-- Set keymaps for indenting selected lines in visual mode
vim.api.nvim_set_keymap('x', 'J', ":m '>+1<CR>gv=gv", term_opts)
vim.api.nvim_set_keymap('x', 'K', ":m '<-2<CR>gv=gv", term_opts)

-- for default noe tree
keymap("n", "<leader>e", ":Lex 20<cr>", term_opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +4<CR>", term_opts)
keymap("n", "<C-Down>", ":resize -4<CR>", term_opts)
keymap("n", "<C-Left>", ":vertical resize -4<CR>", term_opts)
keymap("n", "<C-Right>", ":vertical resize +4<CR>", term_opts)

-- Navigate buffers
keymap("n", "<S-h>", ":bprevious<CR>", term_opts)
keymap("n", "<S-l>", ":bnext<CR>", term_opts)

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
-- Navigate vim panes better

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", term_opts)
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", term_opts)
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", term_opts)
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", term_opts)


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

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")


vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("Ex")
end)


vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

