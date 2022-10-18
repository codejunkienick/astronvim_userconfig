return function(config)
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
end
