require "app_store/base"
require "app_store/application"

# A category like categories on the AppStore.
# Available attributes:
# * <tt>item-count</tt>: total items count for this category.
# * <tt>title</tt>: title for the category.
class AppStore::Category < AppStore::Base
  plist :mapping => {
    'item-count'  => :item_count,
    'title'       => :title
  }
  
  # Returns an array of featured categories (main categories).
  # It is the same list as the one displayed in the iPhone AppStore.
  def self.featured
    plist = AppStore::Caller.get(AppStore::Caller::FeaturedCategoriesURL)
    plist['items'].collect { |item| new :plist => item }
  end
  
  # Returns an array of items contained in the category, with a maximum of 25 items (Apple limitation).
  # If there are more than 25 items in the category, an extra item is added at the end of the list
  # as a link to the next 25 entries.
  # Each element can be either a Category or an Application.
  def items
    if @items.nil?
      plist = AppStore::Caller.get(@raw['url'])
      @items = plist['items'].collect do |item|
        if item['link-type'] == 'software'
          AppStore::Application.find_by_id(item['item-id'])
        else
          AppStore::Category.new(:plist => item)
        end
      end
    end
    @items
  end
end