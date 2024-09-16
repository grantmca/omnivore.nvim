describe("Text Formatting Tests", function()

  local format_width

  before_each(function()
    format_width = require('omnivore.preview_formatter')._format_width
  end)

  it("splits simple sentences correctly", function()
    local input_string = "Lua is great for string manipulation"
    local width = 10
    local expected_output = {"Lua is", "great for", "string", "manipulati", "on"}
    local result = format_width(input_string, width)
    assert.are.same(expected_output, result)
  end)

  it("handles long words by breaking them up", function()
    local input_string = "A particularlylongword and normal words"
    local width = 8
    local expected_output = {"A", "particul", "arlylong", "word and", "normal", "words"}
    local result = format_width(input_string, width)
    assert.are.same(expected_output, result)
  end)

  it("correctly utilizes maximum width", function()
    local input_string = "Short words but a wider width"
    local width = 20
    local expected_output = {"Short words but a", "wider width"}
    local result = format_width(input_string, width)
    assert.are.same(expected_output, result)
  end)

  it("correctly handles an empty string", function()
    local input_string = ""
    local width = 10
    local expected_output = {}
    local result = format_width(input_string, width)
    assert.are.same(expected_output, result)
  end)

  it("manages strings where all words are longer than width", function()
    local input_string = "superlongword evenlongerword longestwordyet"
    local width = 5
    local expected_output = {"super", "longw", "ord", "evenl", "onger", "word", "longe", "stwor", "dyet"}
    local result = format_width(input_string, width)
    assert.are.same(expected_output, result)
  end)
end)
