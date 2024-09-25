local api = require('omnivore.api')
local pickers = require('telescope.pickers')
local config = require('telescope.config').values
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local utils = require('telescope.previewers.utils')
local preview_formatter = require('omnivore.preview_formatter')
local annotation_formatter = require('omnivore.annotation_formatter')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

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
        local out = preview_formatter.notes(
          entry.value.annotation,
          entry.value.quote,
          entry.value.libraryItem.description,
          entry.value.libraryItem.url,
          width
        )
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, out)
        utils.highlighter(self.state.bufnr, 'markdown')
      end,
    }),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local note = selection.value.annotation
        local quote = selection.value.quote
        local url = selection.value.libraryItem.url
        local title = selection.value.libraryItem.title
        local lines = vim.split(annotation_formatter.notes(note, quote, title, url), '\n')
        vim.api.nvim_put(lines, "", false, true)
      end)
      return true
    end,
  }):find()
end

return show_notes()
