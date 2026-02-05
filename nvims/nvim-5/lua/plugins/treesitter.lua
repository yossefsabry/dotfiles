return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup({})

    require("nvim-ts-autotag").setup({})

    local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
    vim.o.foldlevelstart = 99

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if not ok then
          return
        end

        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        local wins = vim.fn.win_findbuf(args.buf)
        for _, win in ipairs(wins) do
          if vim.api.nvim_win_is_valid(win) then
            vim.wo[win].foldmethod = "expr"
            vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[win].foldlevel = 99
          end
        end
      end,
    })
  end,
}
