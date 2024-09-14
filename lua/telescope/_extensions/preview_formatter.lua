local M = {}

local function format_width(string, width)
  local words = vim.split(string, "%s+")
  local output = {}
  local current_string = ""
  local current_length = 0

  for _, word in ipairs(words) do
    local word_length = #word
    if current_length + word_length > width / 2 then
      table.insert(output, current_string)
      current_string = word
      current_length = word_length
    else
      current_string = current_string .. " " .. word
      current_length = current_length + word_length
    end
  end

  if #current_string > 0 then
    table.insert(output, current_string)
  end

  return output
end

function M.notes(entry, width)
  local annotation = entry.value.annotation ~= vim.NIL and string.gsub(entry.value.annotation, "%s+", " ") or ""
  local quote = entry.value.quote ~= vim.NIL and string.gsub(entry.value.quote, "%s+", " ") or ""
  local description = string.gsub(entry.value.libraryItem.description or "", "%s+", " ")
  local url = entry.value.libraryItem.url or ""
  local formatted_annotation = format_width(annotation, width)
  local formatted_description = format_width(description, width)
  local formatted_quote = format_width(quote, width)
  local formatted = {
    '# Note:',
    '',
    formatted_annotation,
    '',
    '# Quote:',
    formatted_quote,
    '',
    '# Library Item Description*',
    formatted_description,
    '',
    '# Item URL:',
    url,
  }
  return vim.iter(formatted):flatten():totable()
end

return M
