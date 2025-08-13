-- lua/custom/core/common.lua
local M = {}

M.data_dir = vim.fn.stdpath('data') .. '/custom_nvim_config'

function M.ensure_dir()
  vim.fn.mkdir(M.data_dir, 'p')
end

function M.read_from_file(filename)
  M.ensure_dir()
  local path = M.data_dir .. '/' .. filename
  local file = io.open(path, 'r')
  if not file then
    return nil
  end
  local content = file:read('*a')
  file:close()
  if content == '' then
    return nil
  end
  return content
end

function M.write_to_file(filename, content)
  M.ensure_dir()
  local path = M.data_dir .. '/' .. filename
  local file = io.open(path, 'w')
  if not file then
    vim.notify('Error opening file for writing: ' .. path, vim.log.levels.ERROR)
    return
  end
  file:write(content)
  file:close()
end

return M
