local api = require('omnivore.api')
local pickers = require('telescope.pickers')
local config = require('telescope.config').values
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local utils = require('telescope.previewers.utils')
local log = require('plenary.log').new {
    plugin = 'omnivore',
    level = 'info',
}
local M = {}

M._format_width = function (string, width)
  local words = vim.split(string, "%s+")

  local output = {}
  local current_string = ""
  local current_length = 0

  for _, word in ipairs(words) do
    local word_length = #word
    if current_length + word_length > width/2 then
      table.insert(output, current_string)
      current_string = word
      current_length = #word
    else
      current_string = current_string .. " " .. word
      current_length = current_length + #word
    end
  end

  if #current_string > 0 then
    table.insert(output, current_string)
  end

  return output
end

M._format_preview = function (entry, width)
  local annotation
  local quote

  if entry.value.annotation == vim.NIL then
    annotation = ""
  else
    annotation = string.gsub(entry.value.annotation, "%s+", " ")
  end

  if entry.value.quote == vim.NIL then
    quote = ""
  else
    quote = string.gsub(entry.value.quote, "%s+", " ")
  end
  local description = string.gsub(entry.value.libraryItem.description or "", "%s+", " ")
  local url = entry.value.libraryItem.url or ""
  local formatted_annotation = M._format_width(annotation, width)
  local formatted_description = M._format_width(description, width)
  local formatted_quote = M._format_width(quote, width)
  local formatted = {
    '# Note:',
    '',
    formatted_annotation,
    '',
    '# Quote:', formatted_quote, '',
    '# Libary Item Description*', formatted_description, '',
    '# Item Url: ', url,
  }
  formatted = vim.iter(formatted):flatten():totable()
  return formatted
end

M.show_notes = function (opts)
  pickers.new(opts, {
    finder = finders.new_table({
      results = api.query_highlights(),
      entry_maker = function (entry)
        return {
          value = entry.node,
          display = entry.node.libraryItem.title,
          ordinal = entry.node.libraryItem.title
        }
      end,
    }),
    sorter = config.generic_sorter(opts),
    previewer = previewers.new_buffer_previewer({
      title = "Omnivore Notes",
      define_preview = function(self, entry)
        local width = vim.api.nvim_win_get_width(self.state.winid)
        local out = M._format_preview(entry, width)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, out)
        utils.highlighter(self.state.bufnr, 'markdown')
      end,
    })
  }):find()
end

M.show_notes()
