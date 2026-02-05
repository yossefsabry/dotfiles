return {
  "ThePrimeagen/99",
  lazy = true,

  -- optional: lazy-load when you run any of these commands
  cmd = {
    "NinetyNineFillFunction",
    "NinetyNineVisual",
    "NinetyNineStop",
    "NinetyNineLogs",
    "NinetyNineLogsNext",
    "NinetyNineLogsPrev",
  },

  keys = {
    { "<leader>9f", "<cmd>NinetyNineFillFunction<CR>", desc = "99: Fill in function" },
    { "<leader>9v", "<cmd>NinetyNineVisual<CR>", desc = "99: Run on visual selection", mode = "v" },
    { "<leader>9s", "<cmd>NinetyNineStop<CR>", desc = "99: Stop requests", mode = "v" },

    -- extra (nice to have)
    { "<leader>9l", "<cmd>NinetyNineLogs<CR>", desc = "99: View logs" },
    { "<leader>9]", "<cmd>NinetyNineLogsNext<CR>", desc = "99: Next request logs" },
    { "<leader>9[", "<cmd>NinetyNineLogsPrev<CR>", desc = "99: Prev request logs" },
  },

  config = function()
    local _99 = require("99")

    -- same logging pattern from the README
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup({
      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },
      completion = {
        custom_rules = { "scratch/custom_rules/" },
        source = "cmp",
      },
      md_files = { "AGENT.md" },
    })

    -- Custom commands (same style as your Harpoon config)
    vim.api.nvim_create_user_command("NinetyNineFillFunction", function()
      _99.fill_in_function()
    end, {})

    vim.api.nvim_create_user_command("NinetyNineVisual", function()
      _99.visual()
    end, {})

    vim.api.nvim_create_user_command("NinetyNineStop", function()
      _99.stop_all_requests()
    end, {})

    vim.api.nvim_create_user_command("NinetyNineLogs", function()
      _99.view_logs()
    end, {})

    vim.api.nvim_create_user_command("NinetyNineLogsNext", function()
      _99.next_request_logs()
    end, {})

    vim.api.nvim_create_user_command("NinetyNineLogsPrev", function()
      _99.prev_request_logs()
    end, {})
  end,
}

