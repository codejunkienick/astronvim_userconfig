
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

local function getWorkspaceFolder()
  local filename = vim.api.nvim_buf_get_name(0)
  local rv = ""

  local filename_reversed = reverse_filename(filename)

  for i = #filename_reversed, 1, -1 do
    if
      filename_reversed[i]
      and filename_reversed[i]:match "packages"
      and filename_reversed[i - 1]
      and not rv:match(filename_reversed[i - 1])
    then
      rv = filename_reversed[i - 1]:sub(1, -2) .. "  "
    end
  end

  return rv
end

return function(config)
  -- the first element of the configuration table is the statusline
  config[1] = {
    -- default highlight for the entire statusline
    hl = { fg = "fg", bg = "bg" },
    -- each element following is a component in astronvim.status module

    -- add the vim mode component
    astronvim.status.component.mode {
      -- enable mode text with padding as well as an icon before it
      mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
      -- define the highlight color for the text
      hl = { fg = "bg" },
      -- surround the component with a separators
      surround = {
        -- it's a left element, so use the left separator
        separator = "left",
        -- set the color of the surrounding based on the current mode using astronvim.status module
        color = function() return { main = astronvim.status.hl.mode_bg(), right = "blank_bg" } end,
      },
    },
    -- we want an empty space here so we can use the component builder to make a new section with just an empty string
    astronvim.status.component.builder {
      { provider = "" },
      -- define the surrounding separator and colors to be used inside of the component
      -- and the color to the right of the separated out section
      surround = { separator = "left", color = { main = "blank_bg", right = "file_info_bg" } },
    },
    -- add a section for the currently opened file information
    astronvim.status.component.file_info {
      -- enable the file_icon and disable the highlighting based on filetype
      file_icon = { highlight = false, padding = { left = 0 } },
      -- add padding
      padding = { right = 1 },
      -- define the section separator
      surround = { separator = "left", condition = false },
    },
    -- add a component for the current git branch if it exists and use no separator for the sections
    astronvim.status.component.git_branch { surround = { separator = "none" } },
    -- add a component for the current git diff if it exists and use no separator for the sections
    astronvim.status.component.git_diff { padding = { left = 1 }, surround = { separator = "none" } },
    -- fill the rest of the statusline
    -- the elements after this will appear in the middle of the statusline
    astronvim.status.component.fill(),
    -- add a component to display if the LSP is loading, disable showing running client names, and use no separator
    astronvim.status.component.lsp { lsp_client_names = false, surround = { separator = "none", color = "bg" } },
    -- fill the rest of the statusline
    -- the elements after this will appear on the right of the statusline
    astronvim.status.component.fill(),
    -- add a component for the current diagnostics if it exists and use the right separator for the section
    astronvim.status.component.diagnostics { surround = { separator = "right" } },

    -- add a component to display LSP clients, disable showing LSP progress, and use the right separator
    -- astronvim.status.component.lsp { lsp_progress = false, surround = { separator = "right" } },

    -- NvChad has some nice icons to go along with information, so we can create a parent component to do this
    -- all of the children of this table will be treated together as a single component
    {
      -- define a simple component where the provider is just a folder icon
      astronvim.status.component.builder {
        -- astronvim.get_icon gets the user interface icon for a closed folder with a space after it
        { provider = astronvim.get_icon "FolderClosed" },
        -- add padding after icon
        padding = { right = 1 },
        -- set the foreground color to be used for the icon
        hl = { fg = "bg" },
        -- use the right separator and define the background color
        surround = { separator = "right", color = "folder_icon_bg" },
      },
      -- add a file information component and only show the current working directory name
      astronvim.status.component.builder {
        -- we only want filename to be used and we can change the fname
        -- function to get the current working directory name
        { provider =  function() return  ' ' .. getWorkspaceFolder() .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") end },
        -- disable all other elements of the file_info component
        padding = { left = 0, right = 0 },
        hl = { fg = "fg" },
        -- use no separator for this part but define a background color
        --
        surround = { separator = "none", color = "file_info_bg" },
      },
    },
    -- the final component of the NvChad statusline is the navigation section
    -- this is very similar to the previous current working directory section with the icon
    { -- make nav section with icon border
      -- define a custom component with just a file icon
      astronvim.status.component.builder {
        { provider = astronvim.get_icon "DefaultFile" },
        -- add padding after icon
        padding = { right = 1 },
        -- set the icon foreground
        hl = { fg = "bg" },
        -- use the right separator and define the background color
        -- as well as the color to the left of the separator
        surround = { separator = "right", color = { main = "nav_icon_bg", left = "file_info_bg" } },
      },
      -- add a navigation component and just display the percentage of progress in the file
      astronvim.status.component.nav {
        -- add some padding for the percentage provider
        percentage = { padding = { left = 1, right = 1 } },
        -- disable all other providers
        ruler = false,
        scrollbar = false,
        -- define the foreground color
        hl = { fg = "nav_icon_bg" },
        -- use no separator and define the background color
        surround = { separator = "none", color = "file_info_bg" },
      },
    },
  }

  -- a second element in the heirline setup would override the winbar
  -- by only providing a single element we will only override the statusline
  -- and use the default winbar in AstroNvim

  -- return the final confiuration table
  return config
end
