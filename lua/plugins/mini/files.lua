MiniDeps.later(function()
  require('mini.files').setup()

  vim.keymap.set('n', '<leader>d', function()
    if not MiniFiles.close() then MiniFiles.open() end
  end)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function()
      vim.keymap.set('n', '<leader>p', function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        require('config.util').setreg_relative_path(path)
      end)
    end
  })
end)
