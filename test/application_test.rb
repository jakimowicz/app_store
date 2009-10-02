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
        'artwork-urls' => [],
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
  
  context "fake calls to real AppStore using FakeMechanize for offline tests" do
    setup do
      @http_agent = FakeMechanize::Agent.new do |mock|
        # Search for term "remote"
        mock.get :uri => AppStore::Caller::SearchURL,
          :parameters => {:media => 'software', :term => 'remote'}, 
          :body => File.open("test/raw_answers/search_remote.txt").read
        
        [284417350, 289616509, 316771002, 300719251].each do |app_id|
          # Load all applications
          mock.get :uri => AppStore::Caller::ApplicationURL,
            :parameters => {:id => app_id},
            :body => File.open("test/raw_answers/application_#{app_id}.txt").read

          # Add an error catch for all non existing applications
          mock.error :uri => AppStore::Caller::ApplicationURL,
            :params_not_equal => {:id => app_id},
            :body => File.open("test/raw_answers/application_not_found.txt").read
          
        end
      end
      
      # Place the fake agent in the caller
      AppStore::Caller.instance_variable_set "@agent", @http_agent
    end
    
    teardown do
      # Remove fake agent
      AppStore::Caller.instance_variable_set "@agent", nil
    end
    
    context "search for 'remote'" do
      setup do
        @list = AppStore::Application.search('remote')
      end

      should "call search url with search term in the http query" do
        assert @http_agent.was_get?(AppStore::Caller::SearchURL,
                                    :parameters => {:media => 'software', :term => 'remote'})
      end
      
      should "find 4 applications" do
        assert_equal 4, @list.length
      end
            
    end
    
    context "load application 316771002" do
      setup do
        @app = AppStore::Application.find_by_id(316771002)
      end
      
      should "should have 4 artworks" do
        assert_equal 4, @app.artworks.count
      end
    end
  end
end