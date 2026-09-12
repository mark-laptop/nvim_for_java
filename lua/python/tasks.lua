local M = {}
function M.run(kind)
  vim.cmd("wall")
  local env = require("python.env")
  local root, file = env.root(), vim.api.nvim_buf_get_name(0)
  local ok, python = pcall(env.resolve, root)
  if not ok then vim.notify(python, vim.log.levels.ERROR); return end
  local args = { python }
  if kind == "file" then
    vim.list_extend(args, { "-u", file })
  elseif kind == "repl" then
    table.insert(args, "-i")
  elseif kind == "test_file" then
    vim.list_extend(args, { "-m", "pytest", "-v", file })
  elseif kind == "test_all" then
    vim.list_extend(args, { "-m", "pytest", "-v" })
  else
    return
  end
  -- A list avoids shell quoting problems for interpreter/project paths.
  vim.cmd("botright 12split")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  local job = vim.fn.jobstart(args, {
    term = true, cwd = root,
    on_exit = function(_, code)
      vim.schedule(function()
        vim.notify("Python task finished: exit " .. code, code == 0 and vim.log.levels.INFO or vim.log.levels.WARN)
      end)
    end,
  })
  if job <= 0 then vim.notify("Unable to start Python", vim.log.levels.ERROR); return end
  vim.cmd("startinsert")
  return job, buf
end
function M.module()
  local root = require("python.env").root()
  vim.ui.input({ prompt = "Python module (e.g. package.main): " }, function(name)
    if not name or name == "" then return end
    vim.cmd("wall")
    require("dap").run({
      type = "python", request = "launch", name = "Run module " .. name,
      module = name, pythonPath = require("python.env").resolve(root),
      cwd = root, console = "integratedTerminal", noDebug = true,
    })
  end)
end
return M
