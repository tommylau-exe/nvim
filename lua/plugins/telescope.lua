return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
        require('telescope').setup {
            defaults = require('telescope.themes').get_ivy(),
            extensions = { fzf = {} },
        }
        require('telescope').load_extension('fzf')

        vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
        vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
        vim.keymap.set('n', '<leader>fw', require('telescope.builtin').live_grep)
        vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
        vim.keymap.set('n', '<leader>fc', function()
            require('telescope.builtin').find_files { cwd = vim.fn.stdpath('config') }
        end)

        vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files)
        vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches)

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function()
                vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_workspace_symbols)

                local cursor = require('telescope.themes').get_cursor()
                vim.keymap.set('n', 'gd', function() require('telescope.builtin').lsp_definitions(cursor) end)
                vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references(cursor) end)
                vim.keymap.set('n', 'gs', function() require('telescope.builtin').lsp_document_symbols(cursor) end)
            end
        })
    end,
}
