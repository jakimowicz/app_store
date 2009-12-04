require "test_helper"

class ApplicationTest < Test::Unit::TestCase
  
  context "test custom initializer with an emulated plist as a hash" do
    setup do
      AppStore::Application.send(:public, *AppStore::Application.protected_instance_methods)
      @plist = {
        'type' => 'software',
        'item-id' => '424242',
        'title' => 'fantapp',
        'description' => "Fantastic application that allows you to control your car from your iPhone",
        'store-offers' => {
          'STDQ' => {
            'price' => 42,
            'size'  => 101010
          }
        },
        'artwork-urls' => [
          { "box-height"  => 57,
            "url"         => "http://a1.phobos.apple.com/us/r1000/058/Purple/c6/e0/62/mzl.eillqyke.png",
            "box-width"   => 57,
            "needs-shine" => false },
            
          { "box-height"  => 460,
            "url"         => "http://a1.phobos.apple.com/us/r1000/009/Purple/d7/72/58/mzl.yridpiqv.480x480-75.jpg",
            "box-width"   => 320 },
            
          { "default"      => {
              "box-height"  => 57,
              "url"         => "http://a1.phobos.apple.com/us/r1000/058/Purple/c6/e0/62/mzl.eillqyke.png",
              "box-width"   => 57,
              "needs-shine" => false
            },
            "image-type"  => "software-icon",
            "url"         => "" },
            
          { "thumbnail"   => {
              "box-height"  => 99,
              "url"         => "http://a1.phobos.apple.com/us/r1000/037/Purple/df/fa/6a/mzl.mlprrfol.148x99-75.jpg",
              "box-width"   => 148,
              "needs-shine" => false
            },
            "default"     => {
              "box-height"  => 460,
              "url"         => "http://a1.phobos.apple.com/us/r1000/037/Purple/df/fa/6a/mzl.mlprrfol.480x480-75.jpg",
              "box-width"   => 320
            },
            "image-type"  => "screenshot",
            "url"         => "" },
          { "thumbnail"   => {
              "box-height"  => 99,
              "url"         => "http://a1.phobos.apple.com/us/r1000/058/Purple/d5/d4/6a/mzl.zmpdhenu.148x99-75.jpg",
              "box-width"   => 148,
              "needs-shine" => false
            },
            "default" => {
              "box-height"  => 460,
              "url"         => "http://a1.phobos.apple.com/us/r1000/058/Purple/d5/d4/6a/mzl.zmpdhenu.480x480-75.jpg",
              "box-width"   => 320
            },
            "image-type"  => "screenshot",
            "url"         => "" },
          { "thumbnail"   => {
              "box-height"  => 99,
              "url"         => "http://a1.phobos.apple.com/us/r1000/029/Purple/d3/9c/76/mzl.xgeoazvu.148x99-75.jpg",
              "box-width"   => 148,
              "needs-shine" => false
            },
            "default" =>  {
              "box-height"  => 460,
              "url"         => "http://a1.phobos.apple.com/us/r1000/029/Purple/d3/9c/76/mzl.xgeoazvu.480x480-75.jpg",
              "box-width"   => 320
            },
            "image-type"  => "screenshot",
            "url"         => "" },
          { "thumbnail" => {
              "box-height"  => 99,
              "url"         => "http://a1.phobos.apple.com/us/r1000/038/Purple/df/24/ec/mzl.ktobakku.148x99-75.jpg",
              "box-width"   => 148,
              "needs-shine" => false
            },
            "default" => {
              "box-height"  => 480,
              "url"         => "http://a1.phobos.apple.com/us/r1000/038/Purple/df/24/ec/mzl.ktobakku.480x480-75.jpg",
              "box-width"   => 320
            },
            "image-type"  => "screenshot",
            "url"         => "" }
        ],
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
      assert_kind_of AppStore::Company, @app.company
      assert_equal 'http://www.google.com', @app.company.url
      assert_equal 'Google', @app.company.title
    end
    
    should "have 5 artworks" do
      assert_equal 5, @app.artworks.count
    end
    
    should "have a software icon thumbnail" do
      assert_not_nil @app.icon_thumbnail
      assert_kind_of AppStore::Image, @app.icon_thumbnail
    end
    
    should "have 4 screenshots" do
      assert_equal 4, @app.screenshots.count
    end
    
    should "have no icon in screenshots" do
      assert !@app.screenshots.include?(@app.icon_thumbnail)
    end
    
    should "have the right item_id" do
      assert_equal '424242', @app.item_id
    end
    
    should "have a correct item url to the real AppStore" do
      assert_equal "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=424242", @app.itunes_url
    end
    
    should "have the right description" do
      assert_equal "Fantastic application that allows you to control your car from your iPhone", @app.description
    end
    
    should "have the right title" do
      assert_equal "fantapp", @app.title
    end
  end
  
  # context "fake calls to real AppStore using FakeMechanize for offline tests" do
  #   setup do
  #     @http_agent = FakeMechanize::Agent.new do |mock|
  #       # Search for term "remote"
  #       mock.get :uri => AppStore::Caller::SearchURL,
  #         :parameters => {:media => 'software', :term => 'remote'}, 
  #         :body => File.open("test/raw_answers/search_remote.txt").read
  #       
  #       [284417350, 289616509, 316771002, 300719251].each do |app_id|
  #         # Load all applications
  #         mock.get :uri => AppStore::Caller::ApplicationURL,
  #           :parameters => {:id => app_id},
  #           :body => File.open("test/raw_answers/application_#{app_id}.txt").read
  # 
  #         # Add an error catch for all non existing applications
  #         mock.error :uri => AppStore::Caller::ApplicationURL,
  #           :params_not_equal => {:id => app_id},
  #           :body => File.open("test/raw_answers/application_not_found.txt").read
  #         
  #       end
  #     end
  #     
  #     # Place the fake agent in the caller
  #     AppStore::Caller.instance_variable_set "@agent", @http_agent
  #   end
  #   
  #   teardown do
  #     # Remove fake agent
  #     AppStore::Caller.instance_variable_set "@agent", nil
  #   end
  #   
  #   context "search for 'remote'" do
  #     setup do
  #       @list = AppStore::Application.search('remote')
  #     end
  # 
  #     should "call search url with search term in the http query" do
  #       assert @http_agent.was_get?(AppStore::Caller::SearchURL,
  #                                   :parameters => {:media => 'software', :term => 'remote'})
  #     end
  #     
  #     should "find 4 applications" do
  #       assert_equal 4, @list.length
  #     end
  #           
  #   end
  #   
  #   context "load application 316771002" do
  #     setup do
  #       @app = AppStore::Application.find_by_id(316771002)
  #     end
  #     
  #     should "should have 4 artworks" do
  #       assert_equal 4, @app.artworks.count
  #     end
  #   end
  # end
end