------------------------------------------------
--                                            --
--    This is a main configuration file for    --
--                    EcoVim                  --
--      Change variables which you need to    --
--                                            --
------------------------------------------------

local icons = require("utils.icons")

EcoVim = {
  colorscheme = "kanagawa",
  ui = {
    font = { "FiraCode Nerd Font", ":h14" },
    float = {
      border = "rounded",
    },
  },
  plugins = {
    -- Make sure to reload nvim & "Update Plugins" after change
    completion = {
      select_first_on_enter = false,
    },
    -- Completely replaces the UI for messages, cmdline and the popupmenu
    experimental_noice = {
      enabled = true,
    },
    -- Enables moving by subwords and skips significant punctuation with w, e, b motions
    jump_by_subwords = {
      enabled = false,
    },
  },
  -- Please keep it
  icons = icons,
  -- Statusline configuration
  statusline = {
    path_enabled = false,
    path = "relative", -- absolute/relative
  },
}
