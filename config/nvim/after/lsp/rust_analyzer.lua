return {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      completion = {
        callable = { snippets = "add_parentheses" },
        hideDeprecated = true,
      },
      hover = {
        documentation = {
          keywords = { enable = false },
        },
      },
    },
  },
}
