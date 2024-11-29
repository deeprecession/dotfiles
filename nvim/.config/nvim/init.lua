--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local api = vim.api
local cmd = vim.cmd
local map = vim.keymap.set

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {

  { 'nvim-lua/plenary.nvim' },

  { 'tpope/vim-fugitive' },    -- Git commands in nvim
  { 'tpope/vim-rhubarb' },     -- Fugitive-companion to interact with github

  { 'numToStr/Comment.nvim' }, -- "gc" to comment visual regions/lines

  { 'kdheepak/lazygit.nvim' }, -- lazygit

  { 'akinsho/git-conflict.nvim', version = '*', config = true },

  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = { -- set to setup table
    },
  },

  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'nvimtools/none-ls.nvim',
    },
  },

  { 'nvim-tree/nvim-web-devicons' }, -- not strictly required, but recommended

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
  },

  { 'jose-elias-alvarez/null-ls.nvim' }, -- linter

  { 'ludovicchabant/vim-gutentags' },    -- Automatic tags management

  {
    'akinsho/org-bullets.nvim',
    config = function()
      require('org-bullets').setup {
        symbols = {
          -- list symbol
          list = '•',
          -- headlines can be a list
          headlines = { '◉', '○', '✸', '✿' },
          -- or a function that receives the defaults and returns a list
          headlines = false,
          checkboxes = {
            half = { '', 'OrgTSCheckboxHalfChecked' },
            done = { '✓', 'OrgDone' },
            todo = { '˟', 'OrgTODO' },
          },
        },
      }
    end,
  },

  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require('fidget').setup {
        -- options
      }
    end,
  },

  -- UI to select things (files, grep results, open buffers...)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  },

  { 'nvim-lualine/lualine.nvim' }, -- Fancier statusline

  -- Add indentation guides even on blank lines
  { 'lukas-reineke/indent-blankline.nvim' },

  -- Add git related info in the signs columns and popups
  { 'lewis6991/gitsigns.nvim',            dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Highlight, edit, and navigate code using a fast incremental parsing library

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require 'nvim-treesitter.configs'

      configs.setup {
        ensure_installed = {
          'c',
          'go',
          'python',
          'typescript',
          'lua',
          'vim',
          'vimdoc',
          'query',
          'elixir',
          'heex',
          'javascript',
          'html',
          'sql',
          'toml',
          'bash',
          'proto',
          'json',
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = false },
      }
    end,
  },

  -- Additional textobjects for treesitter
  { 'nvim-treesitter/nvim-treesitter-textobjects' },

  { 'neovim/nvim-lspconfig' }, -- Collection of configurations for built-in LSP client

  -- LSP downloader
  { 'williamboman/mason.nvim' },

  { 'hrsh7th/nvim-cmp' }, -- Autocompletion plugin
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-nvim-lua' },

  -- Snippets
  { 'saadparwaiz1/cmp_luasnip' },
  { 'rafamadriz/friendly-snippets' },
  {
    'L3MON4D3/LuaSnip',
    config = function()
      require('luasnip/loaders/from_vscode').load {
        paths = { '~/.local/share/nvim/site/pack/packer/start/friendly-snippets' },
      }
    end,
  },

  { 'rebelot/kanagawa.nvim' }, -- colorscheme

  { 'voldikss/vim-floaterm' }, -- floatterm

  -- Debugging
  { 'nvim-neotest/nvim-nio' },
  { 'mfussenegger/nvim-dap' },
  { 'leoluz/nvim-dap-go' },
  { 'mfussenegger/nvim-dap-python' },
  { 'rcarriga/nvim-dap-ui' },
  { 'theHamsta/nvim-dap-virtual-text' },
  { 'nvim-telescope/telescope-dap.nvim' },

  -- Golang
  { 'fatih/vim-go' },

  -- "steelsojka/pears.nvim" -- autopairs
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  -- Test Runner
  { 'klen/nvim-test' },

  -- Harpoon
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- guess indent
  { 'tpope/vim-sleuth' },

  -- surround
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  {
    'nvim-orgmode/orgmode',
    config = function()
      require('orgmode').setup {}
    end,
  },

  {
    'scalameta/nvim-metals',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
      {
        'mfussenegger/nvim-dap',
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require 'dap'

          dap.configurations.scala = {
            {
              type = 'scala',
              request = 'launch',
              name = 'RunOrTest',
              metals = {
                runType = 'runOrTestFile',
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = 'scala',
              request = 'launch',
              name = 'Test Target',
              metals = {
                runType = 'testTarget',
              },
            },
          }
        end,
      },
    },
    ft = { 'scala', 'sbt', 'java' },
    opts = function()
      local metals_config = require('metals').bare_config()

      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
      }

      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to either "off" or "on"
      --
      -- "off" will enable LSP progress notifications by Metals and you'll need
      -- to ensure you have a plugin like fidget.nvim installed to handle them.
      --
      -- "on" will enable the custom Metals status extension and you *have* to have
      -- a have settings to capture this in your statusline or else you'll not see
      -- any messages from metals. There is more info in the help docs about this
      metals_config.init_options.statusBarProvider = 'off'

      -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
      metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require('metals').setup_dap()

        -- LSP mappings
        map('n', 'gD', vim.lsp.buf.definition)
        map('n', 'K', vim.lsp.buf.hover)
        map('n', 'gi', vim.lsp.buf.implementation)
        map('n', 'gr', vim.lsp.buf.references)
        map('n', 'gds', vim.lsp.buf.document_symbol)
        map('n', 'gws', vim.lsp.buf.workspace_symbol)
        map('n', '<leader>cl', vim.lsp.codelens.run)
        map('n', '<leader>sh', vim.lsp.buf.signature_help)
        map('n', '<leader>rn', vim.lsp.buf.rename)
        map('n', '<leader>f', vim.lsp.buf.format)
        map('n', '<leader>ca', vim.lsp.buf.code_action)

        map('n', '<leader>ws', function()
          require('metals').hover_worksheet()
        end)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = self.ft,
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}

