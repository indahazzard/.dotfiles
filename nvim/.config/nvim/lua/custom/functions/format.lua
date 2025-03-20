local F = {}

local function format()
  local filepath = vim.api.nvim_buf_get_name(0)
  local extension = filepath:match("^.+(%..+)$")

  local notificationTemplate = function ( formatter )
      vim.notify("Formatted - "..filepath .. ' with '..formatter, vim.log.levels.INFO, {title = 'Formatter', timeout = 1000})
  end

  local command = nil

  if extension == ".php" then
      command = "/Users/mykyta.v.dotsenko/.composer/vendor/bin/phpcbf --standard="..vim.loop.cwd().."/phpcs.xml "..filepath
      notificationTemplate('phpcbf')
  end

  if (command ~= nil) then
      vim.fn.system(command)
      vim.cmd("edit!")
  else
      vim.notify('No formatting tool found for - ' .. extension)
  end
end

F.format = format

return F
