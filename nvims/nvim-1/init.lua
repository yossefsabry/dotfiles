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

local open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    if syntax == "markdown" then
        local ok, buf, win = pcall(open_floating_preview, contents, syntax, opts, ...)
        if ok then
            return buf, win
        end
        return open_floating_preview(contents, "plaintext", opts, ...)
    end
    return open_floating_preview(contents, syntax, opts, ...)
end

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

-- diable auto comment nextline
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- adding folds for nvim and save theme and load theme when open file


-- adding color for the highlight line
vim.cmd("highlight Visual guibg=#005b44 guifg=NONE")



-- for check the spelling in markdown and text files
local function check_spell()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text" },
        callback = function()
            vim.opt_local.spell = true
            vim.opt_local.spelllang = "en_us" -- Or your desired language
        end,
    })
end; check_spell()
