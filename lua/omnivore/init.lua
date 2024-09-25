local M = {}

M.setup = function(config)
  if not config then
    config = {}
  end
  if config.api_token ~= nil then
    M.config.api_token = config.api_token
  elseif os.getenv('OMNIVORE_KEY') ~= nil then
    M.config.api_token = os.getenv('OMNIVORE_KEY')
  else
    print("API token is required!")
  end
end

return M
