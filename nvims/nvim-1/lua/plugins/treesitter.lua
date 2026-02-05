


return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "TSInstall", "TSUpdate", "TSUpdateSync", "TSInstallInfo" },
        config = function()
            local status_ok, configs = pcall(require, "nvim-treesitter.configs")
            if not status_ok then
                return
            end

            local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"
            vim.opt.runtimepath:append(parser_install_dir)

            require("nvim-treesitter.install").compilers = { "clang", "gcc" }

            configs.setup({
                parser_install_dir = parser_install_dir,
                ensure_installed = {
                    "markdown",
                    "markdown_inline",
                    "go",
                    "lua",
                    "vim",
                    "vimdoc",
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
}
