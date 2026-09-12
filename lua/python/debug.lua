local M = {}
function M.setup()
  local dap, env = require("dap"), require("python.env")
  dap.adapters.python = function(callback, config)
    if config.request == "attach" then
      callback({ type = "server", host = (config.connect or {}).host or "127.0.0.1", port = (config.connect or {}).port or 5678 })
      return
    end
    local python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/"
      .. (vim.fn.has("win32") == 1 and "Scripts/python.exe" or "bin/python")
    if vim.fn.executable(python) == 0 then
      vim.notify("debugpy is missing. Run :MasonToolsInstall", vim.log.levels.ERROR)
      return
    end
    -- TCP avoids the Windows venv launcher exiting with code 1 when the
    -- stdio adapter pipe is closed by nvim-dap at the end of a session.
    callback({ type = "server", host = "127.0.0.1", port = "${port}",
      executable = { command = python,
        args = { "-m", "debugpy.adapter", "--host", "127.0.0.1", "--port", "${port}" },
        detached = false },
      options = { source_filetype = "python" } })
  end
  dap.adapters.debugpy = dap.adapters.python
  local function config(name, fields)
    return vim.tbl_extend("force", {
      type = "python", request = "launch", name = name,
      pythonPath = function() return env.resolve() end,
      cwd = function() return env.root() end,
      console = "integratedTerminal", justMyCode = true,
    }, fields)
  end
  dap.configurations.python = {
    config("Python: current file", { program = "${file}" }),
    config("Python: module", { module = function()
      local name = vim.fn.input("Module: ")
      return name ~= "" and name or dap.ABORT
    end }),
    config("Python: pytest current file", { module = "pytest", args = { "-v", "${file}" } }),
    config("Python: pytest project", { module = "pytest", args = { "-v" } }),
    { type = "python", request = "attach", name = "Python: attach localhost:5678",
      connect = { host = "127.0.0.1", port = 5678 }, justMyCode = true },
  }
end
function M.tests()
  vim.cmd("wall")
  local env = require("python.env")
  require("dap").run({
    type = "python", request = "launch", name = "Debug pytest file",
    module = "pytest", args = { "-v", vim.api.nvim_buf_get_name(0) },
    pythonPath = env.resolve(), cwd = env.root(), console = "integratedTerminal", justMyCode = true,
  })
end
return M
