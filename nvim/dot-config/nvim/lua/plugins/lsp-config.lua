return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = false,
              rangeVariableTypes = false,
            },
          },
        },
      },
    },
  },
}
