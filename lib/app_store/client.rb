require "rubygems"
require "nokogiri"
require "mechanize"
require "plist"

require "app_store"

# Client regroups all the calling and xml parsing mechanism to call the AppStore.
class AppStore::Client
  
  attr_reader :store_front
  attr_reader :store_front_name

  # Urls
  FeaturedCategoriesURL = "http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewFeaturedSoftwareCategories"
  ApplicationURL        = "http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware"
  CategoryURL           = "http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewGenre"
  SearchURL             = "http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search"
  
  # Store Front
  StoreFronts           = {
    :ar   => "143505",  # Argentina
    :au   => "143460",  # Australia
    :be   => "143446",  # Belgium
    :br   => "143503",  # Brazil
    :ca   => "143455",  # Canada
    :cl   => "143483",  # Chile
    :cn   => "143465",  # China
    :fr   => "143442",  # France
    :us   => "143441",  # United states
  }

  DefaultStoreFrontName = :us
  
  def initialize(args = {})
    @store_front_name = args[:store_front] || DefaultStoreFrontName
    # About the X-Apple-Store-Front header: this is used to select which store and which language.
    # Format is XXXXXX-Y,Z where XXXXXX is the store number (us, french, ...), Y the language and Z the return format.
    # If you omit the language, the default one for the store is used.
    # Return format can be either "1" or "2" : "1" returns data to be directly displayed and "2" is a more structured format.
    @store_front = "#{StoreFronts[@store_front_name]},2"
  end

  # Call the Apple AppStore using given <tt>url</tt> and passing <tt>params</tt> with an HTTP Get method.
  # Call is seen as a fake iPhone iTunes client.
  def iphone_get(url, params = {})
    Plist::parse_xml make_call_and_handle_answer(iphone_agent, url, params).body
  end
  
  alias :get :iphone_get
  
  # Call the Apple AppStore using given <tt>url</tt> and passing <tt>params</tt> with HTTP Get method.
  # Call is seen as a fake Mac OS X iTunes client.
  def itunes_get(url, params = {})
    Nokogiri.parse make_call_and_handle_answer(itunes_agent, url, params).body
  end
  
  protected
  def iphone_agent
    @iphone_agent ||= Mechanize.new { |a| a.user_agent = 'iTunes-iPhone/3.0 (2)' }
  end
  
  def itunes_agent
    @itunes_agent ||= Mechanize.new { |a| a.user_agent = 'iTunes/9.0.1 (Macintosh; Intel Mac OS X 10.6.1) AppleWebKit/531.9' }
  end
  
  def headers
    {
      "X-Apple-Client-Application" => "Software",
      "X-Apple-Store-Front" => @store_front
    }
  end
  
  # Make call using given <tt>agent</tt>, <tt>url</tt> and <tt>params</tt>.
  # Handle answer code and returns answer if answer code was correct.
  def make_call_and_handle_answer(agent, url, params)
    answer = agent.get(:url => url, :headers => headers, :params => params)
    raise AppStore::RequestError if answer.code.to_s != '200'
    answer
  end

end