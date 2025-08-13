-- Creando tarea desde vim porque puedo

-- ===================================================================
-- CONFIGURATION
-- Configuration is now managed in lua/custom/core/
-- ===================================================================
local projects_config = require('custom.core.projects')
local auth_config = require('custom.core.auth')
local user_config = require('custom.core.user')
local domain_config = require('custom.core.domain')

-- ===================================================================
-- HELPER FUNCTIONS
-- ===================================================================

---@diagnostic disable-next-line: missing-fields
local function get_visual_selection()
  local old_reg = vim.fn.getreg('"')
  local old_reg_type = vim.fn.getregtype('"')
  vim.cmd('noautocmd silent! normal! "vy"')
  local selection = vim.fn.getreg('"')
  vim.fn.setreg('"', old_reg, old_reg_type)
  return selection
end

-- ===================================================================
-- API CALL LOGIC
-- ===================================================================

-- Posts the current visual selection as a user story to the selected project
local function post_selection_to_api()
  local projects = projects_config.get()
  if #projects == 0 then
    vim.notify("Project list is empty. Press <leader>ur to fetch projects from the API.", vim.log.levels.WARN)
    return
  end

  local selection = get_visual_selection()
  if selection == '' then
    vim.notify("No text selected.", vim.log.levels.WARN)
    return
  end

  local project_names = {}
  for _, p in ipairs(projects) do
    table.insert(project_names, p.name)
  end

  vim.ui.select(project_names, { prompt = "Select Project:" }, function(choice)
    if not choice then
      vim.notify("Project selection cancelled.", vim.log.levels.WARN)
      return
    end

    local project_id
    for _, p in ipairs(projects) do
      if p.name == choice then
        project_id = p.id
        break
      end
    end

    local payload = {
      project = project_id,
      subject = selection,
    }
    local json_payload = vim.fn.json_encode(payload)
    local api_endpoint = domain_config.get() .. "/api/v1/userstories"

    local command = {
      "curl",
      "-X",
      "POST",
      "-H",
      "Content-Type: application/json",
      "-H",
      "Authorization: Bearer " .. auth_config.get(),
      "-d",
      json_payload,
      "-s",
      api_endpoint,
    }

    vim.notify("Sending to [" .. choice .. "]...")
    vim.system(command, function(obj)
      vim.schedule(function()
        if obj.code ~= 0 then
          vim.notify("Error sending request: " .. obj.stderr, vim.log.levels.ERROR)
        else
          vim.notify("User story sent successfully!")
        end
      end)
    end)
  end)
end

-- ===================================================================
-- KEYMAPS
-- ===================================================================
vim.keymap.set({ "v", "x" }, "<leader>u", post_selection_to_api, { desc = "Post selection as User Story" })
vim.keymap.set("n", "<leader>ur", projects_config.update, { desc = "Update projects from API" })