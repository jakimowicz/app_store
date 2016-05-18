require "app_store/base"

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
      AppStore::Application.new :plist => @client.itunes_get(@url)['item-metadata'] || @raw,
                                :client => @client
    else
      raise 'unsupported'
    end
  end
end