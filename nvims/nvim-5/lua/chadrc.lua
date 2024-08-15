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
    statusline = {
        -- more opts
        order = {...}, -- check stl/utils.lua file in ui repo 
        modules = {
            -- The default cursor module is override
            cursor = function()
                return "%#BruhHl#" .. " bruh " -- the highlight group here is BruhHl,
            end
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
