local picker = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values
local key = os.getenv('OMNIVORE_KEY')
local url = "https://api-prod.omnivore.app/api/graphql"
local M = {}

local function query_graphql(api_url, api_key, query)
  local cmd = {
    "curl --request POST",
    string.format("--url '%s'", api_url),
    "--header 'Content-Type: application/json'",
    string.format("--header 'authorization: %s'", api_key),
    string.format("--data '{\"query\": \"%s\"}'", query)
  }

  print(table.concat(cmd, ' '))

  vim.fn.jobstart(table.concat(cmd, ' '), {
    stdout_buffered = true,
    on_stdout = function(job_id, data, event)
      if data then
        print("--------------------------------------------")
        print(data[1])
        print("--------------------------------------------")
      end
    end,
    on_stderr = function(job_id, data, event)
      if data then
        print("Error:", table.concat(data))
      end
    end,
  })
end

local gql_query = [[
    query Search {
        search(first: 5) {
            ... on SearchSuccess {
                edges {
                    node {
                        content
                        highlights {
                            html
                            quote
                            type
                            annotation
                        }
                        archivedAt
                        folder
                        url
                        title
                        slug
                        readAt
                    }
                }
                pageInfo {
                    hasNextPage
                }
            }
            ... on SearchError {
                errorCodes
            }
        }
    }
]]

query_graphql(url, key, gql_query:gsub("%s+", " "))

return M
