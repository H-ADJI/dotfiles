return {
  "mfussenegger/nvim-lint",
  -- enabled = false,
  config = function()
    require("lint").linters_by_ft = {
      -- python = { "flake8" },
    }
  end,
}
