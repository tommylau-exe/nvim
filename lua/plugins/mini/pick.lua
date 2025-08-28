MiniDeps.later(function()
  require('mini.pick').setup()
  vim.ui.select = MiniPick.ui_select

  vim.keymap.set('n', '<leader><leader>', MiniPick.builtin.files)
  vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files)
  vim.keymap.set('n', '<leader>fw', MiniPick.builtin.grep_live)
  vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers)
  vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers)
  vim.keymap.set('n', '<leader>fh', MiniPick.builtin.help)

  -- TODO: why doesn't this work
  vim.keymap.set('n', '<leader>fc', function()
    MiniPick.builtin.files({ source = { cwd = vim.fn.stdpath('config') } })
  end)

  vim.keymap.set('n', '<leader>gf', MiniExtra.pickers.git_files)
  vim.keymap.set('n', '<leader>gb', MiniExtra.pickers.git_branches)

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
      vim.keymap.set('n', 'grr', function()
        MiniExtra.pickers.lsp({ scope = 'references' })
      end)
      vim.keymap.set('n', 'gri', function()
        MiniExtra.pickers.lsp({ scope = 'implementation' })
      end)
      vim.keymap.set('n', 'grt', function()
        MiniExtra.pickers.lsp({ scope = 'type_definition' })
      end)
      vim.keymap.set('n', 'grd', function()
        MiniExtra.pickers.lsp({ scope = 'definition' })
      end)
      vim.keymap.set('n', 'gO', function()
        MiniExtra.pickers.lsp({ scope = 'document_symbol' })
      end)
    end,
  })
end)
