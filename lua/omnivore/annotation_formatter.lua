local M = {}

function M.notes(note, quote, title, url)
    local parts = {
        note,
        string.format("\"%s\"", quote),
        string.format("[%s|%s] ", title, url)
    }
    local formatted_notes = table.concat(parts, "\n")
    return formatted_notes
end

return M
