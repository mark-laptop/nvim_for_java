local M = {}

function M.setup(buf)
  local function signature()
    if #vim.lsp.get_clients({ bufnr = buf, method = "textDocument/signatureHelp" }) > 0 then
      vim.lsp.buf.signature_help({ border = "rounded", focusable = false, silent = true })
    end
  end
  vim.keymap.set({ "i", "n" }, "<C-k>", signature,
    { buffer = buf, desc = "Python: function parameters" })

  -- Wait for the inserted trigger to reach both the buffer and the server.
  local group = vim.api.nvim_create_augroup("PythonSignature" .. buf, { clear = true })
  vim.api.nvim_create_autocmd("InsertCharPre", {
    group = group, buffer = buf,
    callback = function()
      if vim.v.char ~= "(" and vim.v.char ~= "," then return end
      vim.defer_fn(function()
        if vim.api.nvim_get_current_buf() == buf and vim.api.nvim_get_mode().mode == "i" then
          signature()
        end
      end, 100)
    end,
  })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group, buffer = buf,
    callback = function(event)
      local namespace = vim.lsp.diagnostic.get_namespace(event.data.client_id)
      vim.diagnostic.config({
        virtual_text = { spacing = 2, source = "if_many" },
        underline = true, severity_sort = true,
        float = { border = "rounded", source = true },
      }, namespace)
    end,
  })
end

return M
