-- <leader>w for js/ts: run the project's own eslint --fix then prettier over the
-- buffer, then write -- matching CI for repos that lint with eslint and format
-- with prettier. Prefers the eslint_d/prettierd daemons on PATH for speed,
-- falling back to the node_modules/.bin CLIs.
--
-- Layers over <leader>w: setup() wraps whatever mapping already exists, handling
-- the prettier/eslint filetypes itself and deferring everything else to the
-- previous mapping. Disposable: delete this file and its setup() call in
-- plugins/local/init.lua, and <leader>w reverts to that previous mapping.

local util = require('config.util')

local M = {}

local prettier_fts = {
  javascript = true, javascriptreact = true, ['javascript.jsx'] = true,
  typescript = true, typescriptreact = true, ['typescript.tsx'] = true,
  json = true, jsonc = true, css = true, scss = true, less = true,
  html = true, yaml = true, markdown = true, graphql = true, vue = true,
}
local eslint_fts = {
  javascript = true, javascriptreact = true, ['javascript.jsx'] = true,
  typescript = true, typescriptreact = true, ['typescript.tsx'] = true,
}
local eslint_configs = {
  'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
  'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
  '.eslintrc', '.eslintrc.js', '.eslintrc.cjs',
  '.eslintrc.json', '.eslintrc.yaml', '.eslintrc.yml',
}

-- nearest node_modules/.bin/<name> above the file, or nil
local function find_bin(fname, name)
  local root = vim.fs.root(fname, function(entry, dir)
    return entry == 'node_modules'
      and vim.uv.fs_stat(vim.fs.joinpath(dir, 'node_modules', '.bin', name)) ~= nil
  end)
  return root and vim.fs.joinpath(root, 'node_modules', '.bin', name) or nil
end

-- an executable on PATH, or nil
local function exe(name)
  local path = vim.fn.exepath(name)
  return path ~= '' and path or nil
end

-- prefer a daemon on PATH, else the project-local CLI
local function resolve(fname, daemon, name)
  return exe(daemon) or find_bin(fname, name)
end

-- the dir holding the nearest eslint config, or nil. eslint must run with this
-- as cwd since configs can reference plugins by relative path (e.g. rulesdir)
local function eslint_root(fname)
  return vim.fs.root(fname, { eslint_configs }) -- nested list = equal priority
end

local function eslint_argv(bin, fname)
  return { bin, '--stdin', '--stdin-filename', fname, '--fix-dry-run', '--format', 'json' }
end

-- prettierd takes the filename as an arg; prettier wants --stdin-filepath
local function prettier_argv(bin, fname)
  return bin:find('prettierd', 1, true) and { bin, fname } or { bin, '--stdin-filepath', fname }
end

local function run_eslint(bin, fname, cwd, input, cb)
  vim.system(eslint_argv(bin, fname), { stdin = input, cwd = cwd }, function(obj)
    vim.schedule(function()
      -- eslint exits non-zero when unfixable problems remain; parse stdout anyway
      local ok, parsed = pcall(vim.json.decode, obj.stdout or '')
      cb(ok and parsed and parsed[1] and parsed[1].output or nil)
    end)
  end)
end

local function run_prettier(bin, fname, input, cb)
  vim.system(prettier_argv(bin, fname), { stdin = input }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify(obj.stderr ~= '' and obj.stderr or 'prettier failed',
          vim.log.levels.ERROR, { title = 'prettier' })
        return cb(nil)
      end
      cb(obj.stdout ~= '' and obj.stdout or nil) -- empty output = ignored file
    end)
  end)
end

-- replace the buffer with text (only if changed), then write
local function apply(bufnr, text)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  local lines = vim.split(text, '\n')
  if lines[#lines] == '' then table.remove(lines) end
  if not vim.deep_equal(lines, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end
  util.write(bufnr)
end

-- eslint --fix then prettier (prettier alone for the other prettier filetypes).
-- Returns true if it handled the buffer, false if no tool applies.
local function try_format(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local ft = vim.bo[bufnr].filetype

  local prettier, eslint, eslint_cwd
  if fname ~= '' then
    if prettier_fts[ft] then prettier = resolve(fname, 'prettierd', 'prettier') end
    if eslint_fts[ft] then
      eslint_cwd = eslint_root(fname)
      if eslint_cwd then eslint = resolve(fname, 'eslint_d', 'eslint') end
    end
  end
  if not prettier and not eslint then return false end

  local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n') .. '\n'

  local function then_prettier(input)
    if not prettier then return apply(bufnr, input) end
    run_prettier(prettier, fname, input, function(out) apply(bufnr, out or input) end)
  end

  if eslint then
    run_eslint(eslint, fname, eslint_cwd, text, function(out) then_prettier(out or text) end)
  else
    then_prettier(text)
  end
  return true
end

-- invoke a previously-captured `maparg(..., {dict=true})` mapping
local function call_prev(prev)
  if prev.callback then
    prev.callback()
  elseif type(prev.rhs) == 'string' and prev.rhs ~= '' then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(prev.rhs, true, false, true), 'n', false)
  else
    util.write(vim.api.nvim_get_current_buf()) -- nothing was mapped; just save
  end
end

-- Warm the daemons (spin up the process and preload the project config) by
-- running them once and discarding the output, so the first format is fast.
-- Read-only: the buffer is never modified. Once per project + daemon.
local warmed = {}
local function prewarm(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == '' then return end

  local prettier = exe('prettierd')
  local eslint, eslint_cwd = exe('eslint_d'), nil
  if eslint then
    eslint_cwd = eslint_root(fname)
    if not eslint_cwd then eslint = nil end
  end
  if not prettier and not eslint then return end

  local root = vim.fs.root(bufnr, { 'package.json', '.git' }) or vim.fs.dirname(fname)
  local input
  local function warm(daemon, argv, cwd)
    local key = root .. '\0' .. daemon
    if warmed[key] then return end
    warmed[key] = true
    input = input or table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n') .. '\n'
    vim.system(argv, { stdin = input, cwd = cwd }, function() end) -- fire and forget; discarded
  end

  if prettier then warm('prettierd', prettier_argv(prettier, fname)) end
  if eslint then warm('eslint_d', eslint_argv(eslint, fname), eslint_cwd) end
end

-- wrap <leader>w: format js/ts ourselves, else fall through to the previous
-- mapping; and prewarm the daemons on first js/ts open
function M.setup()
  local prev = vim.fn.maparg('<leader>w', 'n', false, true)
  vim.keymap.set('n', '<leader>w', function()
    if not try_format(vim.api.nvim_get_current_buf()) then
      call_prev(prev)
    end
  end, { desc = 'Format and write' })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    callback = function(args) prewarm(args.buf) end,
  })
end

return M
