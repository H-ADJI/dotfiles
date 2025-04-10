return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,
    -- online, please don't ask me how to install them :)
    ensure_installed = {
      "python",
      "go",
    },
  },
}
