return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      'icon',
      { 'permissions', highlight = 'Special' },
      { 'size', highlight = 'Special' },
      { 'mtime', highlight = 'Special' },
    },
  },
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
  keys = {
    {
      '<leader>o.',
      function()
        require('oil').open(vim.fn.getcwd())
      end,
      desc = '[O]pen current directory [.]',
    },
    { '<leader>of', '<cmd>Oil<cr>', desc = '[O]pen directory of current [f]ile' },
    { '<leader>o~', '<cmd>Oil ~<cr>', desc = '[O]pen home directory [~]' },
    { '<leader>o`', '<cmd>Oil ~<cr>', desc = '[O]pen home directory [~]' },
    {
      '<leader>o/',
      function()
        local cwd = vim.fn.getcwd()

        -- append trailing '/' if not already present
        if cwd:sub(-1) ~= '/' then
          cwd = cwd .. '/'
        end

        vim.ui.input({ prompt = 'Open directory: ', default = cwd, completion = 'dir' }, function(directory)
          if directory == nil or directory == '' then
            return
          end

          require('oil').open(directory)
        end)
      end,
      desc = '[O]pen directory [/]...',
    },
  },
}
