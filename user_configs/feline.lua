local one_monokai = {
  fg = "#abb2bf",
  bg = "#2c323c",
  green = "#98c379",
  yellow = "#e5c07b",
  purple = "#c678dd",
  orange = "#d19a66",
  peanut = "#f6d5a4",
  red = "#e06c75",
  aqua = "#61afef",
  darkblue = "#282c34",
  dark_red = "#f75f5f",
}

local vi_mode_colors = {
  NORMAL = "green",
  OP = "green",
  INSERT = "yellow",
  VISUAL = "purple",
  LINES = "orange",
  BLOCK = "dark_red",
  REPLACE = "red",
}

local function reverse(tbl)
  for i = 1, math.floor(#tbl / 2) do
    local j = #tbl - i + 1
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
end

local function get_tail(filename) return vim.fn.fnamemodify(filename, ":t") end

local function split_filename(filename)
  local nodes = {}
  for parent in string.gmatch(filename, "[^/]+/") do
    table.insert(nodes, parent)
  end
  table.insert(nodes, get_tail(filename))
  return nodes
end

local function reverse_filename(filename)
  local parents = split_filename(filename)
  reverse(parents)
  return parents
end

local function same_until(first, second)
  for i = 1, #first do
    if first[i] ~= second[i] then return i end
  end
  return 1
end

local function get_unique_filename(filename, other_filenames)
  local rv = ""

  local others_reversed = vim.tbl_map(reverse_filename, other_filenames)
  local filename_reversed = reverse_filename(filename)
  local same_until_map = vim.tbl_map(function(second) return same_until(filename_reversed, second) end, others_reversed)

  local max = 2
  for _, v in ipairs(same_until_map) do
    if v > max then max = v end
  end

  for i = max, 1, -1 do
    if filename_reversed[i] then rv = rv .. filename_reversed[i] end
  end

  -- if rv:match "index" and max < 2 and filename_reversed[2] then rv = filename_reversed[2] .. rv end

  for i = #filename_reversed, 1, -1 do
    if
      filename_reversed[i]
      and filename_reversed[i]:match "packages"
      and filename_reversed[i - 1]
      and not rv:match(filename_reversed[i - 1])
    then
      rv = filename_reversed[i - 1]:sub(1, -2) .. "  " .. rv
    end
  end

  return rv
end

local function get_current_ufn()
  local buffers = vim.fn.getbufinfo()
  local listed = vim.tbl_filter(function(buffer) return buffer.listed == 1 end, buffers)
  local names = vim.tbl_map(function(buffer) return buffer.name end, listed)
  local current_name = vim.fn.expand "%"
  return get_unique_filename(current_name, names)
end

local c = {
  vim_mode = {
    provider = {
      name = "vi_mode",
      opts = {
        show_mode_name = true,
        -- padding = "center", -- Uncomment for extra padding.
      },
    },
    hl = function()
      return {
        fg = require("feline.providers.vi_mode").get_mode_color(),
        bg = "darkblue",
        style = "bold",
        name = "NeovimModeHLColor",
      }
    end,
    left_sep = "block",
    right_sep = "block",
  },
  gitBranch = {
    provider = "git_branch",
    hl = {
      fg = "peanut",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffAdded = {
    provider = "git_diff_added",
    hl = {
      fg = "green",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffRemoved = {
    provider = "git_diff_removed",
    hl = {
      fg = "red",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffChanged = {
    provider = "git_diff_changed",
    hl = {
      fg = "fg",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "right_filled",
  },
  separator = {
    provider = "",
  },
  fileinfo = {
    provider = get_current_ufn,
    hl = {
      style = "bold",
    },
    left_sep = " ",
    right_sep = " ",
  },
  diagnostic_errors = {
    provider = "diagnostic_errors",
    hl = {
      fg = "red",
    },
  },
  diagnostic_warnings = {
    provider = "diagnostic_warnings",
    hl = {
      fg = "yellow",
    },
  },
  diagnostic_hints = {
    provider = "diagnostic_hints",
    hl = {
      fg = "aqua",
    },
  },
  diagnostic_info = {
    provider = "diagnostic_info",
  },
  file_type = {
    provider = {
      name = "file_type",
      opts = {
        filetype_icon = true,
        case = "titlecase",
      },
    },
    hl = {
      fg = "red",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
  },
  position = {
    provider = "position",
    hl = {
      fg = "green",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
  },
  line_percentage = {
    provider = "line_percentage",
    hl = {
      fg = "aqua",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
  },
}

local left = {
  c.vim_mode,
  c.gitBranch,
  c.gitDiffAdded,
  c.gitDiffRemoved,
  c.gitDiffChanged,
  c.separator,
}

local middle = {
  c.fileinfo,
  c.diagnostic_errors,
  c.diagnostic_warnings,
  c.diagnostic_info,
  c.diagnostic_hints,
}

local right = {
  c.file_type,
  c.position,
  c.line_percentage,
}

local components = {
  active = {
    left,
    middle,
    right,
  },
  inactive = {
    left,
    middle,
    right,
  },
}

return {
  components = components,
  theme = one_monokai,
  vi_mode_colors = vi_mode_colors,
}
