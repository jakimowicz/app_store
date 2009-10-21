require "app_store/base"
require "app_store/caller"

class AppStore::Link < AppStore::Base
  plist :mapping => {
    'link-type'   => :item_type,
    'item-id'     => :item_id,
    'title'       => :title,
    'url'         => :url
  }
  
  def destination
    @destination ||= case @item_type
    when 'software'
      AppStore::Application.new :plist => AppStore::Caller.get(@url)['item-metadata']
    else
      raise 'unsupported'
    end
  end
end