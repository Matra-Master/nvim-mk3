-- lua/custom/core/auth.lua
local common = require('custom.core.common')
-- FRAN: Add domain logic

local M = {}

local function fetch_and_save()
  -- TODO: Fill in the endpoint and parsing logic to fetch and return the auth token.
  -- Example:
  -- local url = "https://your-api.com/auth"
  -- local command = { "curl", "-s", url }
  -- vim.system(command, function(obj)
  --   if obj.code == 0 then
  --     local token = obj.stdout -- or parse from json: vim.fn.json_decode(obj.stdout).token
  --     common.write_to_file('auth_token', token)
  --   else
  --     vim.notify("Failed to fetch auth token: " .. obj.stderr, vim.log.levels.ERROR)
  --   end
  -- end)
  vim.notify('Please configure the auth token endpoint in lua/custom/core/auth.lua', vim.log.levels.WARN)
  local placeholder_token = 'your_placeholder_token'
  common.write_to_file('auth_token', placeholder_token)
  return placeholder_token
end

function M.get()
  local token = common.read_from_file('auth_token')
  if not token then
    vim.notify('Auth token not found, fetching from API...', vim.log.levels.INFO)
    return fetch_and_save()
  end
  return token
end

return M
