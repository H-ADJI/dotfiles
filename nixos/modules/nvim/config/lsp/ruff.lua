---@type vim.lsp.Config
local config = {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
return config
