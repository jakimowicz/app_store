require 'app_store/client'
require 'app_store/application'
require 'app_store/helpers/string'
require 'app_store/helpers/proxy'

# Define an agent which is linked to a specific store front and can perform all calls to this specific store.
# Accepts every AppStore class as a method, ex :
# = Examples
#  agent = AppStore::Agent.new(:store_front => :fr)
#  agent.category.featured                           # => will call Category.featured with store front set to :fr
#  agent.application.find_by_id(42)                  # => will call Application.find_by_id(42) with store front set to :fr
#  agent.application.find_by_id(42, :bleh => 'yeah') # => also accepts extra arguments and merge them with store front
class AppStore::Agent
  def initialize(args = {})
    @store_front = AppStore::Client::StoreFronts[args[:store_front]] || AppStore::Client::DefaultStoreFront
    @client = AppStore::Client.new(:store_front => @store_front)
  end
  
  private
  def method_missing(method, *args)
    # OPTIMIZE: we should use a 'camelize' method instead of capitalize
    AppStore::Helper::Proxy.new :to => "AppStore::#{method.to_s.capitalize}".constantize,
                                :extra => {:client => @client}
  end
end