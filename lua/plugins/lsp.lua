return {
    {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            }
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'j-hui/fidget.nvim', opts = {} },
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            require('lspconfig').lua_ls.setup { capabilities = capabilities }
            require('plugins.lsp.local').setup(capabilities)

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function()
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
                    vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format)
                    vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration)
                end
            })
        end
    },
}
