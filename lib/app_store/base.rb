require "app_store/caller"
require "app_store/helpers/plist"

# Implements basic operations for AppStore objects : initialization, plist parsing, ...
class AppStore::Base
  extend AppStore::Helper::Plist
  
  # Instanciate a new object.
  # <tt>attrs</tt> accepts:
  # * <tt>:plist</tt>: a plist object to be parsed
  def initialize(attrs = {})
    init_from_plist attrs[:plist] if attrs[:plist]
  end
  
  protected
  def init_from_plist(plist)
    @raw = plist
  end
end