return {
  { "mason-org/mason.nvim", opts = {} },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "jdtls", "java-debug-adapter", "java-test", "vscode-spring-boot-tools", "lemminx", "yaml-language-server", "lua-language-server", "pyright", "ruff", "debugpy" },
      auto_update = false,
      run_on_start = true,
    },
  },
}
