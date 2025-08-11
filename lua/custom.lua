
-- Creando tarea desde vim porque puedo

-- ===================================================================
-- MOCK CONFIGURATION
-- In the next step, we will load this from a file.
-- ===================================================================
local config = {
  auth_token = "COMPLETAR_TOKEN",
  projects = {
    { id = 6, name = "Infraestructura Tuxdi" },
    { id = 18, name = "Novathena Legacy" },
    { id = 20, name = "CAF Access" },
  },
  api_endpoint = "https://mng.tuxdi.com/api/v1/userstories",
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

local function post_selection_to_api()
  -- 1. Get visually selected text
  local selection = get_visual_selection()
  if selection == '' then
    vim.notify("No text selected.", vim.log.levels.WARN)
    return
  end

  -- 2. Prepare project list for the UI prompt
  local project_names = {}
  for _, p in ipairs(config.projects) do
    table.insert(project_names, p.name)
  end

  -- 3. Ask the user to select a project
  vim.ui.select(project_names, { prompt = "Select Project:" }, function(choice)
    if not choice then
      vim.notify("Project selection cancelled.", vim.log.levels.WARN)
      return
    end

    -- Find the chosen project's ID
    local project_id
    for _, p in ipairs(config.projects) do
      if p.name == choice then
        project_id = p.id
        break
      end
    end

    -- 4. Prepare and send the API request
    local payload = {
      project = project_id,
      subject = selection,
    }
    local json_payload = vim.fn.json_encode(payload)

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
      config.api_endpoint,
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
-- KEYMAP
-- ===================================================================
vim.keymap.set({ "v", "x" }, "<leader>u", post_selection_to_api, { desc = "Post selection as User Story" })
