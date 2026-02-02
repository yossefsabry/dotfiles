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
vim.g.netrw_banner = 1
vim.g.netrw_winsize = 1
vim.g.netrw_liststyle = 1

-- Modes
vim.opt.hlsearch = false -- disable search highlight
vim.opt.incsearch = true
-- vim.opt.guicursor = "" -- for change the cursor to block in insert mode

-- setting color in column 75
vim.opt.colorcolumn = "75"

vim.opt.nu = true
vim.opt.relativenumber = true

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- set highlight in cursor line
vim.opt.cursorline = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
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
-- for ignore some files
vim.opt.wildignore:append("**/node_modules/**")
vim.opt.path:append('**')

vim.opt.updatetime = 250


-- Center the screen after moving with search n/N
keymap("n", "<C-d>", "<C-d>zz", term_opts)
keymap("n", "<C-u>", "<C-u>zz", term_opts)
keymap("n", "n", "nzzzv", term_opts)
keymap("n", "N", "Nzzzv", term_opts)
keymap("n", "G", "Gzz", term_opts)

-- Set keymaps for indenting selected lines in visual mode
vim.api.nvim_set_keymap("x", "J", ":m '>+1<CR>gv=gv", term_opts)
vim.api.nvim_set_keymap("x", "K", ":m '<-2<CR>gv=gv", term_opts)

-- for default noe tree
keymap("n", "<leader>e", ":vertical Ex<CR>", term_opts)
-- keymap("n", "<leader>vp", ":Neotree/home/yossef/Documents float<cr>", term_opts)
-- keymap("n", "<leader>e", ":Dirbuf <CR>", term_opts)

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

-- Visual block mode mappings
keymap("v", "J", ":m '>+1<CR>gv=gv", term_opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", term_opts)
keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", term_opts)
keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", term_opts)

-- Terminal mode mappings
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Navigate vim panes better
keymap("n", "<c-k>", ":wincmd k<CR>", term_opts)
keymap("n", "<c-j>", ":wincmd j<CR>", term_opts)
keymap("n", "<c-h>", ":wincmd h<CR>", term_opts)
keymap("n", "<c-l>", ":wincmd l<CR>", term_opts)

-- insert mode disable this for now
-- keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
-- keymap("i", "JK", "<Esc>", { noremap = true, silent = true })

-- disabkeymapys in insert mode ---
vim.keymap.set({ "n", "i" }, "<left>", "<nop>", term_opts)
vim.keymap.set({ "n", "i" }, "<right>", "<nop>", term_opts)
vim.keymap.set({ "n", "i" }, "<up>", "<nop>", term_opts)
vim.keymap.set({ "n", "i" }, "<down>", "<nop>", term_opts)

-- lsp Config rempap
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', term_opts)
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', term_opts)
keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', term_opts)
keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', term_opts)
keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', term_opts)
-- vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', term_opts)
keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', term_opts)
keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', term_opts)
keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', term_opts)
keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', term_opts)

-- Key mkeymape_runner.nvim
keymap("n", "<A-r>", ":RunCode<CR>", term_opts)
keymap("n", "<A-r>f", ":RunFile<CR>", term_opts)
keymap("n", "<A-r>p", ":RunProject<CR>", term_opts)
keymap("n", "<A-r>c", ":RunClose<CR>", term_opts)
keymap("n", "<A-r>cp", ":CRProjects<CR>", term_opts)

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])
keymap("x", "<leader>p", "\"_dp")

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

keymap("n", "Q", "<nop>")

-- king
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- create folds
keymap("n", "<leader>z", "zfaB", term_opts)

-- keymap for copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap("i", "<M-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- Define the key mapping

-- dap config
keymap("n", "<Leader>dt", ":DapToggleBreakpoint<CR>")
keymap("n", "<Leader>dc", ":DapContinue<CR>")
keymap("n", "<Leader>dx", ":DapTerminate<CR>")
keymap("n", "<Leader>do", ":DapStepOver<CR>")

-- for quickfix list for to switch between them
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        vim.keymap.set('n', '<C-n>', '<cmd>cn | wincmd p<CR>', opts)
        vim.keymap.set('n', '<C-p>', '<cmd>cN | wincmd p<CR>', opts)
    end,
})

