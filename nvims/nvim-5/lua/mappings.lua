require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")
map("i", "JK", "<ESC>")

vim.g.mapleader = " "
vim.opt.hlsearch = false -- disable search highlight
vim.opt.incsearch = true
vim.opt.guicursor = ""


-- normal mode
map("i", "jk", "<Esc>")
map("i", "JK", "<Esc>")

-- save file with ctrl-s
map("n", "<C-s>", ":w<CR>", { noremap = true })
map("i", "<C-s>", "<C-o>:write<CR>a", { noremap = true })

-- increment or decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "increment number" })
map("n", "<leader>-", "<C-a>", { desc = "decrement number" })

map("n", "<C-d>", "<c-d>zz", { desc = "half page down and cursor in center" })
map("n", "<C-u>", "<c-u>zz", { desc = "half page down and cursor in center" })
map("n", "G", "Gzz", { desc = "page down and cursor in center" })

-- new tree mapping
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "nvim tree toggle "})
map("n", "<leader>-", "<cmd>Ex<CR>", { desc = "netrw nvim"})

-- tab management
map("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "open new tab" })
map("n", "<leader>tl", "<cmd>tabclose<CR>", { desc = "close current tab" })
map("n", "L", "<cmd>tabn<CR>", { desc = "go to next tab" })
map("n", "H", "<cmd>tabp<CR>", { desc = "go to prev tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab" })

-- telescope
map("n", "<leader>fs", "<cmd>Telescope find_files<cr>", { desc = "fuzzy find files in cwd" })
map("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", { desc = "fuzzy find recent files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "find string in cwd" })

-- lsp Config rempap
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { desc = " show info  " })
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = " go definition " })
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { desc = " show declaration " })
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { desc = " show implementation " })
map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { desc = " go definitionj " })
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { desc = " show references " })
map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { desc = " show signature_help " })
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = " code action " })
map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = "open diagnostic " })
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { desc = " prev diagnostic " })
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { desc = "next diagnostic " })

-- adding maping for coderunner
map("n", "<A-r>", ":RunCode<CR>", {desc = "run code"})
map("n", "<A-r>f", ":RunFile<CR>", {desc = "run file"})
map("n", "<A-r>p", ":RunProject<CR>", {desc = "run project"})
map("n", "<A-r>c", ":RunClose<CR>", {desc = "run close"})
map("n", "<A-r>cp", ":CRProjects<CR>", {desc = "run project"})

-- next greatest remap ever : asbjornHaland