require('mason').setup()
require('mason-null-ls').setup {
  handlers = {},
}

require('fidget').setup()

require('colorizer').setup()

-- Linter
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
require('null-ls').setup {
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}

--WSL clipboard support
local win_clip = io.open('/mnt/c/Windows/System32/clip.exe', 'r')
if win_clip ~= nil then
  vim.api.nvim_command [[
      autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @0) | endif
  ]]
  io.close(win_clip)
end

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

--Tabulation
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.smartindent = true
vim.bo.autoindent = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Turn off comment on new line after comment line
vim.o.formatoptions = 'tcqnj'

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = '*',
  callback = function()
    vim.opt.fo:remove 'c'
    vim.opt.fo:remove 'r'
    vim.opt.fo:remove 'o'
  end,
})

-- require "pears".setup()

-- center widow when use crtl+d and crtl+u
vim.keymap.set({ 'n', 'v' }, '<C-d>', '<C-d>zz')
vim.keymap.set({ 'n', 'v' }, '<C-u>', '<C-u>zz')

-- Bind compile current file
vim.keymap.set('n', '<F17>', ':!compiler %<CR>', { silent = true })

-- Default options:
require('kanagawa').setup {
  compile = false,  -- enable compiling the colorscheme
  undercurl = true, -- enable undercurls
  commentStyle = { italic = true },
  functionStyle = {},
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  typeStyle = {},
  transparent = true,    -- do not set background color
  dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
  terminalColors = true, -- define vim.g.terminal_color_{0,17}
  colors = {             -- add/modify theme and palette colors
    palette = {},
    theme = {
      wave = {},
      lotus = {},
      dragon = {},
      all = {
        ui = { bg_gutter = 'none' },
      },
    },
  },
  overrides = function(colors) -- add/modify highlights
    return {}
  end,
  theme = 'wave',  -- Load "wave" theme when 'background' option is not set
  background = {   -- map the value of 'background' option to a theme
    dark = 'wave', -- try "dragon" !
    light = 'lotus',
  },
}

-- setup must be called before loading
vim.cmd 'colorscheme kanagawa'
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'codedark',
    component_separators = '|',
    section_separators = '',
  },
}

-- Harpoon
local harpoon = require 'harpoon'
harpoon:setup {}

local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
      .new({}, {
        prompt_title = 'Harpoon',
        finder = require('telescope.finders').new_table {
          results = file_paths,
        },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
      })
      :find()
end

