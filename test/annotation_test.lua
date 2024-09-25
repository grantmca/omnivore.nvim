describe("Annotation Formatting Tests", function()

  local formatter

  before_each(function()
    formatter = require('omnivore.annotation_formatter')
  end)

  it("formats a note correctly", function()
    local note = "Notes are a good way to keep track of things"
    local quote = "The Importance of keeping notes"
    local title = "The Note Taking Manefesto"
    local url = "www.notes.test"

    local formatted_notes = formatter.notes(note, quote, title, url)

    local expected_output = [[
Notes are a good way to keep track of things
"The Importance of keeping notes"
[The Note Taking Manefesto|www.notes.test] ]]

    assert.are.same(expected_output, formatted_notes)
  end)

end)
