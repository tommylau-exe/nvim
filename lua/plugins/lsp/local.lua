local M = {}

M.setup = function(capabilities)
    require('lspconfig').clangd.setup {
        capabilities = capabilities,
        cmd = { 'clangd', '--query-driver=arm-apple-darwin11' },
    }
end

return M
