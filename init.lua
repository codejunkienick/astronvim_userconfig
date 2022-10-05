local function disable_formatting(client)
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end
local config = {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  colorscheme = "onedark",

  options = {
    opt = {
      relativenumber = false, -- sets vim.opt.relativenumber
      -- number = false,
    },
    g = {
      instant_username = "Sneaky",
      -- neomake_typescript_enabled_makers = {'eslint'},
      -- neomake_eslint_exe = 'eslint_d',
      neomake_open_list = 2,
      mapleader = " ", -- sets vim.g.mapleader
    },
  },

  plugins = {
    init = {
      { "jbyuki/instant.nvim" },
      { "sindrets/diffview.nvim" },
      { "folke/twilight.nvim" },
      { "folke/zen-mode.nvim" },
      {
        "David-Kunz/jester",
        config = function()
          require("jester").setup {
            path_to_jest_debug = "./node_modules/.bin/jest",
            path_to_jest_run = "./node_modules/.bin/jest",
          }
        end,
      },
      { "mfussenegger/nvim-dap" },
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
          }
        end,
      },
      {
        "s1n7ax/nvim-window-picker",
        tag = "v1.*",
        config = function() require("window-picker").setup() end,
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
      ["declancm/cinnamon.nvim"] = { disable = true },
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },
    },
    ["neo-tree"] = function(config)
      config.close_if_last_window = false
      return config
    end,
    ["telescope"] = function(config)
      local telescope_actions = require "telescope.actions"
      config.defaults.mappings.n["<C-q>"] = telescope_actions.close
      config.defaults.mappings.i["<C-q>"] = telescope_actions.close
      return config
    end,
    ["bufferline"] = function(config)
      config.max_name_length = 18
      config.max_prefix_length = 13
      config.tab_size = 24
      config.diagnostics = "nvim_lsp"
      config.separator_style = "thick"
      config.sort_by = "relative_directory"
      config.name_formatter = function(buf) -- buf contains:
        if buf.name:match "index" then
          return vim.fn.fnamemodify(buf.path, ":p:h:t") .. "/i." .. vim.fn.fnamemodify(buf.path, ":e")
        end
        return buf.name
      end
      config.custom_filter = function(buf, buf_nums) return not vim.fn.bufname(buf):match "node_modules" end
    end,
    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      config.sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.formatting.eslint_d,
        -- null_ls.builtins.formatting.eslint_d.with {
        --   timeout = 10000,
        --   filetypes = { "javascript", "javascriptreact", "json", "typescript", "typescriptreact", "vue" },
        -- },
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
      }
      config.on_attach = function(client)
        -- NOTE: You can remove this on attach function to disable format on save
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = function() vim.lsp.buf.formatting_sync(nil, 2000) end,
          })
        end
      end
      return config
    end,
    treesitter = {
      ensure_installed = { "lua" },
    },
    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "data" .. "/packer_compiled.lua",
    },
  },

  luasnip = {
    vscode_snippet_paths = {},
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  ["which-key"] = {
    -- Add bindings
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          j = { name = "Jest" },
        },
      },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    servers = {
      -- "pyright"
    },
    -- easily add or disable built in mappings added during LSP attaching
    mappings = {
      n = {
        -- ["<leader>lf"] = false -- disable formatting keymap
      },
    },
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      tsserver = {
        root_dir = require("lspconfig.util").find_git_ancestor,
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

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = true,
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
      -- Jest
      ["<leader>jr"] = { function() require("jester").run() end, desc = "Jest: Run nearest test under the cursor" },
      ["<leader>jR"] = {
        function() require("jester").run_debug() end,
        desc = "Jest: Debug Run nearest test under the cursor",
      },
      ["<leader>jf"] = { function() require("jester").run_file() end, desc = "Jest: Run file" },
      ["<leader>jF"] = { function() require("jester").debug_file() end, desc = "Jest: Debug Run file" },

      -- Trouble
      ["<leader>lT"] = { ":Trouble workspace_diagnostics<cr>", desc = "Open Trouble Workspace Diagnostics" },
      ["<leader>lt"] = { ":Trouble document_diagnostics<cr>", desc = "Open Trouble Document" },
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  },

  -- This function is run last
  -- good place to configuring augroups/autocommands and custom filetypes
  polish = function()
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })
  end,
}

return config
