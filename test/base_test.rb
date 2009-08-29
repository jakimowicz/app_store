require "test_helper"

class BaseTest < Test::Unit::TestCase
  should "store raw data from plist at initialization" do
    AppStore::Base.send :attr_reader, :raw
    base = AppStore::Base.new :plist => "plist instance"
    assert_equal "plist instance", base.raw
  end  
  
end