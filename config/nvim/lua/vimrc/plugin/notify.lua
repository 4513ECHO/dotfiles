vim.notify = require("notify")

require("notify").setup {
  stages = "slide",
  background_color = 'NormalFloat',
  minimum_width = 30,
  icons = {
    ERROR = "✗",
    WARN = "‼",
    INFO = "i",
    DEBUG = "B",
    TRACE = "T",
  },
}
