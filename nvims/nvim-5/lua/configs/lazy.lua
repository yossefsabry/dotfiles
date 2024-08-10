return {
    defaults = { lazy = true },
    install = { colorscheme = { "defaults" } },

    -- ui = {
    --   icons = {
    --     ft = "",
    --     lazy = "󰂠 ",
    --     loaded = "",
    --     not_loaded = "",
    --   },
    -- },

    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
                "Gitsigns",
                "conform",
            },
        },
    },
}
