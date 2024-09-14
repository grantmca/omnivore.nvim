local M = {}

M._format_width = function(input_string, width)
  local words = vim.split(input_string, "%s+")
  local output = {}
  local current_line = ""
  local current_length = 0

  for _, word in ipairs(words) do
    local word_length = #word
    if word_length > width then
      if current_length > 0 then
        table.insert(output, current_line)
        current_line = ""
        current_length = 0
      end

      while word_length > width do
        table.insert(output, word:sub(1, width))
        word = word:sub(width + 1)
        word_length = #word
      end
      if word_length > 0 then
        current_line = word
        current_length = word_length
      end
    else
      if current_length + word_length + (current_length > 0 and 1 or 0) > width then
        table.insert(output, current_line)
        current_line = word
        current_length = word_length
      else
        if current_length > 0 then
          current_line = current_line .. " "
          current_length = current_length + 1
        end
        current_line = current_line .. word
        current_length = current_length + word_length
      end
    end
  end

  if current_length > 0 then
    table.insert(output, current_line)
  end

  return output
end

local function sanitize_and_strip(input)
  if input ~= vim.NIL then
    return string.gsub(input, "%s+", " ")
  else
    return ""
  end
end

function M.notes(entry, width)
  local annotation = sanitize_and_strip(entry.value.annotation)
  local quote = sanitize_and_strip(entry.value.quote)
  local description = sanitize_and_strip(entry.value.libraryItem.description or "")
  local url = entry.value.libraryItem.url or ""

  local formatted_annotation = M._format_width(annotation, width)
  local formatted_description = M._format_width(description, width)
  local formatted_quote = M._format_width(quote, width)
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
