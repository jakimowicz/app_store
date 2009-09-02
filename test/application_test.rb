require "test_helper"

class ApplicationTest < Test::Unit::TestCase
  
  context "test custom initializer with an emulated plist as a hash" do
    setup do
      AppStore::Application.send(:public, *AppStore::Application.protected_instance_methods)
      @plist = {
        'type' => 'software',
        'store-offers' => {
          'STDQ' => {
            'price' => 42,
            'size'  => 101010
          }
        },
        'company' => {
          'url'   => 'http://www.google.com',
          'title' => 'Google'
        }
      }
      @app = AppStore::Application.new(:plist => @plist)
    end
  
    should "set price correctly on initialization from plist" do
      assert_equal 42, @app.price
    end
    
    should "set size correctly on initialization from plist" do
      assert_equal 101010, @app.size
    end
    
    should "set company correctly on initialization from plist" do
      assert_equal 'http://www.google.com', @app.company.url
      assert_equal 'Google', @app.company.title
    end
  end
end
