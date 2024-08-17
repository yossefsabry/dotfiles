if not vim.g.neovide then
  return {} -- do nothing if not in a Neovide session
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      g = { -- configure vim.g variables
        -- configure scaling
        neovide_scale_factor = 1.0,
        neovide_cursor_vfx_mode = "railgun",
      },
    },
  },
}
