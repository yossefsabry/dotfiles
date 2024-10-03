---@diagnostic disable: undefined-global
-- setup for the lazyvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
---@diagnostic disable-next-line: undefined-global
vim.opt.rtp:prepend(lazypath)
require("options")

require("lazy").setup("plugins")

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

-- diable auto comment nextline
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- adding folds for nvim and save theme and load theme when open file
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = { "*.*" },
    desc = "save view (folds), when closing file",
    command = "mkview",
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = { "*.*" },
    desc = "load view (folds), when opening file",
    command = "silent! loadview",
})

-- adding color for the highlight line
vim.cmd("highlight Visual guibg=#005b44 guifg=NONE")

-- Set the color for the ColorColumn
vim.cmd([[ highlight ColorColumn guibg=#3c3836 ]])
