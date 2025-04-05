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

  { 'tpope/vim-fugitive' }, -- Git commands in nvim
  { 'tpope/vim-rhubarb' }, -- Fugitive-companion to interact with github

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
    'davidmh/mdx.nvim',
    config = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

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

  { 'ludovicchabant/vim-gutentags' }, -- Automatic tags management

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
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

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
          -- 'javascript',
          -- 'typescript',
          'lua',
          'vim',
          'vimdoc',
          'query',
          'elixir',
          'heex',
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
  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = { 'mfussenegger/nvim-dap' },
  },

  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = {
      'mfussenegger/nvim-dap',
      {
        'microsoft/vscode-js-debug',
        commit = '4d7c704d3f07',
        build = 'npm i && npm run compile vsDebugServerBundle && mv dist out',
      },
    },
  },

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
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    config = function()
      require('typescript-tools').setup {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          jsx_close_tag = {
            enable = true,
            filetypes = { 'javascriptreact', 'typescriptreact' },
          },
        },
      }
    end,
  },
}
