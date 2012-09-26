require "test_helper"

class ClientTest < Test::Unit::TestCase
  
  context "with no store front specified" do
  
    setup do
      AppStore::Client.send(:public, *AppStore::Client.protected_instance_methods)
      @client = AppStore::Client.new
    end
  
    should "returns a mechanize agent on call to iphone_agent" do
      assert_kind_of Mechanize, @client.iphone_agent
    end

    should "set mechanize user agent to iTunes-iPhone/3.0 (2) for iphone_agent" do
      assert_equal 'iTunes-iPhone/3.0 (2)', @client.iphone_agent.user_agent
    end

    should "returns a mechanize agent on call to itunes_agent" do
      assert_kind_of Mechanize, @client.itunes_agent
    end

    should "set mechanize user agent to iTunes/9.0.1 (Macintosh; Intel Mac OS X 10.6.1) AppleWebKit/531.9 for itunes_agent" do
      assert_equal 'iTunes/9.0.1 (Macintosh; Intel Mac OS X 10.6.1) AppleWebKit/531.9', @client.itunes_agent.user_agent
    end
  
    should "have headers with client application" do
      assert_equal "Software", @client.headers["X-Apple-Client-Application"]
    end
    
    should "have headers with store front in the correct format" do
      assert @client.headers["X-Apple-Store-Front"].match(/[0-9]{6},[0-9]{0,1}/)
    end

    should "have headers with default store front" do
      assert_equal  AppStore::Client::StoreFronts[AppStore::Client::DefaultStoreFrontName],
                    @client.headers["X-Apple-Store-Front"].split(',').first
    end

    should "have headers with correct format specified in store front" do
      assert_equal "2", @client.headers["X-Apple-Store-Front"].split(',').last
    end
  end
end