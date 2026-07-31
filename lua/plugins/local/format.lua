-- <leader>w: format the buffer with an attached LSP client (when one supports
-- it), then write. This is the generic base; ecosystem formatters layer over it
-- by wrapping the <leader>w mapping (see eslint_prettier.lua).

local util = require('config.util')

local M = {}

--- Format the buffer via LSP (when supported), then write it.
---@param bufnr? integer defaults to the current buffer
function M.format_and_write(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client:supports_method('textDocument/formatting', bufnr) then
      vim.lsp.buf.format({ bufnr = bufnr })
      break
    end
  end
  util.write(bufnr)
end

-- bind <leader>w to the base formatter. Call before layers that wrap it.
function M.setup()
  vim.keymap.set('n', '<leader>w', function() M.format_and_write() end,
    { desc = 'Format and write' })
end

return M
