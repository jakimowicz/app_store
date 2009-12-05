require "test_helper"
require "app_store/agent"

class AgentTest < Test::Unit::TestCase
  
  context "with no store front specified" do  
    setup do
      @agent = AppStore::Agent.new
    end
    
    should "have an AppStore client" do
      assert_kind_of AppStore::Client, @agent.instance_variable_get("@client")
    end
    
    should "have a default store set for client" do
      assert_equal AppStore::Client::DefaultStoreFrontName, @agent.instance_variable_get("@store_front")
    end

    context "while calling application" do
      should "returns a proxy" do
        assert_kind_of AppStore::Helper::Proxy, @agent.application
      end
      
      should "point to the Application class" do
        assert_equal AppStore::Application, @agent.application.instance_variable_get("@to")
      end
      
      should "have a client matching agent client in extra parameters" do
        assert_kind_of AppStore::Client, @agent.application.instance_variable_get("@extra")[:client]
        assert_equal  @agent.instance_variable_get("@client"),
                      @agent.application.instance_variable_get("@extra")[:client]
      end
    end
  end
  
  context "with a specific store front" do
    setup do
      @store_front = :fr
      @agent = AppStore::Agent.new(:store_front => @store_front)
    end
    
    should "have an AppStore client with correct store front" do
      assert_kind_of AppStore::Client, @agent.instance_variable_get("@client")
      assert_equal @store_front, @agent.instance_variable_get("@client").store_front_name
    end
    
    context "while calling application" do
      should "have a client with store front matching agent store front" do
        assert_equal @store_front, @agent.application.instance_variable_get("@extra")[:client].store_front_name
      end
    end
  end
  
end