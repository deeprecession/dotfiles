return {

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
      vim.opt.list = true
      -- vim.opt.listchars:append("space:⋅")
      -- vim.opt.listchars:append("eol:↴")

      require("ibl").setup {
        exclude = {
          filetypes = { "help", "dashboard", "packer", "NvimTree", "Trouble", "TelescopePrompt", "Float" },
          buftypes = { "terminal", "nofile", "telescope" },
        },
        indent = {
          char = "┊",
        },
        whitespace = {
          remove_blankline_trail = true,
        },
        scope = { enabled = false },
        }
    end,
  },
}