vim.keymap.set('n', '<leader>hh', ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
vim.keymap.set('n', '<leader>ha', ":lua require('harpoon.mark').add_file()<CR>")

vim.keymap.set('n', '<leader>hn', ":lua require('harpoon.ui').nav_next()<CR>")
vim.keymap.set('n', '<leader>hp', ":lua require('harpoon.ui').nav_prev()<CR>")
vim.keymap.set('n', '<leader>hp', ":lua require('harpoon.ui').nav_prev()<CR>")

vim.keymap.set('n', '<leader>hj', ":lua require('harpoon.ui').nav_file(1)<CR>")
vim.keymap.set('n', '<leader>hk', ":lua require('harpoon.ui').nav_file(2)<CR>")
vim.keymap.set('n', '<leader>hl', ":lua require('harpoon.ui').nav_file(3)<CR>")
vim.keymap.set('n', '<leader>h;', ":lua require('harpoon.ui').nav_file(4)<CR>")

--Enable Comment.nvim
require('Comment').setup()

--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Indent blankline
require('ibl').setup {
  indent = { char = '┊' },
  whitespace = {
    remove_blankline_trail = true,
  },
  scope = { enabled = false },
}

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- LazyGit
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>')

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}
-- require('telescope').load_extension('fzf')

--  Telescope shortcuts
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').find_files {
    hidden = true,
    file_ignore_patterns = { '.git/', 'node_modules/', '.cache/', '%.o$', '%.a$', '%.out$', '%.class$', '%.pdf$', '%.mkv$', '%.mp4$', '%.zip$' },
    prompt_title = '[S]earch [F]iles',
  }
end)
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

require('nvim-test').setup {
  run = true,               -- run tests (using for debug)
  commands_create = true,   -- create commands (TestFile, TestLast, ...)
  filename_modifier = ':.', -- modify filenames before tests run(:h filename-modifiers)
  silent = false,           -- less notifications
  term = 'terminal',        -- a terminal to run ("terminal"|"toggleterm")
  termOpts = {
    direction = 'vertical', -- terminal's direction ("horizontal"|"vertical"|"float")
    width = 96,             -- terminal's width (for vertical|float)
    height = 24,            -- terminal's height (for horizontal|float)
    go_back = false,        -- return focus to original window after executing
    stopinsert = 'auto',    -- exit from insert mode (true|false|"auto")
    keep_one = true,        -- keep only one terminal for testing
  },
  runners = {               -- setup tests runners
    go = 'nvim-test.runners.go-test',
    python = 'nvim-test.runners.pytest',
  },
}

vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>')
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>')
vim.keymap.set('n', '<leader>tl', ':TestLast<CR>')
vim.keymap.set('n', '<leader>ts', ':TestSuite<CR>')
vim.keymap.set('n', '<leader>tv', ':TestVisit<CR>')

--Debugging setup
vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<F10>', ":lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<F11>', ":lua require'dap'.step_into()<CR>")
vim.keymap.set('n', '<F12>', ":lua require'dap'.step_out()<CR>")
vim.keymap.set('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set('n', '<leader>lp', ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>")
vim.keymap.set('n', '<F6>', ":lua require'dapui'.toggle()<CR>")

require('nvim-dap-virtual-text').setup()
require('dapui').setup()
require('dap-python').test_runner = 'pytest'

local dap = require 'dap'
local dapui = require 'dapui'

require('dap-go').setup {
  -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details do:
  -- :help dap-configuration
  dap_configurations = {
    {
      -- Must be "go" or it will be ignored by the plugin
      type = 'go',
      name = 'Attach remote',
      mode = 'remote',
      request = 'attach',
    },
  },
  -- delve configurations
  delve = {
    -- the path to the executable dlv which will be used for debugging.
    -- by default, this is the "dlv" executable on your PATH.
    path = 'dlv',
    -- time to wait for delve to initialize the debug session.
    -- default to 20 seconds
    initialize_timeout_sec = 20,
    -- a string that defines the port to start delve debugger.
    -- default to string "${port}" which instructs nvim-dap
    -- to start the process in a random available port
    host = 'localhost',
    port = 2345,
    -- additional args to pass to dlv
    args = {},
    -- the build flags that are passed to delve.
    -- defaults to empty string, but can be used to provide flags
    -- such as "-tags=unit" to make sure the test suite is
    -- compiled during debugging, for example.
    -- passing build flags using args is ineffective, as those are
    -- ignored by delve in dap mode.
    -- avaliable ui interactive function to prompt for arguments get_arguments
    build_flags = {},
    -- whether the dlv process to be created detached or not. there is
    -- an issue on Windows where this needs to be set to false
    -- otherwise the dlv server creation will fail.
    -- avaliable ui interactive function to prompt for build flags: get_build_flags
    detached = vim.fn.has 'win32' == 0,
    -- the current working directory to run dlv from, if other than
    -- the current working directory.
    cwd = nil,
  },
  -- options related to running closest test
  tests = {
    -- enables verbosity when running the test.
    verbose = false,
  },
}
-- dap.listeners.after.event_initialized["dapui_config"] = function ()
--    dapui.open()
-- end

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}

