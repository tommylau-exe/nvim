MiniDeps.later(function()
  require('mini.files').setup()

  vim.keymap.set('n', '<leader>d', function()
    if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
  end)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(ev)
      vim.keymap.set('n', '<leader>p', function()
        local path = (MiniFiles.get_fs_entry(ev.data.buf_id) or {}).path
        require('config.util').setreg_relative_path(path)
      end, { buffer = ev.data.buf_id })
    end
  })
end)
