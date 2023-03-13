return function()
  local dap = require "dap"
  dap.configurations.typescript = {
    {
      type = "pwa-chrome",
      outFiles = {
        "${workspaceFolder}/packages/*/dist/remote-staging/*.js",
        "!**/node_modules/**",
      },
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}/packages/imdfront",
    },
  }
  dap.configurations.javascript = {
    {
      type = "pwa-chrome",
      outFiles = {
        "${workspaceFolder}/packages/*/dist/remote-staging/*.js",
        "!**/node_modules/**",
      },
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}/packages/imdfront",
    },
  }
  dap.configurations.javascriptreact = {
    {
      type = "pwa-chrome",
      outFiles = {
        "${workspaceFolder}/packages/*/dist/remote-staging/*.js",
        "!**/node_modules/**",
      },
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}/packages/imdfront",
    },
  }
  dap.configurations.typescriptreact = {
    {
      type = "pwa-chrome",
      outFiles = {
        "${workspaceFolder}/packages/*/dist/remote-staging/*.js",
        "!**/node_modules/**",
      },
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}/packages/imdfront",
    },
  }
end
