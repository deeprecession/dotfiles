local present, kanagawa = pcall(require, "kanagawa")
if not present then
  return
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Setup Colorscheme                                        │
-- ╰──────────────────────────────────────────────────────────╯
kanagawa.setup({
  compile = false,             -- enable compiling the colorscheme
  undercurl = true,            -- enable undercurls
  commentStyle = { italic = true },
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  transparent = true,          -- transparent background
  dimInactive = false,         -- dim inactive windows
  terminalColors = true,       -- enable terminal colors
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",   -- disable gutter background
        },
      },
    },
  },
  overrides = function(colors) -- custom highlights
    return {}
  end,
  theme = "wave",             -- default theme (dark)
  background = {              -- theme based on 'background' option
    dark = "wave",            -- "wave" | "dragon" (more vibrant)
    light = "lotus",          -- light variant
  },
})

-- Apply the colorscheme
vim.cmd("colorscheme kanagawa")
