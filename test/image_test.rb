require "test_helper"

class ImageTest < Test::Unit::TestCase
  
  context "test custom initializer with an emulated plist as a hash" do
    setup do
      @icon_plist = {
        "box-height"  => 57,
        "url"         => "http://a1.phobos.apple.com/us/r1000/058/Purple/c6/e0/62/mzl.eillqyke.png",
        "box-width"   => 57,
        "needs-shine" => false
      }
      
      @default_screenshot_plist = {
        "box-height"  => 480,
        "url"         => "http://a1.phobos.apple.com/us/r1000/038/Purple/df/24/ec/mzl.ktobakku.480x480-75.jpg",
        "box-width"   => 320
      }
      
      @thumbnail_screenshot_plist = {
        "box-height"  => 99,
        "url"         => "http://a1.phobos.apple.com/us/r1000/038/Purple/df/24/ec/mzl.ktobakku.148x99-75.jpg",
        "box-width"   => 148,
        "needs-shine" => false
      }

      @icon = AppStore::Image.new(:plist => @icon_plist)
      @default_screenshot = AppStore::Image.new(:plist => @default_screenshot_plist)
      @thumbnail_screenshot = AppStore::Image.new(:plist => @thumbnail_screenshot_plist)
    end

    should "have a box-height property correctly set through plist mapping" do
      assert_equal @icon_plist['box-height'],                 @icon.height
      assert_equal @default_screenshot_plist['box-height'],   @default_screenshot.height
      assert_equal @thumbnail_screenshot_plist['box-height'], @thumbnail_screenshot.height
    end

    should "have a box-width property correctly set through plist mapping" do
      assert_equal @icon_plist['box-width'],                 @icon.width
      assert_equal @default_screenshot_plist['box-width'],   @default_screenshot.width
      assert_equal @thumbnail_screenshot_plist['box-width'], @thumbnail_screenshot.width
    end

    should "have an url property correctly set through plist mapping" do
      assert_equal @icon_plist['url'],                 @icon.url
      assert_equal @default_screenshot_plist['url'],   @default_screenshot.url
      assert_equal @thumbnail_screenshot_plist['url'], @thumbnail_screenshot.url
    end
    
    should "have an optional needs-shine property" do
      assert_equal @icon_plist['needs-shine'],                  @icon.needs_shine
      assert_equal @thumbnail_screenshot_plist['needs-shine'],  @thumbnail_screenshot.needs_shine
    end
    
    should "not fail if needs-shine was not provided" do
      assert_nil @default_screenshot.needs_shine
    end

  end
end