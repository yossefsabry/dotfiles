local function getCharLen(s, pos)
  local byte = string.byte(s, pos)
  if not byte then return nil end
  return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
end

local function neovim_alpha_config(opts)
  local logo = {
    [[  ███       ███  ]],
    [[  ████      ████ ]],
    [[  ████     █████ ]],
    [[ █ ████    █████ ]],
    [[ ██ ████   █████ ]],
    [[ ███ ████  █████ ]],
    [[ ████ ████ ████ ]],
    [[ █████  ████████ ]],
    [[ █████   ███████ ]],
    [[ █████    ██████ ]],
    [[ █████     █████ ]],
    [[ ████      ████ ]],
    [[  ███       ███  ]],
    [[                    ]],
    [[  N  E  O  V  I  M  ]],
  }
  local colors = {
    ["b"] = { fg = "#3399ff", ctermfg = 33 },
    ["a"] = { fg = "#53C670", ctermfg = 35 },
    ["g"] = { fg = "#39ac56", ctermfg = 29 },
    ["h"] = { fg = "#33994d", ctermfg = 23 },
    ["i"] = { fg = "#33994d", bg = "#39ac56", ctermfg = 23, ctermbg = 29 },
    ["j"] = { fg = "#53C670", bg = "#33994d", ctermfg = 35, ctermbg = 23 },
    ["k"] = { fg = "#30A572", ctermfg = 36 },
  }

  local color_maps = {
    [[  kkkka       gggg  ]],
    [[  kkkkaa      ggggg ]],
    [[ b kkkaaa     ggggg ]],
    [[ bb kkaaaa    ggggg ]],
    [[ bbb kaaaaa   ggggg ]],
    [[ bbbb aaaaaa  ggggg ]],
    [[ bbbbb aaaaaa igggg ]],
    [[ bbbbb  aaaaaahiggg ]],
    [[ bbbbb   aaaaajhigg ]],
    [[ bbbbb    aaaaajhig ]],
    [[ bbbbb     aaaaajhi ]],
    [[ bbbbb      aaaaajh ]],
    [[  bbbb       aaaaa  ]],
    [[                    ]],
    [[  a  a  a  b  b  b  ]],
  }
  opts.section.header.val = logo

  for key, color in pairs(colors) do
    local name = "Alpha" .. key
    vim.api.nvim_set_hl(0, name, color)
    colors[key] = name
  end

  opts.section.header.opts.hl = {}
  for i, line in ipairs(color_maps) do
    local highlights = {}
    local pos = 0

    for j = 1, #line do
      local opos = pos
      pos = pos + getCharLen(logo[i], opos + 1)

      local color_name = colors[line:sub(j, j)]
      if color_name then table.insert(highlights, { color_name, opos, pos }) end
    end

    table.insert(opts.section.header.opts.hl, highlights)
  end

  return opts
end

return neovim_alpha_config
