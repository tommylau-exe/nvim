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
  -- show the full (possibly multi-line) diagnostic for the cursor's line
  virtual_lines = { current_line = true },
  -- open the float automatically when jumping with ]d / [d
  jump = { float = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN]  = '',
      [vim.diagnostic.severity.INFO]  = '',
      [vim.diagnostic.severity.HINT]  = '',
    },
  },
})

-- <leader>w formats and writes; see lua/plugins/local/format.lua (bound in init.lua)

-- if supported by lsp, enable inline hints
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end
    if not client:supports_method('textDocument/inlayHint', ev.buf) then return end

    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
  end,
})

-- if supported by lsp, enable symbol highlighting under cursor
vim.opt.updatetime = 400
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end
    if not client:supports_method('textDocument/documentHighlight', ev.buf) then return end

    local group = vim.api.nvim_create_augroup('highlight_symbol', { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = ev.buf, group = group })

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = group,
      buffer = ev.buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = group,
      buffer = ev.buf,
      callback = vim.lsp.buf.clear_references,
    })
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
enable_if_installed('sorbet_lsp')
enable_if_installed('vtsls')
enable_if_installed('graphql_lsp')
