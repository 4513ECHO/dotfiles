return {
  settings = {
    pylsp = {
      configurationSources = { "flake8" },
      plugins = {
        black = { enabled = true },
        flake8 = { enabled = true },
        meccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        pyls_isort = { enabled = true },
        pylsp_mypy = {
          enabled = true,
          overrides = { "--no-pretty", true },
          report_progress = true,
        },
      },
    },
  },
}

