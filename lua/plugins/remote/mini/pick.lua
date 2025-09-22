MiniDeps.later(function()
  require('mini.pick').setup()
  vim.ui.select = MiniPick.ui_select

  vim.keymap.set('n', '<leader><leader>', MiniPick.builtin.files)
  vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files)
  vim.keymap.set('n', '<leader>fw', MiniPick.builtin.grep_live)
  vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers)
  vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers)
  vim.keymap.set('n', '<leader>fh', MiniPick.builtin.help)

  vim.keymap.set('n', '<leader>fc', function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath('config') } })
  end)
  vim.keymap.set('n', '<leader>fp', function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath('data') } })
  end)

  vim.keymap.set('n', '<leader>gf', MiniExtra.pickers.git_files)
  vim.keymap.set('n', '<leader>gb', function()
    MiniExtra.pickers.git_branches({}, {
      source = {
        choose = function(item)
          local branch = item:match('^%*?%s*(%S+)')
          vim.cmd('Git switch ' .. branch)
        end,
      },
    })
  end)

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
