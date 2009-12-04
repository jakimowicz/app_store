require "test_helper"

class BaseTest < Test::Unit::TestCase
  
  context "without client" do
    should "store raw data from plist at initialization" do
      dummy = AppStore::Dummy.new :plist => "plist instance"
      assert_equal "plist instance", dummy.raw
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
  
  context "with client" do
    setup do
      @dummy = AppStore::Dummy.new :client => AppStore::Client.new
    end

    should "have a client instance variable" do
      assert_equal ["@client"], @dummy.instance_variables
      assert_kind_of AppStore::Client, @dummy.instance_variable_get("@client")
    end
    
    should "returns store_front_name from client" do
      assert_equal @dummy.instance_variable_get("@client").store_front_name, @dummy.store_front_name
    end
  end
  
end