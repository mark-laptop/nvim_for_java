return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
  },
  {
    "JavaHello/spring-boot.nvim",
    lazy = true,
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-jdtls" },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, ui = require("dap"), require("dapui")
      ui.setup()
      dap.listeners.after.event_initialized.java_ui = function() ui.open() end
      dap.configurations.java = {
        { type = "java", request = "attach", name = "Attach localhost:5005", hostName = "127.0.0.1", port = 5005 },
      }
      local function map(key, action, desc)
        vim.keymap.set("n", key, action, { desc = desc })
      end
      map("<F5>", dap.continue, "Debug: start / continue")
      map("<F10>", dap.step_over, "Debug: step over")
      map("<F11>", dap.step_into, "Debug: step into")
      map("<F12>", dap.step_out, "Debug: step out")
      map("<leader>db", dap.toggle_breakpoint, "Debug: breakpoint")
      map("<leader>dB", function()
        vim.ui.input({ prompt = "Breakpoint condition: " }, function(value)
          if value and value ~= "" then dap.set_breakpoint(value) end
        end)
      end, "Debug: conditional breakpoint")
      map("<leader>du", ui.toggle, "Debug: UI")
      map("<leader>de", ui.eval, "Debug: evaluate expression")
      map("<leader>dq", dap.terminate, "Debug: terminate")
      map("<leader>dr", dap.repl.toggle, "Debug: console")
    end,
  },
}
