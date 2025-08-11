
-- Creando tarea desde vim porque puedo

-- ===================================================================
-- CONFIGURATION
-- In the next step, we will load this from a file.
-- ===================================================================
local config = {
  auth_token = "COMPLETAR_TOKEN",
  user_id = 5, -- Your user ID
  api_domain = "https://mng.tuxdi.com", -- Your API domain
  projects = {},
}

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

-- Fetches the list of projects from the API and updates the config
local function update_projects_from_api()
  vim.notify("Fetching projects from API...")

  local url = string.format(
    "%s/api/v1/projects?member=%s&order_by=memberships__user_order",
    config.api_domain,
    config.user_id
  )

  local command = {
    "curl",
    "-X",
    "GET",
    "-H",
    "Content-Type: application/json",
    "-H",
    "Authorization: Bearer " .. config.auth_token,
    "-s",
    url,
  }

  vim.system(command, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify("Error fetching projects: " .. obj.stderr, vim.log.levels.ERROR)
        return
      end

      local ok, projects_data = pcall(vim.fn.json_decode, obj.stdout)
      if not ok then
        vim.notify("Error parsing projects JSON from API response.", vim.log.levels.ERROR)
        return
      end

      local new_projects = {}
      for _, project in ipairs(projects_data) do
        if project.id and project.name then
          table.insert(new_projects, { id = project.id, name = project.name })
        end
      end
      config.projects = new_projects

      vim.notify("Projects updated! Found " .. #config.projects .. " projects.", vim.log.levels.INFO)
    end)
  end)
end

-- Posts the current visual selection as a user story to the selected project
local function post_selection_to_api()
  if #config.projects == 0 then
    vim.notify("Project list is empty. Press <leader>ur to fetch projects from the API.", vim.log.levels.WARN)
    return
  end

  local selection = get_visual_selection()
  if selection == '' then
    vim.notify("No text selected.", vim.log.levels.WARN)
    return
  end

  local project_names = {}
  for _, p in ipairs(config.projects) do
    table.insert(project_names, p.name)
  end

  vim.ui.select(project_names, { prompt = "Select Project:" }, function(choice)
    if not choice then
      vim.notify("Project selection cancelled.", vim.log.levels.WARN)
      return
    end

    local project_id
    for _, p in ipairs(config.projects) do
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
    local api_endpoint = config.api_domain .. "/api/v1/userstories"

    local command = {
      "curl",
      "-X",
      "POST",
      "-H",
      "Content-Type: application/json",
      "-H",
      "Authorization: Bearer " .. config.auth_token,
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
vim.keymap.set("n", "<leader>ur", update_projects_from_api, { desc = "Update projects from API" })
