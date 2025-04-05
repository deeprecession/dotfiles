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

-- trying to add russian
vim.api.nvim_set_option(
  'langmap',
  'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
)

--WSL clipboard support
local win_clip = io.open('/mnt/c/Windows/System32/clip.exe', 'r')
if win_clip ~= nil then
  vim.api.nvim_command [[
      autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @0) | endif
  ]]
  io.close(win_clip)
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = '*',
  callback = function()
    vim.opt.fo:remove 'c'
    vim.opt.fo:remove 'r'
    vim.opt.fo:remove 'o'
  end,
})
