-- lua/custom/core/projects.lua
local common = require('custom.core.common')
local auth = require('custom.core.auth')
local user = require('custom.core.user')
local domain = require('custom.core.domain')

local M = {}

function M.get()
  local projects_json = common.read_from_file('projects')
  if not projects_json then
    return {}
  end
  local ok, projects = pcall(vim.fn.json_decode, projects_json)
  if not ok then
    vim.notify('Failed to parse projects file.', vim.log.levels.ERROR)
    return {}
  end
  return projects
end

function M.update()
  vim.notify('Fetching projects from API...')

  -- TODO: The user can customize this function to fit their needs.
  -- This is a scaffold based on the original `update_projects_from_api` function.
  local url = string.format(
    '%s/api/v1/projects?member=%s&order_by=memberships__user_order',
    domain.get(),
    user.get()
  )

  local command = {
    'curl',
    '-X',
    'GET',
    '-H',
    'Content-Type: application/json',
    '-H',
    'Authorization: Bearer ' .. auth.get(),
    '-s',
    url,
  }

  vim.system(command, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify('Error fetching projects: ' .. obj.stderr, vim.log.levels.ERROR)
        return
      end

      local ok, projects_data = pcall(vim.fn.json_decode, obj.stdout)
      if not ok then
        vim.notify('Error parsing projects JSON from API response.', vim.log.levels.ERROR)
        return
      end

      local new_projects = {}
      for _, project in ipairs(projects_data) do
        if project.id and project.name then
          table.insert(new_projects, { id = project.id, name = project.name })
        end
      end

      common.write_to_file('projects', vim.fn.json_encode(new_projects))
      vim.notify('Projects updated! Found ' .. #new_projects .. ' projects.', vim.log.levels.INFO)
    end)
  end)
end

return M
