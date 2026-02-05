local servers = { "clangd", "gopls", "lua_ls", "svelte", "pyright", "phpactor" }

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

local markdown_ts_ready
local function has_markdown_treesitter()
  if markdown_ts_ready ~= nil then
    return markdown_ts_ready
  end

  local ok = vim.treesitter.language.add("markdown")
  markdown_ts_ready = ok == true
  return markdown_ts_ready
end

local function open_lsp_float(contents, config)
  local syntax = "markdown"
  if not has_markdown_treesitter() then
    syntax = "plaintext"
  end
  return vim.lsp.util.open_floating_preview(contents, syntax, config)
end

if not vim.g._lsp_float_markdown_guard then
  vim.g._lsp_float_markdown_guard = true
  local original_open_floating_preview = vim.lsp.util.open_floating_preview

  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    if syntax == "markdown" and not has_markdown_treesitter() then
      syntax = "plaintext"
    end
    return original_open_floating_preview(contents, syntax, opts, ...)
  end
end

vim.lsp.handlers["textDocument/hover"] = function(_, result, _, config)
  config = config or {}
  config.focus_id = "textDocument/hover"

  if not (result and result.contents) then
    return
  end

  local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  contents = vim.lsp.util.trim_empty_lines(contents)

  if vim.tbl_isempty(contents) then
    return
  end

  return open_lsp_float(contents, config)
end

vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, _, config)
  config = config or {}
  config.focus_id = "textDocument/signatureHelp"

  if not (result and result.signatures and result.signatures[1]) then
    return
  end

  local contents = vim.lsp.util.convert_signature_help_to_markdown_lines(result)
  contents = vim.lsp.util.trim_empty_lines(contents)

  if vim.tbl_isempty(contents) then
    return
  end

  return open_lsp_float(contents, config)
end
