local new_bee_alpha_config = require "plugins.alpha_themes.new_bee"
local rainbow_cat_alpha_config = require "plugins.alpha_themes.rainbow_cat"
local panda_alpha_config = require "plugins.alpha_themes.panda"
local neovim_alpha_config = require "plugins.alpha_themes.neovim"

---@type LazySpec
return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      math.randomseed(os.time())
      local theme = ({ panda_alpha_config, rainbow_cat_alpha_config, new_bee_alpha_config, neovim_alpha_config })[math.random(
        1,
        4
      )]
      return theme(opts)
    end,
  },
}