-- If you want to use this for Rust and C, add something like this:

dap.adapters.executable = {
  type = 'executable',
  command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
  name = 'lldb1',
  host = '127.0.0.1',
  port = 13000,
}

dap.adapters.lldb = {
  name = 'codelldb server',
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
    args = { '--port', '${port}' },
  },
}

dap.adapters.python = {
  type = 'executable',
  command = '/usr/bin/python',
  args = { '-m', 'debugpy.adapter' },
}
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = 'Launch file',

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = '${file}', -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end,
  },
}

require('neo-tree').setup {
  filesystem = {
    filtered_items = {
      visible = true,        -- Make sure this is set to true
      hide_dotfiles = false, -- Set to false to show dotfiles like .git, .env, etc.
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings
local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>km', require('telescope.builtin').keymaps, '[K]ey [M]aps')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Enable the following language servers
local servers = {
  'jdtls',
  'pyright',
  'emmet_language_server',
  'texlab',
  'quick_lint_js',
  'vtsls',
  'bashls',
  'gopls',
  'html',
  'sqlls',
  'buf_ls',
  'htmx',
  'templ',
  'cssmodules_ls',
  'somesass_ls',
  -- 'tailwindcss',
  'yamlls',
  'cssls',
  'jsonls',
  'hls',
  'metals',
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.omnisharp.setup {
  capabilities = capabilities,
  cmd = { 'dotnet', vim.fn.stdpath 'data' .. '/mason/packages/omnisharp/libexec/OmniSharp.dll' },
  enable_import_completion = true,
  organize_imports_on_format = true,
  enable_roslyn_analyzers = true,
  root_dir = function()
    return vim.loop.cwd()
  end,
}

-- Example custom server
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig['lua_ls'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconfig['clangd'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
}

function leave_snippet()
  if
      ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
      and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require('luasnip').session.jump_active
  then
    require('luasnip').unlink_current()
  end
end

-- stop snippets when you leave to normal mode
vim.api.nvim_command [[
    autocmd ModeChanged * lua leave_snippet()
]]

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
        -- elseif luasnip.jumpable(-1) then
        --   luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },

  experimental = {
    native_menu = false,
    ghost_text = true,
  },

  sources = {
    { name = 'luasnip',  priority = 40 },
    { name = 'nvim_lsp', priority = 30 },
    { name = 'path',     priority = 10 },
    { name = 'orgmode',  priority = 5 },
  },
  sorting = {
    priority_weight = 1.0,
    comparators = {
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
      cmp.config.compare.offset,
      cmp.config.compare.order,
      -- cmp.config.compare.sort_text,
      -- cmp.config.exact,
      -- cmp.config.compare.kind,
    },
  },
}

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.format(nil, 3000)
  end,
})

local TrimWhiteSpaceGrp = vim.api.nvim_create_augroup('TrimWhiteSpaceGrp', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = TrimWhiteSpaceGrp,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

require('orgmode').setup {
  org_agenda_files = { '~/obsidian/org/*' },
  org_default_notes_file = '~/org/refile.org',
}

vim.keymap.set('n', '<leader>os', ':Telescope find_files cwd=~/obsidian/org <CR>')

vim.keymap.set('n', '<leader>fe', '<CMD>Neotree reveal_force_cwd toggle<CR>', { desc = 'Open parent directory' })

vim.api.nvim_set_option(
  'langmap',
  'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
)

-- Map Alt+щ to behave like Alt+o in both normal and insert modes
vim.api.nvim_set_keymap('n', '<A-щ>', '<A-o>', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-щ>', '<A-o>', { noremap = true })
