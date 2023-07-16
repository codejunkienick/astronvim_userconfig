local config = {
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_reload = false, -- automatically reload and sync packer after a successful update
    auto_quit = false, -- automatically quit the current session after a successful update
  },
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
  colorscheme = "onedark",
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  lsp = {
    formatting = {
      filter = function(client)
        -- only enable null-ls for javascript files
        if
          vim.bo.filetype == "javascript"
          or vim.bo.filetype == "typescript"
          or vim.bo.filetype == "typescriptreact"
        then
          return client.name == "null-ls"
        end

        -- enable all other clients
        return true
      end,
    },
    config = require "user/configs/lsp",
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
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin", "matchparen" },
      },
    },
  },
  plugins = {
    {
      "microsoft/vscode-js-debug",
      lazy = true,
      build = "npm install --legacy-peer-deps && npm run compile",
    },
    {
      "mfussenegger/nvim-dap",
      config = require "user/configs/dap",
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "mfussenegger/nvim-dap" },
      config = require "user/configs/dap-ui",
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      config = function() require("nvim-dap-virtual-text").setup() end,
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      dependencies = { "mfussenegger/nvim-dap" },
      config = function()
        require("dap-vscode-js").setup {
          adapters = { "pwa-node", "pwa-chrome" },
        }
      end,
    },
    {
      "sindrets/diffview.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    { "folke/twilight.nvim" },
    { "folke/zen-mode.nvim" },
    {
      "nvim-neotest/neotest",
      dependencies = {
        "haydenmeade/neotest-jest",
      },
      config = require "user/configs/neotest",
    },
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
      dependencies = {
        "tpope/vim-repeat",
      },
    },
    {
      "navarasu/onedark.nvim",
      name = "onedark",
      config = function()
        require("onedark").setup {
          style = "dark",
        }
        require("onedark").load()
      end,
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      opts = function(_, config)
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
    },
    {
      "nvim-telescope/telescope.nvim",
      opts = function(_, config)
        local telescope_actions = require "telescope.actions"
        config.pickers = {
          lsp_definitions = {
            file_ignore_patterns = { "react/index.d.ts" },
          },
        }
        config.defaults.mappings.n["<C-q>"] = telescope_actions.close
        config.defaults.mappings.n["d"] = telescope_actions.delete_buffer
        config.defaults.mappings.i["<C-q>"] = telescope_actions.close
        return config
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, config)
        config.close_if_last_window = false
        return config
      end,
    },
    {
      "onsails/lspkind.nvim",
      opts = function(_, config)
        config.mode = "text_symbol"
        return config
      end,
    },
  },
  -- -- heirline = require "user/configs/heirline",
  -- -- bufferline = require "user/plugins/bufferline",
  -- treesitter = {
  --   ensure_installed = { "lua", "typescript", "tsx", "javascript" },
  --   indent = { enable = true },
  -- },
  -- luasnip = {
  --   vscode_snippet_paths = {},
  --   filetype_extend = {
  --     javascript = { "javascriptreact" },
  --   },
  -- },
  mappings = {
    -- first key is the mode
    n = {
      -- Git
      ["<leader>gd"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "View File history (Diffview)" },
      -- ["<leader>C"] = {
      --   function()
      --     require("bufferline.commands").close_in_direction "left"
      --     require("bufferline.commands").close_in_direction "right"
      --   end,
      --   desc = "Close All Except Current",
      -- },
      -- General
      s = false,
      S = false,
      L = {
        function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        desc = "Next buffer",
      },
      H = {
        function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        desc = "Previous buffer",
      },
      ["tn"] = { ":tabnew<cr>", desc = "New Tab" },
      ["tc"] = { ":tabclose<cr>", desc = "Tab Close" },
      ["tl"] = { ":tabnext<cr>", desc = "Tab Next" },
      ["th"] = { ":tabnext<cr>", desc = "Tab Previous" },
      ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
      -- Zen
      ["<leader>k"] = { function() require("zen-mode").toggle() end, desc = "Get into zen" },
      -- Neotest
      ["<leader>N"] = { name = "Neotest" },
      ["<leader>Nr"] = {
        function() require("neotest").run.run() end,
        desc = "Run Nearest Test",
      },
      ["<leader>NR"] = {
        function() require("neotest").run.run(vim.fn.expand "%") end,
        desc = "Run Test File",
      },
      ["<leader>Ns"] = {
        function() require("neotest").summary.toggle() end,
        desc = "Toggle Summary",
      },
      ["<leader>Nd"] = {
        function() require("neotest").run.run { strategy = "dap" } end,
        desc = "Debug Nearest Test",
      },
      ["<leader>ND"] = {
        function() require("neotest").run.run { vim.fn.expand "%", strategy = "dap" } end,
        desc = "Debug Test File",
      },
      -- DAP
      ["<leader>D"] = { name = "DAP UI" },
      ["<leader>Du"] = { function() require("dapui").toggle() end, desc = "DAP UI toggle" },
      ["<leader>DS"] = { function() require("dapui").float_element "stacks" end, desc = "DAP UI Stacks" },
      ["<leader>DR"] = { function() require("dapui").float_element "repl" end, desc = "DAP UI Repl" },
      ["<leader>Dt"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      ["<leader>Dr"] = { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },
      ["<leader>Di"] = { function() require("dap").step_into() end, desc = "Step Into" },
      ["<leader>Do"] = { function() require("dap").step_out() end, desc = "Step Out" },
      ["<leader>Db"] = { function() require("dap").step_back() end, desc = "Step Back" },
      ["<leader>Dc"] = { function() require("dap").continue() end, desc = "Continue" },
      -- Trouble
      ["<leader>lT"] = { ":Trouble workspace_diagnostics<cr>", desc = "Open Trouble Workspace Diagnostics" },
      ["<leader>lt"] = { ":Trouble document_diagnostics<cr>", desc = "Open Trouble Document" },
    },
  },
  polish = function()
    -- vim.keymap.del("n", "<leader>d")
    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "red", linehl = "", numhl = "" })
    require("leap").add_default_mappings()
  end,
}

return config
