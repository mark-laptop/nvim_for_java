vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.tabstop = 4
require("python.completion").setup(vim.api.nvim_get_current_buf())
local function map(key, fn, desc)
  vim.keymap.set("n", key, fn, { buffer = true, desc = desc })
end
map("<leader>pr", function() require("python.tasks").run("file") end, "Python: run file")
map("<leader>pm", function() require("python.tasks").module() end, "Python: run module")
map("<leader>pt", function() require("python.tasks").run("test_file") end, "Python: pytest file")
map("<leader>pT", function() require("python.tasks").run("test_all") end, "Python: pytest project")
map("<leader>pd", function() require("python.debug").tests() end, "Python: debug pytest file")
map("<leader>pi", function() require("python.tasks").run("repl") end, "Python: REPL")
map("<leader>pv", function() require("python.env").select() end, "Python: select interpreter")
map("<leader>pe", function() require("python.env").show() end, "Python: show interpreter")
map("<leader>po", function()
  vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true })
end, "Python: organize imports")
vim.api.nvim_buf_create_user_command(0, "PythonSelect", function() require("python.env").select() end, {})
vim.api.nvim_buf_create_user_command(0, "PythonInfo", function() require("python.env").show() end, {})
