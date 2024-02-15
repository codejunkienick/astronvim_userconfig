return function()
  require("neotest").setup {
    icons = {
      expanded = "",
      child_prefix = "",
      child_indent = "",
      final_child_prefix = "",
      non_collapsible = "",
      collapsed = "",

      passed = "",
      running = "",
      failed = "",
      unknown = "",
    },
    adapters = {
      require "neotest-rust" {
        args = { "--no-capture" },
      },
      require "neotest-jest" {
        jestCommand = "yarn test",
        jestConfigFile = "jest.config.ts",
        cwd = function(path) return vim.fn.getcwd() end,
        env = { CI = true },
      },
    },
  }
end
