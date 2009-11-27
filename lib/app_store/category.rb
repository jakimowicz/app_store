require "app_store/base"
require "app_store/application"

# A category like categories on the AppStore.
# Available attributes:
# * <tt>item-count</tt>: total items count for this category.
# * <tt>title</tt>: title for the category.
# = Examples
# === Fetch featured categories
#  @categories = AppStore::Category.featured
#  @categories.class              # => Array
#  @categories.length             # => 20
# 
# === Use category
#  @category = @categories.first
#  @category.title                # => "Games"
#  @category.item_count           # => 1573
# 
# === Category by id
#  @category = AppStore::Category.find_by_id(6014)
#  @category.title                # => "Games"
# 
# === Iterate through subcategories and applications
# This example will display all categories with all applications available in the current AppStore
#  def go_deeper(category)
#    puts "Category #{category.title}"
#    category.items.each do |item|
#      if item.is_a?(AppStore::Category)
#        go_deeper item
#      else
#        puts " => #{item.title} has id #{item.item_id}"
#      end
#    end
#  end
#  
#  AppStore::Category.featured.each {|category| go_deeper category}
#
class AppStore::Category < AppStore::Base
  plist :mapping => {
    'item-count'  => :item_count,
    'title'       => :title
  }
  
  # Returns an array of featured categories (main categories).
  # It is the same list as the one displayed in the iPhone AppStore.
  def self.featured(options = {})
    client = options[:client] || AppStore::Client.new
    plist = client.get(AppStore::Client::FeaturedCategoriesURL)
    plist['items'].collect { |item| new :client => client, :plist => item }
  end
  
  # Search a Category by its <tt>id</tt>. Accepts only one <tt>id</tt> and returns a Category instance.
  def self.find_by_id(id, options = {})
    client = options[:client] || AppStore::Client.new
    new :item_id  => id,
        :client   => client,
        :plist    => client.get(AppStore::Client::CategoryURL, :id => id)
  end
  
  # Returns id for this category
  def item_id
    @item_id ||= @raw['url'].match(/^http:\/\/.*\/.*id[=]{0,1}([0-9]+)[&?].*$/)[1]
  end
  
  # Returns an instance of List which contains items elements.
  # Each element in the list can be either another category (subcategory) or a Link to an application.
  def items
    if @items.nil?
      plist = @raw['items'] ? @raw : @client.get(@raw['url'])
      @items = AppStore::List.new(
        :client               => @client,
        :list                 => plist['items'],
        :element_type         => 'link',
        :element_initializer  => lambda {|element|
          (element['link-type'] == 'software' ? AppStore::Link : AppStore::Category).new(:client => @client,
                                                                                         :plist => element)
        }
      )
    end
    @items
  end
end