return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "mason-org/mason.nvim" },
    config = function()
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
      vim.lsp.config("lua_ls", { settings = { Lua = {
        runtime = { version = "LuaJIT" },
        workspace = { library = { vim.env.VIMRUNTIME } },
      } } })
      local python = require("python.env")
      vim.lsp.config("pyright", {
        root_markers = python.markers,
        before_init = function(_, config)
          local ok, path = pcall(python.resolve, config.root_dir)
          if ok then config.settings.python.pythonPath = path end
        end,
        settings = {
          pyright = { disableOrganizeImports = true },
          python = { analysis = {
            typeCheckingMode = "basic", autoImportCompletions = true,
            autoSearchPaths = true, useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          } },
        },
      })
      vim.lsp.config("ruff", {
        root_markers = python.markers,
        on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      })
      require("core.web-lsp").setup()
      vim.lsp.enable({ "lua_ls", "lemminx", "yamlls", "pyright", "ruff",
        "html", "marksman", "dockerls", "docker_compose_language_service" })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspMappings", { clear = true }),
        callback = function(event)
          local function map(key, action, desc)
            vim.keymap.set("n", key, action, { buffer = event.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("gr", require("telescope.builtin").lsp_references, "Find references")
          map("K", vim.lsp.buf.hover, "Documentation")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code actions")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>cl", vim.diagnostic.setqflist, "Project diagnostics")
          map("<leader>fs", require("telescope.builtin").lsp_document_symbols, "Document symbols")
          map("<leader>fS", require("telescope.builtin").lsp_workspace_symbols, "Workspace / Spring symbols")
        end,
      })
    end,
  },
}
