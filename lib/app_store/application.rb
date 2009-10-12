require "app_store/base"
require "app_store/company"
require "app_store/user_review"
require "app_store/artwork"
require "app_store/list"

# Represents an application in the AppStore.
# Available attributes:
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
class AppStore::Application < AppStore::Base
  attr_reader :company, :price, :size, :artworks, :icon, :screenshots
  
  plist :accepted_type => 'software',
    :mapping => {
      'average-user-rating' => :average_user_rating,
      'user-rating-count'   => :user_rating_count,
      'release-date'        => :release_date,
      'description'         => :description,
      'item-id'             => :item_id,
      'version'             => :version,
      'title'               => :title
    }
  
  # Search an Application by its <tt>id</tt>. Accepts only one <tt>id</tt> and returns an Application instance.
  def self.find_by_id(id)
    plist = AppStore::Caller.get(AppStore::Caller::ApplicationURL, :id => id)
    # TODO : Check if everything was right before instancianting
    new :plist => plist['item-metadata']
  end
  
  # Search an Application by a <tt>text</tt>.
  # Returns an array with matching application or an empty array if no result found.
  def self.search(text)
    plist = AppStore::Caller.get(AppStore::Caller::SearchURL, :media => 'software', :term => text)
    plist['items'].collect { |item| find_by_id item['item-id'] } rescue []
  end
  
  def initialize(attrs = {})
    @screenshots ||= []
    super
  end
  
  # Returns an array of UserReview objects.
  def user_reviews
    if @user_reviews.nil?
      plist = AppStore::Caller.get(@raw['view-user-reviews-url'])
      @user_reviews = AppStore::List.new( :element_initializer  => lambda {|element| AppStore::UserReview.new :plist => element},
                                          :element_type         => 'review',
                                          :list => plist['items'] )
    end
    @user_reviews
  end
  
  protected
  def custom_init_from_plist(plist)
    # Set size and price
    @price  = plist['store-offers']['STDQ']['price']
    @size   = plist['store-offers']['STDQ']['size']
    
    # Seek for company
    @company  = AppStore::Company.new(:plist => plist['company'])
    
    # Parse artwork
    @artworks = plist['artwork-urls'].collect do |plist_artwork|
      # OPTIMIZE : handle default_screenshot
      if plist_artwork['image-type'] and plist_artwork['default']
        artwork = AppStore::Artwork.new :plist => plist_artwork
        @icon ||= artwork.default if artwork.is_icon?
        @screenshots << artwork.default unless artwork.is_icon?
        artwork
      end
    end
    @artworks.compact!
  end
end