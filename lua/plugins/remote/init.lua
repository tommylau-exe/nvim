vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end
})

vim.pack.add({
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
})

require('plugins.remote.mini')
require('plugins.remote.theme')
require('plugins.remote.treesitter')
