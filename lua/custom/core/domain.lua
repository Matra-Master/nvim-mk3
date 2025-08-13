-- lua/custom/core/domain.lua
local common = require('custom.core.common')

local M = {}

local function fetch_and_save()
  -- TODO: Fill in the endpoint and parsing logic to fetch and return the API domain.
  vim.notify('Please configure the API domain endpoint in lua/custom/core/domain.lua', vim.log.levels.WARN)
  local placeholder_domain = "https://mng.tuxdi.com" -- Default placeholder
  common.write_to_file('api_domain', placeholder_domain)
  return placeholder_domain
end

function M.get()
  local domain = common.read_from_file('api_domain')
  if not domain then
    vim.notify('API domain not found, fetching from API...', vim.log.levels.INFO)
    return fetch_and_save()
  end
  return domain
end

return M
