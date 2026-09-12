local M = {}
function M.run(task)
  vim.cmd("wall")
  local root = require("java.setup").root()
  if not root then return end
  -- Use the nearest module for tasks, but search parents for a wrapper.
  local module = vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts" }) or root
  local maven = vim.uv.fs_stat(module .. "/pom.xml") ~= nil
  if not maven and not vim.uv.fs_stat(module .. "/build.gradle") and not vim.uv.fs_stat(module .. "/build.gradle.kts") then
    vim.notify("No Maven/Gradle build file found", vim.log.levels.WARN)
    return
  end
  local win = vim.fn.has("win32") == 1
  local wrapper = maven and (win and "mvnw.cmd" or "mvnw") or (win and "gradlew.bat" or "gradlew")
  local found = vim.fs.find(wrapper, { path = module, upward = true })[1]
  local executable = found or (maven and "mvn" or "gradle")
  if not found and vim.fn.executable(executable) == 0 then
    vim.notify("Missing " .. executable .. " and project wrapper", vim.log.levels.ERROR)
    return
  end
  local tasks = maven and {
    build = { "package", "-DskipTests" }, test = { "test" }, boot = { "spring-boot:run" },
    debug = { "spring-boot:run", "-Dspring-boot.run.jvmArguments=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=127.0.0.1:5005" },
  } or { build = { "build", "-x", "test" }, test = { "test" }, boot = { "bootRun" }, debug = { "bootRun", "--debug-jvm" } }
  local args = tasks[task]
  if not args then return end
  local command = vim.fn.shellescape(executable)
  for _, arg in ipairs(args) do command = command .. " " .. vim.fn.shellescape(arg) end
  if vim.o.shell:lower():find("powershell") or vim.o.shell:lower():find("pwsh") then command = "& " .. command end
  require("toggleterm.terminal").Terminal:new({
    cmd = command, dir = module, direction = "horizontal", close_on_exit = false,
  }):toggle()
end
return M
