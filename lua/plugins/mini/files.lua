require('mini.files').setup()

MiniDeps.later(function()
  vim.keymap.set('n', '<leader>d', function()
    if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
  end)
end)
MiniDeps.later(function()
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
