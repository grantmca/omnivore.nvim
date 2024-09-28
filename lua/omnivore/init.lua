local M = {}

M.setup = function(config)
  if not config then
    config = {}
  end
  if config.api_token ~= nil then
    config.api_token = config.api_token
  elseif os.getenv('OMNIVORE_KEY') ~= nil then
    config.api_token = os.getenv('OMNIVORE_KEY')
  else
    print("API token is required!")
  end
  M.confg = config
end

return M
