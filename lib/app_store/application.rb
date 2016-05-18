require "app_store/base"
require "app_store/company"
require "app_store/user_review"
require "app_store/list"
require "app_store/link"
require "app_store/image"

# Represents an application in the AppStore.
# = Available attributes:
# * <tt>average_user_rating</tt>: average rating from all user_reviews.
# * <tt>user_rating_count</tt>: user_reviews count.
# * <tt>release_date</tt>: release date on the AppStore for the application.
# * <tt>description</tt>: application description.
# * <tt>screenshots</tt>: array of Image objects for screenshots.
# * <tt>item_id</tt>: application id.
# * <tt>version</tt>: application version.
# * <tt>company</tt>: a Company object, the one which submit the application.
# * <tt>title</tt>: application title.
# * <tt>price</tt>: price of the application on the Apple AppStore.
# * <tt>icon</tt>: Image object of the application icon.
# * <tt>size</tt>: size of the application in byte.
# = Examples
# === Simple search
#    @applications = AppStore::Application.search('upnp')
#    @applications.class            # => Array
#    @applications.length           # => 8
#    @applications.first.title      # => "PlugPlayer"
#    @applications.first.price      # => 4.99
# 
# === Find an application by id
#    @fontpicker = AppStore::Application.find_by_id(327076783)
#    @fontpicker.class             # => AppStore::Application
#    @fontpicker.title             # => "FontPicker"
#    @fontpicker.price             # => 0.0
#    @fontpicker.company.title     # => "Etienne Segonzac"
# 
# === Medias
#   @fontpicker.screenshots           # => [#<AppStore::Image:0x1017683e0 @width=320, @ra ...
#   @fontpicker.screenshots.first.url # => "http://a1.phobos.apple.com/us/r1000/017/Purple/c4/99/6d/mzl.jtoxfers.480x480-75.jpg"
#   @fontpicker.icon.url							# => "http://a1.phobos.apple.com/us/r1000/026/Purple/39/40/54/mzl.yrrhymuu.100x100-75.jpg"
#
# === User reviews
#    @remote = AppStore::Application.find_by_id(284417350)
#    @remote.title                # => "Remote"
#    @remote.user_reviews.length  # => 10
# 
#    @review = @remote.user_reviews.first
# 
#    @review.user_name            # => "Ebolavoodoo on Aug 27, 2009"
#    @review.average_user_rating  # => 1.0
#    @review.text                 # => "Simply amazing. My new favorite app. Instantly responds. Easy to navigate and control. For those who say it doesn't work. Stinks to be you."
class AppStore::Application < AppStore::Base
  ApplicationURL        = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware"
  
  attr_reader :company, :price, :size, :artworks, :icon, :icon_thumbnail, :screenshots
  
  plist :mapping => {
    'average-user-rating' => :average_user_rating,
    'user-rating-count'   => :user_rating_count,
    'release-date'        => :release_date,
    'description'         => :description,
    'item-id'             => :item_id,
    'version'             => :version,
    'title'               => :title
  }
  
  # Search an Application by its <tt>id</tt>. Accepts only one <tt>id</tt> and returns an Application instance.
  def self.find_by_id(id, options = {})
    client = options[:client] || AppStore::Client.new
    plist = client.get(AppStore::Client::ApplicationURL, :id => id)
    # TODO : Check if everything was right before instancianting
    new :client => client, :plist => plist['item-metadata']
  end
  
  # Search an Application by a <tt>text</tt>.
  # Returns an array with matching application or an empty array if no result found.
  def self.search(text, options = {})
    client = options[:client] || AppStore::Client.new
    plist = client.get(AppStore::Client::SearchURL, :media => 'software', :term => text)
    AppStore::List.new :client => client, :list => plist['items']
  end
  
  def initialize(attrs = {})
    @screenshots ||= []
    super
  end
  
  # Returns an AppStore::List of UserReview objects.
  def user_reviews
    if @user_reviews.nil?
      plist = @client.get(@raw['view-user-reviews-url'])
      @user_reviews = AppStore::List.new(:list => plist['items'])
    end
    @user_reviews
  end
  
  def itunes_url
    "#{ApplicationURL}?id=#{item_id}"
  end
  
  def icon
    if @icon.nil?
      parsed = @client.browser_get(AppStore::Client::ApplicationURL, :id => item_id)
      
      plist = parsed.search('PictureView[@height="100"][@width="100"]').first
      @icon = AppStore::Image.new(:plist => plist) if plist
    end
    
    @icon
  end
  
  protected
  def custom_init_from_plist(plist)
    client = AppStore::Client.new
    
    # Set size and price
    @price  = plist['store-offers']['STDQ']['price']
    @size   = plist['store-offers']['STDQ']['size']
    
    # Seek for company
    @company  = AppStore::Company.new(:plist => plist['company'])
    
    icons = []
    
    # Parse artwork
    @artworks = plist['artwork-urls'].collect do |plist_artwork_p|
      if plist_artwork_p.include?("default@2x")
        plist_artwork = plist_artwork_p["default@2x"] 
      elsif plist_artwork_p.include?("default")
        plist_artwork = plist_artwork_p["default"]
      else
        plist_artwork = plist_artwork_p
      end
      
      result = AppStore::Image.new :plist => plist_artwork
      
      icons << result if plist_artwork_p["image-type"] == "software-icon"
      
      result
    end

    @artworks.compact!
    
    @icon_thumbnail ||= @artworks.first if @artworks.size > 0
    
    if icons.size > 0
      @icon = icons.sort_by { |icon| icon.width * icon.height }.last
      
      icon_url = @icon.url.dup
      icon_url[/\d+x\d+/] = "512x512"
      
      if icon_url != @icon.url then
        result = begin; client.browser_get(icon_url); rescue Mechanize::ResponseCodeError; nil; end
        @icon.url.replace(icon_url) if result
      end
    end
  end
end