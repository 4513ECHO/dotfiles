return {
  settings = {
    evenBetterToml = {
      schema = {
        associations = {
          ["/dpp/[^/]+\\.toml$"] = (
            "file://"
            .. vim.env.VIMRCDIR
            .. "/settings/dein.toml.json"
          ),
        },
      },
    },
  },
}
