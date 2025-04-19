local M = {}

M.filetypes = {
  "vue",
}

M.init_options = {
  typescript = {
    tsdk = '',
  },
  config = {
    vue = {
      hybridMode = false,
    },
    settings = {
      typescript = {
        inlayHints = {
          enumMemberValues = {
            enabled = true,
          },
          functionLikeReturnTypes = {
            enabled = true,
          },
          propertyDeclarationTypes = {
            enabled = true,
          },
          parameterTypes = {
            enabled = true,
            suppressWhenArgumentMatchesName = true,
          },
          variableTypes = {
            enabled = true,
          },
        },
      },
    },
  },
}

return M
