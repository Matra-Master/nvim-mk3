
-- Creando tarea desde vim porque puedo

---@diagnostic disable-next-line: missing-fields
local function get_visual_selection()
  local old_reg = vim.fn.getreg('"')
  local old_reg_type = vim.fn.getregtype('"')
  vim.cmd('noautocmd silent! normal! "vy"')
  local selection = vim.fn.getreg('"')
  vim.fn.setreg('"', old_reg, old_reg_type)
  return selection
end

local function post_selection_to_api()
  local api_endpoint = "https://mng.tuxdi.com/api/v1/userstories"
  local auth_token = os.getenv("AUTH_TOKEN")

  if not auth_token then
    vim.notify("AUTH_TOKEN environment variable not set.", vim.log.levels.ERROR)
    return
  end

  local selection = get_visual_selection()
  if selection == '' then
    vim.notify("No text selected.", vim.log.levels.WARN)
    return
  end

  local payload = {
    project = 6,
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
    "Authorization: Bearer " .. auth_token,
    "-d",
    json_payload,
    "-s",
    api_endpoint,
  }

  vim.notify("Sending user story to API...")
  vim.system(command, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify("Error sending request: " .. obj.stderr, vim.log.levels.ERROR)
      else
        vim.notify("User story sent successfully!")
      end
    end)
  end)
end

vim.keymap.set({ "v", "x" }, "<leader>u", post_selection_to_api, { desc = "Post selection as User Story" })
