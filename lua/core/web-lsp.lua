local M = {}
function M.setup()
  vim.filetype.add({
    filename = {
      ["compose.yml"] = "yaml.docker-compose",
      ["compose.yaml"] = "yaml.docker-compose",
      ["docker-compose.yml"] = "yaml.docker-compose",
      ["docker-compose.yaml"] = "yaml.docker-compose",
      ["Dockerfile"] = "dockerfile",
      ["Containerfile"] = "dockerfile",
    },
    pattern = {
      ["compose%..*%.ya?ml"] = "yaml.docker-compose",
      ["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
      ["Dockerfile%..*"] = "dockerfile",
      ["Containerfile%..*"] = "dockerfile",
    },
  })
  vim.lsp.config("html", {
    settings = { html = { suggest = { html5 = true }, format = { enable = true } } },
  })
  vim.lsp.config("marksman", { root_markers = { ".marksman.toml", ".git" } })
  vim.lsp.config("docker_compose_language_service", {
    root_markers = { "compose.yml", "compose.yaml", "docker-compose.yml", "docker-compose.yaml", ".git" },
  })
  vim.lsp.config("yamlls", {
    -- Compose has its own server: avoid duplicate completions and formatters.
    filetypes = { "yaml", "yaml.gitlab", "yaml.helm-values" },
    settings = {
      yaml = {
        validate = true, completion = true, hover = true,
        format = { enable = true },
        schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
      },
    },
  })
end
return M
