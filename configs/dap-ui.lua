return function()
  require("dapui").setup {
    layouts = {
      {
        elements = {
          -- Elements can be strings or table with id and size keys.
          { id = "scopes", size = 0.5 },
          "watches",
          "breakpoints",
          "console",
        },
        size = 50, -- 40 columns
        position = "right",
      },
      {
        elements = {
          "repl",
        },
        size = 0.05, -- 25% of total lines
        position = "bottom",
      },
    },
  }
end
