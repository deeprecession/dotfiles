-- Setup installer & lsp configs
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason.setup({
  ui = {
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = EcoVim.ui.float.border or "rounded",
  },
})

mason_lsp.setup({
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = {
    "bashls",
    "cssls",
    "eslint",
    "graphql",
    "html",
    "jsonls",
    "lua_ls",
    "prismals",
    "tailwindcss",
    "volar",
    "ts_ls"
  },
  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
  --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  automatic_installation = true,
})


local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = EcoVim.ui.float.border,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = EcoVim.ui.float.border }),
}

local capabilities = require('blink.cmp').get_lsp_capabilities()

local function on_attach(client, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr })
end

-- Global override for floating preview border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or EcoVim.ui.float.border or "rounded" -- default to EcoVim border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      handlers = handlers,
    }
  end,

  -- ["ts_ls"] = function()
  --   require("typescript-tools").setup({
  --     capabilities = capabilities or vim.lsp.protocol.make_client_capabilities(),
  --     handlers = require("config.lsp.servers.tsserver").handlers,
  --     on_attach = require("config.lsp.servers.tsserver").on_attach,
  --     settings = require("config.lsp.servers.tsserver").settings,
  --     filetypes = require("config.lsp.servers.tsserver").filetypes,
  --   })
  -- end,

  ["ts_ls"] = function()
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      handlers = handlers,
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      init_options = {
        plugins = {
          {
            name = '@vue/typescript-plugin',
            location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
            languages = { 'vue' },
          },
        },
      },
      settings = {
      typescript = {
        tsserver = {
          useSyntaxServer = false,
        },
        inlayHints = {
          -- includeInlayParameterNameHints = 'all',
          -- includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          -- includeInlayFunctionParameterTypeHints = false,
          -- includeInlayVariableTypeHints = false,
          -- includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          -- includeInlayPropertyDeclarationTypeHints = false,
          -- includeInlayFunctionLikeReturnTypeHints = false,
          -- includeInlayEnumMemberValueHints = true,
        },
      },
    },
    })
  end,

  -- ["tailwindcss"] = function()
  --   capabilities.textDocument.completion.completionItem.snippetSupport = true
  --   capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  --   capabilities.textDocument.foldingRange = {
  --     dynamicRegistration = false,
  --     lineFoldingOnly = true,
  --   }
  --
  --   lspconfig.tailwindcss.setup({
  --     capabilities = capabilities,
  --     filetypes = require("config.lsp.servers.tailwindcss").filetypes,
  --     handlers = handlers,
  --     init_options = require("config.lsp.servers.tailwindcss").init_options,
  --     on_attach = require("config.lsp.servers.tailwindcss").on_attach,
  --     settings = require("config.lsp.servers.tailwindcss").settings,
  --     flags = {
  --       debounce_text_changes = 1000,
  --     },
  --   })
  -- end,

  ["cssls"] = function()
    lspconfig.cssls.setup({
      capabilities = capabilities,
      handlers = handlers,
      on_attach = require("config.lsp.servers.cssls").on_attach,
      settings = require("config.lsp.servers.cssls").settings,
      flags = {
        debounce_text_changes = 1000,
      },
    })
  end,

  ["eslint"] = function()
    lspconfig.eslint.setup({
      capabilities = capabilities,
      handlers = handlers,
      on_attach = require("config.lsp.servers.eslint").on_attach,
      settings = require("config.lsp.servers.eslint").settings,
      flags = {
        allow_incremental_sync = false,
        debounce_text_changes = 1000,
        exit_timeout = 1500,
      },
    })
  end,

  ["jsonls"] = function()
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      handlers = handlers,
      on_attach = on_attach,
      settings = require("config.lsp.servers.jsonls").settings,
    })
  end,

  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      handlers = handlers,
      on_attach = on_attach,
      settings = require("config.lsp.servers.lua_ls").settings,
    })
  end,

  ["volar"] = function()
    lspconfig.volar.setup({
      filetypes = require("config.lsp.servers.volar").filetypes,
      handlers = handlers,
      capabilities = capabilities,
      init_options = require("config.lsp.servers.volar").init_options,
      on_attach = on_attach,
      settings = require("config.lsp.servers.volar").settings,
    })
  end
}
