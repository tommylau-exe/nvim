-- simple plugin inspired by the Emacs 'compile command'
--
-- useful for placing command output in a dedicated buffer to inspect and
-- operate on. e.g. using `gf` on paths in output, yanking selections

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

local buf_count = 0
local function create_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  if buf_count == 0 then
    vim.api.nvim_buf_set_name(buf, 'Command Output')
  else
    vim.api.nvim_buf_set_name(buf, string.format('Command Output (%d)', buf_count))
  end

  buf_count = buf_count + 1
  return buf
end

-- default arguments
M.args = {
  vertical_split = false,
}

function M.setup(args)
  M.args = vim.tbl_deep_extend('force', M.args, args)
end

function M.prompt()
  local cmd = input('Compile command: ', '', 'shellcmdline')
  if #cmd == 0 then return end

  local cmd_res = vim.fn.systemlist(cmd)

  local buf = create_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, cmd_res)
  vim.api.nvim_set_option_value('readonly', true, { buf = buf })

  local win = get_or_create_window()
  vim.api.nvim_win_set_buf(win, buf)
end

return M
