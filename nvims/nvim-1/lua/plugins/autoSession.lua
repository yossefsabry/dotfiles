return {
   -- session managment
  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_enable_last_session = true,
        session_lens = {
          buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      }
    end
  },

  -- session navigetor
  {
    'rmagatti/session-lens',
    requires = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'},
    config = function()
      require("telescope").load_extension("session-lens")
      require('session-lens').setup {
        path_display = {'shorten'},
        theme = 'ivy', -- default is dropdown
        theme_conf = { border = false },
        previewer = true
      }
      vim.diagnostic.config({
        virtual_text = {
          prefix = "◆◆", -- Could be '■', '▎', 'x'
        },
      })
    end
  },
}
