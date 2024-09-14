local api = require('omnivore.api')
local pickers = require('telescope.pickers')
local config = require('telescope.config').values
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local utils = require('telescope.previewers.utils')
local preview_formatter = require('telescope._extensions.preview_formatter')

local show_notes = function (opts)
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
        local out = preview_formatter.notes(entry, width)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, out)
        utils.highlighter(self.state.bufnr, 'markdown')
      end,
    })
  }):find()
end

return show_notes()
