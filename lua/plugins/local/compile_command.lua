-- simple plugin inspired by the Emacs 'compile command'
--
-- useful for placing command output in a dedicated buffer to inspect and
-- operate on. e.g. using `gf` on paths in output, yanking selections

---@class CompileCommand.Opts
---@field vertical_split? boolean Open the output window in a vertical (right) split instead of below

---@class CompileCommand
---@field args CompileCommand.Opts
local M = {}

-- thin wrapper around vim.fn.input() that fixes neovide's cursor
local function input(...)
  if not vim.g.neovide then
    return vim.fn.input(...)
  end

  vim.g.neovide_cursor_hack = false
  local result = vim.fn.input(...)
  vim.g.neovide_cursor_hack = true
  return result
end

local last_used_window = nil
local function get_or_create_window()
  if last_used_window and vim.api.nvim_win_is_valid(last_used_window) then
    return last_used_window
  end

  if M.args.vertical_split then
    last_used_window = vim.api.nvim_open_win(0, false, { split = 'right' })
  else
    last_used_window = vim.api.nvim_open_win(0, false, { split = 'below' })
  end

  return last_used_window
end

local output_buf = nil
local function get_or_create_buf()
  if output_buf and vim.api.nvim_buf_is_valid(output_buf) then
    return output_buf
  end

  output_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(output_buf, 'Command Output')
  return output_buf
end

-- default arguments
---@type CompileCommand.Opts
M.args = {
  vertical_split = false,
}

--- Configure the plugin.
---@param args CompileCommand.Opts Partial options to override the defaults
function M.setup(args)
  M.args = vim.tbl_deep_extend('force', M.args, args)
end

-- replace the full contents of a buffer, toggling modifiable around the write
local function set_buf_lines(buf, lines)
  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
end

--- Prompt for a shell command, then run it asynchronously and show its output
--- in the reused "Command Output" buffer/window.
function M.prompt()
  local cmd = input('Compile command: ', '', 'shellcmdline')
  if #cmd == 0 then return end

  local buf = get_or_create_buf()
  set_buf_lines(buf, { string.format('$ %s', cmd), '', 'Running...' })

  local win = get_or_create_window()
  vim.api.nvim_win_set_buf(win, buf)

  -- run through a shell so pipes/globs and shellcmdline completion behave as
  -- typed; vim.system is async so the editor stays responsive
  vim.system({ 'sh', '-c', cmd }, { text = true }, function(obj)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then return end

      local lines = { string.format('$ %s', cmd), '' }
      vim.list_extend(lines, vim.split((obj.stdout or '') .. (obj.stderr or ''), '\n'))
      if obj.code ~= 0 then
        vim.list_extend(lines, { '', string.format('[exited %d]', obj.code) })
      end

      set_buf_lines(buf, lines)
    end)
  end)
end

return M
