local deno_as_npm = require("vimrc.plugins.lsp.util").deno_as_npm

return {
  cmd = deno_as_npm { "npm:yaml-language-server@1.17.0", "--stdio" },
  cmd_env = deno_as_npm.cmd_env,
  settings = {
    yaml = {
      completion = true,
      hover = true,
      validate = true,
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas {
        extra = {
          {
            description = "efm-langserver config",
            fileMatch = "/efm-langserver/config.yaml",
            name = "efm-langserver",
            url = "https://mattn.github.io/efm-langserver/schema.json",
          },
          {
            description = "aqua.yaml",
            fileMatch = "/aqua/aqua.yaml",
            name = "aqua.yaml",
            url = "https://pax.deno.dev/aquaproj/aqua@v2.48.1/json-schema/aqua-yaml.json",
          },
          {
            description = "aqua-registry",
            fileMatch = {
              "/aqua-registry/pkgs/**/registry.yaml",
              "/aqua-registry/registry.yaml",
              "/aqua/experimental.yaml",
              "/aqua/registry.yaml",
            },
            name = "aqua-registry",
            url = "https://pax.deno.dev/aquaproj/aqua@v2.48.1/json-schema/registry.json",
          },
        },
      },
    },
  },
}
