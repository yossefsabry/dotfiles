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
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if not ok then
          return
        end

        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo[args.buf].foldmethod = "expr"
        vim.wo[args.buf].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
}
