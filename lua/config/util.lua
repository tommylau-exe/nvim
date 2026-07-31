local M = {}

-- write bufnr specifically (callers may run async, so not just the current
-- buffer), if it is still valid
---@param bufnr integer
function M.write(bufnr)
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_call(bufnr, function() vim.cmd('write') end)
  end
end

---@param path string
---@return string|nil
function M.setreg_relative_path(path)
  path = vim.fs.relpath(vim.fn.getcwd() .. '/', path) or ""
  if path and #path > 0 then
    vim.fn.setreg(vim.v.register, path)
    print(path)
  end
end

return M
