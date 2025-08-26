vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN]  = '',
      [vim.diagnostic.severity.INFO]  = '',
      [vim.diagnostic.severity.HINT]  = '',
    },
  },
})

-- if supported by lsp, overwrite <leader>w mapping to format on save
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end
    if not client:supports_method('textDocument/formatting', ev.buf) then return end

    vim.keymap.set('n', '<leader>w', function()
      vim.lsp.buf.format({ bufnr = ev.buf, id = ev.data.client_id })
      vim.cmd('write')
    end, { buffer = ev.buf })
  end,
})

---@param lsp_name string
local function enable_if_installed(lsp_name)
  local lsp_cmd = vim.tbl_get(vim.lsp.config, lsp_name, 'cmd', 1)
  if lsp_cmd and vim.fn.executable(lsp_cmd) == 1 then
    vim.lsp.enable(lsp_name)
  end
end
enable_if_installed('lua_ls')
enable_if_installed('ruby_lsp')
enable_if_installed('vtsls')
enable_if_installed('graphql_lsp')
