-- nvim-treesitter (main) has no setup(): parsers are installed explicitly and
-- highlighting is attached per-buffer.

-- ruby's treesitter indent/highlight is incomplete, so keep vim's regex
-- syntax running alongside it
local vim_regex_highlight = { ruby = true }

-- registered eagerly so the buffer opened at startup gets highlighted: it
-- fires FileType before any `later` callback runs. attaching needs no plugin
-- code, since parsers and queries live in `stdpath('data')/site`, which is
-- already on the runtimepath.
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

-- installing touches the filesystem and the network, so it waits
MiniMisc.safely('later', function()
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
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
  })
end)
