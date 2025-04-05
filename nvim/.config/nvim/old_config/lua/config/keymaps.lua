--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Map Alt+щ to behave like Alt+o in both normal and insert modes
vim.api.nvim_set_keymap('n', '<A-щ>', '<A-o>', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-щ>', '<A-o>', { noremap = true })

-- center widow when use crtl+d and crtl+u
vim.keymap.set({ 'n', 'v' }, '<C-d>', '<C-d>zz')
vim.keymap.set({ 'n', 'v' }, '<C-u>', '<C-u>zz')

-- Bind compile current file
vim.keymap.set('n', '<F17>', ':!compiler %<CR>', { silent = true })
