require "test_helper"

class BaseTest < Test::Unit::TestCase
  should "store raw data from plist at initialization" do
    base = AppStore::Dummy.new :plist => "plist instance"
    assert_equal "plist instance", base.raw
  end
  
  should "call custom_init_from_plist with plist given at initialization if custom_init_from_plist is defined" do
    # Define a custom_init_from_plist function which do something testable
    class AppStore::Dummy
      attr_reader :plist_stored_via_custom
      
      def custom_init_from_plist(plist)
        @plist_stored_via_custom = plist
      end
    end
    
    dummy = AppStore::Dummy.new :plist => "plist object"
    
    assert_equal "plist object", dummy.plist_stored_via_custom
      
  end
  
end