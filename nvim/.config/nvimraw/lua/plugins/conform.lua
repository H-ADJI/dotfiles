return {
    "stevearc/conform.nvim",
    keys = {
        { "<leader>lf", ":ConformInfo<CR>", desc = "conform formatters information" },
        -- { "<leader>cf", require("conform").format, mode = { "n", "x", "o", "v" }, desc = "format buffer " },
    },
    opts = {
        log_level = vim.log.levels.DEBUG,
        formatters_by_ft = {
            python = { "black" },
            go = { "gofmt", "golines", "goimports" },
            sql = { "sql_formatter" },
            html = { "prettierd" },
            css = { "prettierd" },
            json = { "prettierd" },
            yaml = { "prettierd" },
            javascript = { "prettierd" },
            markdown = { "prettierd" },
            scss = { "prettierd" },
            -- kdl = { "kdlfmt" },
            -- ["_"] = { "shfmt" },
        },
        formatters = {
            kdlfmt = {
                command = "kdlfmt",
                args = { "format", "$FILENAME" }, -- Adjust path to your SQL formatter config if needed
                stdin = true,
            },
            black = {
                prepend_args = { "-l", "120" },
            },
            sql_formatter = {
                command = "sql-formatter",
                args = { "--config", ".sql-formatter.json" }, -- Adjust path to your SQL formatter config if needed
                stdin = true,
            },
        },
    },
}
