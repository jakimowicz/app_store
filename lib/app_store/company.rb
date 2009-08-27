require "app_store"

# Represents a company (the application developper)
# The following attributes are available:
# * <tt>title</tt>: title of the company, or name of the developper.
# * <tt>url</tt>: website url.
class AppStore::Company < AppStore::Base
  plist :mapping => { 'title' => :title, 'url' => :url }
end