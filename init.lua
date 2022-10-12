local function disable_formatting(client)
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

local function filter(arr, fn)
  if type(arr) ~= "table" then return arr end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then table.insert(filtered, v) end
  end

  return filtered
end

local function filterReactDTS(value) return string.match(value.targetUri, "react/index.d.ts") == nil end

local config = {
  updater = {
    channel = "nightly",
    branch = "nightly",
    auto_reload = false,
    auto_quit = false,
  },

  colorscheme = "onedark",

  options = {
    opt = {
      spell = false,
      signcolumn = "number",
      relativenumber = false,
    },
    g = {
      cmp_enabled = true,
      autopairs_enabled = true,
      diagnostics_enabled = true,
      status_diagnostics_enabled = true,
      instant_username = "Sneaky",
      neomake_open_list = 2,
      mapleader = " ",
    },
  },

  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  --
  -- cmp = {
  --   source_priority = {
  --     nvim_lsp = 1000,
  --     luasnip = 750,
  --     buffer = 500,
  --     path = 250,
  --   },
  -- },

  lsp = {
    ["server-settings"] = {
      tsserver = {
        root_dir = require("lspconfig.util").find_git_ancestor,
        handlers = {
          ["textDocument/definition"] = function(err, result, method, ...)
            if vim.tbl_islist(result) and #result > 1 then
              local filtered_result = filter(result, filterReactDTS)
              return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
            end

            vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
          end,
        },
      },
      eslint = {
        on_attach = disable_formatting,
        settings = {
          workingDirectories = {
            { mode = "location" },
          },
        },
        root_dir = require("lspconfig.util").find_git_ancestor,
      },
    },
  },

  heirline = {
    separators = {
      left = { "", " " },
      right = { "  ", "" },
    },
    -- add new colors that can be used by heirline
    colors = {
      blank_bg = "#5c6370",
      file_info_bg = "#3e4452",
      nav_icon_bg = "#89b06d",
      folder_icon_bg = "#ec5f67",
    },
  },

  plugins = {
    init = {
      {
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npm run compile",
      },
      {
        "mfussenegger/nvim-dap",
        config = function()
          local dap = require "dap"
          -- dap.configurations.javascriptreact = {
          --   {
          --     type = "pwa-chrome",
          --     request = "attach",
          --     program = "${file}",
          --     cwd = vim.fn.getcwd(),
          --     sourceMaps = true,
          --     protocol = "inspector",
          --     port = 9222,
          --     webRoot = "${workspaceFolder}",
          --   },
          -- }
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
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = function()
          require("dapui").setup {
            layouts = {
              {
                elements = {
                  -- Elements can be strings or table with id and size keys.
                  { id = "scopes", size = 0.5 },
                  "breakpoints",
                  "stacks",
                },
                size = 50, -- 40 columns
                position = "left",
              },
              {
                elements = {
                  "console",
                },
                size = 0.15, -- 25% of total lines
                position = "bottom",
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
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function() require("nvim-dap-virtual-text").setup() end,
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        requires = { "mfussenegger/nvim-dap" },
        config = function()
          require("dap-vscode-js").setup {
            -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
            -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
            -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
          }
        end,
      },
      { "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" },
      { "jbyuki/instant.nvim" },
      { "sindrets/diffview.nvim" },
      { "folke/twilight.nvim" },
      { "folke/zen-mode.nvim" },
      {
        "nvim-neotest/neotest",
        requires = {
          "haydenmeade/neotest-jest",
        },
        config = function()
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
              require "neotest-jest" {
                jestCommand = "yarn test --maxWorkers=50% ",
                jestConfigFile = "jest.config.ts",
                env = { CI = true },
              },
            },
          }
        end,
      },
      { "neomake/neomake" },
      {
        "kevinhwang91/nvim-bqf",
        config = function()
          require("bqf").setup {
            auto_enable = true,
            auto_resize_height = true, -- highly recommended enable
          }
        end,
      },

      {
        "folke/trouble.nvim",
        config = function() require("trouble").setup {} end,
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
      },
      {
        "beauwilliams/focus.nvim",
        config = function()
          require("focus").setup {
            excluded_filetypes = { "toggleterm" },
            excluded_buftypes = { "nofile", "prompt", "popup", "quickfix" },
            treewidth = 40,
            width = 100,
            signcolumn = false,
          }
        end,
      },
      {
        "ggandor/lightspeed.nvim",
      },
      {
        "navarasu/onedark.nvim",
        as = "onedark",
        config = function()
          require("onedark").setup {
            style = "dark",
          }
          require("onedark").load()
        end,
      },
    },
    lspkind = function(config)
      config.mode = "text_symbol"
      return config
    end,
    heirline = require "user/user_configs/heirline",
    telescope = function(config)
      local telescope_actions = require "telescope.actions"
      config.defaults.mappings.n["<C-q>"] = telescope_actions.close
      config.defaults.mappings.i["<C-q>"] = telescope_actions.close
      return config
    end,
    bufferline = function(config)
      config.options.max_name_length = 18
      config.options.max_prefix_length = 13
      config.options.tab_size = 24
      config.options.diagnostics = "nvim_lsp"
      config.options.separator_style = "thick"
      config.options.sort_by = "relative_directory"
      config.options.name_formatter = function(buf)
        if buf.name:match "index" then
          return vim.fn.fnamemodify(buf.path, ":p:h:t") .. "/." .. vim.fn.fnamemodify(buf.path, ":e")
        end
        return buf.name
      end
      config.options.custom_filter = function(buf) return not vim.fn.bufname(buf):match "node_modules" end
      return config
    end,
    treesitter = {
      ensure_installed = { "lua", "typescript", "tsx", "javascript" },
      indent = { enable = true },
    },
    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      config.sources = {
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
      }

      return config
    end,
    ["neo-tree"] = function(config)
      config.close_if_last_window = false
      return config
    end,
  },

  luasnip = {
    vscode_snippet_paths = {},
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  ["which-key"] = {
    register_mappings = {
      n = {
        ["<leader>"] = {
          n = { name = "Neotest" },
          d = { name = "DAP" },
        },
      },
    },
  },

  mappings = {
    -- first key is the mode
    n = {
      -- Git
      ["<leader>gd"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "View File history (Diffview)" },

      -- General
      ["tn"] = { ":tabnew<cr>", desc = "New Tab" },
      ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
      -- Zen
      ["<leader>k"] = { function() require("zen-mode").toggle() end, desc = "Get into zen" },
      -- Neotest
      ["<leader>nr"] = {
        function() require("neotest").run.run() end,
        desc = "Run Nearest Test",
      },
      ["<leader>nR"] = {
        function() require("neotest").run.run(vim.fn.expand "%") end,
        desc = "Run Test File",
      },
      ["<leader>ns"] = {
        function() require("neotest").summary.toggle() end,
        desc = "Toggle Summary",
      },
      ["<leader>nd"] = {
        function() require("neotest").run.run { strategy = "dap" } end,
        desc = "Debug Nearest Test",
      },
      ["<leader>nD"] = {
        function() require("neotest").run.run { vim.fn.expand "%", strategy = "dap" } end,
        desc = "Debug Test File",
      },

      -- DAP
      ["<leader>dU"] = { function() require("dapui").toggle() end, desc = "DAP UI toggle" },
      ["<leader>dt"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      ["<leader>dR"] = { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },
      ["<leader>di"] = { function() require("dap").step_into() end, desc = "Step Into" },
      ["<leader>do"] = { function() require("dap").step_out() end, desc = "Step Out" },
      ["<leader>db"] = { function() require("dap").step_back() end, desc = "Step Back" },
      ["<leader>dc"] = { function() require("dap").continue() end, desc = "Continue" },

      -- Trouble
      ["<leader>lT"] = { ":Trouble workspace_diagnostics<cr>", desc = "Open Trouble Workspace Diagnostics" },
      ["<leader>lt"] = { ":Trouble document_diagnostics<cr>", desc = "Open Trouble Document" },
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    vim.keymap.del("n", "<leader>d")
    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "red", linehl = "", numhl = "" })
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
