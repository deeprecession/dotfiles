return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          css =  { "prettierd", "prettier" },
          graphql =  { "prettierd", "prettier" },
          html =  { "htmlbeautifier" },
          javascript =  { "prettierd", "prettier" },
          javascriptreact =  { "prettierd", "prettier" },
          vue =  { "prettierd", "prettier" },
          json =  { "prettierd", "prettier" },
          lua = { "stylua" },
          markdown =  { "prettierd", "prettier" },
          python = { "isort", "black" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          sql = { "sql-formatter" },
          svelte =  { "prettierd", "prettier" },
          typescript =  { "prettier" },
          typescriptreact =  { "prettierd", "prettier" },
          yaml = { "prettier" },
          xml = { "xmlformatter" },
          go = { "goimports", "gofmt" },
          shell = { "shfmt" },
          ["_"] = { "trim_whitespace" },
        },
      })

      vim.keymap.set({ "n" }, "<leader>f", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 5000,
        })
      end, { desc = "format file" })

      vim.keymap.set({ "v" }, "<leader>f", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 5000,
        })
      end, { desc = "format selection" })

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end

        conform.format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })
    end,
  },
}
