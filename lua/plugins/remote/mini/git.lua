MiniMisc.safely('later', function()
  require('mini.git').setup()

  vim.keymap.set('n', '<leader>gg', MiniGit.show_at_cursor, { desc = 'Git info at cursor' })
end)
