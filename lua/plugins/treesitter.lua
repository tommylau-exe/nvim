MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = {
    post_checkout = function() vim.cmd('TSUpdate') end,
  },
})

MiniDeps.later(function()
  require('nvim-treesitter.configs').setup({
    additional_vim_regex_highlighting = { 'ruby' },
    auto_install = false,
    ensure_installed = {
      'c',
      'graphql',
      'javascript',
      'lua',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'ruby',
      'typescript',
      'vim',
      'vimdoc',
    },
    highlight = { enable = true },
    ignore_install = {},
    modules = {},
    sync_install = false,
  })
end)
