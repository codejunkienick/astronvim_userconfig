local config = {
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_reload = false, -- automatically reload and sync packer after a successful update
    auto_quit = false, -- automatically quit the current session after a successful update
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
      -- mapleader = " ",
    },
  },

  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    ["server-settings"] = require "user/configs/lsp",
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
        config = require "user/plugins/dap",
      },
      {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = require "user/plugins/dap-ui",
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
            adapters = { "pwa-node", "pwa-chrome" },
          }
        end,
      },
      -- { "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" },
      -- { "jbyuki/instant.nvim" },
      { "sindrets/diffview.nvim" },
      { "folke/twilight.nvim" },
      { "folke/zen-mode.nvim" },
      {
        "nvim-neotest/neotest",
        requires = {
          "haydenmeade/neotest-jest",
        },
        config = require "user/plugins/neotest",
      },
      -- { "neomake/neomake" },
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
        "ggandor/leap.nvim",
        config = function() require("leap").add_default_mappings() end,
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
    heirline = require "user/plugins/heirline",
    telescope = function(config)
      local telescope_actions = require "telescope.actions"
      config.defaults.mappings.n["<C-q>"] = telescope_actions.close
      config.defaults.mappings.n["d"] = telescope_actions.delete_buffer
      config.defaults.mappings.i["<C-q>"] = telescope_actions.close
      return config
    end,
    bufferline = require "user/plugins/bufferline",
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
    register = {
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
      ["<leader>C"] = {
        function()
          require("bufferline.commands").close_in_direction "left"
          require("bufferline.commands").close_in_direction "right"
        end,
        desc = "Close All Except Current",
      },

      -- General
      ["tn"] = { ":tabnew<cr>", desc = "New Tab" },
      ["tc"] = { ":tabclose<cr>", desc = "Tab Close" },
      ["tl"] = { ":tabnext<cr>", desc = "Tab Next" },
      ["th"] = { ":tabnext<cr>", desc = "Tab Previous" },
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
      ["<leader>du"] = { function() require("dapui").toggle() end, desc = "DAP UI toggle" },
      ["<leader>dS"] = { function() require("dapui").float_element "stacks" end, desc = "DAP UI Stacks" },
      ["<leader>dR"] = { function() require("dapui").float_element "repl" end, desc = "DAP UI Repl" },
      ["<leader>dt"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      ["<leader>dr"] = { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },
      ["<leader>di"] = { function() require("dap").step_into() end, desc = "Step Into" },
      ["<leader>do"] = { function() require("dap").step_out() end, desc = "Step Out" },
      ["<leader>db"] = { function() require("dap").step_back() end, desc = "Step Back" },
      ["<leader>dc"] = { function() require("dap").continue() end, desc = "Continue" },

      -- Trouble
      ["<leader>lT"] = { ":Trouble workspace_diagnostics<cr>", desc = "Open Trouble Workspace Diagnostics" },
      ["<leader>lt"] = { ":Trouble document_diagnostics<cr>", desc = "Open Trouble Document" },
    },
  },

  polish = function()
    vim.keymap.del("n", "<leader>d")
    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "red", linehl = "", numhl = "" })
  end,
}

return config
