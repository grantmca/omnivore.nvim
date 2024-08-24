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
        local annotation
        if entry.value.annotation == vim.NIL then
          annotation = "" 
        else
          annotation = string.gsub(entry.value.annotation, "%s+", " ")
        end
        local description = string.gsub(entry.value.libraryItem.description or "", "%s+", " ")
        local url = entry.value.libraryItem.url or ""

        local formatted = {
          '# Note: ' .. annotation,
          '',
          '*Libary Item Description*: ' .. description,
          '*Item Url*: ' .. url,
        }

        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, formatted)
        vim.api.nvim_buf_set_option(self.state.bufnr, 'wrap', true)
        utils.highlighter(self.state.bufnr, 'markdown')
      end,
    })
  }):find()
end

M.show_notes()
