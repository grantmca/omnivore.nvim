local M = {}
local config = require('omnivore').config

local url = "https://api-prod.omnivore.app/api/graphql"
local key = config.api_token

local function query_graphql(api_url, api_key, query)
  local output
local _, _, _, search_type = query:find("(%S+)%s+(%S+)%s+(%S+)")
  search_type = search_type:lower()
  local cmd = {
    "curl --request POST",
    string.format("--url '%s'", api_url),
    "--header 'Content-Type: application/json'",
    string.format("--header 'authorization: %s'", api_key),
    string.format("--data '{\"query\": \"%s\"}'", query)
  }

  local job_id = vim.fn.jobstart(table.concat(cmd, ' '), {
    stdout_buffered = true,
    on_stdout = function(job_id, data, event)
      if data then
        output = vim.json.decode(data[1])['data'][search_type]['edges']
      end
    end
  })
  vim.fn.jobwait({job_id})
  return output
end

function M.query_highlights()
  local gql_query =
  [[
    query Highlights {
        highlights(first: 50) {
            ... on HighlightsSuccess {
                edges {
                    node {
                        annotation
                        html
                        libraryItem {
                            description
                            hash
                            originalArticleUrl
                            slug
                            pageType
                            title
                            url
                        }
                        quote
                        representation
                    }
                }
            }
            ... on HighlightsError {
                errorCodes
            }
        }
    }
  ]]

  return query_graphql(url, key, gql_query:gsub("%s+", " "))
end

return M
