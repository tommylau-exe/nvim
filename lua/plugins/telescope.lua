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
        vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status)
        vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches)

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function()
                vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_workspace_symbols)
                vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions)
                vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
                vim.keymap.set('n', 'gs', require('telescope.builtin').lsp_document_symbols)
            end
        })
    end,
}
