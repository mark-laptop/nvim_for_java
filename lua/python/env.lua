local M = {}
local selected, fallback = {}, nil
M.markers = { "pyproject.toml", "pyrightconfig.json", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }
function M.root(buf)
  return vim.fs.root(buf or 0, M.markers)
    or vim.fs.dirname(vim.api.nvim_buf_get_name(buf or 0))
    or vim.fn.getcwd()
end
local function executable(path)
  return path and path ~= "" and vim.fn.executable(path) == 1
end
function M.in_venv(path)
  if not path or path == "" then return nil end
  local python = path .. (vim.fn.has("win32") == 1 and "/Scripts/python.exe" or "/bin/python")
  return executable(python) and python or nil
end
function M.resolve(root)
  root = root or M.root()
  if executable(selected[root]) then return selected[root] end
  for _, name in ipairs({ ".venv", "venv", "env" }) do
    local python = M.in_venv(root .. "/" .. name)
    if python then return python end
  end
  local active = M.in_venv(vim.env.VIRTUAL_ENV)
  if active then return active end
  if vim.env.CONDA_PREFIX then
    local conda = vim.env.CONDA_PREFIX .. (vim.fn.has("win32") == 1 and "/python.exe" or "/bin/python")
    if executable(conda) then return conda end
  end
  if executable(fallback) then return fallback end
  for _, name in ipairs({ "python", "python3" }) do
    local path = vim.fn.exepath(name)
    if executable(path) and not path:find("WindowsApps", 1, true) then fallback = path; return path end
  end
  local command
  if vim.fn.executable("uv") == 1 then
    command = { "uv", "python", "find", "--system", "--no-python-downloads" }
  elseif vim.fn.executable("py") == 1 then
    command = { "py", "-3", "-c", "import sys; print(sys.executable)" }
  end
  if command then
    local result = vim.system(command, { text = true }):wait(5000)
    local path = vim.trim(result.stdout or "")
    if result.code == 0 and executable(path) then fallback = path; return path end
  end
  error("Python not found. Install Python or use :PythonSelect with its executable path.")
end
function M.select()
  local root = M.root()
  local ok, current = pcall(M.resolve, root)
  vim.ui.input({ prompt = "Python executable or venv directory: ", default = ok and current or "", completion = "file" }, function(path)
    if not path or path == "" then return end
    path = vim.fn.expand(path)
    path = M.in_venv(path) or path
    if not executable(path) then vim.notify("Invalid Python executable: " .. path, vim.log.levels.ERROR); return end
    selected[root] = path
    for _, client in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
      if client.config.root_dir == root then
        client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
        client:notify("workspace/didChangeConfiguration", { settings = client.settings })
      end
    end
    vim.notify("Python: " .. path)
  end)
end
function M.show()
  local ok, path = pcall(M.resolve)
  vim.notify(tostring(path), ok and vim.log.levels.INFO or vim.log.levels.ERROR)
end
return M
