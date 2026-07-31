---@type vim.lsp.Config
return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = {
    'tsconfig.json',
    'package.json',
    'jsconfig.json',
    '.git',
  },
  settings = {
    -- prefer the project's TypeScript over vtsls's bundled (older) one
    vtsls = { autoUseWorkspaceTsdk = true },
  },
}
