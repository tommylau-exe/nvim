MiniMisc.safely('later', function()
  require('mini.pick').setup()
  vim.ui.select = MiniPick.ui_select

  vim.keymap.set('n', '<leader><leader>', MiniPick.builtin.files, { desc = 'Files' })
  vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files, { desc = 'Files' })
  vim.keymap.set('n', '<leader>fw', MiniPick.builtin.grep_live, { desc = 'Grep live' })
  vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers, { desc = 'Buffers' })
  vim.keymap.set('n', '<leader>fh', MiniPick.builtin.help, { desc = 'Help tags' })

  vim.keymap.set('n', '<leader>fc', function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath('config') } })
  end, { desc = 'Files in config' })
  vim.keymap.set('n', '<leader>fp', function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath('data') } })
  end, { desc = 'Files in data' })

  vim.keymap.set('n', '<leader>gf', MiniExtra.pickers.git_files, { desc = 'Git files' })
  vim.keymap.set('n', '<leader>gb', function()
    MiniExtra.pickers.git_branches({}, {
      source = {
        choose = function(item)
          local branch = item:match('^%*?%s*(%S+)')
          vim.cmd('Git switch ' .. branch)
        end,
      },
    })
  end, { desc = 'Git branches' })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
      vim.keymap.set('n', 'grr', function()
        MiniExtra.pickers.lsp({ scope = 'references' })
      end, { desc = 'LSP references' })
      vim.keymap.set('n', 'gri', function()
        MiniExtra.pickers.lsp({ scope = 'implementation' })
      end, { desc = 'LSP implementations' })
      vim.keymap.set('n', 'grt', function()
        MiniExtra.pickers.lsp({ scope = 'type_definition' })
      end, { desc = 'LSP type definitions' })
      vim.keymap.set('n', 'grd', function()
        MiniExtra.pickers.lsp({ scope = 'definition' })
      end, { desc = 'LSP definitions' })
      vim.keymap.set('n', 'gO', function()
        MiniExtra.pickers.lsp({ scope = 'document_symbol' })
      end, { desc = 'LSP document symbols' })
    end,
  })
end)
