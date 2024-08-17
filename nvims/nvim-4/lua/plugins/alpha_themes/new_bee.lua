local function getLen(str, start_pos)
  local byte = string.byte(str, start_pos)
  if not byte then return nil end
  return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
end

local function colorize(header, header_color_map, colors)
  for letter, color in pairs(colors) do
    local color_name = "AlphaJemuelKwelKwelWalangTatay" .. letter
    vim.api.nvim_set_hl(0, color_name, color)
    colors[letter] = color_name
  end

  local colorized = {}

  for i, line in ipairs(header_color_map) do
    local colorized_line = {}
    local pos = 0

    for j = 1, #line do
      local start = pos
      pos = pos + getLen(header[i], start + 1)

      local color_name = colors[line:sub(j, j)]
      if color_name then table.insert(colorized_line, { color_name, start, pos }) end
    end

    table.insert(colorized, colorized_line)
  end

  return colorized
end

local new_bee_alpha_config = function(opts)
  local color = require "astrotheme.lib.color"

  local mocha = require("catppuccin.palettes").get_palette "mocha"

  local color_map = {
    [[      AAAA]],
    [[AAAAAA  AAAA]],
    [[AA    AAAA  AAAA        KKHHKKHHHH]],
    [[AAAA    AAAA  AA    HHBBKKKKKKKKKKKKKK]],
    [[  AAAAAA      AAKKBBHHKKBBYYBBKKKKHHKKKKKK]],
    [[      AAAA  BBAAKKHHBBBBKKKKBBYYBBHHHHKKKKKK]],
    [[        BBAABBKKYYYYHHKKYYYYKKKKBBBBBBZZZZZZ]],
    [[    YYBBYYBBKKYYYYYYYYYYKKKKBBKKAAAAZZOOZZZZ]],
    [[    XXXXYYYYBBYYYYYYYYBBBBBBKKKKBBBBAAAAZZZZ]],
    [[    XXXXUUUUYYYYBBYYYYYYBBKKBBZZOOAAZZOOAAAAAA]],
    [[  ZZZZZZXXUUXXXXYYYYYYYYBBAAAAZZOOOOAAOOZZZZAAAA]],
    [[  ZZUUZZXXUUUUXXXXUUXXFFFFFFFFAAAAOOZZAAZZZZ  AA]],
    [[    RRRRUUUUZZZZZZZZXXOOFFFFOOZZOOAAAAAAZZZZAA]],
    [[    CCSSUUUUZZXXXXZZXXOOFFFFOOZZOOOOZZOOAAAA]],
    [[    CCCCUUUUUUUUUURRRROOFFFFOOZZOOOOZZOOZZZZ]],
    [[    CCCCUUUUUUUUSSCCCCEEQQQQOOZZOOOOZZOOZZZZ]],
    [[    CCCCUUGGUUUUCCCCCCEEQQQQOOZZOOOOZZEEZZ]],
    [[    RRRRGGGGUUGGCCCCCCOOOOOOOOZZOOEEZZII]],
    [[      IIRRGGGGGGCCCCCCOOOOOOOOZZEEII]],
    [[            GGRRCCCCCCOOOOEEEEII  II]],
    [[                RRRRRREEEE  IIII]],
    [[                      II]],
    [[]],
  }

  local yellow = "#FAC87C"
  local orange = "#BF854E"
  local maroon = "#502E2B"
  local brown = "#38291B"
  local colors = {
    ["A"] = { fg = mocha.rosewater },
    ["Y"] = { fg = yellow },
    ["B"] = { fg = color.tohex(color.darken(color.new(yellow), 5)) },
    ["X"] = { fg = color.tohex(color.darken(color.new(yellow), 20)) },
    ["U"] = { fg = color.tohex(color.darken(color.new(yellow), 25)) },
    ["F"] = { fg = color.tohex(color.darken(color.new(yellow), 35)) },
    ["O"] = { fg = color.tohex(color.darken(color.new(yellow), 45)) },
    ["K"] = { fg = maroon },
    ["H"] = { fg = color.tohex(color.darken(color.new(maroon), 10)) },
    ["Z"] = { fg = mocha.crust },
    ["G"] = { fg = color.tohex(color.darken(color.new(yellow), 25)) },
    ["R"] = { fg = orange },
    ["Q"] = { fg = color.tohex(color.darken(color.new(orange), 20)) },
    ["E"] = { fg = color.tohex(color.darken(color.new(orange), 35)) },
    ["I"] = { fg = brown },
    ["C"] = { fg = mocha.mantle },
    ["S"] = { fg = mocha.subtext1 },
  }

  local header = {}
  for _, line in ipairs(color_map) do
    local header_line = [[]]
    for i = 1, #line do
      if line:sub(i, i) ~= " " then
        header_line = header_line .. "█"
      else
        header_line = header_line .. " "
      end
    end
    table.insert(header, header_line)
  end

  local header_add = [[          N        E      O    B   E E         ]]
  table.insert(header, header_add)

  local hl_add = {}
  for i = 1, #header_add do
    table.insert(hl_add, { "NeoBeeTitle", 1, i })
  end

  opts.section.header.val = header
  local colorized = colorize(header, color_map, colors)

  table.insert(colorized, hl_add)

  opts.section.header.opts = {
    hl = colorized,
    position = "center",
  }

  return opts
end

return new_bee_alpha_config
