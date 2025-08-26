local M = {}

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
