return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'diff',
                'html',
                'javascript',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'query',
                'vim',
                'vimdoc',
            },
            auto_install = false,
            hightlight = {
                enable = true,
                additional_vim_regex_highlighting = { 'ruby' }
            },
            indent = {
                enable = true,
                disable = { 'ruby' }
            },
        },
    }
}
