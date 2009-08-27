module AppStore
  # Error while comunicating with the AppStore
  class RequestError < StandardError
  end
  
  # A parse error is raised if data returned by the AppStore was not expected
  class ParseError < StandardError
  end
end

require "app_store/application"
require "app_store/category"