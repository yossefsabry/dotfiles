


return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            local ok, treesitter = pcall(require, "nvim-treesitter")
            if not ok then
                return
            end

            local cargo_bin = vim.fn.expand("~/.cargo/bin")
            if not vim.env.PATH:find(cargo_bin, 1, true) then
                vim.env.PATH = vim.env.PATH .. ":" .. cargo_bin
            end

            treesitter.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            treesitter.install({
                "markdown",
                "markdown_inline",
                "go",
                "lua",
                "vim",
                "vimdoc",
            })
        end,
    },
}
