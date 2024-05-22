local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- adding undotree
  { "mbbill/undotree" },

  -- adding colorscheme
  {
    -- transparnet background color for nvim
    "tribela/vim-transparent",
  },
  {
    "rose-pine/neovim", as = "rose-pine",
    priority = 1000 ,
    config = function()
      vim.cmd([[colorscheme rose-pine]])
      vim.o.background = "dark" -- or "light" for light mode
    end
  },

  -- lualine for nvim
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = { theme = 'seoul256' }
      }
    end
  },

  -- adding telescope
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            "lib",
            "lib64",
            ".git",
            "include/site"
          }
        }
      }
    end
  },

  -- adding noetree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- addding commint plugin nvim
  {
    'numToStr/Comment.nvim',
    opts = {
    },
    lazy = false,
  },

  -- adding autoClose Tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  -- tmux navigetor
  {
    "christoomey/vim-tmux-navigator",
  },

  -- adding treeSettier
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,   -- for auto install the highlight for the languaga
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- adding go nvim
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },


  -- adding haproon
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {"ThePrimeagen/vim-be-good"},

  {
    {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      lazy = true,
      config = false,
      init = function()
        vim.g.lsp_zero_extend_cmp = 0
        vim.g.lsp_zero_extend_lspconfig = 0
      end,
    },
  },
  -- adding lsp-zero
  {
    {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      lazy = true,
      config = false,
    },
    {
      'williamboman/mason.nvim',
      lazy = false,
      config = true,
    },

    -- Autocompletion
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        {'L3MON4D3/LuaSnip'},
      },
      config = function()
        -- Here is where you configure the autocompletion settings.
        local lsp_zero = require('lsp-zero')
        lsp_zero.extend_cmp()

        -- And you can configure cmp even more, if you want to.
        local cmp = require('cmp')

        cmp.setup({
          formatting = lsp_zero.cmp_format({details = true}),
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }),
          }),
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
        })
        vim.diagnostic.config({
          virtual_text = {
            prefix = "◆◆", -- Could be '■', '▎', 'x'
          },
        })
        lsp_zero.set_sign_icons({
          error = '',
          warn = '',
          hint = '',
          info = ''
        })

      end
    },

    -- LSP
    {
      'neovim/nvim-lspconfig',
      cmd = {'LspInfo', 'LspInstall', 'LspStart'},
      event = {'BufReadPre', 'BufNewFile'},
      dependencies = {
        {'hrsh7th/cmp-nvim-lsp'},
        {'williamboman/mason-lspconfig.nvim'},
      },
      config = function()
        local lsp_zero = require('lsp-zero')

        -- end the shape for the lsp

        lsp_zero.extend_lspconfig()

        lsp_zero.on_attach(function(client, bufnr)
          lsp_zero.default_keymaps({buffer = bufnr})
        end)

        require('mason-lspconfig').setup({
          ensure_installed = {"tsserver", "gopls", "lua_ls"},
          handlers = {
            function(server_name)
              require('lspconfig')[server_name].setup({})
            end,
            lua_ls = function()
              local lua_opts = lsp_zero.nvim_lua_ls()
              require('lspconfig').lua_ls.setup(lua_opts)
            end,
          },
        })
      end
    }
  },


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
    dependencies = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'},
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
})

