return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  opts = {
    layouts = {
      {
        elements = { "console" },
        size = 20, -- Adjust the height as needed
        position = "bottom",
      },
    },
  },
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")
    local width = 160
    local height = 30
    dapui.setup(opts)
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close({})
    end
    -- keymaps for floating elements
    vim.keymap.set("n", "<leader>dfs", function()
      local element = "scopes"
      dapui.float_element(element, {
        title = element,
        enter = true,
        width = width,
        height = height,
        position = "center",
      })
    end, { desc = "DapUI: Float scopes (centered)" })

    -- Float call stack
    vim.keymap.set("n", "<leader>dft", function()
      local element = "stacks"
      dapui.float_element(element, {
        title = element,
        enter = true,
        width = width,
        height = height,
        position = "center",
      })
    end, { desc = "DapUI: Float stacks (centered)" })

    -- Float breakpoints
    vim.keymap.set("n", "<leader>dfb", function()
      local element = "breakpoints"
      dapui.float_element("breakpoints", {
        title = element,
        enter = true,
        width = width,
        height = height,
        position = "center",
      })
    end, { desc = "DapUI: Float breakpoints (centered)" })

    -- Float watches
    vim.keymap.set("n", "<leader>dfw", function()
      local element = "watches"
      dapui.float_element("watches", {
        title = element,
        enter = true,
        width = width,
        height = height,
        position = "center",
      })
    end, { desc = "DapUI: Float watches (centered)" })

    -- Float REPL
    vim.keymap.set("n", "<leader>dfr", function()
      local element = "repl"
      dapui.float_element("repl", {
        title = element,
        enter = true,
        width = width,
        height = height,
        position = "center",
      })
    end, { desc = "DapUI: Float REPL (centered)" })

    -- Float console
    vim.keymap.set("n", "<leader>dfc", function()
      local element = "console"
      dapui.float_element("console", {
        title = element,
        enter = true,
        width = width,
        height = height,
        position = "center",
      })
    end, { desc = "DapUI: Float console (centered)" })
  end,
}
