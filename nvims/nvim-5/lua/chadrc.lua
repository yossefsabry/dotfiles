-- This file needs to have same structure as nvconfig.lua 


---@type ChadrcConfig
local M = {}
M.ui = {
    tabufline = {
        --  more opts
        order = { "treeOffset", "buffers", "tabs", "btns", 'abc' },
        modules = {
            -- You can add your custom component
            abc = function()
                return "hi"
            end,
        }
    },
    theme = "rosepine",

    hl_override = {
        Comment = { italic = true },
        ["@comment"] = { italic = true },
    },
    transparency = false
}

return M
