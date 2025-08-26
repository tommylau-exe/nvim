---@type vim.lsp.Config
return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql' },
  root_markers = {
    '.graphqlrc',
    '.graphqlrc.yaml',
    '.graphqlrc.json',
    '.graphqlrc.js',
    'graphql.config.yaml',
    'graphql.config.json',
    'graphql.config.js',
  },
}
