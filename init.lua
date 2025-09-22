vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes'
vim.opt.list = true
vim.opt.listchars = {
  tab   = '» ',
  lead  = '·',
  trail = '·',
  nbsp  = '␣',
}

vim.opt.cursorline = true
vim.opt.colorcolumn = '+1'

vim.opt.undofile = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<esc>', ':nohlsearch<cr>', { silent = true })
vim.keymap.set('n', '<leader>o', ':b #<cr>', { silent = true })
vim.keymap.set('n', '<leader>l', ':%lua<cr>', { silent = true })
vim.keymap.set('v', '<leader>l', ':lua<cr>', { silent = true })
vim.keymap.set('n', '<leader>p', function()
  local path = vim.fn.expand('%')
  require('config.util').setreg_relative_path(path)
end)
vim.keymap.set('n', '<leader>w', ':write<cr>')
vim.keymap.set('n', '<leader>q', ':qall<cr>')
vim.keymap.set('n', '<leader>d', ':Ex<cr>')

require('config')
require('plugins')
