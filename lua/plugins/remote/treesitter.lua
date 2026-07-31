-- nvim-treesitter's `main` branch dropped the `nvim-treesitter.configs` module.
-- parsers are installed explicitly and highlighting is attached per-buffer.
MiniMisc.safely('later', function()
  vim.cmd.packadd('nvim-treesitter')

  require('nvim-treesitter').install({
    'c',
    'graphql',
    'javascript',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'ruby',
    'typescript',
    'vim',
    'vimdoc',
  })

  -- ruby's treesitter indent/highlight is incomplete, so keep vim's regex
  -- syntax running alongside it (was `additional_vim_regex_highlighting`)
  local vim_regex_highlight = { ruby = true }

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local lang = vim.treesitter.language.get_lang(filetype)
      if not lang or not vim.treesitter.language.add(lang) then return end

      vim.treesitter.start(buf, lang)

      if vim.treesitter.query.get(lang, 'indents') then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      if vim_regex_highlight[lang] then
        vim.bo[buf].syntax = 'on'
      end
    end,
  })
end)
