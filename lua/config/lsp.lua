local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
    local server_name = vim.fn.fnamemodify(f, ':t:r')
    table.insert(lsp_configs, server_name)
end
vim.lsp.enable(lsp_configs)

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
        vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format)
        vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration)
    end
})
