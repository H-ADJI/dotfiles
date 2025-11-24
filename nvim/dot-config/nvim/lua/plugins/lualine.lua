return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local function conform_status()
      local ok, conform = pcall(require, "conform")
      if not ok then
        return ""
      end

      local buf = vim.api.nvim_get_current_buf()
      local formatters = conform.list_formatters_for_buffer(buf)

      if formatters and #formatters > 0 then
        return " " .. table.concat(formatters, ", ")
      else
        return ""
      end
    end
    return {
      options = {
        theme = "auto",
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "filename",
            path = 4,

          },
        },
        lualine_x = {
          "lsp_status",
          conform_status,
        },
        lualine_y = {
          "progress",
          {
            "searchcount",
            maxcount = 9999,
            timeout = 500,
          },
        },
        lualine_z = { "location" },
      },
    }
  end,
}
