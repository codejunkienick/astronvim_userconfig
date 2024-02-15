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
      rustaceanvim = {},
      -- mapleader = " ",
    },
  },
  colorscheme = "onedark",
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  lsp = {
    setup_handlers = {
      -- add custom handler
      rust_analyzer = function(_, opts)
        opts.checkOnSave = {
          command = "clippy",
        }
        require("rust-tools").setup {

          server = opts,
        }
      end,
    },
    -- setup_handlers = {
    --   rust_analyzer = function(_, opts)
    --     opts.checkOnSave = {
    --       command = "clippy",
    --     }
    --     return opts
    --   end,
    -- },
    timeout_ms = 5000,
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
    automatic_installation = { exclude = { "rust_analyzer", "solargraph" } },
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
    "simrat39/rust-tools.nvim",
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "rust_analyzer" },
        automatic_installation = { exclude = { "rust_analyzer" } },
      },
    },
    {
      "jcdickinson/codeium.nvim",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
      },
      config = function() require("codeium").setup {} end,
    },
    -- {
    --   "mrcjkb/rustaceanvim",
    --   lazy = false,
    --   version = "^4", -- Recommended
    --   ft = { "rust" },
    -- },
    { -- override nvim-cmp plugin
      "hrsh7th/nvim-cmp",
      -- override the options table that is used in the `require("cmp").setup()` call
      commit = "c4e491a87eeacf0408902c32f031d802c7eafce8",
      opts = function(_, opts)
        -- opts parameter is the default options table
        -- the function is lazy loaded so cmp is able to be required
        opts.sources = {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          {
            name = "codeium",
            priority = 600,
          },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }
        opts.formatting = {
          format = require("lspkind").cmp_format {
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { Codeium = "" },
          },
        }

        -- return the new table to be used
        return opts
      end,
    },
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
        "rouge8/neotest-rust",
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
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
    },
    {
      "nvim-focus/focus.nvim",
      lazy = false,
      config = function()
        require("focus").setup {
          enable = true,
          commads = true,
        }
      end,
      {
        "Lilja/zellij.nvim",
        lazy = false,
        config = function()
          require("zellij").setup {
            replaceVimWindowNavigationKeybinds = true,
          }
        end,
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
            null_ls.builtins.formatting.prettierd,
            -- null_ls.builtins.formatting.eslint_d,
            null_ls.builtins.diagnostics.eslint_d,
            null_ls.builtins.code_actions.eslint_d,
            null_ls.builtins.diagnostics.markdownlint,
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
    {
      "ggandor/leap.nvim",
      lazy = false,
      dependencies = {
        "tpope/vim-repeat",
      },
    },
    {
      "epwalsh/obsidian.nvim",
      version = "*", -- recommended, use latest release instead of latest commit
      lazy = true,
      ft = "markdown",
      -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
      -- event = {
      --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      --   "BufReadPre path/to/my-vault/**.md",
      --   "BufNewFile path/to/my-vault/**.md",
      -- },
      dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",

        -- see below for full list of optional dependencies 👇
      },
      opts = {
        workspaces = {
          {
            name = "personal",
            path = "~/vaults/personal",
          },
          {
            name = "work",
            path = "~/vaults/work",
          },
        },

        -- see below for full list of options 👇
      },
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

    local ignore_filetypes = { "neo-tree" }
    local ignore_buftypes = { "nofile", "prompt", "popup" }

    local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

    vim.api.nvim_create_autocmd("WinEnter", {
      group = augroup,
      callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
          vim.w.focus_disable = true
        else
          vim.w.focus_disable = false
        end
      end,
      desc = "Disable focus autoresize for BufType",
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
          vim.b.focus_disable = true
        else
          vim.b.focus_disable = false
        end
      end,
      desc = "Disable focus autoresize for FileType",
    })
  end,
}

return config
