return {
  settings = {
    deno = {
      enable = true,
      lint = true,
      suggest = {
        autoImports = false,
      },
      unstable = true,
    },
  },
  root_markers = { "deno.json", "deno.jsonc", "denops" },
}
