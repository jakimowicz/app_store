require "test_helper"

class ArtworkTest < Test::Unit::TestCase
  
  context "test custom initializer with an emulated plist as a hash" do
    setup do
      @icon_plist = {
        "default" => {
          "box-height"  => 57,
          "url"         => "http://a1.phobos.apple.com/us/r1000/058/Purple/c6/e0/62/mzl.eillqyke.png",
          "box-width"   => 57,
          "needs-shine" => false
        },
        "image-type"  => "software-icon",
        "url"         => ""
      }
      
      @screenshot_plist = {
        "thumbnail" => {
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
        "url"         => ""
      }
      
      @icon = AppStore::Artwork.new(:plist => @icon_plist)
      @screenshot = AppStore::Artwork.new(:plist => @screenshot_plist)
    end
    
    should "return true for is_icon? if it is an icon" do
      assert @icon.is_icon?
    end
    
    should "return false for is_icon? if it is a screenshot (not an icon)" do
      assert_equal false, @screenshot.is_icon?
    end
    
    should "set image-type through plist mapping" do
      assert_equal @icon_plist['image-type'],       @icon.image_type
      assert_equal @screenshot_plist['image-type'], @screenshot.image_type
    end
    
    should "set default image for icon" do
      assert_not_nil @icon.default
      assert_kind_of AppStore::Image, @icon.default
    end

    should "set default image for screenshot" do
      assert_not_nil @screenshot.default
      assert_kind_of AppStore::Image, @screenshot.default
    end
    
    should "set thumbnail for screenshot" do
      assert_not_nil @screenshot.default
      assert_kind_of AppStore::Image, @screenshot.default
    end
  end
end