-- ~/.config/nvim/lua/custom/init.lua

local M = {}
M.mappings = require("custom.mappings") -- load the disable shourtcuts
M.plugins = {
    ["lewis6991/gitsigns.nvim"] = { enable = false },
    ["windwp/nvim-autopairs"] = { enable = false },
    ["nvim-tree/nvim-web-devicons"] = { enable = false },
}

return M

