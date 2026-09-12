local M = {}
local function exists(path) return vim.uv.fs_stat(path) ~= nil end

function M.root()
  return vim.fs.root(0, { "mvnw", "mvnw.cmd", "gradlew", "gradlew.bat", "settings.gradle", "settings.gradle.kts" })
    or vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
    or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
end

function M.java()
  local home = vim.env.JDTLS_JAVA_HOME or vim.env.JAVA_HOME
  return home and (home .. "/bin/java" .. (vim.fn.has("win32") == 1 and ".exe" or "")) or "java"
end

function M.spring()
  local root = M.root()
  if not root or not (vim.fs.find({ "pom.xml", "build.gradle", "build.gradle.kts" }, { path = root, upward = true })[1]) then return end
  local spring = require("spring_boot")
  -- The current Spring distribution uses a sibling lib/ directory. Mason's
  -- share link alone loses that relative classpath on Windows.
  local jar = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/vscode-spring-boot-tools/extension/language-server/*-exec.jar", false, true)[1]
    or spring.get_boot_ls()
  if not jar then return end
  local opts = {
    ls_path = jar, java_cmd = M.java(), autocmd = false,
    log_file = vim.fn.stdpath("log") .. "/spring-boot.log",
    server = { root_dir = root, capabilities = require("cmp_nvim_lsp").default_capabilities() },
  }
  -- Build a fresh config per project; the upstream autocmd captures the first root.
  opts.exploded_ls_jar_data = vim.fn.isdirectory(jar .. "/BOOT-INF") == 1
  spring.init_lsp_commands()
  local launch = require("spring_boot.launch")
  launch.start(launch.update_ls_config(opts))
end

function M.start()
  local root = M.root()
  if not root or root == "" then return end
  local base = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local launcher = vim.fn.glob(base .. "/plugins/org.eclipse.equinox.launcher_*.jar", false, true)[1]
  if not launcher then
    vim.notify("Java tools are not installed yet. Run :MasonToolsInstall, then reopen Neovim.", vim.log.levels.WARN)
    return
  end
  local jdtls = require("jdtls")
  local state = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(vim.fs.normalize(root)):sub(1, 16)
  vim.fn.mkdir(state, "p")
  local platform = vim.fn.has("win32") == 1 and "win" or (vim.fn.has("mac") == 1 and "mac" or "linux")
  local cmd = {
    M.java(), "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4", "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Xmx2g", "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  }
  if exists(base .. "/lombok.jar") then table.insert(cmd, "-javaagent:" .. base .. "/lombok.jar") end
  vim.list_extend(cmd, { "-jar", launcher, "-configuration", base .. "/config_" .. platform,
    "-data", state .. "/workspace" })
  local packages = vim.fn.stdpath("data") .. "/mason/packages/"
  local bundles = vim.fn.glob(packages .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", false, true)
  for _, jar in ipairs(vim.fn.glob(packages .. "java-test/extension/server/*.jar", false, true)) do
    local name = vim.fs.basename(jar)
    local already_in_jdtls = vim.fn.glob(base .. "/plugins/" .. name, false, true)[1]
    if not already_in_jdtls and name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and name ~= "jacocoagent.jar" then
      table.insert(bundles, jar)
    end
  end
  vim.list_extend(bundles, require("spring_boot").java_extensions())
  local runtimes = {}
  for _, version in ipairs({ 8, 11, 17, 21, 25 }) do
    local home = vim.env["JAVA" .. version .. "_HOME"]
    if home then table.insert(runtimes, { name = version == 8 and "JavaSE-1.8" or "JavaSE-" .. version, path = home }) end
  end
  jdtls.start_or_attach({
    cmd = cmd, root_dir = root,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    init_options = { bundles = bundles },
    settings = { java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      configuration = { updateBuildConfiguration = "interactive", runtimes = runtimes },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      codeGeneration = { useBlocks = true },
    } },
    on_attach = function(_, bufnr)
      jdtls.setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()
      local function map(mode, key, action, desc)
        vim.keymap.set(mode, key, action, { buffer = bufnr, desc = desc })
      end
      map("n", "<leader>jo", jdtls.organize_imports, "Java: organize imports")
      map("n", "<leader>jt", function() jdtls.test_nearest_method({ config_overrides = { noDebug = true } }) end, "Java: test method")
      map("n", "<leader>jT", function() jdtls.test_class({ config_overrides = { noDebug = true } }) end, "Java: test class")
      map("n", "<leader>dt", jdtls.test_nearest_method, "Debug: test method")
      map("n", "<leader>dT", jdtls.test_class, "Debug: test class")
      map("n", "<leader>jr", function()
        local dap = require("dap")
        local configs = vim.tbl_filter(function(config) return config.request == "launch" end, dap.configurations.java or {})
        if #configs == 0 then
          vim.notify("Main classes are still loading. Try again after Java indexing finishes.")
          require("jdtls.dap").setup_dap_main_class_configs()
          return
        end
        vim.ui.select(configs, { prompt = "Run Java main:", format_item = function(c) return c.name end }, function(config)
          if config then dap.run(vim.tbl_extend("force", config, { noDebug = true })) end
        end)
      end, "Java: run main")
      map("n", "<leader>ju", jdtls.update_project_config, "Java: reload build configuration")
      map("x", "<leader>jv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Java: extract variable")
      map("x", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Java: extract method")
    end,
  })
  M.spring()
end
return M
