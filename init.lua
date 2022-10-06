local function disable_formatting(client)
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

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
      spell = true,
      signcolumn = "auto",
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

  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  lsp = {
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

  heirline = {
    separators = {
      left = { "", " " },
      right = { " ", "" },
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
    heirline = require "user/user_configs/heirline",
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
      config.options.hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      }
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
    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      config.sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
      }

      return config
    end,
    treesitter = {
      ensure_installed = { "lua" },
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
    register_mappings = {
      n = {
        ["<leader>"] = {
          j = { name = "Jest" },
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

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
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
