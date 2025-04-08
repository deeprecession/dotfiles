return {
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        html = { "htmlhint", "markuplint" },
        json = { "jsonlint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        python = { "pylint" },
        go = { "golangci-lint", "nilaway" },
        c = { "cpplint" },
        cpp = { "cpplint" },
        yaml = {"yamllint"},
        sql = {"sqlfluff"},
        protobuf = { "buf", "protolint" },
        bash = { "shellcheck", "shellharden" },
      }

      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "lint file" })

      vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost",
        "BufReadPre", "BufWritePost",
        "TextChanged", "TextChangedI" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

    end,
  },
}
