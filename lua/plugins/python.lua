return {
  {
    "mfussenegger/nvim-dap",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("PythonDebugger", { clear = true }),
        pattern = "python", once = true,
        callback = function() require("python.debug").setup() end,
      })
    end,
  },
}
