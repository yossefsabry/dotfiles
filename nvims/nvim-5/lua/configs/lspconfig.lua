local servers = { "clangd", "gopls", "lua_ls", "svelte", "pyright", "phpactor" }

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
