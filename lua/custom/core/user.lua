-- lua/custom/core/user.lua
local common = require('custom.core.common')

local M = {}

local function fetch_and_save()
  -- TODO: Fill in the endpoint and parsing logic to fetch and return the user ID.
  vim.notify('Please configure the user ID endpoint in lua/custom/core/user.lua', vim.log.levels.WARN)
  local placeholder_user_id = '5' -- Default placeholder
  common.write_to_file('user_id', placeholder_user_id)
  return placeholder_user_id
end

function M.get()
  local user_id = common.read_from_file('user_id')
  if not user_id then
    vim.notify('User ID not found, fetching from API...', vim.log.levels.INFO)
    return fetch_and_save()
  end
  return user_id
end

return M
