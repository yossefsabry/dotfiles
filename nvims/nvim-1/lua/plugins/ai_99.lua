return {
  'ThePrimeagen/99',
  keys = {
    {
      '<leader>9v',
      function()
        require('99').visual()
      end,
      mode = 'v',
      desc = '99: Visual',
    },
    {
      '<leader>9s',
      function()
        require('99').stop_all_requests()
      end,
      mode = 'v',
      desc = '99: Stop all requests',
    },
    {
      '<leader>99',
      function()
        require('99').visual_prompt {}
      end,
      mode = 'v',
      desc = '99: Visual prompt',
    },
  },

  config = function()
    local _99 = require '99'

    -- For logging that is to a file if you wish to trace through requests
    -- for reporting bugs, i would not rely on this, but instead the provided
    -- logging mechanisms within 99.  This is for more debugging purposes
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)
    _99.setup {
      -- model = 'opencode/big-pickle',
      model = 'openai/gpt-5.2-codex',
      logger = {
        level = _99.INFO,
        -- path = '/tmp/' .. basename .. '.99.debug',
        path = '/tmp/99.debug',
        print_on_error = true,
      },

      --- A new feature that is centered around tags
      completion = {
        --- Defaults to .cursor/rules
        -- I am going to disable these until i understand the
        -- problem better.  Inside of cursor rules there is also
        -- application rules, which means i need to apply these
        -- differently
        -- cursor_rules = "<custom path to cursor rules>"

        --- A list of folders where you have your own SKILL.md
        --- Expected format:
        --- /path/to/dir/<skill_name>/SKILL.md
        ---
        --- Example:
        --- Input Path:
        --- "scratch/custom_rules/"
        ---
        --- Output Rules:
        --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
        --- ... the other rules in that dir ...
        ---
        -- custom_rules = {
        --   'scratch/custom_rules/',
        -- },

        --- What autocomplete do you use.  We currently only
        --- support cmp right now
        -- source = 'cmp',
      },

      --- WARNING: if you change cwd then this is likely broken
      --- ill likely fix this in a later change
      ---
      --- md_files is a list of files to look for and auto add based on the location
      --- of the originating request.  That means if you are at /foo/bar/baz.lua
      --- the system will automagically look for:
      --- /foo/bar/AGENT.md
      --- /foo/AGENT.md
      --- assuming that /foo is project root (based on cwd)
      md_files = {
        'AGENT.md',
        'AGENTS.md'
      },
    }
  end,
}
